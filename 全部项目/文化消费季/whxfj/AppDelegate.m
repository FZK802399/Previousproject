//
//  AppDelegate.m
//  whxfj
//
//  Created by 司马帅帅 on 14-8-23.
//  Copyright (c) 2014年 baobin. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

#import "WXApi.h"
#import "WeiXinViewController.h"

#import <TencentOpenAPI/TencentOAuth.h>
#import "QQViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    //设置电池条字体为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    MainViewController *mainViewController = [[MainViewController alloc] init];
    UINavigationController *navMainViewController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    self.window.rootViewController = navMainViewController;
    
    //初始化分享控制器
    [self initShareViewController];
    
    return YES;
}

//初始化分享控制器
- (void)initShareViewController
{
    //初始化微信控制器weixinViewController
    _weixinViewController = [[WeiXinViewController alloc] init];
    //初始化QQ控制器qqViewController
    _qqViewController = [[QQViewController alloc] init];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSLog(@"msmsm1 %@", url);
    if ([url isEqual:[NSURL URLWithString:kWXRedirectUrl]]) {
        return [WXApi handleOpenURL:url delegate:self.weixinViewController];
    } else {
        return YES;
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"msmsm2 %@", url);
    if ([[url absoluteString] hasPrefix:@"wxae1c90ff75fef1f3:"]) {
        return [WXApi handleOpenURL:url delegate:self.weixinViewController];
    } else if ([[url absoluteString] hasPrefix:@"tencent222222:" ]) {
        return [TencentOAuth HandleOpenURL:url];
    } else {
        return YES;
    }
}

@end
