//
//  FXController.m
//  万汇江分界面
//
//  Created by dzy_PC on 15/11/25.
//  Copyright (c) 2015年 dzy_PC. All rights reserved.
//
#define WIDTH [UIScreen mainScreen].bounds.size.width
#import "FXController.h"
#import "DevelopmentFXController.h"
#import "MyGroupDetailController.h"
#import "MYView.h"
#import "FXHeaderView.h"
#import "FXCell.h"
#import "FXModel.h"
#import "MJRefresh.h"
@interface FXController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong)FXHeaderView * headView;
@property (nonatomic,strong)NSMutableArray * arr;

@end

@implementation FXController

-(NSMutableArray *)arr
{
    if (_arr == nil) {
        _arr = [NSMutableArray array];
    }
    return _arr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self basicStep];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [self loadDataFromWeb];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = YES;
}

-(void)basicStep
{
    self.navigationItem.title = @"我的团队";
    
    self.tableView.rowHeight = 76;
    self.headView =[[[NSBundle mainBundle]loadNibNamed:@"FXHeaderView" owner:self options:nil]lastObject];
    self.tableView.tableHeaderView = self.headView;
    [self.tableView addHeaderWithTarget:self action:@selector(loadDataFromWeb)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)loadDataFromWeb
{
    [self.arr removeAllObjects];
    [FXModel getFXListWithBlock:^(NSArray * List, CGFloat today, CGFloat total,NSError * error) {
        [self.tableView headerEndRefreshing];
        if (error) {
            [self showMessageWithStr:@"获取列表失败"];
        }
        else
        {
            [self.arr addObjectsFromArray:List];
            self.headView.today.text = [NSString stringWithFormat:@"%.2f",today];
            self.headView.total.text = [NSString stringWithFormat:@"%.2f",total];
            [self.tableView reloadData];
        }
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arr.count;
}

-(CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LZScreenWidth, 40)];
    view.backgroundColor = [UIColor colorWithWhite:0.945 alpha:1];
    
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 9, LZScreenWidth, 0.5)];
    line1.backgroundColor = [UIColor colorWithWhite:0.863 alpha:0.800];
    [view addSubview:line1];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, LZScreenWidth, 30)];
    label.backgroundColor = BACKGROUND_GRAY;
    label.text = @"  我的会员";
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = FONT_BLACK;
    [view addSubview:label];
    
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 40, LZScreenWidth, 0.5)];
    line2.backgroundColor = [UIColor colorWithWhite:0.863 alpha:0.800];
    [view addSubview:line2];
    
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FXCell * cell = [[NSBundle mainBundle]loadNibNamed:@"FXCell" owner:nil options:nil].lastObject;
    if (self.arr.count != 0) {
        cell.model = self.arr[indexPath.row];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyGroupDetailController * vc = [[MyGroupDetailController alloc]init];
    vc.model = self.arr[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)developMentClick:(id)sender {
    DevelopmentFXController * vc = [[DevelopmentFXController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)showMessageWithStr:(NSString *)str
{
//    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//    [alert show];
    [MBProgressHUD showMessage:str hideAfterTime:1.0f];
}
@end
