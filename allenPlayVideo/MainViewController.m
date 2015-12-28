//
//  MainViewController.m
//  allenPlayVideo
//
//  Created by allen_hsu on 2015/12/28.
//  Copyright © 2015年 allen_hsu. All rights reserved.
//

#import "MainViewController.h"
#import "allenPlayVideoClass.h"

@interface MainViewController ()

@end

@implementation MainViewController

#pragma mark - private method

- (void)setupInitValue {
    self.title = @"MainView";
}
- (void)setupVideoView {
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 200);
    allenPlayVideoClass *playView  = [[allenPlayVideoClass alloc] initWithFrame:frame];
    [self.view addSubview:playView];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInitValue];
    [self setupVideoView];
}


@end
