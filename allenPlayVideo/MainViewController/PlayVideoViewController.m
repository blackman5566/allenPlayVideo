//
//  MainViewController.m
//  allenPlayVideo
//
//  Created by allen_hsu on 2015/12/28.
//  Copyright © 2015年 allen_hsu. All rights reserved.
//

#import "PlayVideoViewController.h"
#import "PlayVideoView.h"
#import "VideoListStorage.h"

@interface PlayVideoViewController ()

@property(nonatomic, strong) PlayVideoView *playVideo;

@end

@implementation PlayVideoViewController

#pragma mark - private method

- (void)setupInitValue {
    self.title = @"影片";
    self.navigationController.navigationBar.hidden = YES;
}

- (void)setupVideoView {
    NSMutableArray *videoFile = [VideoListStorage shared].videoListInfoArrays;
    if (videoFile.count) {
        self.playVideo = [PlayVideoView new];
        [self.view addSubview:self.playVideo];
        [self.playVideo initVideoData:[VideoListStorage shared].videoListInfoArrays];
    }
    else {
        UIAlertController *alert = [UIAlertController
                                    alertControllerWithTitle:@"沒有影片"
                                                     message:@"趕快去下載"
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler: ^(UIAlertAction *action){
                                       self.navigationController.tabBarController.selectedIndex = 1;
                                   }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];

    }
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInitValue];
    [self setupVideoView];
}

- (void)viewWillAppear:(BOOL)animated {
    [self setupVideoView];
}

@end
