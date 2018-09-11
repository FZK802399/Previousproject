//
//  YiYuanGouDetailBaseCollectionViewCell.h
//  ShopNum1V3.1
//
//  Created by Mac on 15/12/31.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YiYuanGouModel;

@protocol YiYuanGouDetailBaseCollectionViewCellDelegate <NSObject>

@optional
- (void)didSelectCheckLogistics;

@end

@interface YiYuanGouDetailBaseCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) id<YiYuanGouDetailBaseCollectionViewCellDelegate> delegate;

- (void)updateViewWithModel:(YiYuanGouModel *)model;

@end
