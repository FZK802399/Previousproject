//
//  ScoreDetailViewController.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-9-2.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "WFSViewController.h"
#import "ScoreModel.h"
///积分详情
@interface ScoreDetailViewController : WFSViewController<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *currentScore;
@property (strong, nonatomic) IBOutlet UITableView *ScoreDetailTbleView;
@property (strong, nonatomic) NSArray *ScoreDetailList;

@end
