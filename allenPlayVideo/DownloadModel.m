//
//  DownloadModel.m
//  allenPlayVideo
//
//  Created by 許佳豪 on 2016/1/4.
//  Copyright © 2016年 allen_hsu. All rights reserved.
//
#import "AppDelegate.h"
#import "DownloadModel.h"
#import "FileDownloadInfo.h"
#import "VideoListStorage.h"

@interface DownloadModel () <NSURLSessionDownloadDelegate>

@property (nonatomic, copy) DownloadFinishCallBackBlock completion;
@property (nonatomic, copy) DownloadProgressUpdateBlock downloadProgressUpdate;

@end

@implementation DownloadModel

#pragma mark - class method

+ (void)downloadVideo:(NSString *)videoName videoUrl:(NSURL *)videoUrl {
    [[DownloadModel shared] downloadVideo:videoName videoUrl:videoUrl];
}

+ (void)downloadProgressUpdateBlock:(DownloadProgressUpdateBlock)downloadProgressUpdate {
    [[DownloadModel shared] downloadProgressUpdateBlock:downloadProgressUpdate];
}

+ (void)downloadFinishCallBackBlockcompletion:(DownloadFinishCallBackBlock)completion {
    [[DownloadModel shared] downloadFinishCallBackBlockcompletion:completion];
}

+ (void)stopTask:(NSInteger)index {
    [[DownloadModel shared] stopTask:index];
}

+ (void)startTask:(NSInteger)index {
    [[DownloadModel shared] startTask:index];
}

+ (void)cancelTask:(NSInteger)index {
    [[DownloadModel shared] cancelTask:index];
}

+ (NSMutableArray *)fileInfoArrays {
    static NSMutableArray *shared = nil;
    if (!shared) {
        shared = [[NSMutableArray alloc] init];
    }
    return shared;
}

+ (DownloadModel *)shared {
    static DownloadModel *shared = nil;
    if (!shared) {
        shared = [[self alloc] init];
    }
    return shared;
}

#pragma mark - private method

- (BOOL)isExist:(NSString *)videoName {
    for (FileDownloadInfo *fileInfo in [DownloadModel fileInfoArrays]) {
        if ([fileInfo.fileTitle isEqualToString:videoName]) {
            return 0;
        }
    }
    return 1;
}

- (void)downloadVideo:(NSString *)videoName videoUrl:(NSURL *)url {
    if ([self isExist:videoName]) {
        FileDownloadInfo *fileInfo = [[FileDownloadInfo alloc] initWithFileTitle:videoName andDownloadSource:url];
        [[DownloadModel shared] setTask:fileInfo];
    }
    else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"已在下載清單中"message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}
// downloadFinishCallBackBlockcompletion
- (void)downloadFinishCallBackBlockcompletion:(DownloadFinishCallBackBlock)completion {
    self.completion = completion;
}

// downloadProgressUpdateBlock
- (void)downloadProgressUpdateBlock:(DownloadProgressUpdateBlock)downloadProgressUpdate {
    self.downloadProgressUpdate = downloadProgressUpdate;
}

// 找尋特定的任務
- (FileDownloadInfo *)getFileDownloadInfoWithTaskIdentifier:(unsigned long)identifier {
    FileDownloadInfo *fileInfo;
    for (int i = 0; i < [DownloadModel fileInfoArrays].count; i++) {
        fileInfo = [DownloadModel fileInfoArrays][i];
        if (fileInfo.taskIdentifier == identifier) {
            fileInfo = [DownloadModel fileInfoArrays][i];
            break;
        }
    }
    return fileInfo;
}

#pragma mark * init

// 任務初始設定
- (void)setTask:(FileDownloadInfo *)fileInfo {
    fileInfo.downloadTask = [[self sessionShare] downloadTaskWithRequest:[NSURLRequest requestWithURL:fileInfo.downloadSource]];
    fileInfo.taskIdentifier = fileInfo.downloadTask.taskIdentifier;
    fileInfo.isDownloading = YES;
    [[DownloadModel fileInfoArrays] addObject:fileInfo];
    [fileInfo.downloadTask resume];
    [[VideoListStorage shared] exportPath:[DaiStoragePath document]];
    self.completion();
}

// 暫停任務
- (void)stopTask:(NSInteger)index {
    FileDownloadInfo *fileInfo = [DownloadModel fileInfoArrays][index];
    [fileInfo.downloadTask cancelByProducingResumeData: ^(NSData *_Nullable resumeData) {
         fileInfo.taskResumeData = [[NSData alloc] initWithData:resumeData];
     }];
    fileInfo.isDownloading = NO;
    [fileInfo.downloadTask suspend];

}

// 開始任務
- (void)startTask:(NSInteger)index {
    FileDownloadInfo *fileInfo = [DownloadModel fileInfoArrays][index];
    if (!fileInfo.isDownloading) {
        if (fileInfo.taskIdentifier == -1) {
            fileInfo.downloadTask = [[self sessionShare] downloadTaskWithRequest:[NSURLRequest requestWithURL:fileInfo.downloadSource]];
        }
        else {
            fileInfo.downloadTask = [[self sessionShare] downloadTaskWithResumeData:fileInfo.taskResumeData];
        }
        fileInfo.taskIdentifier = fileInfo.downloadTask.taskIdentifier;
        [fileInfo.downloadTask resume];
        fileInfo.isDownloading = YES;
    }
}

// 取消任務
- (void)cancelTask:(NSInteger)index {
    FileDownloadInfo *fileInfo = [DownloadModel fileInfoArrays][index];
    [fileInfo.downloadTask cancel];
    [[DownloadModel fileInfoArrays] removeObjectAtIndex:index];
}

#pragma mark - NSURLSessionDownloadDelegate

// 初始化 NSURLSession
- (NSURLSession *)sessionShare {
    static NSURLSession *session = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.hiiir.allenPlayVideo.BackgroundSession"];
        configuration.HTTPMaximumConnectionsPerHost = 5;
        session = [NSURLSession sessionWithConfiguration:configuration
                                                delegate:self
                                           delegateQueue:nil];
    });
    return session;
}

// 背景下載 deleage
- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.backgroundSessionCompletionHandler) {
        void (^completionHandler)() = appDelegate.backgroundSessionCompletionHandler;
        appDelegate.backgroundSessionCompletionHandler = nil;
        completionHandler();
    }
}

//會自動回傳目前下載進度。
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
    didWriteData:(int64_t)bytesWritten
    totalBytesWritten:(int64_t)totalBytesWritten
    totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    if (totalBytesExpectedToWrite != NSURLSessionTransferSizeUnknown) {
        NSLog(@"%lu = %f", (unsigned long)downloadTask.taskIdentifier, (float)totalBytesWritten / totalBytesExpectedToWrite);
        self.downloadProgressUpdate(downloadTask, bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
    }
}

// 當下載完，回自動將檔案移至 documents 資料夾裡。
- (void)URLSession:(NSURLSession *)session
    downloadTask:(NSURLSessionDownloadTask *)downloadTask
    didFinishDownloadingToURL:(NSURL *)location {
    FileDownloadInfo *fileInfo = [self getFileDownloadInfoWithTaskIdentifier:downloadTask.taskIdentifier];
    if (location) {
        NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
        NSString *fileName = [NSString stringWithFormat:@"%@.m4v", fileInfo.fileTitle];
        NSURL *tempURL = [documentsURL URLByAppendingPathComponent:fileName];
        [[NSFileManager defaultManager] moveItemAtURL:location toURL:tempURL error:nil];
        [[DownloadModel fileInfoArrays] removeObject:fileInfo];
        [[VideoListStorage shared].videoListInfoArrays addObject:fileInfo.fileTitle];
        [[VideoListStorage shared] exportPath:[DaiStoragePath document]];
        self.completion();
    }
}
@end
