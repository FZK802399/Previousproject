//
//  TiXianDetailController.m
//  ShopNum1V3.1
//
//  Created by yons on 16/3/8.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import "TiXianDetailController.h"
#import "TiXianDetailCell.h"
#import "TiXianModel.h"
@interface TiXianDetailController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * arr;
@end

@implementation TiXianDetailController

-(NSMutableArray *)arr
{
    if (_arr == nil) {
        _arr = [NSMutableArray array];
    }
    return _arr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 60;
    self.navigationItem.title = @"提现明细";
    [self loadDataFromWeb];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadDataFromWeb
{
    [TiXianModel getHistoryListWithBlock:^(NSArray *arr, NSError *error) {
        [self.arr removeAllObjects];
        [self.arr addObjectsFromArray:arr];
        [self.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TiXianDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TiXianDetailCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"TiXianDetailCell" owner:nil options:nil].lastObject;
    }
    cell.model = self.arr[indexPath.row];
    return cell;
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
