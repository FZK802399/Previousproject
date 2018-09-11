//
//  YiYuanCollectionViewCell.h
//  ShopNum1V3.1
//
//  Created by Mac on 15/12/22.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kYiYuanCollectionViewCell;

@class YiYuanGouModel;

@interface YiYuanCollectionViewCell : UICollectionViewCell

- (void)updateViewWithModel:(YiYuanGouModel *)model;

@end
