//
//  TiXianThreeCell.m
//  ShopNum1V3.1
//
//  Created by yons on 16/3/8.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import "TiXianThreeCell.h"

@interface TiXianThreeCell ()


@end

@implementation TiXianThreeCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)click:(id)sender {
    [self.textField resignFirstResponder];
}
@end
