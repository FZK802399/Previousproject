//
//  AdvanceController.m
//  ShopNum1V3.1
//
//  Created by yons on 15/12/2.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "AdvanceController.h"
#import "AdvancePaymentModel.h"
#import "ScoreCell.h"
#import "ChongZhiViewController.h"
#import "TiXianController.h"

@interface AdvanceController ()<ChongZhiDelegate>
@property (nonatomic,strong)NSMutableArray * arr;

@property (nonatomic,weak)UILabel * num;
@end

@implementation AdvanceController

-(NSMutableArray *)arr
{
    if (_arr == nil) {
        _arr = [NSMutableArray array];
    }
    return _arr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"我要充值" style:UIBarButtonItemStylePlain target:self action:@selector(chongZhi)];
//    self.navigationItem.rightBarButtonItem = rightButton;
    [self basicStep];
    [self loadDataFromWeb];
    [self setTableHeadView];
}

- (void)chongZhi {
    ChongZhiViewController *chongZhiVC = ZDX_VC(@"StoryboardIOS7", @"ChongZhiViewController");
    chongZhiVC.delegate = self;
    [self.navigationController pushViewController:chongZhiVC animated:YES];
}

- (void)tixian
{
    TiXianController * vc = [TiXianController create];
    vc.allMonry = self.totalStr;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)basicStep
{
    self.tableView.rowHeight = 65;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navigationItem.title = @"预存款明细";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)loadDataFromWeb
{
    AppConfig * config = [AppConfig sharedAppConfig];
    [config loadConfig];
    NSDictionary * dict =@{
                           @"MemLoginID":config.loginName,
                           @"AppSign":config.appSign
                           };
    [AdvancePaymentModel getAdvancePaymentModifyLogByParamer:dict andblock:^(NSArray *List, NSError *error) {
        [self.arr removeAllObjects];
        [self.arr addObjectsFromArray:List];
        [self.tableView reloadData];
        if (List.count > 0) {
            AdvancePaymentModel * model = List.firstObject;
            self.num.text = [NSString stringWithFormat:@"AU$%.2f",model.LastOperateMoney];
        }
    }];
}

#pragma mark - 设置头视图
-(void)setTableHeadView
{
//    NSString * str = [NSString stringWithFormat:@"AU$%@",self.totalStr];
    CGSize numSize = [self getSizeWithString:self.totalStr FontNum:30];
    CGSize titleSize = [self getSizeWithString:@"预存款余额" FontNum:17];
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LZScreenWidth, 130)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel * num = [[UILabel alloc]initWithFrame:CGRectMake((LZScreenWidth-numSize.width-titleSize.width)/2, (130-numSize.height)/2 - 20, numSize.width, numSize.height)];
    num.font = [UIFont systemFontOfSize:30];
    num.textColor = MYRED;
    num.text = self.totalStr;
    [view addSubview:num];
    self.num = num;
    
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(num.frame), CGRectGetMaxY(num.frame)-titleSize.height-5, titleSize.width, titleSize.height)];
    title.font = [UIFont systemFontOfSize:17];
    title.textColor = FONT_BLACK;
    title.text = @"预存款余额";
    [view addSubview:title];
    
    UIButton * chongzhi = [UIButton buttonWithType:UIButtonTypeCustom];
    chongzhi.frame = CGRectMake((LZScreenWidth - 60)/2, 130 - 45, 60, 30);
    [chongzhi setTitle:@"充值" forState:UIControlStateNormal];
    [chongzhi setTitleColor:MAIN_BLUE forState:UIControlStateNormal];
    chongzhi.layer.cornerRadius = 3;
    chongzhi.layer.borderColor = MAIN_BLUE.CGColor;
    chongzhi.layer.borderWidth = 1;
    chongzhi.titleLabel.font = [UIFont systemFontOfSize:15];
    [chongzhi addTarget:self action:@selector(chongZhi) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:chongzhi];
    
//    UIButton * tixian = [UIButton buttonWithType:UIButtonTypeCustom];
//    tixian.frame = CGRectMake(CGRectGetMaxX(chongzhi.frame) + 20, 130 - 45, 60, 30);
//    [tixian setTitle:@"提现" forState:UIControlStateNormal];
//    [tixian setTitleColor:MAIN_ORANGE forState:UIControlStateNormal];
//    tixian.layer.cornerRadius = 3;
//    tixian.layer.borderColor = MAIN_ORANGE.CGColor;
//    tixian.layer.borderWidth = 1;
//    tixian.titleLabel.font = [UIFont systemFontOfSize:15];
//    [view addSubview:tixian];
//    [tixian addTarget:self action:@selector(tixian) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.tableHeaderView = view;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ScoreCell * cell = [[[NSBundle mainBundle]loadNibNamed:@"ScoreCell" owner:nil options:nil]lastObject];
    cell.advanceModel = [self.arr objectAtIndex:indexPath.row];
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

-(void)ChongZhiDidAddEndWithVC:(ChongZhiViewController *)vc
{
    [self loadDataFromWeb];
}

///工具方法
-(CGSize )getSizeWithString:(NSString *)string FontNum:(CGFloat )num
{
    return [string boundingRectWithSize:CGSizeMake(LZScreenWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:num]} context:nil].size;
}

@end
