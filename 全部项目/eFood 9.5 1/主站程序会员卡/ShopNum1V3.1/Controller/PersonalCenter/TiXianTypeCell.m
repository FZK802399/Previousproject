//
//  TiXianTypeCell.m
//  ShopNum1V3.1
//
//  Created by yons on 16/3/8.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import "TiXianTypeCell.h"

@interface TiXianTypeCell ()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *gouXuan;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *width;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation TiXianTypeCell

-(void)setModel:(BankModel *)model
{
    _model = model;
    self.name.text = model.BankName;
    self.gouXuan.hidden = !model.isSelected;
}

- (void)updateWithBool:(BOOL)isClick
{
    if (isClick) {
        self.width.constant = 55;
        [self.btn setTitle:@"管理" forState:UIControlStateNormal];
    }
    else
    {
        self.width.constant = 0;
        [self.btn setTitle:@"" forState:UIControlStateNormal];
    }
}

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.btn.layer.cornerRadius = 3;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)guanli:(id)sender {
    if ([self.delegate respondsToSelector:@selector(tiXianTypeCell:didClickWithSection:)]) {
        [self.delegate tiXianTypeCell:self didClickWithSection:0];
    }
}
@end
