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
@interface DownloadModel () <NSURLSessionDownloadDelegate>

@property (nonatomic, copy) DownloadFinishCallBackBlock completion;

@end

@implementation DownloadModel

#pragma mark - class method

+ (void)downloadVideo:(NSString *)videoName videoUrl:(NSURL *)videoUrl completion:(DownloadFinishCallBackBlock)completion {
    [[DownloadModel shared] downloadVideo:videoName videoUrl:videoUrl completion:completion];
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

+ (NSMutableArray *)fileDownloadDataArrays {
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
    for (int i = 0; [DownloadModel fileDownloadDataArrays].count; i++) {
        FileDownloadInfo *fileInfo = [DownloadModel fileDownloadDataArrays][i];
        if ([fileInfo.fileTitle isEqualToString:videoName]) {
            return 0;
        }
    }
    return 1;
}

- (void)downloadVideo:(NSString *)videoName videoUrl:(NSURL *)url completion:(DownloadFinishCallBackBlock)completion {
    if ([self isExist:videoName]) {
        self.completion = completion;
        FileDownloadInfo *fileInfo = [[FileDownloadInfo alloc] initWithFileTitle:videoName andDownloadSource:url];
        [[DownloadModel shared] setTask:fileInfo];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"已在下載清單中"message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (FileDownloadInfo *)getFileDownloadInfoWithTaskIdentifier:(unsigned long)identifier {
    FileDownloadInfo *fileInfo;
    for (int i = 0; i < [DownloadModel fileDownloadDataArrays].count; i++) {
        fileInfo = [DownloadModel fileDownloadDataArrays][i];
        if (fileInfo.taskIdentifier == identifier) {
            fileInfo = [DownloadModel fileDownloadDataArrays][i];
            break;
        }
    }
    return fileInfo;
}

#pragma mark * init

- (void)setTask:(FileDownloadInfo *)fileInfo {
    fileInfo.downloadTask = [[self sessionShare] downloadTaskWithURL:fileInfo.downloadSource];
    fileInfo.taskIdentifier = fileInfo.downloadTask.taskIdentifier;
    fileInfo.isDownloading = YES;
    [[DownloadModel fileDownloadDataArrays] addObject:fileInfo];
    [fileInfo.downloadTask resume];
}
- (void)stopTask:(NSInteger)index {
    FileDownloadInfo *fileInfo = [DownloadModel fileDownloadDataArrays][index];
    [fileInfo.downloadTask suspend];
    
}
- (void)startTask:(NSInteger)index {
    FileDownloadInfo *fileInfo = [DownloadModel fileDownloadDataArrays][index];
    [fileInfo.downloadTask resume];
    
}
- (void)cancelTask:(NSInteger)index {
    FileDownloadInfo *fileInfo = [DownloadModel fileDownloadDataArrays][index];
    [fileInfo.downloadTask cancel];
    [[DownloadModel fileDownloadDataArrays] removeObjectAtIndex:index];
}

#pragma mark - NSURLSessionDownloadDelegate

- (NSURLSession *)sessionShare {
    static NSURLSession *session = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.hiiir.allenPlayVideo.BackgroundSession"];
        session = [NSURLSession sessionWithConfiguration:configuration
                                                delegate:self
                                           delegateQueue:nil];
    });
    return session;
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.backgroundSessionCompletionHandler) {
        void (^completionHandler)() = appDelegate.backgroundSessionCompletionHandler;
        appDelegate.backgroundSessionCompletionHandler = nil;
        completionHandler();
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
    didWriteData:(int64_t)bytesWritten
    totalBytesWritten:(int64_t)totalBytesWritten
    totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    if (totalBytesExpectedToWrite != NSURLSessionTransferSizeUnknown) {
        float percent = (float)totalBytesWritten / totalBytesExpectedToWrite;
        NSLog(@"downloadTask = %@ %f", downloadTask, percent);
    }
}

- (void)URLSession:(NSURLSession *)session
    downloadTask:(NSURLSessionDownloadTask *)downloadTask
    didFinishDownloadingToURL:(NSURL *)location {
    FileDownloadInfo *fileInfo = [self getFileDownloadInfoWithTaskIdentifier:downloadTask.taskIdentifier];
    if (location) {
        NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
        NSString *fileName = [NSString stringWithFormat:@"%@.m4v", fileInfo.fileTitle];
        NSURL *tempURL = [documentsURL URLByAppendingPathComponent:fileName];
        [[NSFileManager defaultManager] moveItemAtURL:location toURL:tempURL error:nil];
        self.completion();
    }
}
@end