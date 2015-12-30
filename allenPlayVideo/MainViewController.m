//
//  MainViewController.m
//  allenPlayVideo
//
//  Created by allen_hsu on 2015/12/28.
//  Copyright © 2015年 allen_hsu. All rights reserved.
//

#import "MainViewController.h"
#import "PlayVideoView.h"

@interface MainViewController ()

@property(nonatomic, strong) PlayVideoView *playVideo;

@end

@implementation MainViewController

#pragma mark - private method

- (void)setupInitValue {
    self.title = @"MainView";
}

- (void)setupVideoView {
    self.playVideo = [PlayVideoView new];
    [self.view addSubview:self.playVideo];
    NSArray *array = @[@"like", @"Movie", @"我能給的"];
    [self.playVideo initVideoData:array];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInitValue];
    [self setupVideoView];
}


@end
