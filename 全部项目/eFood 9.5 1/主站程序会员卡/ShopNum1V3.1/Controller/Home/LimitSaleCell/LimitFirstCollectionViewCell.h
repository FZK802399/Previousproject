//
//  LimitFirstCollectionViewCell.h
//  ShopNum1V3.1
//
//  Created by Mac on 15/12/24.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kLimitFirstCellIdentifier;
@class SaleProductModel;

@protocol LimitFirstCollectionViewCellDelegate <NSObject>

@required
- (void)didSelectCollect;

@end

@interface LimitFirstCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) id<LimitFirstCollectionViewCellDelegate> delegate;
@property (assign, nonatomic) BOOL isCollect;
@property (assign, nonatomic) BOOL isEndTime;

@property (assign, nonatomic) SaleType saleType;

- (void)updateViewWithModel:(SaleProductModel *)model;
- (void)updateTimeLabelWithComponent:(NSDateComponents *)component;

- (void)beginScorll;
- (void)endScorll;

@end
