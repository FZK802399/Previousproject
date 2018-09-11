//
//  CityListCell.h
//  美丽中国
//
//  Created by 司马帅帅 on 15/7/21.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PanoInfo;

@interface CityListCell : UITableViewCell

//设置内容视图里显示的内容
- (void)setContentView:(PanoInfo *)panoInfo;

//获取cell高度
+ (CGFloat)getHeight;

@end
