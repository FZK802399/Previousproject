//
//  FIrstCollectionViewCell.h
//  ShopNum1V3.1
//
//  Created by Mac on 15/12/23.
//  Copyright (c) 2015年 WFS. All rights reserved.
//


#import <UIKit/UIKit.h>

extern NSString *const kFirstContentCollectionViewCell;

@class FIrstCollectionViewCell;
@protocol FIrstCollectionViewCellDelegate <NSObject>

@required
- (void) firstCollectionViewCell:(FIrstCollectionViewCell *)view clickAtIndex:(NSInteger)index;
@end

@interface FIrstCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) id<FIrstCollectionViewCellDelegate> delegate;

@end
