//
//  MyGroupDetailCell.m
//  ShopNum1V3.1
//
//  Created by yons on 16/3/7.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import "MyGroupDetailCell.h"

@interface MyGroupDetailCell ()
@property (weak, nonatomic) IBOutlet UILabel *orderNum;
@property (weak, nonatomic) IBOutlet UILabel *price;

@end

@implementation MyGroupDetailCell

- (void)setModel:(MyGroupDetailModel *)model
{
    _model = model;
    self.orderNum.text = [NSString stringWithFormat:@"订单编号: %@",model.OrderNumber];
    self.price.text = [NSString stringWithFormat:@"¥%.2f",model.Profit];
}

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
