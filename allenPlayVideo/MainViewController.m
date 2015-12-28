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
    self.PlayVideo = [[PlayVideoView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight(self.view.frame))];
    [self.view addSubview:self.PlayVideo];
    [self.PlayVideo playVideoConfigure:0];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInitValue];
    [self setupVideoView];
}


@end
