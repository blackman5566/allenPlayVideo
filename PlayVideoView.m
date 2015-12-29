//
//  PlayVideoView.m
//  LEOPlayerVideoDemo
//
//  Created by huangwenchen on 15/10/10.
//  Copyright © 2015年 huangwenchen. All rights reserved.
//

#import "PlayVideoView.h"
@interface PlayVideoView ()

@property (weak, nonatomic) IBOutlet UIView *playVideoView;
@property (weak, nonatomic) IBOutlet UIButton *playAndPauseButton;
@property (weak, nonatomic) IBOutlet UIButton *rateButton;
@property (weak, nonatomic) IBOutlet UISlider *videoSlider;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;

@property (strong, nonatomic) NSArray *dataSoruce;
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;

@property (assign, nonatomic) BOOL isChangeRate;
@property (assign, nonatomic) BOOL isPlayingVideos;
@property (assign, nonatomic) BOOL isSliderMoving;
@property (assign, nonatomic) int playIndex;

@end

@implementation PlayVideoView

#pragma mark - IBAction Action

- (IBAction)periousVideoButtonAction:(id)sender {
    // 上一首
    [self periousVideoButtonAction];
}

- (IBAction)nextVideoButtonAction:(id)sender {
    // 下一首
    [self nextVideoButtonAction];
}

- (IBAction)playMusicButtonAction:(id)sender {
    // 播放功能
    if (self.isPlayingVideos) {
        [self.playAndPauseButton setTitle:@"Pause" forState:UIControlStateNormal];
        [self playVideo];
    }
    else {
        [self.playAndPauseButton setTitle:@"Play" forState:UIControlStateNormal];
        [self pauseVideo];
    }
    self.isPlayingVideos = !self.isPlayingVideos;
}

- (IBAction)fullScreenButtonAction:(id)sender {
    // 全畫面
}

- (IBAction)rateButtonAction:(id)sender {
    // 播放速率
    if (self.isChangeRate) {
        self.player.rate = 1.0;
        [self.rateButton setTitle:@"x2" forState:UIControlStateNormal];
    }
    else {
        self.player.rate = 2.0;
        [self.rateButton setTitle:@"normal" forState:UIControlStateNormal];
    }
    self.isChangeRate = !self.isChangeRate;
}

#pragma mark * Slider

- (IBAction)videoSliderTouchDown:(id)sender {
    self.isSliderMoving = YES;
}

- (IBAction)videoSliderUpInside:(id)sender {
    CMTime dragedCMTime = CMTimeMakeWithSeconds(self.videoSlider.value, self.videoSlider.maximumValue);
    [self.player seekToTime:dragedCMTime completionHandler: ^(BOOL finished) {
         [self.player play];
     }];
    self.isSliderMoving = !self.isSliderMoving;
}

#pragma mark - private instance method

#pragma mark * init

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil][0];
    }
    return self;
}

- (void)checkVideoData:(NSArray *)videoData {
    if (videoData.count) {
        self.isChangeRate = NO;
        self.dataSoruce = videoData;
        self.playIndex = 0;
        [self playVideoConfigure:self.playIndex];
    }
    else {
        NSLog(@"no data");
    }

}
- (void)playVideoConfigure:(int)videoindex {
    [self removeAllObserver];
    // 取得檔案路徑
    NSString *path = [[NSBundle mainBundle] pathForResource:self.dataSoruce[videoindex] ofType:@"m4v"];
    NSURL *fileURL = [NSURL fileURLWithPath:path];
    // 設定播放項目
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:fileURL];
    self.player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.frame = self.frame;
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.playVideoView.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self.playVideoView.layer addSublayer:self.playerLayer];
    [self.player play];
    self.isPlayingVideos = YES;
    [self addObservers];
}

#pragma mark * misc

- (void)addProgressBarUpdate {
    int totalSeconds = CMTimeGetSeconds(self.player.currentItem.asset.duration);
    self.videoSlider.maximumValue = totalSeconds;
    // 给播放器增加進度更新
    __weak typeof(self) weakSelf = self;
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 2) queue:dispatch_get_main_queue() usingBlock: ^(CMTime time) {
         if (!weakSelf.isSliderMoving) {
             CGFloat currentTime = CMTimeGetSeconds(weakSelf.player.currentTime);
             weakSelf.videoSlider.value = currentTime;
             weakSelf.currentTimeLabel.text = [weakSelf convertTime:currentTime];
         }
     }];
}

- (NSString *)convertTime:(CGFloat)second {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (second / 3600 >= 1) {
        [formatter setDateFormat:@"HH:mm:ss"];
    }
    else {
        [formatter setDateFormat:@"mm:ss"];
    }
    return [formatter stringFromDate:date];
}

- (UIImage *)videoImage:(int)keyValue {
    // 取得影片檔案位置
    NSString *path = [[NSBundle mainBundle] pathForResource:self.dataSoruce[keyValue] ofType:@"m4v"];
    NSURL *fileURL = [NSURL fileURLWithPath:path];
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:fileURL options:nil];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    // 選擇要擷取圖片的時間範圍，參數 2 為截取影片 2 秒處的畫面，10 為每秒 10禎
    CMTime time = CMTimeMakeWithSeconds(2, 10);
    CGImageRef imgRef = [imageGenerator copyCGImageAtTime:time actualTime:nil error:nil];
    return [[UIImage alloc] initWithCGImage:imgRef];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status = [change[@"new"] intValue];
        if (status == AVPlayerStatusReadyToPlay) {
            CGFloat totalSeconds = CMTimeGetSeconds(playerItem.duration);
            self.totalTimeLabel.text = [self convertTime:totalSeconds];
            [self addProgressBarUpdate];
            NSLog(@"addProgressBarUpdate");
        }
    }

}

- (void)addObservers {
    // 使用 KVO 監聽 playerItem 狀態
    [self.player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    // 使用 NSNotificationCenter 監聽 playerItem：如果播放完就直接下一首
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(nextVideoButtonAction)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
}

- (void)removeAllObserver {
    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}


#pragma mark * play feature

- (void)nextVideoButtonAction {
    self.playIndex++;
    self.playIndex %= self.dataSoruce.count;
    [self playVideoConfigure:self.playIndex];
}

- (void)periousVideoButtonAction {
    self.playIndex--;
    self.playIndex %= self.dataSoruce.count;
    [self playVideoConfigure:self.playIndex];
}

- (void)playVideo {
    [self.player play];
}

- (void)pauseVideo {
    [self.player pause];
}

@end
