//
//  ShopCartTableViewCell.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-29.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>
#import "ShopCartMerchandiseModel.h"
#import "ShopCartScoreMerchandiseModel.h"

@class ShopCartTableViewCell;

typedef enum {
    kCellStateCenter,
    kCellStateLeft,
    kCellStateRight
} SWCellState;

@protocol ShopCartTableViewCellDelegate <NSObject>

@optional
- (void)swippableTableViewCell:(ShopCartTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index;
- (void)swippableTableViewCell:(ShopCartTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index;
- (void)swippableTableViewCell:(ShopCartTableViewCell *)cell scrollingToState:(SWCellState)state;

- (void)countAdd:(id)merchandise;

- (void)countSubtract:(id)merchandise;

- (void)clickImageOrTitle:(id)merchandise;

///True Check
- (void)btnCheckOrUnCheck:(id)merchandise status:(Boolean)isCheck;

@end

@interface ShopCartTableViewCell : UITableViewCell

@property (nonatomic, strong) NSArray *leftUtilityButtons;
@property (nonatomic, strong) NSArray *rightUtilityButtons;
@property (nonatomic) id <ShopCartTableViewCellDelegate> delegate;
@property (nonatomic, strong) id currentMerchandise;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containingTableView:(UITableView *)containingTableView leftUtilityButtons:(NSArray *)leftUtilityButtons rightUtilityButtons:(NSArray *)rightUtilityButtons;

- (void)setBackgroundColor:(UIColor *)backgroundColor;
- (void)hideUtilityButtonsAnimated:(BOOL)animated;

-(void)creatShopCartTableViewCellWithShopCartMerchandiseModel:(ShopCartMerchandiseModel*)intro;

-(void)creatShopCartTableViewCellWithShopCartScoreMerchandiseModel:(ShopCartScoreMerchandiseModel*)intro;

@end

