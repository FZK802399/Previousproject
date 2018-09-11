//
//  RecommendPersonTableViewCell.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-11-11.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "RecommendPersonTableViewCell.h"

@implementation RecommendPersonTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleGray;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)creatRecommendPersonTableViewCell:(RecommendPersonModel *)model{
    self.userId.text = model.CommendPeople;
    self.recommendEmail.text = model.Email;
    self.recommendName.text = model.RealName;
    self.recommendPhone.text = model.Mobile;
    self.recommendSex.text = model.Sex == 0 ? @"女" : @"男";
}

@end
