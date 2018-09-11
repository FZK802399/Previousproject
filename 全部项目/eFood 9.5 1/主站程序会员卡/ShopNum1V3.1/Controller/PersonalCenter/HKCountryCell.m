//
//  HKCountryCell.m
//  ShopNum1V3.1
//
//  Created by Mac on 16/6/2.
//  Copyright © 2016年 WFS. All rights reserved.
//

#import "HKCountryCell.h"

@implementation HKCountryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.countryNameLabel setTextColor:[UIColor colorWithRed:91/225.0 green:91/225.0 blue:91/225.0 alpha:1.0]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
