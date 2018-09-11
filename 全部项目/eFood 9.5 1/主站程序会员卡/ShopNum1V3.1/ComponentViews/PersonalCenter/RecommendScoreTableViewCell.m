//
//  RecommendScoreTableViewCell.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-11-11.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "RecommendScoreTableViewCell.h"

@implementation RecommendScoreTableViewCell

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

-(void)creatRecommendScoreTableViewCell:(RecommendScoreModel *)model {
    self.ScoreTime.text = model.CreateTime;
    self.changeScore.text = [NSString stringWithFormat:@"%d", model.OperateScore];
    self.LastScore.text = [NSString stringWithFormat:@"%d", model.LastOperateScore];
}

@end
