//
//  YiYuanGouOrderListCollectionViewCell.h
//  ShopNum1V3.1
//
//  Created by Mac on 15/12/31.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kYiYuanGouOrderListCellIdentifier;

@class YiYuanGouModel;
@class YiYuanGouOrderListCollectionViewCell;

@protocol YiYuanGouOrderListCollectionViewCellDelegate <NSObject>

@optional
- (void)didSelectGoBuy:(YiYuanGouOrderListCollectionViewCell *)cell;

@end

@interface YiYuanGouOrderListCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) id<YiYuanGouOrderListCollectionViewCellDelegate> delegate;

- (void)updateViewWithModel:(YiYuanGouModel *)model;

@end
