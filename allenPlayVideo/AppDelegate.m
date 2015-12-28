//
//  AppDelegate.m
//  allenPlayVideo
//
//  Created by allen_hsu on 2015/12/28.
//  Copyright © 2015年 allen_hsu. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "DownloadViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UITabBarController *tabBar = [UITabBarController new];
    tabBar.viewControllers =[self generatorViewControllers];

    self.window.rootViewController = [MainViewController new];
    [self.window makeKeyAndVisible];
    return YES;
}

- (NSArray *)generatorViewControllers {
    UINavigationController *MainNavigationController = [[UINavigationController alloc] initWithRootViewController:[MainViewController new]];
    UINavigationController *downNavigationController = [[UINavigationController alloc] initWithRootViewController:[DownloadViewController new]];
    return @[MainNavigationController, downNavigationController];
}
@end
