//
//  BanJiaCollectionViewCell.h
//  ShopNum1V3.1
//
//  Created by Mac on 15/12/23.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kBanJiaCollectionViewCell;

@class FloorProductModel;

@interface BanJiaCollectionViewCell : UICollectionViewCell

+ (CGSize)banJiaCellsize;
- (void)updateViewWithModel:(FloorProductModel *)model;

@end
