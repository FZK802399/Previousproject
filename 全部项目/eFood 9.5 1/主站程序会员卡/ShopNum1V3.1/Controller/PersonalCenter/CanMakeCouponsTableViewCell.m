//
//  CanMakeCouponsTableViewCell.m
//  ShopNum1V3.1
//
//  Created by 森泓投资 on 16/8/15.
//  Copyright © 2016年 WFS. All rights reserved.
//

#import "CanMakeCouponsTableViewCell.h"

@implementation CanMakeCouponsTableViewCell

-(void)setCmodel:(CouponsModel *)cmodel
{
    _didSelect = NO;
    NSString *rttype=[NSString stringWithFormat:@"%@",cmodel.RTtype];
    NSLog(@"rttype=========%@",rttype);
    if ([rttype isEqualToString:@"1"]) {
        self.backImageView.image =[UIImage imageNamed:@"one"];
    }else if ([rttype isEqualToString:@"2"]){
        self.backImageView.image =[UIImage imageNamed:@"two"];
    }else{
        self.backImageView.image =[UIImage imageNamed:@"three"];
    }
    _cmodel = cmodel;
    self.backImage =cmodel.backImage;
    self.moneyLabel.text = cmodel.money;
    self.moneyMakeLabel.text  =cmodel.moneyMake;
    self.CouponsLabel.text = cmodel.coupons;
    self.timeLabel.text = cmodel.time;

}


+(CanMakeCouponsTableViewCell *)canMakeCoupons
{

    CanMakeCouponsTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"CanMakeCouponsTableViewCell" owner:nil options:nil] firstObject];
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
