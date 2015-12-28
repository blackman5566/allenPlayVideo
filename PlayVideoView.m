//
//  PlayVideoView.m
//  LEOPlayerVideoDemo
//
//  Created by huangwenchen on 15/10/10.
//  Copyright © 2015年 huangwenchen. All rights reserved.
//

#import "PlayVideoView.h"
@implementation PlayVideoView

#pragma mark - AVPlayer

+ (Class)layerClass {
    // 包裝一個 AVPlayerLayer 使用。
    return [AVPlayerLayer class];
}

- (AVPlayer *)player {
    // 初始化 player。
    return [(AVPlayerLayer *)[self layer] player];
}

- (void)setPlayer:(AVPlayer *)player {
    // 將 AVPlayer 放到 UiView 。
    [(AVPlayerLayer *)[self layer] setPlayer:player];
}


- (AVPlayerLayer *)playerLayer {
    // 回傳自己的 layer。
    return (AVPlayerLayer *)self.layer;
}

#pragma mark - IBAction

- (IBAction)periousVideoButtonAction:(id)sender {
    [self periousVideoButtonAction];
}

- (IBAction)nextVideoButtonAction:(id)sender {
    [self nextVideoButtonAction];
}

- (IBAction)playMusicButtonAction:(id)sender {
    // 播放功能
    self.isPlayingVideos = !self.isPlayingVideos;
    [self playVideo];
}

- (IBAction)fullScreenButtonAction:(id)sender {

}

#pragma mark * Slider

- (IBAction)videoSliderTouchDown:(id)sender {
    self.isSliderMoving = YES;
}

- (IBAction)videoSliderUpInside:(id)sender {
    self.isSliderMoving = NO;
    CMTime newTime = CMTimeMakeWithSeconds(self.videoSlider.value, self.videoSlider.maximumValue);
    [self.player seekToTime:newTime];
}

#pragma mark * init

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"PlayVideoView" owner:self options:nil] lastObject];
        self.isPlayingVideos = YES;
    }
    return self;
}

#pragma mark - private instance method

#pragma mark * init

- (void)playVideoConfigure:(int)keyValue {
    // [self removeAllObserver];
    // 取得檔案路徑
    NSString *path = [[NSBundle mainBundle] pathForResource:@"like" ofType:@"m4v"];
    NSLog(@"path = %@", path);
    NSURL *fileURL = [NSURL fileURLWithPath:path];
    // 設定播放項目
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:fileURL];
    self.player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.player play];
    // [self addObservers];
}

#pragma mark * misc

- (NSString *)formatTime:(int)num {
    // 秒轉分鐘
    int sec = num % 60;
    int min = num / 60;
    return [NSString stringWithFormat:@"%02d:%02d", min, sec];
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
    if (self.player == object && [keyPath isEqualToString:@"status"]) {
        if (self.player.status == AVPlayerStatusReadyToPlay) {
            //顯示總時間
            int totalSeconds = CMTimeGetSeconds(self.player.currentItem.asset.duration);
            self.totalTimeLabel.text = [self formatTime:totalSeconds];
            //設定 currentVideoSlider 的長度
            self.videoSlider.maximumValue = totalSeconds;
            // 解除 retain cycle
            __weak typeof(self) weakSelf = self;
            // 给播放器增加進度更新
            [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 2) queue:dispatch_get_main_queue() usingBlock: ^(CMTime time) {
                 if (!weakSelf.isSliderMoving) {
                     int currentTime = CMTimeGetSeconds(weakSelf.player.currentTime);
                     weakSelf.videoSlider.value = currentTime;
                     weakSelf.currentlyTimeLabel.text = [weakSelf formatTime:currentTime];
                 }
             }];
        }
        else if (self.player.status == AVPlayerStatusFailed) {
            NSLog(@"檔案錯誤");
        }
        else if (self.player.status == AVPlayerStatusUnknown) {
            NSLog(@"沒有任何檔案數據");
        }
    }
}

- (void)addObservers {
    // 使用 KVO 監聽 playerItem 狀態
    [self.player addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    // 使用 NSNotificationCenter 監聽 playerItem：如果播放完就直接下一首
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(nextVideoButtonAction)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:self.player.currentItem];
}

- (void)removeAllObserver {
    [self.player removeObserver:self forKeyPath:@"status"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}


#pragma mark * play feature

- (void)playVideo {
    if (self.isPlayingVideos) {
        [self.playVideoButton setTitle:@"play" forState:UIControlStateNormal];
        [self.playerLayer.player pause];
    }
    else {
        [self.playVideoButton setTitle:@"pause" forState:UIControlStateNormal];
        [self.playerLayer.player play];
    }
}

- (void)nextVideoButtonAction {
    self.playIndex++;
    self.playIndex = self.playIndex % self.dataSoruce.count;
    [self playVideoConfigure:self.playIndex];
    [self playVideo];
}

- (void)periousVideoButtonAction {
    self.playIndex--;
    self.playIndex = self.playIndex % self.dataSoruce.count;
    [self playVideoConfigure:self.playIndex];
    [self playVideo];
}

@end
