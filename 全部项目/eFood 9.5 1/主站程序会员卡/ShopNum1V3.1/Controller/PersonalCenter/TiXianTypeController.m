//
//  TiXianTypeController.m
//  ShopNum1V3.1
//
//  Created by yons on 16/3/8.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import "TiXianTypeController.h"
#import "TiXianAddTypeController.h"
#import "TiXianUpdataTypeController.h"

#import "TiXianTypeCell.h"

#import "BankModel.h"
@interface TiXianTypeController ()<UITableViewDataSource,UITableViewDelegate,TiXianTypeCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (nonatomic,strong)NSMutableArray * arr;

@property (nonatomic,assign)BOOL isClick;
@end

@implementation TiXianTypeController

-(NSMutableArray *)arr
{
    if (_arr == nil) {
        _arr = [NSMutableArray array];
    }
    return _arr;
}

+ (instancetype)create
{
    return [[UIStoryboard storyboardWithName:@"Center" bundle:nil]instantiateViewControllerWithIdentifier:@"TiXianTypeController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isClick = NO;
    self.btn.layer.cornerRadius = 3;
    self.tableView.backgroundColor = BACKGROUND_GRAY;
    self.tableView.rowHeight = 50;
    self.navigationItem.title = @"提现方式";
    
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithTitle:@"操作" style:UIBarButtonItemStylePlain target:self action:@selector(operation)];
    item.tintColor = RGB(71, 71, 71);
    self.navigationItem.rightBarButtonItem = item;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadDataFromWeb];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.arr.count > 0) {
        NSInteger i = 0;
        for (BankModel * model in self.arr) {
            if (model.isSelected == YES) {
                i = -1;
            }
        }
        if (i == 0) {
            BankModel * Sectionmodel = self.arr.firstObject;
            if ([self.delegate respondsToSelector:@selector(TiXianTypeController:withModel:)]) {
                [self.delegate TiXianTypeController:self withModel:Sectionmodel];
            }
        }
    }
    if (self.arr.count == 0) {
        if ([self.delegate respondsToSelector:@selector(TiXianTypeController:withModel:)]) {
            [self.delegate TiXianTypeController:self withModel:nil];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadDataFromWeb
{
    [BankModel getBankListWithBlock:^(NSArray *arr, NSError *error) {
        [self.arr removeAllObjects];
        if (arr) {
            if (self.Guid) {
                for (BankModel * model in arr) {
                    if ([model.Guid isEqualToString:self.Guid]) {
                        model.isSelected = YES;
                    }
                }
            }
            [self.arr addObjectsFromArray:arr];
        }
        [self.tableView reloadData];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LZScreenWidth, 12)];
    view.backgroundColor = BACKGROUND_GRAY;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TiXianTypeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TiXianTypeCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"TiXianTypeCell" owner:nil options:nil].lastObject;
    }
    [cell updateWithBool:self.isClick];
    cell.delegate = self;
    cell.model = self.arr[indexPath.section];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BankModel * Sectionmodel = self.arr[indexPath.section];
    Sectionmodel.isSelected = YES;
    if ([self.delegate respondsToSelector:@selector(TiXianTypeController:withModel:)]) {
        [self.delegate TiXianTypeController:self withModel:Sectionmodel];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)addType:(id)sender {
    TiXianAddTypeController * vc = [TiXianAddTypeController create];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)operation
{
    self.isClick = !self.isClick;
    [self.tableView reloadData];
}

-(void)tiXianTypeCell:(TiXianTypeCell *)cell didClickWithSection:(NSInteger)section
{
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    BankModel * model = self.arr[path.section];
    TiXianUpdataTypeController * vc = [TiXianUpdataTypeController create];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
