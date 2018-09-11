//
//  OrderCell.m
//  ShopNum1V3.1
//
//  Created by yons on 15/11/24.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "OrderCell.h"
@implementation OrderCell

-(void)setModel:(OrderMerchandiseIntroModel *)model
{
    _model = model;
    [self.imgView setImageWithURL:[NSURL URLWithString:model.ProductImgStr]];
    self.title.text = model.ProductName;
    self.price.text = [NSString stringWithFormat:@"AU$%.2f x%ld",model.BuyPrice,model.BuyNumber];
    self.type.text = model.SpecificationName;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
