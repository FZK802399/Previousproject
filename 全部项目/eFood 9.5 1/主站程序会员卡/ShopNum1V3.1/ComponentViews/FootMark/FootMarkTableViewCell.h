//
//  FootMarkTableViewCell.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-11.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FootMarkModel.h"
#import "MerchandiseCollectModel.h"
#import "OrderMerchandiseIntroModel.h"
#import "SWUtilityButtonView.h"

typedef enum {
    kCellStateCenter,
    kCellStateLeft,
    kCellStateRight
} FMTCCellState;

@class FootMarkTableViewCell;
@protocol FootMarkTableViewCellDelegate <NSObject>

@optional

- (void)commentProduct:(OrderMerchandiseIntroModel *)model;
- (void)swippableTableViewCell:(FootMarkTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index;
- (void)swippableTableViewCell:(FootMarkTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index;
- (void)swippableTableViewCell:(FootMarkTableViewCell *)cell scrollingToState:(FMTCCellState)state;

@end

@interface FootMarkTableViewCell : UITableViewCell<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *leftUtilityButtons;
@property (nonatomic, strong) NSArray *rightUtilityButtons;

@property (nonatomic, assign) id<FootMarkTableViewCellDelegate> delegate;

@property (nonatomic, assign) FMTCCellState cellState;

@property (nonatomic, strong) UIImageView *showImage;//展示图片

@property (nonatomic, strong) UILabel *nameLabel;//商品名称

@property (nonatomic, strong) UILabel *MarketPriceLabel;//商品市场价格

@property (nonatomic, strong) UILabel *ShopPriceLabel;//商品店铺价格

@property (nonatomic, strong) UIButton *commentPicBtn;//商品晒单

@property (nonatomic, strong) OrderMerchandiseIntroModel *currentProduct;

@property (nonatomic, weak) UIScrollView *cellScrollView;

@property (nonatomic, weak) UIView *scrollViewContentView;
@property (nonatomic, strong) SWUtilityButtonView *scrollViewButtonViewLeft;
@property (nonatomic, strong) SWUtilityButtonView *scrollViewButtonViewRight;

// Used for row height and selection
@property (nonatomic, weak) UITableView *containingTableView;

// The cell's height
@property (nonatomic) CGFloat height;

//@property (nonatomic, strong) UILabel *saleNumLabel;//商品销量

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containingTableView:(UITableView *)containingTableView leftUtilityButtons:(NSArray *)leftUtilityButtons rightUtilityButtons:(NSArray *)rightUtilityButtons;

- (void)setBackgroundColor:(UIColor *)backgroundColor;
- (void)hideUtilityButtonsAnimated:(BOOL)animated;

//根据数据模型创建视图
-(void)creatFootMarkTableViewCellWithMerchandiseIntroModel:(FootMarkModel *) intro;

//根据数据模型创建视图
-(void)creatCollectTableViewCellWithMerchandiseIntroModel:(MerchandiseCollectModel *) intro;

//根据数据模型创建视图
-(void)creatCollectTableViewCellWithOrderMerchandiseIntroModel:(OrderMerchandiseIntroModel *) intro;

@end
