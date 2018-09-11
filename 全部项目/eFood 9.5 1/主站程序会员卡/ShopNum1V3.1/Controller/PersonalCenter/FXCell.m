//
//  FXCell.m
//  万汇江分界面
//
//  Created by dzy_PC on 15/11/25.
//  Copyright (c) 2015年 dzy_PC. All rights reserved.
//

#import "FXCell.h"

@implementation FXCell

-(void)setModel:(FXModel *)model
{
    _model = model;
    self.name.text = model.MemLoginID;
    self.price.text = [NSString stringWithFormat:@"AU$%.2f",model.Profit];
}

- (void)awakeFromNib {
    self.imgView.layer.masksToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
