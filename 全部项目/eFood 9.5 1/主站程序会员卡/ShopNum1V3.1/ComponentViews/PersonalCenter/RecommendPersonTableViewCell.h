//
//  RecommendPersonTableViewCell.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-11-11.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendPersonModel.h"

@interface RecommendPersonTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *userId;
@property (strong, nonatomic) IBOutlet UILabel *recommendEmail;
@property (strong, nonatomic) IBOutlet UILabel *recommendPhone;
@property (strong, nonatomic) IBOutlet UILabel *recommendName;
@property (strong, nonatomic) IBOutlet UILabel *recommendSex;

-(void)creatRecommendPersonTableViewCell:(RecommendPersonModel *)model;

@end
