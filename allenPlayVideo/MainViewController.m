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

- (void)viewDidLoad {
    allenPlayVideoClass *playView  = [[allenPlayVideoClass alloc]initWithFrame:CGRectMake(0, 0,CGRectGetWidth(self.view.frame), 200)];
    [self.view addSubview:playView];
    [super viewDidLoad];
}


@end
