//
//  ScoreViewController.m
//  ShopNum1V3.1
//
//  Created by yons on 15/11/25.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "ScoreViewController.h"
#import "AFAppAPIClient.h"
#import "AppConfig.h"
#import "DzyScoreModel.h"
#import "ScoreCell.h"
@interface ScoreViewController ()
@property (nonatomic,strong)NSMutableArray * arr;
@end

@implementation ScoreViewController

-(NSMutableArray *)arr
{
    if (_arr == nil) {
        _arr = [NSMutableArray array];
    }
    return _arr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 65;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navigationItem.title = @"积分明细";
    [self loadDataFromWeb];
    [self setTableHeadView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)loadDataFromWeb
{
    [DzyScoreModel getScoreListWithBlock:^(NSArray *list, NSError *error) {
        if (list) {
            [self.arr removeAllObjects];
            [self.arr addObjectsFromArray:list];
            [self.tableView reloadData];
        }
    }];
}

-(void)setTableHeadView
{
    NSString * str = [NSString stringWithFormat:@"%ld",self.scoreNum];
    CGSize numSize = [self getSizeWithString:str FontNum:30];
    CGSize titleSize = [self getSizeWithString:@"积分余额" FontNum:17];
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LZScreenWidth, 130)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel * num = [[UILabel alloc]initWithFrame:CGRectMake((LZScreenWidth-numSize.width-titleSize.width)/2, (130-numSize.height)/2, numSize.width, numSize.height)];
    num.font = [UIFont systemFontOfSize:30];
    num.textColor = MYRED;
    num.text = str;
    [view addSubview:num];
    
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(num.frame), CGRectGetMaxY(num.frame)-titleSize.height-5, titleSize.width, titleSize.height)];
    title.font = [UIFont systemFontOfSize:17];
    title.textColor = FONT_BLACK;
    title.text = @"积分余额";
    [view addSubview:title];
    
    self.tableView.tableHeaderView = view;
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ScoreCell * cell = [[[NSBundle mainBundle]loadNibNamed:@"ScoreCell" owner:nil options:nil]lastObject];
    cell.model = [self.arr objectAtIndex:indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 11;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, LZScreenWidth, 11)];
    view.backgroundColor = BACKGROUND_GRAY;
    return view;
}

///工具方法
-(CGSize )getSizeWithString:(NSString *)string FontNum:(CGFloat )num
{
    return [string boundingRectWithSize:CGSizeMake(LZScreenWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:num]} context:nil].size;
}

@end
