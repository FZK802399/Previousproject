//
//  OrderListViewController.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-9-2.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "OrderListViewController.h"
#import "OrderDetailViewController.h"
#import "OrderPayOnlineViewController.h"
#import "LogisticsViewController.h"
#import "BluePrintingViewController.h"
#import "AFAppAPIClient.h"
#import "ConfirmPayController.h"

@interface OrderListViewController ()

@end

@implementation OrderListViewController{

    NSString * orderNum;
    
    NSString * payStr;
    
    NSString * LogisticsStr;
    
    NSString * productGuid;
    
    NSString *curreorderStatue;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadLeftBackBtn];
    
    switch (self.orderStatue) {
        case OrderAll:
            self.title = @"全部订单";
            break;
        case OrderWaitPay:
            self.title = @"待支付订单";
            break;
        case OrderWaitReceiver:
            self.title = @"待收货订单";
            break;
        case OrderWaitShipments:
            self.title = @"待发货订单";
            break;
        case OrderOver:
            self.title = @"待评价订单";
            break;
        case OrderComment:
            self.title = @"买家已评价订单";
            break;
        case OrderCommentBuySeller:
            self.title = @"卖家已评价订单";
            break;
        case OrderReturn:
            self.title = @"退货订单";
            break;
            
        default:
            break;
    }
    
    [self.changeTabView setBackgroundColor:[self getMatchTopColor]];
    
    // Do any additional setup after loading the view.
}

- (void)back {
    if (self.comFrome == 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    if (_orderType == 1) {
        [self changeTabAction:self.scoreOrderBtn];
    }else {
        [self changeTabAction:self.commonOrderBtn];
    }
    
    //    [self.orderListView.tableView reloadData];
}

-(void)cancelOrder:(id)intro{
    OrderIntroModel *model = (OrderIntroModel *)intro;
    NSDictionary * cancelDic = @{
                                 @"AppSign":self.appConfig.appSign,
                                 @"id":model.Guid
                                 };
    [OrderDetailModel cancelOrderWithparameters:cancelDic andblock:^(NSInteger result, NSError *error) {
        if (error) {
            
        }else {
            if (result == 202) {
                //                    [self.orderListView.dataSource removeObject:intro];
                //                    [self.orderListView.tableView reloadData];
                [self LoadOrderList];
            }
        }
    }];
}

-(void)viewWuliuWith:(id)intro{
    if (_orderType == 1) {
        
    }else {
        OrderIntroModel *tempmodel = (OrderIntroModel *)intro;
        LogisticsStr = [NSString stringWithFormat:@"http://m.kuaidi100.com/index_all.html?type=%@&postid=%@",  tempmodel.LogisticsCompanyCode, tempmodel.ShipmentNumber];
        
        LogisticsStr = [LogisticsStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [self performSegueWithIdentifier:kSegueOrderListToLogistics sender:self];
        
    }
}

///确认收货
-(void)confirmReceiver:(id)intro{
    if (_orderType == 1) {
//        ScoreOrderIntroModel *tempmodel = (ScoreOrderIntroModel *)intro;
//        NSDictionary * upateDci = [NSDictionary dictionaryWithObjectsAndKeys:
//                                   tempmodel.Guid,@"id",
//                                   kWebAppSign,@"AppSign",nil];
//        [ScoreOrderIntroModel UpdateScoreOrderStatueWithParameters:upateDci andblock:^(NSInteger result, NSError *error) {
//            if (error) {
//                
//            }else {
//                if (result == 202) {
//                    tempmodel.ShipmentStatus = 2;
//                    tempmodel.OrderStatus = 5;
//                    [self.orderListView.tableView reloadData];
//                    [self showAlertWithMessage:@"收货成功"];
//                }else {
//                    [self showAlertWithMessage:@"收货失败"];
//                }
//            }
//        }];
        
    }else {
        OrderIntroModel *tempmodel = (OrderIntroModel *)intro;
        NSDictionary * upateDci = [NSDictionary dictionaryWithObjectsAndKeys:
                                   tempmodel.Guid,@"id",
                                   kWebAppSign,@"AppSign",nil];
        [OrderIntroModel UpdateOrderStatueWithParameters:upateDci andblock:^(NSInteger result, NSError *error) {
            if (error) {
                
            }else {
                if (result == 202) {
                    tempmodel.ShipmentStatus = 2;
                    tempmodel.OrderStatus = 5;
                    [self.orderListView.tableView reloadData];
                    [self showAlertWithMessage:@"收货成功"];
                }else {
                    [self showAlertWithMessage:@"收货失败"];
                }
            }
        }];
    }
}


-(void)viewPayWith:(id)intro {
    if (_orderType == 1) {
//        ScoreOrderIntroModel *tempmodel = (ScoreOrderIntroModel *)intro;
//        if (tempmodel.TotaltPrice > 0) {
//            payStr = [NSString stringWithFormat:@"%@/alipay/default.aspx?out_trade_no=%@&subject=订单:%@&total_fee=%f", kWebAppBaseUrl, tempmodel.OrderNumber, tempmodel.OrderNumber, tempmodel.TotaltPrice];
//            
//            payStr = [payStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            
//            [self performSegueWithIdentifier:kSegueOrderListToPay sender:self];
//        }else {
//            [self showAlertWithMessage:@"不需要付款"];
//        }
//        
    }else {
        OrderIntroModel *model = (OrderIntroModel *)intro;
        ConfirmPayController * vc = [[UIStoryboard storyboardWithName:@"StoryboardIOS7" bundle:nil]instantiateViewControllerWithIdentifier:@"ConfirmPayController"];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)selectedOrder:(id)model{
    if (_orderType == 1) {
        ScoreOrderIntroModel *tempmodel = (ScoreOrderIntroModel *)model;
        curreorderStatue = tempmodel.OrderStatusStr;
        orderNum = tempmodel.OrderNumber;
        [self performSegueWithIdentifier:kSegueOrderToDetail sender:self];
    }else {
        OrderIntroModel *tempmodel = (OrderIntroModel *)model;
        curreorderStatue = tempmodel.OrderStatusStr;
        orderNum = tempmodel.OrderNumber;
        [self performSegueWithIdentifier:kSegueOrderToDetail sender:self];
    }
    
}

-(void)LoadOrderList{
    if(_orderListView == nil){
        _orderListView = [[OrderList alloc] init];
        _orderListView.view.frame = self.orderView.bounds;
        _orderListView.tableView.frame = _orderListView.view.bounds;
        _orderListView.delegate = self;
        _orderListView.OrderType = _orderType;
        _orderListView.orderStatusView = self.orderStatue;
        [self.orderView addSubview:_orderListView.view];
    }
    else
    {
        [_orderListView.view removeFromSuperview];
        _orderListView = nil;
        _orderListView = [[OrderList alloc] init];
        _orderListView.view.frame = self.orderView.bounds;
        _orderListView.tableView.frame = _orderListView.view.bounds;
        _orderListView.delegate = self;
        _orderListView.OrderType = _orderType;
        _orderListView.orderStatusView = self.orderStatue;
        [self.orderView addSubview:_orderListView.view];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    OrderDetailViewController * odvc = [segue destinationViewController];
    if ([segue.identifier isEqualToString:kSegueOrderToDetail]) {
        if ([odvc respondsToSelector:@selector(setCurrenOderNumber:)]) {
            odvc.currenOderNumber = orderNum;
            odvc.title = [curreorderStatue substringFromIndex:5];
            odvc.currenOrderType = _orderType;
        }
    }
    
    
    
    OrderPayOnlineViewController * oplvc= [segue destinationViewController];
    if ([segue.identifier isEqualToString:kSegueOrderListToPay]) {
        if ([oplvc respondsToSelector:@selector(setPayWebUrl:)]) {
            oplvc.payWebUrl = [NSURL URLWithString:payStr];
        }
    }
    
    LogisticsViewController * lvc= [segue destinationViewController];
    if ([segue.identifier isEqualToString:kSegueOrderListToLogistics]) {
        if ([lvc respondsToSelector:@selector(setLogisticsURL:)]) {
            lvc.LogisticsURL = [NSURL URLWithString:LogisticsStr];
        }
    }
}


- (IBAction)changeTabAction:(id)sender {
    UIButton * selectBtn = (UIButton*)sender;
    if (selectBtn == self.commonOrderBtn) {
        [self.commonOrderBtn setBackgroundImage:[UIImage imageNamed:@"big_leftbg_selected.png"] forState:UIControlStateNormal];
        [self.commonOrderBtn setTitleColor:[UIColor barTitleColor] forState:UIControlStateNormal];
        [self.scoreOrderBtn setBackgroundImage:[UIImage imageNamed:@"big_rightbg_normal.png"] forState:UIControlStateNormal];
        [self.scoreOrderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _orderType = 0;
        [self LoadOrderList];
    }else {
        [self.scoreOrderBtn setBackgroundImage:[UIImage imageNamed:@"big_rightbg_selected.png"] forState:UIControlStateNormal];
        [self.scoreOrderBtn setTitleColor:[UIColor barTitleColor] forState:UIControlStateNormal];
        [self.commonOrderBtn setBackgroundImage:[UIImage imageNamed:@"big_leftbg_normal.png"] forState:UIControlStateNormal];
        [self.commonOrderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _orderType = 1;
        [self LoadOrderList];

    }
}

@end
