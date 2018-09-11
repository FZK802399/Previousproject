//
//  MyListCell.h
//  旅拍1.0
//
//  Created by 司马帅帅 on 15/7/15.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WebInfo;

@interface MyListCell : UITableViewCell

//设置内容视图显示内容
- (void)setContentView:(WebInfo *)webInfo;

+ (CGFloat)getCellHeight;

@end
