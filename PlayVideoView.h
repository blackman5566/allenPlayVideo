//
//  PlayVideoView.h
//  LEOPlayerVideoDemo
//
//  Created by huangwenchen on 15/10/10.
//  Copyright © 2015年 huangwenchen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface PlayVideoView : UIView{
    
}

@property (nonatomic, weak) IBOutlet UIView *topBarView;
@property (nonatomic, weak) IBOutlet UIView *controlButtonView;
@property (nonatomic, weak) IBOutlet UIButton *playVideoButton;
@property (nonatomic, weak) IBOutlet UIButton *fullScreenButton;
@property (nonatomic, weak) IBOutlet UILabel *currentlyTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *totalTimeLabel;
@property (nonatomic, weak) IBOutlet UISlider *videoSlider;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@property (assign, nonatomic) BOOL isPlayingVideos;
@property (assign, nonatomic) BOOL isSliderMoving;
@property (assign, nonatomic) int playIndex;
@property (strong, nonatomic) NSArray *dataSoruce;

- (void)playVideoConfigure:(int)keyValue;
- (UIImage *)videoImage:(int)keyValue;
- (void)playVideo;
@end
