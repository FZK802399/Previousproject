//
//  OrderDetailController.m
//  ShopNum1V3.1
//
//  Created by yons on 15/11/24.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "OrderDetailController.h"
#import "OrderController.h"
#import "OrderListController.h"
#import "RefundController.h"
#import "RefundGoodController.h"
#import "CommentController.h"
#import "LogisticsViewController.h"
#import "OrderCell.h"
#import "ConfirmPayController.h"
#import "OrderDetailFootView.h"
#import "OrderDetailFootView2.h"
#import "OrderDetailTableFootView.h"
#import "UpdateReturnOrderViewController.h"
#import "RefundOrderModel.h"
#import "AddressModel.h"
@interface OrderDetailController ()<UIAlertViewDelegate>

@property (nonatomic,strong)OrderDetailModel * model;
@property (nonatomic,strong)RefundOrderModel * refundModel;
@property(nonatomic,strong)AddressModel *ModelAddress;
//会员打折信息
@property (nonatomic,strong)NSString *userId;

@property (nonatomic ,strong)NSString *Discount;
@property(nonatomic,assign)CGFloat UseMember;
@end

@implementation OrderDetailController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadDataFromWeb];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"订单详情";
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.rowHeight = 96;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self chooosUseI];
    [self setTableFootView];
    
}
-(void)chooosUseI
{
    
    //获取用户信息
    
    NSString *appsign = [[NSUserDefaults standardUserDefaults]objectForKey:@"Shop_Web_AppSign"];
    NSString *memLoginID = [[NSUserDefaults standardUserDefaults]objectForKey:@"Shop_Login_Name"];
    
    NSLog(@"shop_web_appsign===================%@  memLoginId=====================%@",appsign,memLoginID);
    
    
    NSLog(@"shop_web_appsign==========--------11111111-------=========%@  memLoginId===========--------111-------==========%@",appsign,memLoginID);
    NSDictionary *caidy = [NSDictionary dictionaryWithObjectsAndKeys:
                           appsign,@"Appsign",
                           memLoginID,@"MemLoginID",
                           nil];
    [[AFAppAPIClient sharedClient]getPath:kWebAccountInfoPath parameters:caidy success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"responseObject====---------------------==%@",responseObject);
        _userId = responseObject[@"AccoutInfo"][@"ID"];
        _Discount =responseObject [@"AccoutInfo"][@"Discount"];
        
        
        
        
        
        NSLog(@"-----------userId=%@ Discount=%@",_userId,_Discount);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"------------error= %@",error);
    }];
    
}


-(void)loadDataFromWeb
{
    AppConfig * config = [AppConfig sharedAppConfig];
    [config loadConfig];
    NSDictionary * orderDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               self.orderNum,@"OrderNumber",
                               config.appSign,@"AppSign", nil];
    [OrderDetailModel getOrderDetailWithparameters:orderDic andblock:^(OrderDetailModel *model, NSError *error) {
        NSLog(@"model888*************************%f%f%f%f%f%f",model.ShouldPayPrice,model.ProductPrice,model.SurplusPrice,model.ScorePrice,model.DispatchPrice,model.InsurePrice);
        if (error) {
            
        }else {
            if (model) {
                self.model = model;
                
                [self.tableView reloadData];
                [self setTableFootView];
            }
            
        }
    }];
    
    if ([self.listModel.ReturnOrderStatus isEqualToString:@"同意退货"]) {
        NSDictionary *returnDic= [NSDictionary dictionaryWithObjectsAndKeys:
                                  config.appSign,@"AppSign",
                                  config.loginName, @"MemLoginID",
                                  self.listModel.Guid, @"OrderGuid", nil];
        [RefundOrderModel getReturnOrderDetailWithparameters:returnDic andblock:^(RefundOrderModel *model, NSError *error) {
            if (error) {
                [MBProgressHUD showError:@"获取退货信息失败"];
            }
                self.refundModel = model;
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setTableFootView
{
    NSString * address = self.model.Address;
    NSString * msg = self.model.ClientToSellerMsg;
    CGFloat addressSize = [self getSizeWithString:address FontNum:16 Size:CGSizeMake(LZScreenWidth-23, MAXFLOAT)].height == 0 ? 21:[self getSizeWithString:address FontNum:16 Size:CGSizeMake(LZScreenWidth-23, MAXFLOAT)].height;
    CGFloat msgSize = [self getSizeWithString:msg FontNum:15 Size:CGSizeMake(LZScreenWidth-16, MAXFLOAT)].height == 0 ? 21:[self getSizeWithString:msg FontNum:15 Size:CGSizeMake(LZScreenWidth-16, MAXFLOAT)].height;
    CGFloat height = addressSize+msgSize + 243;
    OrderDetailTableFootView * view  = [[[NSBundle mainBundle]loadNibNamed:@"OrderDetailTableFootView" owner:nil options:nil]lastObject];
    view.name.text = self.model.Name;
    view.phone.text = self.model.Mobile;
    view.address.text = self.model.Address;
    view.fpTitle.text = self.model.InvoiceTitle;
    view.fpType.text = self.model.InvoiceType == 0 ? @"":@"0";
    view.fpContent.text = self.model.InvoiceContent;
    view.orderNum.text = self.model.OrderNumber;
    view.orderTime.text = self.model.CreateTime;
    NSMutableAttributedString * message;
    if (self.model.ClientToSellerMsg) {
        if ([self.model.ClientToSellerMsg isEqualToString:@""]) {
            message = [[NSMutableAttributedString alloc]initWithString:@"无"];
        }
        else
        {
            message = [[NSMutableAttributedString alloc]initWithString:self.model.ClientToSellerMsg];
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            style.headIndent = 0;//缩进
            style.firstLineHeadIndent = 15;
            style.lineSpacing = 3;//行距
            [message addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, message.length)];
        }
    }
    view.msg.attributedText = message;
    view.msg.backgroundColor = [self.model.ClientToSellerMsg isEqualToString:@""]?LINE_LIGHTGRAY:[UIColor whiteColor];
    view.frame = CGRectMake(0, 0, LZScreenWidth, height);
    self.tableView.tableFooterView = view;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listModel.ProductList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderCell * cell = [[NSBundle mainBundle]loadNibNamed:@"OrderCell" owner:nil options:nil].firstObject;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    OrderMerchandiseIntroModel * model = self.listModel.ProductList[indexPath.row];
    cell.model = model;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    OrderIntroModel * model = self.listModel;
    
    if ([model.StatusName isEqualToString:@"待发货"]||[model.StatusName isEqualToString:@"配货中"]||([model.StatusName isEqualToString:@"已完成"]&&model.IsBuyComment)||[model.StatusName isEqualToString:@"已退款"]||[model.StatusName isEqualToString:@"已退货"]
        ||(![model.ReturnOrderStatus isEqualToString:@""]&&![model.ReturnOrderStatus isEqualToString:@"同意退货"])) {
        return 101;
    }
    return 220;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

#pragma mark - section foot
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    OrderIntroModel * SectionModel = self.listModel;
    return [self createFootViewWithSection:section model:SectionModel];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self createHeaderViewWithSection:section model:self.listModel];
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
    CGSize titleSize = [self getSizeWithString:status FontNum:15 Size:CGSizeMake(LZScreenWidth, MAXFLOAT)];
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, titleSize.width, 44)];
    titleLabel.text = status;
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = FONT_BLACK;
    [view addSubview:titleLabel];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 44, LZScreenWidth, 0.5)];
    line.backgroundColor = LINE_LIGHTGRAY;
    [view addSubview:line];
    return view;
}

#pragma mark - section footView

///创建待付款的footView
-(UIView *)createFootViewWithSection:(NSInteger)section model:(OrderIntroModel *)intro;

{
    NSLog(@"intro===================%f%f%f%f%f%f%f",intro.DispatchPrice,intro.ScorePrice,intro.ShouldPayPrice,intro.SurplusPrice,intro.AlreadPayPrice,intro.ProductPrice,intro.InsurePrice);
    if ([intro.StatusName isEqualToString:@"待发货"]||[intro.StatusName isEqualToString:@"配货中"]||([intro.StatusName isEqualToString:@"已完成"]&&intro.IsBuyComment)||[intro.StatusName isEqualToString:@"已退款"]||[intro.StatusName isEqualToString:@"已退货"]||(![intro.ReturnOrderStatus isEqualToString:@""]&&![intro.ReturnOrderStatus isEqualToString:@"同意退货"])) {
        OrderDetailFootView2 * view = [[NSBundle mainBundle]loadNibNamed:@"OrderDetailFootView2" owner:nil options:nil].lastObject;
        view.totalPrice.text = [NSString stringWithFormat:@"AU$ %.2f",intro.ProductPrice];
        
        view.scorePrice.text = [NSString stringWithFormat:@"AU$ %.2f",intro.ScorePrice];
        view.shouldPayPrice.text = [NSString stringWithFormat:@"AU$ %.2f",intro.ShouldPayPrice];
        NSLog(@"totalPrice.text,view.scorePrice,view.shouldPayPrice==%@%@%@",view.totalPrice.text,view.scorePrice,view.shouldPayPrice);
        return view;
    }
    else
    {
        OrderDetailFootView * view = [[NSBundle mainBundle]loadNibNamed:@"OrderDetailFootView" owner:nil options:nil].lastObject;
        float vipCount=intro.ProductPrice;
        if (vipCount>=50) {
            NSLog(@"Discountppppppppppp%@",_Discount);
            float usemember=[_Discount floatValue]/10;
            NSLog(@"usemember=================%f",usemember);
            //优惠的价格
            float priceMoner=vipCount*(1-usemember);
            NSLog(@"priceMoner=======%f",priceMoner);
            
            _UseMember=priceMoner;
        }
        else{
            _UseMember=0;
        }

        view.vipDiscount.text=[NSString stringWithFormat:@"AU$ %.2f",_UseMember];
        view.totalPrice.text = [NSString stringWithFormat:@"AU$ %.2f",intro.ProductPrice];
        view.scorePrice.text = [NSString stringWithFormat:@"AU$ %.2f",intro.ScorePrice];
        view.shouldPayPrice.text = [NSString stringWithFormat:@"AU$ %.2f",intro.ShouldPayPrice];
         NSLog(@"view.totalPrice.text==%@view.scorePrice.text===%@view.shouldPayPrice==%@OrderIntroModel===%f",view.totalPrice.text,view.scorePrice.text,view.shouldPayPrice.text,intro.InsurePrice);
        UIButton * rightOne = view.threeBtn;
        UIButton * rightTwo = view.twoBtn;
        UIButton * rightThree = view.oneBtn;
        UIButton * rightFour = view.fourBtn;
        rightThree.hidden = YES;
        rightFour.hidden = YES; 
        if (intro.OrderStatus == 0) {// 未确定
            //        OrderStatus = "待付款";
            [rightOne setTitle:@"立即付款" forState:UIControlStateNormal];
            [rightOne addTarget:self action:@selector(payNow:) forControlEvents:UIControlEventTouchUpInside];
            
            [rightTwo setTitle:@"取消订单" forState:UIControlStateNormal];
            rightTwo.tag = 200+rightTwo.tag;
            [rightTwo addTarget:self action:@selector(operationWithBtn:) forControlEvents:UIControlEventTouchUpInside];
        }
        else if (intro.OrderStatus == 1)
        { //已确认
            if (intro.PaymentStatus == 0)
            { //未付款
                //            OrderStatus = "待付款";
                [rightOne setTitle:@"立即付款" forState:UIControlStateNormal];
                [rightOne addTarget:self action:@selector(payNow:) forControlEvents:UIControlEventTouchUpInside];
                
                [rightTwo setTitle:@"取消订单" forState:UIControlStateNormal];
                rightTwo.tag = 200+rightTwo.tag;
                [rightTwo addTarget:self action:@selector(operationWithBtn:) forControlEvents:UIControlEventTouchUpInside];
                
            }
            else if (intro.PaymentStatus == 2)
            {//付款中
                if (intro.ShipmentStatus == 0)
                {//发货状态 未发货
                    //                OrderStatus = "待发货";
                    [rightOne setTitle:@"申请退款" forState:UIControlStateNormal];
                    [rightOne addTarget:self action:@selector(refundClick:) forControlEvents:UIControlEventTouchUpInside];
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
                        rightOne.tag = 100+rightOne.tag;
                        [rightOne addTarget:self action:@selector(operationWithBtn:) forControlEvents:UIControlEventTouchUpInside];
                        
                        [rightTwo setTitle:@"查看物流" forState:UIControlStateNormal];
                        [rightTwo addTarget:self action:@selector(lookShipment:) forControlEvents:UIControlEventTouchUpInside];
                        
                        rightThree.hidden = YES;
//                        [rightThree setTitle:@"申请退货" forState:UIControlStateNormal];
//                        [rightThree addTarget:self action:@selector(refundGoodClick:) forControlEvents:UIControlEventTouchUpInside];
                    }
                    else{
                        if ([intro.ReturnOrderStatus isEqualToString:@"同意退货"]) {
                            rightOne.hidden = YES;
                            rightTwo.hidden = YES;
                            rightFour.hidden = NO;
                            [rightFour addTarget:self action:@selector(refundGoodEnd:) forControlEvents:UIControlEventTouchUpInside];
                        }
                        //退款状态中
                        //                    OrderStatus = returnOrderStatus;
                        //                    rightOne.hidden = YES;
                        //                    rightTwo.hidden = YES;
                    }
                } else if (intro.ShipmentStatus == 2) {//已收货
                    //                OrderStatus = "已收货";

                } else if (intro.ShipmentStatus == 3) {//配货中
                    
//                    [rightOne setTitle:@"申请退款" forState:UIControlStateNormal];
//                    [rightOne addTarget:self action:@selector(refundClick:) forControlEvents:UIControlEventTouchUpInside];
                    rightOne.hidden = YES;
                    
                    rightTwo.hidden = YES;
                    
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
                rightOne.tag = 300 +rightOne.tag;
                [rightOne setTitle:@"删除订单" forState:UIControlStateNormal];
                [rightOne addTarget:self action:@selector(operationWithBtn:) forControlEvents:UIControlEventTouchUpInside];
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
                    [rightOne addTarget:self action:@selector(commentClick:) forControlEvents:UIControlEventTouchUpInside];
                    
                    rightTwo.tag = 300 +rightTwo.tag;
                    [rightTwo setTitle:@"删除订单" forState:UIControlStateNormal];
                    [rightTwo addTarget:self action:@selector(operationWithBtn:) forControlEvents:UIControlEventTouchUpInside];
                    /*
                    [rightTwo setTitle:@"查看物流" forState:UIControlStateNormal];
                    [rightTwo addTarget:self action:@selector(lookShipment:) forControlEvents:UIControlEventTouchUpInside];
                    
                    rightThree.hidden = NO;
                    rightThree.tag = 300 +rightThree.tag;
                    [rightThree setTitle:@"删除订单" forState:UIControlStateNormal];
                    [rightThree addTarget:self action:@selector(operationWithBtn:) forControlEvents:UIControlEventTouchUpInside];
                     */
                }
                else if (intro.ShipmentStatus == 4) {
                    //                OrderStatus = "已退货";
                }
            }
        }
        return view;
    }

}

///确认收货
-(void)alreadyGetObjectWithAppconfig:(AppConfig *)config
{
    NSDictionary * upateDci = [NSDictionary dictionaryWithObjectsAndKeys:
                               self.listModel.Guid,@"id",
                               config.appSign,@"AppSign",nil];
    [OrderIntroModel UpdateOrderStatueWithParameters:upateDci andblock:^(NSInteger result, NSError *error) {
        if (error) {
            [MBProgressHUD showError:@"操作失败"];
        }else {
            if (result == 202) {
                for (id viewController in self.navigationController.viewControllers) {
                    if ([viewController isKindOfClass:[OrderListController class]]) {
                        [self.navigationController popViewControllerAnimated:YES];
                        if ([viewController respondsToSelector:@selector(operationEndWithController:)]) {
                            [viewController operationEndWithController:self];
                        }
                        [MBProgressHUD showSuccess:@"操作成功"];
                    }
                }
            }else {
                [MBProgressHUD showError:@"操作失败"];
            }
        }
    }];
}

///查看物流
-(void)lookShipment:(UIButton *)btn
{
    LogisticsViewController * lvc= [[UIStoryboard storyboardWithName:@"StoryboardIOS7" bundle:nil]instantiateViewControllerWithIdentifier:@"LogisticsViewController"];
    NSString * str = [NSString stringWithFormat:@"http://senghongwap.efood7.com/pages/LogisticsMessage.html?ShipmentNumber=%@&LogisticsCompanyCode=%@",_listModel.ShipmentNumber,_listModel.LogisticsCompanyCode];
    lvc.LogisticsURL = [NSURL URLWithString:str];
    [self.navigationController pushViewController:lvc animated:YES];
}

///删除订单
-(void)deleOrderWithConfig:(AppConfig *)config
{
    NSDictionary * dict = @{
                            @"AppSign":config.appSign,
                            @"orderNumber":self.listModel.OrderNumber,
                            @"memLoginID":config.loginName
                            };
    [[AFAppAPIClient sharedClient]getPath:@"/api/DeleteOrder" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject - %@ ",responseObject);
        NSInteger result = [[responseObject objectForKey:@"Data"] integerValue];
        if (result == 202) {
            for (id viewController in self.navigationController.viewControllers) {
                if ([viewController isKindOfClass:[OrderListController class]]) {
                    [self.navigationController popViewControllerAnimated:YES];
                    if ([viewController respondsToSelector:@selector(operationEndWithController:)]) {
                        [viewController operationEndWithController:self];
                    }
//                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"删除成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//                    [alert show];
                    [MBProgressHUD showSuccess:@"删除成功"];
                }
            }
        } else {
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"删除失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//            [alert show];
            [MBProgressHUD showError:@"删除失败"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络错误"];
    }];
}

///添加评论
-(void)commentClick:(UIButton *)btn
{
    CommentController * vc = [[CommentController alloc]initWithStyle:UITableViewStyleGrouped];
    vc.model = self.listModel;
    [self.navigationController pushViewController:vc animated:YES];
}

///退款
-(void)refundClick:(UIButton *)btn
{
    RefundController * vc = [[UIStoryboard storyboardWithName:@"Center" bundle:nil]instantiateViewControllerWithIdentifier:@"RefundController"];
    vc.model = self.listModel;
    [self.navigationController pushViewController:vc animated:YES];
}

///退货
-(void)refundGoodClick:(UIButton *)btn
{
    RefundGoodController * vc = [[UIStoryboard storyboardWithName:@"Center" bundle:nil]instantiateViewControllerWithIdentifier:@"RefundGoodController"];
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
    
}

///填写退货物流信息
-(void)refundGoodEnd:(UIButton *)btn
{
    NSLog(@"退货物流信息");
    UpdateReturnOrderViewController * vc = [[UIStoryboard storyboardWithName:@"StoryboardIOS7" bundle:nil]instantiateViewControllerWithIdentifier:@"UpdateReturnOrderViewController"];
    vc.returnOrderGuid = self.refundModel.Guid;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:vc action:@selector(popViewControllerAnimated:)];
    [self.navigationController pushViewController:vc animated:YES];
}

///取消订单
-(void)OrderUpdateWithConfig:(AppConfig *)config
{
    NSDictionary * cancelDic = @{
                                 @"AppSign":config.appSign,
                                 @"id":self.listModel.Guid
                                 };
    [OrderDetailModel cancelOrderWithparameters:cancelDic andblock:^(NSInteger result, NSError *error) {
        if (error) {
            [MBProgressHUD showError:@"网络错误"];
        }else {
            if (result == 202) {
                for (id viewController in self.navigationController.viewControllers) {
                    if ([viewController isKindOfClass:[OrderListController class]]) {
                        [self.navigationController popViewControllerAnimated:YES];
                        if ([viewController respondsToSelector:@selector(operationEndWithController:)]) {
                            [viewController operationEndWithController:self];
                        }
                        [MBProgressHUD showSuccess:@"操作成功" toView:[UIApplication sharedApplication].keyWindow];                        
                    }
                }
            }
            else
            {
                [MBProgressHUD showError:@"操作失败"];
            }
        }
    }];
    
}
#pragma mark - 确认收货 100* 取消订单 200* 删除订单 300*
-(void)operationWithBtn:(UIButton *)btn
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该操作不可返回" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    switch (btn.tag/100) {
        case 1:
            NSLog(@"确认收货");
            alert.tag = 1;
            break;
        case 2:
            NSLog(@"取消订单");
            alert.tag = 2;
            break;
        case 3:
            NSLog(@"删除订单");
            alert.tag = 3;
            break;
    }
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    AppConfig * config = [AppConfig sharedAppConfig];
    [config loadConfig];
    if (buttonIndex == 1) {
        switch (alertView.tag) {
            case 1://确认收货
            {
                [self alreadyGetObjectWithAppconfig:config];
                break;
            }
            case 2://取消订单
            {
                [self OrderUpdateWithConfig:config];
                break;
            }
            case 3://删除订单
            {
                [self deleOrderWithConfig:config];
                break;
            }
            default:
                break;
        }
    }
}

///立即付款
-(void)payNow:(UIButton *)btn
{
    if ([self.listModel.PayTypeName isEqualToString:@"货到付款"]) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您所选择为货到付款，请等待卖家发货" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    else if ([self.listModel.PayTypeName isEqualToString:@"在线支付"])
    {
        ConfirmPayController * vc = [[UIStoryboard storyboardWithName:@"StoryboardIOS7" bundle:nil]instantiateViewControllerWithIdentifier:@"ConfirmPayController"];
        vc.model = self.model;
        vc.totalPrice = self.model.ShouldPayPrice;
        vc.orderNumber = self.model.OrderNumber;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([self.listModel.PayTypeName isEqualToString:@"线下支付"])
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您所选择为线下支付，请等待卖家发货" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
}


///工具方法
-(CGSize )getSizeWithString:(NSString *)string FontNum:(CGFloat )num Size:(CGSize )size
{
    return [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:num]} context:nil].size;
}
@end
