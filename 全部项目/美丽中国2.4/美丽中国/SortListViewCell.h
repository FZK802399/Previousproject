//
//  SortListViewCell.h
//  美丽中国
//
//  Created by 司马帅帅 on 15/7/25.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PanoInfo;

@interface SortListViewCell : UITableViewCell

//设置内容视图显示内容
- (void)setContentView:(PanoInfo *)panoInfo;

//获取cell的高度
+(CGFloat)getCellHeight;

@end
