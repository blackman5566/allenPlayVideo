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

@property(nonatomic, strong) PlayVideoView *PlayVideo;

@end

@implementation MainViewController

#pragma mark - private method

- (void)setupInitValue {
    self.title = @"MainView";
}
- (void)setupVideoView {
    self.PlayVideo = [PlayVideoView new];
    [self.view addSubview:self.PlayVideo];
    NSArray *array = @[@"like", @"Movie", @"我能給的"];
    [self.PlayVideo initVideoData:array];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInitValue];
    [self setupVideoView];
}


@end
