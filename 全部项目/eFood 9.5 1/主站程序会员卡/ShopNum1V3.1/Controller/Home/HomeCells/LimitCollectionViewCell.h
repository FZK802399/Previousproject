//
//  LimitCollectionViewCell.h
//  ShopNum1V3.1
//
//  Created by Mac on 15/12/22.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SaleProductModel;

extern NSString *const kLimitCollectionViewCell;

@interface LimitCollectionViewCell : UICollectionViewCell

@property (assign, nonatomic) SaleType saleType;

+ (CGSize)XianShiCellSize;
- (void)updateViewWithModel:(SaleProductModel *)model;
- (void)updateTimeLabel;
@end
