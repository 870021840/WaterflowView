//
//  AppDelegate.m
//  瀑布流效果
//
//  Created by 谢满 on 15/5/2.
//  Copyright (c) 2015年 谢满. All rights reserved.
//

#import "AppDelegate.h"
#import "TestViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window  makeKeyAndVisible];
    self.window.rootViewController =  [[UINavigationController alloc] initWithRootViewController:[[TestViewController alloc] init]];

    return YES;
}


@end
