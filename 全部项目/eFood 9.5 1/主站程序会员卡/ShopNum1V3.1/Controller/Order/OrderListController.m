//
//  OrderListController.m
//  ShopNum1V3.1
//
//  Created by yons on 15/12/24.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "OrderListController.h"
#import "LogisticsViewController.h"
#import "DZYMerchandiseDetailController.h"
#import "ShoppingCartViewController.h"
#import "LimitSaleDetailViewController.h"
#import "OrderIntroModel.h"
#import "OrderCell.h"
#import "OrderDetailModel.h"
#import "ConfirmPayController.h"
#import "OrderDetailController.h"
#import "CommentController.h"
#import "RefundController.h"
#import <objc/runtime.h>

///关联使用
static char operationModel;

@interface OrderListController ()<SelectDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
///订单类型的数组
@property (nonatomic,strong)NSMutableArray * btnArr;
///tableView数组
@property (nonatomic,strong)NSMutableArray * tableViewArr;
///滚动视图
@property (nonatomic,weak)UIScrollView * scrollView;

@property (nonatomic,assign)NSInteger pageIndex;

@property (nonatomic,strong)NSMutableArray * arr;
///汇率
@property (nonatomic,assign)CGFloat rate;
@end

@implementation OrderListController

-(NSMutableArray *)tableViewArr
{
    if (_tableViewArr == nil) {
        _tableViewArr = [NSMutableArray array];
    }
    return _tableViewArr;
}

-(NSMutableArray *)arr
{
    if (_arr == nil) {
        NSMutableArray * arr1 = [NSMutableArray array];
        NSMutableArray * arr2 = [NSMutableArray array];
        NSMutableArray * arr3 = [NSMutableArray array];
        NSMutableArray * arr4 = [NSMutableArray array];
        NSMutableArray * arr5 = [NSMutableArray array];
        _arr = [NSMutableArray arrayWithObjects:arr1,arr2,arr3,arr4,arr5,nil];
    }
    return _arr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
        [self basicStep];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)basicStep
{
    self.pageIndex = 1;
    self.navigationItem.title = @"订单列表";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = item;
    [AppConfig getRateWithBlock:^(CGFloat rate, NSError *error) {
        self.rate = rate;
        [self createScrollerView];
        [self createSelectView];
    }];

    NSInteger i;
    (self.OrderType == 8) ? (i = 4) : (i = self.OrderType);
    [[self.btnArr objectAtIndex:i] sendActionsForControlEvents:UIControlEventTouchUpInside];
//    if (self.OrderType == 8) {
//        i = 4;
//    } else {
//        i = self.OrderType;
//    }
}

- (void)back
{
    for (id vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[DZYMerchandiseDetailController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
        if ([vc isKindOfClass:[ShoppingCartViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
        if ([vc isKindOfClass:[LimitSaleDetailViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 选择类型头视图
-(void)createSelectView
{
    DZYSelectView * selectView = [[DZYSelectView alloc]initWithFrame:CGRectMake(0, 64, DZYWIDTH, 45) dataSource:[NSMutableArray arrayWithObjects:@"全部",@"待付款",@"待发货",@"待收货",@"待评价", nil] delegate:self normalColor:FONT_BLACK selectedColor:MAIN_BLUE lineColor:MAIN_BLUE fontNum:15];
    self.btnArr = selectView.btnArr;
    selectView.firstClick = self.OrderType;
    [self.view addSubview:selectView];
}

-(void)createScrollerView
{
    UIScrollView * svc = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 109, DZYWIDTH, DZYHEIGHT-109)];
    for (int i = 0; i<5; i++) {
        UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(i*DZYWIDTH, 0, DZYWIDTH, DZYHEIGHT-109) style:UITableViewStyleGrouped];
        tableView.backgroundColor = BACKGROUND_GRAY;
        tableView.tag = i;
        tableView.delegate = self;
        tableView.dataSource = self;
        [svc addSubview:tableView];
        [tableView addFooterWithTarget:self action:@selector(footRefresh)];
        [tableView addHeaderWithTarget:self action:@selector(loadDataFromWeb)];
        [self.tableViewArr addObject:tableView];
    }
    svc.pagingEnabled = YES;
    svc.delegate = self;
    svc.contentSize = CGSizeMake(5*DZYWIDTH, DZYHEIGHT-109);
    [self.view addSubview:svc];
    self.scrollView = svc;
}

#pragma mark - 从网络获取数据
-(void)loadDataFromWeb
{
    self.pageIndex = 1;
    NSInteger i = [self getIndex];
    AppConfig * config = [AppConfig sharedAppConfig];
    [config loadConfig];
    NSDictionary * orderpayDic = @{
                                   @"AppSign":config.appSign,
                                   @"memLoginID":config.loginName,
                                   @"t":@(self.OrderType),
                                   @"pageIndex":@1,
                                   @"pageCount":@20
                                   };
    
    MBProgressHUD *hudView = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    [OrderIntroModel getOrderListWithParameters:orderpayDic andblock:^(NSArray *list, NSError *error) {
        [hudView hide:YES];
        [self.tableViewArr[i] footerEndRefreshing];
        [self.tableViewArr[i] headerEndRefreshing];
        if (error) {
            UIAlertView * aler = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [aler show];
            return ;
        }
        [self.arr[i] removeAllObjects];
        
        [self.arr[i] addObjectsFromArray:list];
        /*
        NSMutableArray * listArr = [NSMutableArray arrayWithArray:list];
        for (OrderIntroModel * model in listArr) {
            if ([model.ReturnOrderStatus isEqualToString:@""]) {
                [self.arr[i] addObject:model];
            }
        }*/
        [self.tableViewArr[i] reloadData];
    }];
}

-(void)footRefresh
{
    AppConfig * config = [AppConfig sharedAppConfig];
    [config loadConfig];
    NSInteger i = [self getIndex];
    self.pageIndex += 1;
    NSDictionary * orderpayDic = @{
                                   @"AppSign":config.appSign,
                                   @"memLoginID":config.loginName,
                                   @"t":@(self.OrderType),
                                   @"pageIndex":@(self.pageIndex),
                                   @"pageCount":@20
                                   };
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    [OrderIntroModel getOrderListWithParameters:orderpayDic andblock:^(NSArray *list, NSError *error) {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        [self.tableViewArr[i] footerEndRefreshing];
        [self.tableViewArr[i] headerEndRefreshing];
        if (error) {
            self.pageIndex -= 1;
            UIAlertView * aler = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [aler show];
            return ;
        }
        if (list.count == 0) {
            self.pageIndex -= 1;
        }
        [self.arr[i] addObjectsFromArray:list];
        /*
        NSMutableArray * listArr = [NSMutableArray arrayWithArray:list];
        for (OrderIntroModel * model in listArr) {
            if ([model.ReturnOrderStatus isEqualToString:@""]) {
                [self.arr[i] addObject:model];
            }
        }*/
        [self.tableViewArr[i] reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)selectWithSelectView:(DZYSelectView *)selectView btn:(UIButton *)btn
{
    CGRect rect = CGRectMake(DZYWIDTH*btn.tag, 0, DZYWIDTH, DZYHEIGHT-109);
    [self.scrollView scrollRectToVisible:rect animated:YES];
    if (btn.tag == 4) {
        self.OrderType = DONE_ORDER_NOT_ASSESS;
    }
    else
    {
        self.OrderType = btn.tag;
    }
    [self loadDataFromWeb];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger i = [self.tableViewArr indexOfObject:tableView];
    return [[self.arr objectAtIndex:i]count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger i = [self.tableViewArr indexOfObject:tableView];
    if ([[self.arr objectAtIndex:i]count] == 0) {
        return 0;
    }
    else {
        OrderIntroModel * SectionModel = [[self.arr objectAtIndex:i] objectAtIndex:section];
        return SectionModel.ProductList.count;
    }
}

#pragma mark - cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger i = [self getIndex];
    if (tableView.tag != i) {
        i = tableView.tag;
    }
    OrderCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OrderCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"OrderCell" owner:nil options:nil].firstObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    OrderIntroModel * sectionModel = [[self.arr objectAtIndex:i]objectAtIndex:indexPath.section];
    OrderMerchandiseIntroModel * model = sectionModel.ProductList[indexPath.row];
    cell.model = model;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    NSInteger i = [self getIndex];
    if (tableView.tag != i) {
        i = tableView.tag;
    }
    if ([self.arr[i] count] > section) {
        OrderIntroModel * model = [[self.arr objectAtIndex:i]objectAtIndex:section];
        if ([model.StatusName isEqualToString:@"配货中"]||[model.StatusName isEqualToString:@"待发货"]||/*[model.StatusName isEqualToString:@"已取消"]||*/([model.StatusName isEqualToString:@"已完成"]&&model.IsBuyComment)||![model.ReturnOrderStatus isEqualToString:@""]||[model.StatusName isEqualToString:@"已退货"]||[model.StatusName isEqualToString:@"已退款"]) {
            return 11;
        }
    }
    return 61;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

#pragma mark - section foot
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    NSInteger i = [self getIndex];
    if (tableView.tag != i) {
        i = tableView.tag;
    }
    OrderIntroModel * SectionModel = [[self.arr objectAtIndex:i]objectAtIndex:section];
    if ([SectionModel.StatusName isEqualToString:@"配货中"]||[SectionModel.StatusName isEqualToString:@"待发货"]||/*[SectionModel.StatusName isEqualToString:@"已取消"]||*/([SectionModel.StatusName isEqualToString:@"已完成"]&&SectionModel.IsBuyComment)||[SectionModel.StatusName isEqualToString:@"已退款"]||![SectionModel.ReturnOrderStatus isEqualToString:@""]||[SectionModel.StatusName isEqualToString:@"已退货"]) {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LZScreenWidth, 11)];
        view.backgroundColor = BACKGROUND_GRAY;
        return view;
    }
    return [self createFootViewWithSection:section model:SectionModel];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSInteger i = [self getIndex];
    if (tableView.tag != i) {
        i = tableView.tag;
    }
    if ([[self.arr objectAtIndex:i]count] == 0) {
        return nil;
    }
    else
    {
        OrderIntroModel * model = [[self.arr objectAtIndex:i]objectAtIndex:section];
        return [self createHeaderViewWithSection:section model:model];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 96;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger i = [self getIndex];
    OrderIntroModel * model = self.arr[i][indexPath.section];
//    OrderIntroModel * model = [[self.arr objectAtIndex:i]objectAtIndex:indexPath.row];
    OrderDetailController * vc = [[OrderDetailController alloc]initWithStyle:UITableViewStyleGrouped];
    vc.orderNum = model.OrderNumber;
    vc.listModel = model;
    [self.navigationController pushViewController:vc animated:YES];
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
    CGSize titleSize = [DZYTools getSizeWithString:status FontNum:15];
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, titleSize.width, 44)];
    titleLabel.text = status;
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = FONT_BLACK;
    [view addSubview:titleLabel];
    
    NSString * rmbPrice = [NSString stringWithFormat:@"约¥ %.2f",model.ShouldPayPrice/self.rate];
    UILabel * rmbPriceLabel = [[UILabel alloc]init];
    rmbPriceLabel.text = rmbPrice;
    rmbPriceLabel.font = [UIFont systemFontOfSize:13];
    [rmbPriceLabel sizeToFit];
    rmbPriceLabel.textColor = FONT_LIGHTGRAY;
    rmbPriceLabel.frame = CGRectMake(LZScreenWidth - rmbPriceLabel.frame.size.width - 8, (44 - rmbPriceLabel.frame.size.height)/2.0f, rmbPriceLabel.frame.size.width, rmbPriceLabel.frame.size.height);
    [view addSubview:rmbPriceLabel];

    
    NSString * price = [NSString stringWithFormat:@"AU$ %.2f",model.ShouldPayPrice];
    UILabel * priceLabel = [[UILabel alloc]init];
    priceLabel.text = price;
    priceLabel.font = [UIFont systemFontOfSize:15];
    priceLabel.textColor = MAIN_ORANGE;
    [priceLabel sizeToFit];
    priceLabel.frame = CGRectMake(CGRectGetMinX(rmbPriceLabel.frame)-priceLabel.frame.size.width-10, (44 - priceLabel.frame.size.height)/2.0f, priceLabel.frame.size.width, priceLabel.frame.size.height);
    [view addSubview:priceLabel];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 44, LZScreenWidth, 0.5)];
    line.backgroundColor = LINE_LIGHTGRAY;
    [view addSubview:line];
    return view;
}

#pragma mark - section footView

///创建待付款的footView
-(UIView *)createFootViewWithSection:(NSInteger)section model:(OrderIntroModel *)intro;
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LZScreenWidth, 50)];
    view.backgroundColor = [UIColor whiteColor];
    
    //  ---
    CGSize fontSize;
    if ([intro.StatusName isEqualToString:@"待评价"]) {
        fontSize = [DZYTools getSizeWithString:@"待评价" FontNum:17];
    }
    else
    {
        fontSize = [DZYTools getSizeWithString:@"立即付款" FontNum:17];
    }
    CGSize btnSize = CGSizeMake(fontSize.width+10, fontSize.height+8);
    
    ///红的 立即付款 确认收货 去评价
    UIButton * rightOne = [[UIButton alloc]initWithFrame:CGRectMake(LZScreenWidth-8-btnSize.width, 10, btnSize.width, 30)];
    rightOne.titleLabel.font = [UIFont systemFontOfSize:15];
    rightOne.layer.cornerRadius = 2;
    rightOne.backgroundColor = MYRED;
    rightOne.tag = section;
    [view addSubview:rightOne];
    
    UIButton * rightTwo = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(rightOne.frame)-8-btnSize.width, 10, btnSize.width, 30)];
    rightTwo.layer.cornerRadius = 2;
    rightTwo.backgroundColor = LINE_DARKGRAY;
    rightTwo.titleLabel.font = [UIFont systemFontOfSize:15];
    rightTwo.tag = section;
    [view addSubview:rightTwo];
    
    ///只有待评价时使用
    UIButton * rightThree = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(rightTwo.frame)-8-btnSize.width, 10, btnSize.width, 30)];
    rightThree.layer.cornerRadius = 2;
    rightThree.backgroundColor = LINE_DARKGRAY;
    rightThree.titleLabel.font = [UIFont systemFontOfSize:15];
    rightThree.tag = section;
    [view addSubview:rightThree];
    rightThree.hidden = YES;
    
    if (intro.OrderStatus == 0) {// 未确定
        //        OrderStatus = "待付款";
        [rightOne setTitle:@"立即付款" forState:UIControlStateNormal];
        [rightOne addTarget:self action:@selector(payNow:) forControlEvents:UIControlEventTouchUpInside];
        
        [rightTwo setTitle:@"取消订单" forState:UIControlStateNormal];
        [rightTwo addTarget:self action:@selector(OrderUpdate:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if (intro.OrderStatus == 1)
    { //已确认
        if (intro.PaymentStatus == 0)
        { //未付款
            //            OrderStatus = "待付款";
            [rightOne setTitle:@"立即付款" forState:UIControlStateNormal];
            [rightOne addTarget:self action:@selector(payNow:) forControlEvents:UIControlEventTouchUpInside];
            
            [rightTwo setTitle:@"取消订单" forState:UIControlStateNormal];
            [rightTwo addTarget:self action:@selector(OrderUpdate:) forControlEvents:UIControlEventTouchUpInside];
            //            rightThree.hidden = NO;
            //            [rightThree addTarget:self action:@selector(refundClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        else if (intro.PaymentStatus == 2)
        {//付款中
            if (intro.ShipmentStatus == 0)
            {//发货状态 未发货
                //                OrderStatus = "待发货";
                rightOne.hidden = YES;
                rightTwo.hidden = YES;
                //加个退款
            }
            else if (intro.ShipmentStatus == 1)
            {// 已发货
                //退货状态
                if([intro.ReturnOrderStatus isEqualToString:@""])
                {
                    //                    OrderStatus = "待收货";
                    [rightOne setTitle:@"确认收货" forState:UIControlStateNormal];
                    [rightOne addTarget:self action:@selector(alreadyGetObject:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [rightTwo setTitle:@"查看物流" forState:UIControlStateNormal];
                    [rightTwo setBackgroundColor:MAIN_ORANGE];
                    [rightTwo addTarget:self action:@selector(lookShipment:) forControlEvents:UIControlEventTouchUpInside];
                    //加个退货
                }
                else{
                    //退款状态中
                    //                    OrderStatus = returnOrderStatus;
                    //                    rightOne.hidden = YES;
                    //                    rightTwo.hidden = YES;
                }
            } else if (intro.ShipmentStatus == 2) {//已收货
                //                OrderStatus = "已收货";
                
            } else if (intro.ShipmentStatus == 3) {//配货中
                //                OrderStatus = "配货中";
                //                self.cancelBtn.hidden = NO;
            } else if (intro.ShipmentStatus == 4) {//退货
                //                OrderStatus = "已退货";
                //新加
            } else if (intro.ShipmentStatus == 5) {//完成
                //                OrderStatus = "完成";
            }
        }
        else if (intro.PaymentStatus == 3)
        {
            if([intro.ReturnOrderStatus isEqualToString:@""]){
                //                OrderStatus = "已退款";
                rightOne.hidden = YES;
                rightTwo.hidden = YES;
            }else{
                //                OrderStatus = returnOrderStatus;
            }
        }
    }
    else if (intro.OrderStatus == 2)
    {//已取消
        if (intro.PaymentStatus == 0)
        {//未付款
            //            OrderStatus = "已取消"; //已取消
            [rightOne setTitle:@"删除订单" forState:UIControlStateNormal];
            [rightOne addTarget:self action:@selector(deleOrder:) forControlEvents:UIControlEventTouchUpInside];
//            deleOrder
            rightTwo.hidden = YES;
        }
        else if (intro.PaymentStatus == 2)
        {//已付款
            if (intro.ShipmentStatus == 0)
            {//未发货
                //                OrderStatus = "退款审核中";
            } else if(intro.ShipmentStatus == 1){//已发货
                
            }
        }else if(![intro.ReturnOrderStatus isEqualToString:@""]){
            //            OrderStatus = returnOrderStatus;
        }
    }
    else if (intro.OrderStatus == 5)
    {
        if (intro.PaymentStatus == 2)
        {
            if (intro.ShipmentStatus == 2) {
                //                OrderStatus = "交易成功"; //已完成
                [rightOne setTitle:@"去评价" forState:UIControlStateNormal];
                rightOne.frame = CGRectMake(LZScreenWidth-8-60, 10, 60, 30);
                [rightOne addTarget:self action:@selector(commentClick:) forControlEvents:UIControlEventTouchUpInside];
                
                rightTwo.hidden = YES;
                /*
                [rightTwo setTitle:@"查看物流" forState:UIControlStateNormal];
                [rightTwo addTarget:self action:@selector(lookShipment:) forControlEvents:UIControlEventTouchUpInside];
                rightTwo.frame = CGRectMake(CGRectGetMinX(rightOne.frame)-8-btnSize.width, 10, btnSize.width, 30);
                
                rightThree.hidden = NO;
                [rightThree setTitle:@"删除订单" forState:UIControlStateNormal];
                [rightThree addTarget:self action:@selector(deleOrder:) forControlEvents:UIControlEventTouchUpInside];
                rightThree.frame = CGRectMake(CGRectGetMinX(rightTwo.frame)-8-btnSize.width, 10, btnSize.width, 30);
                 */
            }
            else if (intro.ShipmentStatus == 4) {
                //                OrderStatus = "已退货";
            }
        }
    }
    UIView * grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 50, LZScreenWidth, 11)];
    grayView.backgroundColor = BACKGROUND_GRAY;
    [view addSubview:grayView];
    return view;
}


#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView == self.scrollView)
    {
        NSInteger index = scrollView.contentOffset.x/DZYWIDTH;
        [[self.btnArr objectAtIndex:index]sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

-(NSInteger )getIndex
{
    NSInteger i = 0;
    for (UIButton * btn in self.btnArr) {
        if (btn.selected) {
            i = [self.btnArr indexOfObject:btn];
        }
    }
    return i;
}

#pragma mark - Cell上的点击事件处理
///确认收货
-(void)alreadyGetObject:(UIButton *)btn
{
    
    NSArray *tempArr = self.arr[[self getIndex]];
    OrderIntroModel *model = tempArr[btn.tag];
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该操作无法返回" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    objc_setAssociatedObject(alert, &operationModel, model, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    alert.tag = 2;
    [alert show];
}

///查看物流
-(void)lookShipment:(UIButton *)btn
{
    NSArray *tempArr = self.arr[[self getIndex]];
    
    OrderIntroModel *model = tempArr[btn.tag];

    LogisticsViewController * lvc= [[UIStoryboard storyboardWithName:@"StoryboardIOS7" bundle:nil]instantiateViewControllerWithIdentifier:@"LogisticsViewController"];
    NSString * str = [NSString stringWithFormat:@"http://senghongwap.efood7.com/pages/LogisticsMessage.html?ShipmentNumber=%@&LogisticsCompanyCode=%@",model.ShipmentNumber,model.LogisticsCompanyCode];
    lvc.LogisticsURL = [NSURL URLWithString:str];
    [self.navigationController pushViewController:lvc animated:YES];
}

///删除订单
-(void)deleOrder:(UIButton *)btn
{
    NSArray *tempArr = self.arr[[self getIndex]];
    
    OrderIntroModel *model = tempArr[btn.tag];

    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该操作无法返回" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    objc_setAssociatedObject(alert, &operationModel, model, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    alert.tag = 3;
    [alert show];
}

///查看订单
-(void)detailClick:(UIButton *)btn
{
    AppConfig * config = [AppConfig sharedAppConfig];
    [config loadConfig];
    NSArray *tempArr = self.arr[[self getIndex]];
    
    OrderIntroModel *model = tempArr[btn.tag];
    NSDictionary * orderDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               model.OrderNumber,@"OrderNumber",
                               config.appSign,@"AppSign", nil];
    [OrderDetailModel getOrderDetailWithparameters:orderDic andblock:^(OrderDetailModel *model, NSError *error) {
        if (error) {
            
        }else {
            if (model) {
                NSLog(@"查看订单");
            }
            
        }
    }];
}

///添加评论
-(void)commentClick:(UIButton *)btn
{
    NSArray *tempArr = self.arr[[self getIndex]];
    
    OrderIntroModel *model = tempArr[btn.tag];
    CommentController * vc = [[CommentController alloc]initWithStyle:UITableViewStyleGrouped];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

///退款
-(void)refundClick:(UIButton *)btn
{
    
}

///取消订单
-(void)OrderUpdate:(UIButton *)btn
{
    NSArray *tempArr = self.arr[[self getIndex]];
    
    OrderIntroModel *model = tempArr[btn.tag];
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该操作无法返回" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 1;
    objc_setAssociatedObject(alert, &operationModel, model, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [alert show];
}

///立即付款
-(void)payNow:(UIButton *)btn
{
    
    NSArray *tempArr = self.arr[[self getIndex]];
    
    OrderIntroModel *model = tempArr[btn.tag];
    if ([model.PayTypeName isEqualToString:@"货到付款"]) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您所选择为货到付款，请等待卖家发货" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    else if ([model.PayTypeName isEqualToString:@"在线支付"])
    {
        ConfirmPayController * vc = [[UIStoryboard storyboardWithName:@"StoryboardIOS7" bundle:nil]instantiateViewControllerWithIdentifier:@"ConfirmPayController"];
        vc.orderNumber = model.OrderNumber;
        vc.totalPrice = model.ShouldPayPrice;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([model.PayTypeName isEqualToString:@"线下支付"])
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您所选择为线下支付，请等待卖家发货" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
}

-(void)operationEndWithController:(id)viewController
{
    [self loadDataFromWeb];
}

#pragma mark - alertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    AppConfig * config = [AppConfig sharedAppConfig];
    [config loadConfig];
    switch (alertView.tag) {
        case 1: //取消订单
        {
            OrderIntroModel * model = objc_getAssociatedObject(alertView, &operationModel);
            if (buttonIndex == 0) {
                //取消
            }
            else
            {
                //确定
                NSDictionary * cancelDic = @{
                                             @"AppSign":config.appSign,
                                             @"id":model.Guid
                                             };
                [OrderDetailModel cancelOrderWithparameters:cancelDic andblock:^(NSInteger result, NSError *error) {
                    if (error) {
                        [MBProgressHUD showError:@"网络错误"];
                    }else {
                        if (result == 202) {
                            [self loadDataFromWeb];
                            [self showSuccessMesaageInWindow:@"操作成功"];
                        }
                        else
                        {
                            [self showErrorMessage:@"操作失败"];
                        }
                    }
                }];
            }
            break;
        }
        case 2: //确认收货
        {
            OrderIntroModel * model = objc_getAssociatedObject(alertView, &operationModel);
            if (buttonIndex == 0) {
                //取消
            }
            else
            {
                NSDictionary * upateDci = [NSDictionary dictionaryWithObjectsAndKeys:
                                           model.Guid,@"id",
                                           config.appSign,@"AppSign",nil];
                [OrderIntroModel UpdateOrderStatueWithParameters:upateDci andblock:^(NSInteger result, NSError *error) {
                    if (error) {
                        
                    }else {
                        if (result == 202) {
                            [self loadDataFromWeb];
                            [self showSuccessMesaageInWindow:@"操作成功"];
                        }else {
                            [self showErrorMessage:@"操作失败"];
                        }
                    }
                }];
            }
            break;
        }
        case 3: //删除订单
        {
            OrderIntroModel * model = objc_getAssociatedObject(alertView, &operationModel);
            if (buttonIndex == 0) {
                //取消
            }
            else{
                NSDictionary * dict = @{
                                        @"AppSign":config.appSign,
                                        @"orderNumber":model.OrderNumber,
                                        @"memLoginID":config.loginName
                                        };
                [[AFAppAPIClient sharedClient]getPath:@"/api/DeleteOrder" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSLog(@"responseObject - %@ ",responseObject);
                    NSInteger result = [[responseObject objectForKey:@"Data"] integerValue];
                    if (result == 202) {
                        [self loadDataFromWeb];
                        [self showSuccessMesaageInWindow:@"删除成功"];
                    }
                    else
                    {
                        [self showErrorMessage:@"删除失败"];
                    }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [self showErrorMessage:@"删除失败"];
                }];
            }
            break;
        }
        default:
            break;
    }
    
}

@end
