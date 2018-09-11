//
//  RefundOrderCell.m
//  ShopNum1V3.1
//
//  Created by yons on 15/12/1.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "RefundOrderCell.h"

@implementation RefundOrderCell

-(void)setModel:(OrderMerchandiseIntroModel *)model
{
    _model = model;
    [self.imgView setImageWithURL:[NSURL URLWithString:model.ProductImgStr]];
    self.title.text = model.ProductName;
    self.price.text = [NSString stringWithFormat:@"AU$%.2f",model.BuyPrice];
    self.type.text = model.SpecificationName;
    self.btn.selected = model.isSelect;
    self.num.text = [NSString stringWithFormat:@"%ld",model.refundNum];
}

- (void)awakeFromNib {
    // Initialization code
    self.num.layer.borderWidth = 1;
    self.num.layer.borderColor = LINE_DARKGRAY.CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)click:(UIButton *)sender {
    if([self.delegate respondsToSelector:@selector(goodsReduceOrAddWithModel:addCell:andBtn:)])
    {
        [self.delegate goodsReduceOrAddWithModel:self.model addCell:self andBtn:sender];
    }
}

@end
