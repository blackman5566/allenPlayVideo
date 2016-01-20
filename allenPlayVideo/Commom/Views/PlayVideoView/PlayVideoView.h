//
//  PlayVideoView.h
//  LEOPlayerVideoDemo
//
//  Created by huangwenchen on 15/10/10.
//  Copyright © 2015年 huangwenchen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef void (^RemoveVideoBackBlock)();

@interface PlayVideoView : UIView
/*
 @abstract 初始化 Video 參數設定。
 */
- (void)initVideoData:(NSMutableArray *)videoData;

/*
 @abstract 回傳 Video 圖片。
 */
- (UIImage *)videoImage:(NSInteger)videoindex;

/*
 @abstract 選擇 Video 檔案並播放。
 */
- (void)didVideoSelect:(NSUInteger)index;

/*
 @abstract 刪除 Video 檔案。
 */
- (void)removeVideo:(NSInteger )index callBack:(RemoveVideoBackBlock)completion;

@end
