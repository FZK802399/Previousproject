//
//  ShiYuanCollectionViewCell.h
//  ShopNum1V3.1
//
//  Created by Mac on 15/12/23.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kShiYuanCollectionViewCell;

@class FloorProductModel;

@interface ShiYuanCollectionViewCell : UICollectionViewCell

+ (CGSize)shiYuanCellSize;
- (void)updateViewWithModel:(FloorProductModel *)model;

@end
