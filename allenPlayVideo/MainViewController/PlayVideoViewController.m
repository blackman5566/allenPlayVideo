//
//  MainViewController.m
//  allenPlayVideo
//
//  Created by allen_hsu on 2015/12/28.
//  Copyright © 2015年 allen_hsu. All rights reserved.
//

#import "PlayVideoViewController.h"
#import "PlayVideoView.h"

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
    self.playVideo = [PlayVideoView new];
    [self.view addSubview:self.playVideo];
    NSArray *array = @[@"like", @"Movie", @"我能給的",@"蘇打綠 sodagreen -【追追追】Official Music Video"];
    [self.playVideo initVideoData:array];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInitValue];
    [self setupVideoView];
}


@end