//
//  MemberCollectionViewCell.h
//  ShopNum1V3.1
//
//  Created by Mac on 15/12/23.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kMemberCollectionViewCell;

@class MemberFloorProductModel;

@interface MemberCollectionViewCell : UICollectionViewCell

+ (CGSize)memberCellSize;
- (void)updateViewWithModel:(MemberFloorProductModel *)model;

@end
