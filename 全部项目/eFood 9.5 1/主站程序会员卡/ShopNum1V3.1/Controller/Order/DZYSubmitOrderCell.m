//
//  DZYSubmitOrderCell.m
//  ShopNum1V3.1
//
//  Created by yons on 16/1/20.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import "DZYSubmitOrderCell.h"
#import "UIImageView+WebCache.h"
@interface DZYSubmitOrderCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *num;
@property (weak, nonatomic) IBOutlet UILabel *jinkouS;
@property (weak, nonatomic) IBOutlet UILabel *rmbPrice;

@end

@implementation DZYSubmitOrderCell

-(void)setModel:(OrderMerchandiseSubmitModel *)model
{
    _model = model;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.OriginalImge]];
    self.name.text = model.Name;
    self.price.text = [NSString stringWithFormat:@"价格：AU$%.2f",model.BuyPrice];
    self.rmbPrice.text = [NSString stringWithFormat:@"约¥ %.2f",model.MarketPrice];
    self.num.text = [NSString stringWithFormat:@"x%ld",model.BuyNumber];
    self.jinkouS.text = [NSString stringWithFormat:@"进口税：AU$%.2f",model.IncomeTax*model.BuyNumber];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
