//
//  OrderPayOnlineViewController.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-9-3.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "WFSViewController.h"

@interface OrderPayOnlineViewController : WFSViewController
@property (strong, nonatomic) IBOutlet UIWebView *payWebView;
@property (strong, nonatomic) NSURL *payWebUrl;
///标题
@property (strong, nonatomic) NSString * str;
@end
