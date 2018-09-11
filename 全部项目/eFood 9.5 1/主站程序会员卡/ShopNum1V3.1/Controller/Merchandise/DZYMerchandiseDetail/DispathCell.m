//
//  DispathCell.m
//  ShopNum1V3.1
//
//  Created by yons on 16/1/27.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import "DispathCell.h"

@interface DispathCell ()

@end

@implementation DispathCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.kucun.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
