//
//  AppDelegate.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-4.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppConfig.h"
#import "WXApi.h"
#import "EMChatManagerDelegate.h"
#define ApplicationDelegate ((AppDelegate*)[UIApplication sharedApplication].delegate)
@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate,WXApiDelegate,EMChatManagerDelegate,UIAlertViewDelegate>

@property (strong ,nonatomic) NSDictionary *loginDic;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) AppConfig *appConfig;
@end
