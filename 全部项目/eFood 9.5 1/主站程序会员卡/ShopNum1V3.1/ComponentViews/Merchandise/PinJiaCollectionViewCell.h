//
//  PinJiaCollectionViewCell.h
//  ShopNum1V3.1
//
//  Created by Mac on 15/11/20.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kPinJiaCellIdentifier;

@class MerchandisePingJiaModel;
@class PinJiaCollectionViewCell;

@protocol PinJiaCollectionViewCellDelegate <NSObject>

@required
- (void)didSelectImageViewAtIndex:(NSInteger)index;
@end

@interface PinJiaCollectionViewCell : UICollectionViewCell


+ (CGSize)sizeWithMerchandisePingJiaModel:(MerchandisePingJiaModel *)model;
- (void)updateViewWithMerchandisePingJiaModel:(MerchandisePingJiaModel *)model;

@end
