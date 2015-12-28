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
    tabBar.viewControllers = [self generatorViewControllers];
    self.window.rootViewController = tabBar;
    [self.window makeKeyAndVisible];
    return YES;
}

- (NSArray *)generatorViewControllers {
    UINavigationController *mainNavigationController = [[UINavigationController alloc] initWithRootViewController:[MainViewController new]];
    UITabBarItem *mainButton = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"play.png"] selectedImage:[UIImage imageNamed:@"played.png"]];
    mainNavigationController.tabBarItem = mainButton;
    UINavigationController *downNavigationController = [[UINavigationController alloc] initWithRootViewController:[DownloadViewController new]];
    UITabBarItem *downButton = [[UITabBarItem alloc]initWithTitle:@"" image:[UIImage imageNamed:@"download.png"] selectedImage:[UIImage imageNamed:@"download.png"]];
    downNavigationController.tabBarItem = downButton;
    return @[mainNavigationController, downNavigationController];
}
@end
