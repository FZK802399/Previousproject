//
//  TeJiaCollectionViewCell.h
//  ShopNum1V3.1
//
//  Created by Mac on 15/12/23.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kTeJiaCollectionViewCell;

@protocol TeJiaCollectionViewCellDelegate <NSObject>

@required
- (void)teJiaCellDidSelectAtIndex:(NSInteger)index;
@end

@interface TeJiaCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) id<TeJiaCollectionViewCellDelegate> delegate;

- (void)updateViewWithModels:(NSArray *)models;

@end
