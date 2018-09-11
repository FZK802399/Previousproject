//
//  BaseViewController.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-12.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppConfig.h"

@interface BaseViewController : UITabBarController
@property (strong, nonatomic) AppConfig *appConfig;
@end
