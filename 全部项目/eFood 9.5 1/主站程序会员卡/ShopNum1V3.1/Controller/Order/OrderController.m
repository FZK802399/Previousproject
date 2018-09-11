//
//  OrderController.m
//  OnlineShop
//
//  Created by yons on 15/9/1.
//  Copyright (c) 2015年 m. All rights reserved.
//

#import "OrderController.h"
#import "LogisticsViewController.h"
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

@interface OrderController ()<UITableViewDataSource,UITableViewDelegate,OrderEndDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIView *redLine;

//@property(nonatomic,weak)UIView * redLine;
//全部 待付款 待发货 待收货 待评价 tag 0 - 4
@property (weak, nonatomic) IBOutlet UIButton *btnOne;
@property (weak, nonatomic) IBOutlet UIButton *btnTwo;
@property (weak, nonatomic) IBOutlet UIButton *btnThree;
@property (weak, nonatomic) IBOutlet UIButton *btnFour;
@property (weak, nonatomic) IBOutlet UIButton *btnFive;
//@property (weak, nonatomic) IBOutlet UIView *grayView;
///储存上面5个按钮
@property(nonatomic,strong)NSArray * btnArr;

@property(nonatomic,strong)NSMutableArray * arr;
//@property(nonatomic,strong)UIView * selectView;

///页数
@property(nonatomic,assign)NSInteger pageIndex;
@end

@implementation OrderController
+ (instancetype) create {
    return [[UIStoryboard storyboardWithName:@"Center" bundle:nil] instantiateViewControllerWithIdentifier:@"OrderController"];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.selectView.hidden = NO;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    UIButton * btn;
    if (self.OrderType == 8) {
        btn = self.btnArr[4];
    }
    else
    {
        btn = self.btnArr[self.OrderType];
    }
    CGFloat x = btn.center.x;
    CGPoint center = CGPointMake(x, 44);
    CABasicAnimation* anim=[CABasicAnimation animation];
    //想修改的层的属性
    anim.keyPath=@"position";
    
    anim.toValue=[NSValue valueWithCGPoint:center];
    anim.duration=0.5;
    anim.removedOnCompletion=NO;  //不关闭动画
    anim.fillMode=kCAFillModeForwards; //填充模式 变成前进
    [self.redLine.layer addAnimation:anim forKey:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    self.selectView.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self basicSet];
}

- (void) dealloc {
    [self.tableView removeFooter];
}

- (NSMutableArray *)arr
{
    if (_arr == nil) {
        _arr = [NSMutableArray array];
    }
    return _arr;
}

-(void)basicSet
{
//    self.OrderType = 0;
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"订单列表";
    [self loadLeftBackBtn];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    
    [self.tableView addFooterWithTarget:self action:@selector(footRefresh)];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
//    self.grayView.backgroundColor = BACKGROUND_GRAY;
    self.tableView.backgroundColor = BACKGROUND_GRAY;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.btnArr = [NSArray arrayWithObjects:self.btnOne,self.btnTwo,self.btnThree,self.btnFour,self.btnFive, nil];
    for (UIButton * btn in self.btnArr) {
        [btn setTitleColor:MYRED forState:UIControlStateSelected];
        [btn setTitleColor:FONT_BLACK forState:UIControlStateNormal];
    }
    
    UIButton * btn;
//    根据orderType进行一次点击事件
    if (self.OrderType == 8) {
        btn = self.btnArr[4];
    }
    else
    {
        btn = self.btnArr[self.OrderType];
    }
    [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    UISwipeGestureRecognizer * leftSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftSwipe)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftSwipe];
    
    UISwipeGestureRecognizer * rightSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(rightSwipe)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipe];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 从网络获取数据
-(void)loadDataFromWeb
{
    self.pageIndex = 1;
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
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error) {
            [MBProgressHUD showError:@"网络错误"];
        }
        [self.arr removeAllObjects];
        NSMutableArray * listArr = [NSMutableArray arrayWithArray:list];
        for (OrderIntroModel * model in listArr) {
            if ([model.ReturnOrderStatus isEqualToString:@""]) {
                [self.arr addObject:model];
            }
        }
        [self.tableView footerEndRefreshing];
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
                                   @"t":@(self.OrderType),
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
        NSMutableArray * listArr = [NSMutableArray arrayWithArray:list];
        for (OrderIntroModel * model in listArr) {
            if ([model.ReturnOrderStatus isEqualToString:@""]) {
                [self.arr addObject:model];
            }
        }
        [self.tableView footerEndRefreshing];
        [self.tableView reloadData];
    }];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.arr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.arr.count == 0) {
        return 0;
    }
    else
    {
        OrderIntroModel * SectionModel = self.arr[section];
        return SectionModel.ProductList.count;
    }
}

#pragma mark - cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderCell * cell = [[NSBundle mainBundle]loadNibNamed:@"OrderCell" owner:nil options:nil].firstObject;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    OrderIntroModel * sectionModel = self.arr[indexPath.section];
    OrderMerchandiseIntroModel * model = sectionModel.ProductList[indexPath.row];
    cell.model = model;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    OrderIntroModel * model = self.arr[section];
    if ([model.StatusName isEqualToString:@"待发货"]||[model.StatusName isEqualToString:@"已取消"]||([model.StatusName isEqualToString:@"已完成"]&&model.IsBuyComment)||[model.StatusName isEqualToString:@"已退款"]||![model.ReturnOrderStatus isEqualToString:@""]||[model.StatusName isEqualToString:@"已退货"]) {
        return 11;
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
    OrderIntroModel * SectionModel = self.arr[section];
    if ([SectionModel.StatusName isEqualToString:@"待发货"]||[SectionModel.StatusName isEqualToString:@"已取消"]||([SectionModel.StatusName isEqualToString:@"已完成"]&&SectionModel.IsBuyComment)||[SectionModel.StatusName isEqualToString:@"已退款"]||![SectionModel.ReturnOrderStatus isEqualToString:@""]||[SectionModel.StatusName isEqualToString:@"已退货"]) {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LZScreenWidth, 11)];
        view.backgroundColor = BACKGROUND_GRAY;
        return view;
    }
    return [self createFootViewWithSection:section model:SectionModel];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.arr.count == 0) {
        return nil;
    }
    else
    {
        OrderIntroModel * model = self.arr[section];
        return [self createHeaderViewWithSection:section model:model];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 96;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderIntroModel * model = self.arr[indexPath.section];
    OrderDetailController * vc = [[OrderDetailController alloc]initWithStyle:UITableViewStyleGrouped];
    vc.orderNum = model.OrderNumber;
    vc.listModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 订单类型选择按钮
///订单的查看类型 tableHeaderView
- (IBAction)headClick:(UIButton *)sender {
    if (sender.isSelected) {
        return;
    }
    [sender setSelected:YES];
    for (UIButton * btn in self.btnArr) {
        if (btn.tag == sender.tag) {
            continue;
        }
        [btn setSelected:NO];
    }
//    for (UIButton * btn in self.btnArr) {
//        btn.enabled = NO;
//    }
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        for (UIButton * btn in self.btnArr) {
//            btn.enabled = YES;
//        }
//    });
    
    self.OrderType = sender.tag;
#pragma mark - 特效
    CGFloat x = sender.center.x;
    CGPoint center = CGPointMake(x, 44);
    
    CABasicAnimation* anim=[CABasicAnimation animation];
    //想修改的层的属性
    anim.keyPath=@"position";
    
    anim.toValue=[NSValue valueWithCGPoint:center];
    anim.duration = 0.5;
    anim.removedOnCompletion = NO;  //不关闭动画
    anim.fillMode=kCAFillModeForwards; //填充模式 变成前进
    //    anim.beginTime=CACurrentMediaTime()+5; //延时
    [self.redLine.layer addAnimation:anim forKey:nil];
    
    CATransition * trans = [CATransition animation];
    trans.subtype = kCATransitionFromRight;
    trans.duration = 1;
    trans.timingFunction = UIViewAnimationCurveEaseInOut;
    [self.view.layer addAnimation:trans forKey:nil];
    [self loadDataFromWeb];
}

#pragma mark - 滑动事件
///左滑
-(void)leftSwipe
{
    int selected = 0;
    for (UIButton * btn in self.btnArr) {
        if (btn.isSelected) {
            break;
        }
        selected++;
    }
    if (selected == 0) {
        return;
    }
    else
    {
        [[self.btnArr objectAtIndex:selected-1] sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}
///右滑
-(void)rightSwipe
{
    int selected = 0;
    for (UIButton * btn in self.btnArr) {
        if (btn.isSelected) {
            break;
        }
        selected++;
    }
    if (selected == self.btnArr.count-1) {
        return;
    }
    else
    {
        [[self.btnArr objectAtIndex:selected+1] sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
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

#pragma mark - section footView

///创建待付款的footView
-(UIView *)createFootViewWithSection:(NSInteger)section model:(OrderIntroModel *)intro;
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LZScreenWidth, 50)];
    view.backgroundColor = [UIColor whiteColor];
    
    //  ---
    CGSize fontSize;
    if ([intro.StatusName isEqualToString:@"待评价"]) {
        fontSize = [self getSizeWithString:@"待评价" FontNum:17];
    }
    else
    {
        fontSize = [self getSizeWithString:@"立即付款" FontNum:17];
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
            rightOne.hidden = YES;
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
                
                [rightTwo setTitle:@"查看物流" forState:UIControlStateNormal];
                [rightTwo addTarget:self action:@selector(lookShipment:) forControlEvents:UIControlEventTouchUpInside];
                rightTwo.frame = CGRectMake(CGRectGetMinX(rightOne.frame)-8-btnSize.width, 10, btnSize.width, 30);

                rightThree.hidden = NO;
                [rightThree setTitle:@"删除订单" forState:UIControlStateNormal];
                [rightThree addTarget:self action:@selector(deleOrder:) forControlEvents:UIControlEventTouchUpInside];
                rightThree.frame = CGRectMake(CGRectGetMinX(rightTwo.frame)-8-btnSize.width, 10, btnSize.width, 30);
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

///确认收货
-(void)alreadyGetObject:(UIButton *)btn
{
    
    OrderIntroModel *tempmodel = self.arr[btn.tag];
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该操作无法返回" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    objc_setAssociatedObject(alert, &operationModel, tempmodel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    alert.tag = 2;
    [alert show];
}

///查看物流
-(void)lookShipment:(UIButton *)btn
{
    OrderIntroModel *tempmodel = self.arr[btn.tag];
    LogisticsViewController * lvc= [[UIStoryboard storyboardWithName:@"StoryboardIOS7" bundle:nil]instantiateViewControllerWithIdentifier:@"LogisticsViewController"];
    NSString * str = [NSString stringWithFormat:@"http://m.kuaidi100.com/index_all.html?type=%@&postid=%@",tempmodel.LogisticsCompanyCode,tempmodel.ShipmentNumber];
    lvc.LogisticsURL = [NSURL URLWithString:str];
    [self.navigationController pushViewController:lvc animated:YES];
}

///删除订单
-(void)deleOrder:(UIButton *)btn
{
    OrderIntroModel *model = self.arr[btn.tag];
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
    OrderIntroModel *tempmodel = self.arr[btn.tag];
    NSDictionary * orderDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               tempmodel.OrderNumber,@"OrderNumber",
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
    OrderIntroModel * model = [self.arr objectAtIndex:btn.tag];
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
    OrderIntroModel *model = self.arr[btn.tag];
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该操作无法返回" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 1;
    objc_setAssociatedObject(alert, &operationModel, model, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [alert show];
}

///立即付款
-(void)payNow:(UIButton *)btn
{
    OrderIntroModel *model = self.arr[btn.tag];
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

-(void)backClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

///工具方法
-(CGSize )getSizeWithString:(NSString *)string FontNum:(CGFloat )num
{
    return [string boundingRectWithSize:CGSizeMake(LZScreenWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:num]} context:nil].size;
}
@end
