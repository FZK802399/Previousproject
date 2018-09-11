//
//  XianLiangCollectionViewCell.h
//  ShopNum1V3.1
//
//  Created by Mac on 15/12/28.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kXianLiangCellIdentifier;

@class XianLiangCollectionViewCell;

@protocol XianLiangCollectionViewCellDelegate <NSObject>

@required
- (void)didSelectXianLiangCellAtIndex:(NSInteger)index;

@end

@interface XianLiangCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) id<XianLiangCollectionViewCellDelegate> delegate;

- (void)updateViewWithSaleProductModels:(NSArray *)models;

@end
