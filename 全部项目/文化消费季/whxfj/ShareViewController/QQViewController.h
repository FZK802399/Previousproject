//
//  QQViewController.h
//  MSSideBarMenu
//
//  Created by baobin on 14-3-6.
//  Copyright (c) 2014年 baobin. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class WebListInfo;

#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>

@interface QQViewController : UIViewController

- (void)sendQQWithWebUrlString:(NSString*)webUrlString_ andTitle:(NSString *)titleString_;//分享链接

@end
