//
//  ShopCartCell.m
//  ShopNum1V3.1
//
//  Created by yons on 15/11/27.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "ShopCartCell.h"

@implementation ShopCartCell

-(void)setModel:(ShopCartMerchandiseModel *)model
{
    _model = model;
    [self.imgView setImageWithURL:[NSURL URLWithString:model.originalImageStr]];
    self.title.text = model.name;
    self.type.text = model.Attributes;
    self.price.text = [NSString stringWithFormat:@"AU$%.2f",model.buyPrice];
    self.rmbPrice.text = [NSString stringWithFormat:@"约¥%.2f",model.MarketPrice];
    self.num.text = [NSString stringWithFormat:@"%ld",model.buyNumber];
    self.btn.selected = model.isCheckForShopCart;
}

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.num.layer.borderColor = LINE_DARKGRAY.CGColor;
    self.num.layer.borderWidth = 1;
    self.btn.userInteractionEnabled = NO;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(goodsReduceOrAddWithModel:addCell:andBtn:)]) {
        [self.delegate goodsReduceOrAddWithModel:self.model addCell:self andBtn:sender];
    }
}
@end
