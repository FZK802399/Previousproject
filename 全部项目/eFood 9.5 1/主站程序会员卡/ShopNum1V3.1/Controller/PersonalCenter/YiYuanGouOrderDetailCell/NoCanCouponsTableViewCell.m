//
//  NoCanCouponsTableViewCell.m
//  ShopNum1V3.1
//
//  Created by 森泓投资 on 16/8/15.
//  Copyright © 2016年 WFS. All rights reserved.
//

#import "NoCanCouponsTableViewCell.h"

@implementation NoCanCouponsTableViewCell


-(void)setNcmodel:(CouponsModel *)ncmodel
{
    _ncmodel = ncmodel;
    self.ncmodel.money = ncmodel.money;
    self.ncmodel.moneyMake = ncmodel.moneyMake;
    self.ncmodel.coupons = ncmodel.coupons;
    self.ncmodel.time = ncmodel.time;

    self.moneyLabel.text=ncmodel.money;
    self.moneyMakeLabel.text=ncmodel.moneyMake;
    self.couponsLabel.text=ncmodel.coupons;
    self.timeLabel.text=ncmodel.time;

}
+(NoCanCouponsTableViewCell *)nocCanCoupons
{
    NoCanCouponsTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"NoCanCouponsTableViewCell" owner:nil options:nil] firstObject];
    return cell;
    
    


}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
