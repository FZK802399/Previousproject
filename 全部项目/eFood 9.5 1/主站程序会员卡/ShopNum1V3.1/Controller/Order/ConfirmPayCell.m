//
//  ConfirmPayCell.m
//  ShopNum1V3.1
//
//  Created by yons on 15/11/19.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "ConfirmPayCell.h"

@implementation ConfirmPayCell

-(void)setModel:(PayMentListModel *)model
{
    _model = model;
    self.selectBtn.selected = model.isSelected;
    _name.text = model.NAME;
}

- (void)awakeFromNib {
    self.selectBtn.userInteractionEnabled = NO;
}
- (IBAction)selectClick:(id)sender {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
