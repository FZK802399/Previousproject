//
//  TiXianDetailCell.m
//  ShopNum1V3.1
//
//  Created by yons on 16/3/8.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import "TiXianDetailCell.h"

@interface TiXianDetailCell ()
@property (weak, nonatomic) IBOutlet UILabel *detail;
@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *date;

@end

@implementation TiXianDetailCell

-(void)setModel:(TiXianModel *)model
{
    _model = model;
    self.detail.text = model.Memo;
    NSString * bank;
    if (model.Account.length > 4) {
        bank = [model.Account substringFromIndex:model.Account.length-4];
        self.bankName.text = [NSString stringWithFormat:@"%@（尾号 %@）",model.Bank,bank];
    }
    else
    {
        self.bankName.text = [NSString stringWithFormat:@"%@",model.Bank];
    }
    self.price.text = [NSString stringWithFormat:@"-¥%.2f",model.OperateMoney];
    NSString * str = [model.Date componentsSeparatedByString:@" "].firstObject;
    self.date.text = str;
}

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
