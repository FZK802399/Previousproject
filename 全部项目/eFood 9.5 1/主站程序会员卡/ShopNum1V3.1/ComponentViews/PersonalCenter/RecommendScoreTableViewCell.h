//
//  RecommendScoreTableViewCell.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-11-11.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendScoreModel.h"

@interface RecommendScoreTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *ScoreTime;
@property (strong, nonatomic) IBOutlet UILabel *changeScore;
@property (strong, nonatomic) IBOutlet UILabel *LastScore;

-(void)creatRecommendScoreTableViewCell:(RecommendScoreModel *)model;

@end
