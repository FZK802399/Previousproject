//
//  WeiXinViewController.h
//  MSSideBarMenu
//
//  Created by baobin on 14-3-5.
//  Copyright (c) 2014年 baobin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"

@protocol WeiXinShareDelegate <NSObject>

@optional
- (void)weiXinShareSucceed;
- (void)weiXinNotInstall;

@end

@interface WeiXinViewController : UIViewController <WXApiDelegate>
@property (nonatomic, assign) id delegate;

- (void)sendWeiXinWithWebUrlString:(NSString*)webUrlString_ andScene:(int)scene_ andTitle:(NSString*)titleString_;//分享链接

@end
