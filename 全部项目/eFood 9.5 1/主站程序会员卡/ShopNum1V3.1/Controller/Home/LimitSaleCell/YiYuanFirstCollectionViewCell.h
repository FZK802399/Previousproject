//
//  YiYuanFirstCollectionViewCell.h
//  ShopNum1V3.1
//
//  Created by Mac on 15/12/29.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kYiYuanFirstCellIdentifier;

@class YiYuanGouModel;

@protocol YiYuanFirstCollectionViewCellDelegate <NSObject>

@required
- (void)didSelectCollect;

@end

@interface YiYuanFirstCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) id<YiYuanFirstCollectionViewCellDelegate> delegate;
@property (assign, nonatomic) BOOL isCollect;

- (void)updateViewWithModel:(YiYuanGouModel *)model;

- (void) beginScorll;
- (void) endScorll;

@end
