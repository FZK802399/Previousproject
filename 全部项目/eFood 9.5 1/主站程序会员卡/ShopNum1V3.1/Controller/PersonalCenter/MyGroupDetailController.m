//
//  MyGroupDetailController.m
//  ShopNum1V3.1
//
//  Created by yons on 16/3/7.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import "MyGroupDetailController.h"
#import "MyGroupDetailCell.h"
#import "MyGroupDetailModel.h"
@interface MyGroupDetailController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * arr;
@end

@implementation MyGroupDetailController

-(NSMutableArray *)arr
{
    if (_arr == nil) {
        _arr = [NSMutableArray array];
    }
    return _arr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的会员";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 60;
    self.tableView.backgroundColor = BACKGROUND_GRAY;
    [self loadDataFromWeb];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadDataFromWeb
{
    [MyGroupDetailModel getGroupMemberDetailWithMemLoginID:self.model.MemLoginID andBlock:^(NSArray *arr, NSError *error) {
        if (arr) {
            [self.arr addObjectsFromArray:arr];
            [self.tableView reloadData];
        }
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyGroupDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyGroupDetailCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"MyGroupDetailCell" owner:nil options:nil].lastObject;
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
