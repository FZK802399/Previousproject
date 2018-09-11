//
//  MessageDetailViewController.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-9-11.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "WFSViewController.h"
#import "MessageModelMy.h"
@interface MessageDetailViewController : WFSViewController

@property (strong, nonatomic) MessageModelMy * MessageDeatil;
@property (strong, nonatomic) IBOutlet UILabel *TitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *TimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *ContentLabel;

@end
