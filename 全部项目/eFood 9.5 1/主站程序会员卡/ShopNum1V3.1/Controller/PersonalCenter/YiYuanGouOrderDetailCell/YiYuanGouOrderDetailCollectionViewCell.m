//
//  YiYuanGouOrderDetailCollectionViewCell.m
//  ShopNum1V3.1
//
//  Created by Mac on 15/12/31.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "YiYuanGouOrderDetailCollectionViewCell.h"
#import "YiYuanGouModel.h"

NSString *const kYiYuanGouOrderDetailCellIdentifier = @"YiYuanGouOrderDetailCollectionViewCell";

@interface YiYuanGouOrderDetailCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *payTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeOrderDateLabel; //下单时间
@property (weak, nonatomic) IBOutlet UILabel *payDateLabel; // 支付时间


@end

@implementation YiYuanGouOrderDetailCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[NSBundle mainBundle] loadNibNamed:kYiYuanGouOrderDetailCellIdentifier owner:nil options:nil].firstObject;
    }
    return self;
}

- (void)awakeFromNib {
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = LINE_LIGHTGRAY.CGColor;
}

- (void)updateViewWithModel:(YiYuanGouModel *)model {

    self.orderNumberLabel.text = [NSString stringWithFormat:@"订单号：%@", model.OrderNumber];
    self.payTypeLabel.text = [NSString stringWithFormat:@"支付方式：%@", model.PayType];
    self.placeOrderDateLabel.text = [NSString stringWithFormat:@"下单时间：%@", model.ConfirmTime];
    self.payDateLabel.text = [NSString stringWithFormat:@"支付时间：%@", model.PayTime];
}


@end
