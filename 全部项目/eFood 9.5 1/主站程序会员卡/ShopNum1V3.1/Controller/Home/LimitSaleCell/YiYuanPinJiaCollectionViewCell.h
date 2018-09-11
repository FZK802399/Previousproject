//
//  YiYuanPinJiaCollectionViewCell.h
//  ShopNum1V3.1
//
//  Created by Mac on 15/12/29.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kYiYuanPinJiaCellIdentifier;

@interface YiYuanPinJiaCollectionViewCell : UICollectionViewCell

- (void)updateViewWithPinJiaCount:(NSInteger)count;

@end
