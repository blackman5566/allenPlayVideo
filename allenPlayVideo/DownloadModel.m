//
//  DownloadModel.m
//  allenPlayVideo
//
//  Created by 許佳豪 on 2016/1/4.
//  Copyright © 2016年 allen_hsu. All rights reserved.
//
#import "AppDelegate.h"
#import "DownloadModel.h"

@interface DownloadModel () <NSURLSessionDownloadDelegate>

@property (nonatomic, copy) DownloadFinishCallBackBlock completion;
@property(nonatomic, strong) NSDictionary *fileInfo;

@end

@implementation DownloadModel

#pragma mark - class method

+ (void)downloadVideo:(NSString *)videoName videoUrl:(NSURL *)videoUrl completion:(DownloadFinishCallBackBlock)completion {
    [[DownloadModel shared] downloadVideo:videoName videoUrl:videoUrl completion:completion];
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

- (void)downloadVideo:(NSString *)videoName videoUrl:(NSURL *)url completion:(DownloadFinishCallBackBlock)completion {
    self.completion = completion;
    self.fileInfo = @{ @"fileTitle" : videoName, @"downloadSource" :url, @"downloadProgress" :@"0.0", @"isDownloading":@NO, @"taskIdentifier":@0, @"taskResumeData":@0 };
    [[DownloadModel shared] setTask:self.fileInfo];
}

- (NSDictionary *)getFileDownloadInfoWithTaskIdentifier:(NSNumber *)identifier {
    NSDictionary *fileInfo;
    for (int i = 0; i < [DownloadModel fileDownloadDataArrays].count; i++) {
        if ([DownloadModel fileDownloadDataArrays][i][@"taskIdentifier"] == identifier) {
            fileInfo = [DownloadModel fileDownloadDataArrays][i];
            break;
        }
    }
    return fileInfo;
}

#pragma mark * init

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
        NSLog(@"%f", percent);
    }
}

- (void)URLSession:(NSURLSession *)session
    downloadTask:(NSURLSessionDownloadTask *)downloadTask
    didFinishDownloadingToURL:(NSURL *)location {
    NSDictionary *fileInfo = [self getFileDownloadInfoWithTaskIdentifier:[NSNumber numberWithInteger:downloadTask.taskIdentifier]];
    if (location) {
        NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
        NSString *fileName = [NSString stringWithFormat:@"%@.m4v", fileInfo[@"fileTitle"]];
        NSURL *tempURL = [documentsURL URLByAppendingPathComponent:fileName];
        [[NSFileManager defaultManager] moveItemAtURL:location toURL:tempURL error:nil];
        self.completion();
    }
}

- (void)setTask:(NSDictionary *)fileInfo {
    NSURLSessionDownloadTask *task = [[self sessionShare] downloadTaskWithRequest:[NSURLRequest requestWithURL:fileInfo[@"downloadSource"]]];

    NSMutableDictionary *temp = [[NSMutableDictionary alloc] initWithDictionary:fileInfo];
    temp[@"taskIdentifier"] = [NSNumber numberWithInteger:task.taskIdentifier];
    temp[@"isDownloading"] = @YES;
    temp[@"downloadTask"] = task;
    self.fileInfo = temp;
    [[DownloadModel fileDownloadDataArrays] addObject:fileInfo];

    [task resume];
}

@end
