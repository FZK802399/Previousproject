//
//  FavourTicketCollectionViewCell.h
//  ShopNum1V3.1
//
//  Created by Mac on 16/1/12.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kFavourTicketCollectionViewCellIdentifier;

@class FavourTicketModel;

@interface FavourTicketCollectionViewCell : UICollectionViewCell

- (void)updateViewWithFavourTicketModel:(FavourTicketModel *)model;

@end
