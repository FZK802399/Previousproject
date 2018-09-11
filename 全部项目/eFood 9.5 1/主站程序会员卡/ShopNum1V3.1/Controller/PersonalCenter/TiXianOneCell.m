//
//  TiXianOneCell.m
//  ShopNum1V3.1
//
//  Created by yons on 16/3/7.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import "TiXianOneCell.h"

@interface TiXianOneCell ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@end

@implementation TiXianOneCell

-(void)refreshWithMoney:(NSString *)Money
{
    self.label.text = [NSString stringWithFormat:@"账户余额：%@，本次最多转出%@",Money,Money];
}

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
