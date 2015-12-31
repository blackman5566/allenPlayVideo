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

#pragma mark - life cycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UITabBarController *tabBar = [UITabBarController new];
    tabBar.viewControllers = [self generatorViewControllers];
    self.window.rootViewController = tabBar;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler {
    self.backgroundSessionCompletionHandler = completionHandler;
}

#pragma mark - private instance method

#pragma mark * init

- (NSArray *)generatorViewControllers {
    NSArray *viewControllers = @[[MainViewController new], [DownloadViewController new]];
    NSArray *selectImages = @[@"play", @"download2"];
    NSArray *selectedImages = @[@"played", @"download"];
    NSMutableArray *naviViewControllers = [NSMutableArray new];
    for (int i = 0; i < viewControllers.count; i++) {
        UINavigationController *naviViewController = [[UINavigationController alloc] initWithRootViewController:viewControllers[i]];
        UITabBarItem *barItem = [UITabBarItem new];
        barItem.image = [UIImage imageNamed:selectImages[i]];
        barItem.selectedImage = [UIImage imageNamed:selectedImages[i]];
        naviViewController.tabBarItem = barItem;
        [naviViewControllers addObject:naviViewController];
    }
    return naviViewControllers;
}

@end
