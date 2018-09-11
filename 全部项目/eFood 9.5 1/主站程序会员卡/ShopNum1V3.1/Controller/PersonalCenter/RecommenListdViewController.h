//
//  RecommenListdViewController.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-11-11.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "WFSViewController.h"
#import "RecommendPersonTableViewCell.h"
#import "RecommendScoreTableViewCell.h"

typedef enum{
    RecommendForPerson = 0,
    RecommendForScore = 1
    
} RecommendListViewType;

///我要推荐
@interface RecommenListdViewController : WFSViewController<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIView *viewcontent;
@property (strong, nonatomic) IBOutlet UIButton *RecommendPerBtn;
@property (strong, nonatomic) IBOutlet UIButton *RecommendScoreBtn;
@property (strong, nonatomic) IBOutlet UITableView *ShowTableView;

@property (strong, nonatomic) NSMutableArray *ShowData;

@property (strong, nonatomic) NSArray *personData;

@property (strong, nonatomic) NSArray *rebateData;

@property (assign, nonatomic) RecommendListViewType ShowType;

- (IBAction)changeViewAction:(id)sender;

@end
