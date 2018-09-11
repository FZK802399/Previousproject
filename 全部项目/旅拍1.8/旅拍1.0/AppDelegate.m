//
//  AppDelegate.m
//  旅拍1.0
//
//  Created by 司马帅帅 on 15/7/6.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworking.h"
#import "Header.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //用户注册登录
    [self userLogin];
    
    return YES;
}

//用户注册登录
- (void)userLogin
{
    NSString *userID = [USER_DEFAULT objectForKey:@"UserId"];
    if (!userID) {
        //AFNetworking 发送GET请求
        NSString *urlString = [NSString stringWithFormat:@"%@%@",LocalWebSite,Reuqest_Login];
        //初始化请求（同时也创建了一个线程）
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        //设置请求可以接受的内容的样式
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        //发送GET请求
        [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"注册成功 %@",responseObject);
            //获取用户的userId并且保存起来
            NSDictionary *dic = (NSDictionary *)responseObject;
            [USER_DEFAULT setObject:[dic objectForKey:@"userId"] forKey:@"UserId"];
            [USER_DEFAULT synchronize];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"注册失败 %@",error);
        }];
    } else {
        NSLog(@"登陆成功");
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
