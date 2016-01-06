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

- (void)initVideoData:(NSMutableArray *)videoData;
- (UIImage *)videoImage:(NSInteger)videoindex;
- (void)didVideoSelect:(NSUInteger)index;
- (void)removeVideo:(NSString *)fileName callBack:(RemoveVideoBackBlock)completion;
@end
