//
//  WaterFlowViewCell.h
//  美丽中国
//
//  Created by 司马帅帅 on 15/7/20.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//


#import <UIKit/UIKit.h>
@class CityInfo;

@interface WaterFlowViewCell : UICollectionViewCell

//设置显示内容
- (void)setContentView:(CityInfo*)cityInfo;

@end
