//
//  TiXianTypeCell.h
//  ShopNum1V3.1
//
//  Created by yons on 16/3/8.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BankModel.h"
@class TiXianTypeCell;
@protocol TiXianTypeCellDelegate <NSObject>

- (void)tiXianTypeCell:(TiXianTypeCell *)cell didClickWithSection:(NSInteger )section;

@end

@interface TiXianTypeCell : UITableViewCell
@property (nonatomic,strong)BankModel * model;
@property (nonatomic,weak)id<TiXianTypeCellDelegate>delegate;
- (void)updateWithBool:(BOOL)isClick;
@end
