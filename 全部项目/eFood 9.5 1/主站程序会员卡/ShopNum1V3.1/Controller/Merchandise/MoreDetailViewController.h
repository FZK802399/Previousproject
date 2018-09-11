//
//  MoreDetailViewController.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-25.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "WFSViewController.h"

@interface MoreDetailViewController : WFSViewController

@property (strong, nonatomic) IBOutlet UIWebView *detailWebView;
@property (strong, nonatomic) NSString * htmlStr;

@end
