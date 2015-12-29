//
//  PlayVideoView.h
//  LEOPlayerVideoDemo
//
//  Created by huangwenchen on 15/10/10.
//  Copyright © 2015年 huangwenchen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface PlayVideoView : UIView

- (void)initVideoData:(NSArray *)videoData;
- (UIImage *)videoImage:(NSInteger)keyValue;

@end
