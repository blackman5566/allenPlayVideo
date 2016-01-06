//
//  DownloadModel.h
//  allenPlayVideo
//
//  Created by 許佳豪 on 2016/1/4.
//  Copyright © 2016年 allen_hsu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DownloadFinishCallBackBlock)();
typedef void (^DownloadProgressUpdateBlock)(NSURLSessionDownloadTask *downloadTask,
                                            CGFloat bytesWritten, CGFloat totalBytesWritten, CGFloat totalBytesExpectedToWrite);

@interface DownloadModel : NSObject

+ (void)downloadVideo:(NSString *)videoName videoUrl:(NSURL *)videoUrl;
+ (void)downloadProgressUpdateBlock:(DownloadProgressUpdateBlock)downloadProgressUpdate;
+ (void)downloadFinishCallBackBlockcompletion:(DownloadFinishCallBackBlock)completion;
+ (NSMutableArray *)fileInfoArrays;
+ (void)stopTask:(NSInteger)index;
+ (void)startTask:(NSInteger)index;
+ (void)cancelTask:(NSInteger)index;
@end
