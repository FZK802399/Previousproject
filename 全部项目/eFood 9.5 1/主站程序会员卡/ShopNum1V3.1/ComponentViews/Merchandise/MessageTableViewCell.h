//
//  MessageTableViewCell.h
//  ShopNum1V3.1
//
//  Created by Mac on 16/1/6.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell

+ (CGFloat)heightWithMessage:(EMMessage *)msg;
- (void)updateViewWithMessage:(EMMessage *)msg;

@end
