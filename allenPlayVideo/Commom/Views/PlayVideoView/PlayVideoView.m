//
//  PlayVideoView.m
//  LEOPlayerVideoDemo
//
//  Created by huangwenchen on 15/10/10.
//  Copyright © 2015年 huangwenchen. All rights reserved.
//

#import "PlayVideoView.h"

typedef enum {
    PathTypeFromDefault,
    PathTypeFromDocument,
    PathTypeFromResource,
    PathTypeFromURL
}PathType;

@interface PlayVideoView ()

@property (weak, nonatomic) IBOutlet UIView *playVideoView;
@property (weak, nonatomic) IBOutlet UIView *controlButtonView;
@property (weak, nonatomic) IBOutlet UIButton *playAndPauseButton;
@property (weak, nonatomic) IBOutlet UIButton *rateButton;
@property (weak, nonatomic) IBOutlet UIButton *previouButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet UISlider *videoSlider;

@property (strong, nonatomic) NSMutableArray *dataSoruce;
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;

@property (assign, nonatomic) BOOL isChangeRate;
@property (assign, nonatomic) BOOL isPlayingVideos;
@property (assign, nonatomic) BOOL isSliderMoving;
@property (assign, nonatomic) BOOL isHide;
@property (assign, nonatomic) NSInteger playIndex;

@property(copy, nonatomic) RemoveVideoBackBlock removeVideoBackBlock;

@end

@implementation PlayVideoView

#pragma mark - GestureRecognizer

- (IBAction)tapGestureRecognizerAction:(id)sender {
    if (self.isHide) {
        [self controlButtonViewShow];
    }
    else {
        [self controlButtonViewHide];
    }
    self.isHide = !self.isHide;
}

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
    [self playVideoAndPause];
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

#pragma mark * play feature

- (void)nextVideoButtonAction {
    self.playIndex++;
    NSInteger nextIndex = (self.playIndex + self.dataSoruce.count);
    self.playIndex = nextIndex % self.dataSoruce.count;
    [self playVideoConfigure:self.playIndex];
    self.isPlayingVideos = YES;
    [self playVideoAndPause];
}

- (void)periousVideoButtonAction {
    self.playIndex--;
    NSInteger preIndex = (self.playIndex + self.dataSoruce.count);
    self.playIndex = preIndex % self.dataSoruce.count;
    [self playVideoConfigure:self.playIndex];
    self.isPlayingVideos = YES;
    [self playVideoAndPause];
}

- (void)playVideoAndPause {
    if (self.isPlayingVideos) {
        [self.playAndPauseButton setTitle:@"Pause" forState:UIControlStateNormal];
        [self.player play];
    }
    else {
        [self.playAndPauseButton setTitle:@"Play" forState:UIControlStateNormal];
        [self.player pause];

    }
    self.isPlayingVideos = !self.isPlayingVideos;
}

- (void)didVideoSelect:(NSUInteger)index {
    [self playVideoConfigure:index];
    self.isPlayingVideos = YES;
    [self playVideoAndPause];
}
- (void)removeVideo:(NSInteger)index callBack:(RemoveVideoBackBlock)completion {
    NSString *filetitle = self.dataSoruce[index];
    NSString *path = [self playVideo:filetitle pathType:PathTypeFromDefault];
    if (path) {
        if (self.playIndex == [self.dataSoruce indexOfObject:filetitle]) {
            [self.playerLayer removeFromSuperlayer];
            [self.player pause];
        }
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:path error:NULL];
        UIAlertView *removeSuccessFulAlert = [[UIAlertView alloc] initWithTitle:@"Congratulation:" message:@"Successfully removed" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [removeSuccessFulAlert show];
        [self.dataSoruce removeObject:filetitle];
        completion();
    }
    else {
        NSLog(@"Could not delete file ");
    }
}

#pragma mark * Slider

- (IBAction)videoSliderTouchDown:(id)sender {
    self.isSliderMoving = YES;
}

- (IBAction)videoSliderUpInside:(id)sender {
    CMTime dragedCMTime = CMTimeMakeWithSeconds(self.videoSlider.value, self.videoSlider.maximumValue);
    __weak typeof(self) weakSelf = self;
    [self.player seekToTime:dragedCMTime completionHandler: ^(BOOL finished) {
         [weakSelf playVideoAndPause];
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

- (void)initVideoData:(NSMutableArray *)videoData {
    self.isChangeRate = NO;
    self.isPlayingVideos = YES;
    self.dataSoruce = videoData;
    self.playIndex = 0;
    self.isHide = NO;
    [self playVideoConfigure:self.playIndex];
}

- (void)playVideoConfigure:(NSInteger)videoindex {
    [self removeAllObserver];
    // 取得檔案路徑
    if (self.dataSoruce.count) {
        NSString *path = [self playVideo:self.dataSoruce[videoindex] pathType:PathTypeFromDefault];
        NSURL *fileURL = [NSURL fileURLWithPath:path];
        // 設定播放項目
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:fileURL];
        self.player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        self.playerLayer.frame = self.bounds;
        self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self.playVideoView.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
        [self.playVideoView.layer addSublayer:self.playerLayer];
        [self addObservers];
    }
    else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"沒有影片" message:@"趕快去下載" preferredStyle:UIAlertControllerStyleAlert];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        UIViewController *currentViewController = window.rootViewController;
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler: ^(UIAlertAction *action){
                                       currentViewController.navigationController.tabBarController.selectedIndex = 1;
                                   }];
        [alert addAction:okAction];
        [currentViewController presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark * misc

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

- (UIImage *)videoImage:(NSInteger)videoindex {
    // 取得影片檔案位置
    NSString *path = [self playVideo:self.dataSoruce[videoindex] pathType:PathTypeFromDefault];
    NSURL *fileURL = [NSURL fileURLWithPath:path];
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:fileURL options:nil];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    // 選擇要擷取圖片的時間範圍，參數 2 為截取影片 2 秒處的畫面，10 為每秒 10禎
    CMTime time = CMTimeMakeWithSeconds(2, 10);
    CGImageRef imgRef = [imageGenerator copyCGImageAtTime:time actualTime:nil error:nil];
    return [[UIImage alloc] initWithCGImage:imgRef];
}

- (void)controlButtonViewHide {
    [UIView animateWithDuration:.2f animations: ^{
         self.controlButtonView.alpha = 0.0f;
         self.playAndPauseButton.alpha = 0.0f;
         self.previouButton.alpha = 0.0f;
         self.nextButton.alpha = 0.0f;
     } completion: ^(BOOL finished) {
         self.controlButtonView.hidden = YES;
         self.playAndPauseButton.hidden = YES;
         self.previouButton.hidden = YES;
         self.nextButton.hidden = YES;
     }];
}

- (void)controlButtonViewShow {
    [UIView animateWithDuration:.2f animations: ^{
         self.controlButtonView.alpha = 1.0f;
         self.playAndPauseButton.alpha = 1.0f;
         self.previouButton.alpha = 1.0f;
         self.nextButton.alpha = 1.0f;
     } completion: ^(BOOL finished) {
         self.controlButtonView.hidden = NO;
         self.playAndPauseButton.hidden = NO;
         self.previouButton.hidden = NO;
         self.nextButton.hidden = NO;
     }];
}

#pragma mark * file

- (NSString *)playVideo:(NSString *)videoName pathType:(PathType)pathType {
    NSString *path = [self pathVideoName:videoName fromDocument:pathType];
    if (path) {
        return path;
    }
    return nil;
}

- (NSString *)pathVideoName:(NSString *)videoName fromDocument:(PathType)pathType {
    NSString *path;
    switch (pathType) {
        case PathTypeFromDefault:
        {
            path = [self pathVideoName:videoName fromDocument:PathTypeFromDocument];
            if (!path.length) {
                path = [self pathVideoName:videoName fromDocument:PathTypeFromResource];
            }
            break;
        }

        case PathTypeFromDocument:
        {
            NSArray *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            path = [documentPath[0] stringByAppendingString:[NSString stringWithFormat:@"/%@.m4v", videoName]];
            break;
        }

        case PathTypeFromResource:
        {
            path = [[NSBundle mainBundle] pathForResource:videoName ofType:@".m4v"];
            break;
        }

        case PathTypeFromURL:
        {
            return videoName;
        }
    }
    if (![self isFindMP3:path]) {
        path = [NSString new];
    }
    return path;
}

- (BOOL)isFindMP3:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:path] ? YES : NO;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    //AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status = [change[@"new"] intValue];
        if (status == AVPlayerStatusReadyToPlay) {
            [self addProgressBarUpdate];
        }
    }
}

- (void)addProgressBarUpdate {
    CMTime totalTime = self.player.currentItem.asset.duration;
    CGFloat totalSeconds = CMTimeGetSeconds(totalTime);
    self.videoSlider.maximumValue = totalSeconds;
    // 给播放器增加進度更新
    __weak typeof(self) weakSelf = self;
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 2) queue:dispatch_get_main_queue() usingBlock: ^(CMTime time) {
         if (!weakSelf.isSliderMoving) {
             CGFloat currentTime = CMTimeGetSeconds(weakSelf.player.currentTime);
             weakSelf.videoSlider.value = currentTime;
             weakSelf.currentTimeLabel.text = [weakSelf convertTime:currentTime];
             CGFloat surplusTotalTime = (CGFloat)totalTime.value / totalTime.timescale;
             weakSelf.totalTimeLabel.text = [weakSelf convertTime:surplusTotalTime - currentTime];
         }
     }];
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
    // 移除監聽
    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

@end
