//
//  AppDelegate.h
//  whxfj
//
//  Created by 司马帅帅 on 14-8-23.
//  Copyright (c) 2014年 baobin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeiXinViewController;
@class QQViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, nonatomic) WeiXinViewController *weixinViewController;
@property (readonly, nonatomic) QQViewController *qqViewController;

@end
