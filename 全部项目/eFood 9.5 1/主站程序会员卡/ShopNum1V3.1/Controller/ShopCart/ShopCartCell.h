//
//  ShopCartCell.h
//  ShopNum1V3.1
//
//  Created by yons on 15/11/27.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopCartMerchandiseModel.h"
@class ShopCartCell;
@protocol ShopCartDelegate <NSObject>

//- (void)cellDidSelectWithModel:(ShopCartMerchandiseModel *)model andCell:(ShopCartCell *)cell;


-(void)goodsReduceOrAddWithModel:(ShopCartMerchandiseModel *)model addCell:(ShopCartCell *)cell andBtn:(UIButton *)btn;
@end

@interface ShopCartCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *rmbPrice;
@property (weak, nonatomic) IBOutlet UILabel *num;
///这两没用 就是加边框
@property (weak, nonatomic) IBOutlet UIButton *jian;
@property (weak, nonatomic) IBOutlet UIButton *jia;

@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (nonatomic,strong)ShopCartMerchandiseModel * model;
@property (nonatomic,weak)id<ShopCartDelegate> delegate;
@end
