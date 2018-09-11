//
//  RefundOrderCell.h
//  ShopNum1V3.1
//
//  Created by yons on 15/12/1.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderMerchandiseIntroModel.h"
@class RefundOrderCell;

@protocol RefundGoodDelegate <NSObject>

-(void)goodsReduceOrAddWithModel:(OrderMerchandiseIntroModel *)model addCell:(RefundOrderCell *)cell andBtn:(UIButton *)btn;

@end


@interface RefundOrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *num;

@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (nonatomic,strong)OrderMerchandiseIntroModel * model;
@property (nonatomic,weak)id<RefundGoodDelegate> delegate;
@end
