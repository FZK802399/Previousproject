//
//  LimitNameCollectionViewCell.h
//  ShopNum1V3.1
//
//  Created by Mac on 15/12/24.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kLimitListCellIdentifier;

/// 抢购名称Cell
@interface LimitNameCollectionViewCell : UICollectionViewCell

- (void)updateViewWithModel:(id)model;

@end
