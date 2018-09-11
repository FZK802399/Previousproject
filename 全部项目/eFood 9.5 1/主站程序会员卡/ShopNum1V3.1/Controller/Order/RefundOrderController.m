//
//  RefundOrderController.m
//  ShopNum1V3.1
//
//  Created by yons on 15/11/26.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "RefundOrderController.h"
#import "OrderIntroModel.h"
#import "OrderCell.h"
#import "OrderDetailController.h"
@interface RefundOrderController ()

@property (nonatomic,assign)NSInteger pageIndex;

@property (nonatomic,strong)NSMutableArray * arr;
@end

@implementation RefundOrderController

-(NSMutableArray *)arr
{
    if (_arr == nil) {
        _arr = [NSMutableArray array];
    }
    return _arr;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadDataFromWeb];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"退款/退货订单";
    [self.tableView addFooterWithTarget:self action:@selector(footRefresh)];
    ZDXWeakSelf(weakSelf);
    [self.tableView addHeaderWithCallback:^{
        [weakSelf loadDataFromWeb];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.arr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    OrderIntroModel * model = [self.arr objectAtIndex:section];
    return model.ProductList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderCell * cell = [[NSBundle mainBundle]loadNibNamed:@"OrderCell" owner:nil options:nil].firstObject;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    OrderIntroModel * sectionModel = self.arr[indexPath.section];
    OrderMerchandiseIntroModel * model = sectionModel.ProductList[indexPath.row];
    cell.model = model;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderIntroModel * model = self.arr[indexPath.section];
    OrderDetailController * vc = [[OrderDetailController alloc]initWithStyle:UITableViewStyleGrouped];
    vc.orderNum = model.OrderNumber;
    vc.listModel = model;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:vc action:@selector(popViewControllerAnimated:)];
    [self.navigationController pushViewController:vc animated:YES];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
        OrderIntroModel * model = self.arr[section];
        return [self createHeaderViewWithSection:section model:model];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 96;
}

#pragma mark - section headerView
-(UIView *)createHeaderViewWithSection:(NSInteger )section model:(OrderIntroModel *)model
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LZScreenWidth, 44)];
    view.backgroundColor = [UIColor whiteColor];
    
    NSString * status ;
    if (![model.ReturnOrderStatus isEqualToString:@""]) {
        status = [NSString stringWithFormat:@"订单状态: %@",model.ReturnOrderStatus];
    }
    else
    {
        status = [NSString stringWithFormat:@"订单状态: %@",model.StatusName];
    }
    CGSize titleSize = [self getSizeWithString:status FontNum:15];
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, titleSize.width, 44)];
    titleLabel.text = status;
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = FONT_BLACK;
    [view addSubview:titleLabel];
    
    NSString * price = [NSString stringWithFormat:@"AU$ %.2f",model.ShouldPayPrice];
    CGSize priceSize = [self getSizeWithString:price FontNum:15];
    UILabel * priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(LZScreenWidth-priceSize.width-8, 0, priceSize.width, 44)];
    priceLabel.text = price;
    priceLabel.font = [UIFont systemFontOfSize:15];
    priceLabel.textColor = MYRED;
    [view addSubview:priceLabel];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 44, LZScreenWidth, 0.5)];
    line.backgroundColor = LINE_LIGHTGRAY;
    [view addSubview:line];
    return view;
}

#pragma mark - 网络请求
-(void)loadDataFromWeb
{
    self.pageIndex = 1;
    AppConfig * config = [AppConfig sharedAppConfig];
    [config loadConfig];
    NSDictionary * orderpayDic = @{
                                   @"AppSign":config.appSign,
                                   @"memLoginID":config.loginName,
                                   @"t":@(7),
                                   @"pageIndex":@1,
                                   @"pageCount":@20
                                   };
    [OrderIntroModel getOrderListWithParameters:orderpayDic andblock:^(NSArray *list, NSError *error) {
        [self.tableView headerEndRefreshing];
        if (error) {
            [MBProgressHUD showError:@"网络错误"];
        }
        [self.arr removeAllObjects];
        [self.arr addObjectsFromArray:list];
        [self.tableView reloadData];
    }];
}

-(void)footRefresh
{
    AppConfig * config = [AppConfig sharedAppConfig];
    [config loadConfig];
    self.pageIndex += 1;
    NSDictionary * orderpayDic = @{
                                   @"AppSign":config.appSign,
                                   @"memLoginID":config.loginName,
                                   @"t":@(7),
                                   @"pageIndex":@(self.pageIndex),
                                   @"pageCount":@20
                                   };
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    [OrderIntroModel getOrderListWithParameters:orderpayDic andblock:^(NSArray *list, NSError *error) {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        if (error) {
            self.pageIndex -= 1;
            [MBProgressHUD showError:@"网络错误"];
        }
        if (list.count == 0) {
            self.pageIndex -= 1;
        }
        [self.arr addObjectsFromArray:list];
        [self.tableView footerEndRefreshing];
        [self.tableView reloadData];
    }];
}

///工具方法
-(CGSize )getSizeWithString:(NSString *)string FontNum:(CGFloat )num
{
    return [string boundingRectWithSize:CGSizeMake(LZScreenWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:num]} context:nil].size;
}
@end
