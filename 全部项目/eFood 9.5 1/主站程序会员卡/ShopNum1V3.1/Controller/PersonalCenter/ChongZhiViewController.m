//
//  ChongZhiViewController.m
//  ShopNum1V3.1
//
//  Created by Mac on 15/11/28.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "ChongZhiViewController.h"
#import "OrderSubmitModel.h"
#import "AFAppAPIClient.h"
#import "AppConfig.h"
#import "OrderMerchandiseIntroModel.h"
#import "ConfirmView.h"
#import "ConfirmViewTwo.h"
#import "PayMentListModel.h"
#import "ConfirmPayCell.h"
#import "AppConfig.h"
#import "DzyPopView.h"
#import "AFAppAPIClient.h"
#import "OrderPayOnlineViewController.h"
//-------------------------------------------------------------------------------
///支付宝相关
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
///微信相关
#import "payRequsestHandler.h"
#import "WXApi.h"
#import "WechatPayManager.h"

@interface ChongZhiViewController ()<UITableViewDelegate,UITableViewDataSource, UIAlertViewDelegate>

@property (nonatomic,strong)NSMutableArray * arr;
@property (nonatomic,strong)AppConfig * config;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *submit;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField; // 充值金额

///输入支付密码
@property(nonatomic,strong) DzyPopView * passWordView;

@property (copy, nonatomic) NSString *OrderNumber;
@property (copy, nonatomic) NSString *Name;

@end

@implementation ChongZhiViewController


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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxPayComplete:) name:kNotificationWXPayComplete object:nil];
    [self loadDataFromWeb];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadLeftBackBtn];
    [self basicStep];
    self.Name = @"充值";
    self.submit.layer.cornerRadius = 3.0f;
    self.tableView.scrollEnabled = NO;
    self.moneyTextField.textColor = MYRED;
}

- (void)closeKeyboard {
    [self.moneyTextField resignFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.passWordView removeFromSuperview];
}

-(void)basicStep
{
//    [self setTableHeaderView];
    self.config = [AppConfig sharedAppConfig];
    [self.config loadConfig];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 44.0f;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.moneyTextField.keyboardType = UIKeyboardTypeDecimalPad;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)loadDataFromWeb
{
    [PayMentListModel getListWithBlock:^(NSArray *List, NSError *error) {
        [self.arr removeAllObjects];
        for (PayMentListModel * model in List) {
            if (![model.NAME isEqualToString:@"预存款支付"]) {
                [self.arr addObject:model];
            }
        }
        if (self.arr.count == 0) {
            [self showAlertWithMessage:@"暂无数据"];
        } else {
            [self.tableView reloadData];
        }
    }];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ConfirmPayCell *cell = [[NSBundle mainBundle]loadNibNamed:@"ConfirmPayCell" owner:nil options:nil].lastObject;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    PayMentListModel * model = self.arr[indexPath.row];
    cell.model = model;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.moneyTextField resignFirstResponder];
    PayMentListModel * model = self.arr[indexPath.row];
    if (model.isSelected) {
        model.isSelected = !model.isSelected;
        [self.tableView reloadData];
        return;
    }
    model.isSelected = !model.isSelected;
    for (PayMentListModel * arrModel in self.arr) {
        if (arrModel == model) {
            continue;
        }
        arrModel.isSelected = !model.isSelected;
    }
    [self.tableView reloadData];
}


- (IBAction)payNowClick:(id)sender {
    
    if (self.moneyTextField.text.length == 0) {
        [self showSuccessMessage:@"请输入充值金额"];
        return;
    }
    
    PayMentListModel * model ;
    for (PayMentListModel * m in self.arr) {
        if (m.isSelected == YES) {
            model = m;
        }
    }
    if (model == nil) {
//        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择支付方式" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alertView show];        
        [self showErrorMessage:@"请选择支付方式"];
        return;
    }
    AppConfig * config = [AppConfig sharedAppConfig];
    [config loadConfig];
    [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    NSDictionary *orderDic= @{
                              @"MemLoginID":config.loginName,
                              @"OperateMoney":self.moneyTextField.text,
                              @"PaymentGuid":model.Guid,
                              @"PaymentName":model.NAME
                              };
    [[AFAppAPIClient sharedClient]getPath:@"api/insertAdvancePaymentApplyLog/" parameters:orderDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject - %@",responseObject);
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        if ([[responseObject objectForKey:@"return"] integerValue] == 202) {
            self.OrderNumber = [responseObject objectForKey:@"OrderNumber"];
            if ([model.PaymentType isEqualToString:@"JDpay.aspx"]) {
                NSLog(@"京东支付");
                [self jdPayWithModel:model];
            }
            if ([model.PaymentType isEqualToString:@"Weixin.aspx"]) {
                NSLog(@"微信支付");
                [self wechatPayWithModel:model];
            }
            if ([model.PaymentType isEqualToString:@"Tenpay.aspx"]) {
                NSLog(@"财付通支付");
                [self tenpayWithModel:model];
            }
            if ([model.PaymentType isEqualToString:@"AlipaySDK.aspx"]) {
                NSLog(@"支付宝SDK");
                [self aliPayWithModel:model];
            }
            if ([model.PaymentType isEqualToString:@"Alipay_IN.aspx"]) {
                NSLog(@"支付宝国际版");
                [self GlobalAliPayWithModel:model];
            }
            if ([model.PaymentType isEqualToString:@"AUD_Unionpay.aspx"]) {
                NSLog(@"澳洲银联");
                [self AUDPayWithModel:model];
            }
        }
        else
        {
            [self showSuccessMessage:@"生成订单失败"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        [self showSuccessMessage:@"生成订单失败"];
    }];
}

#pragma mark - 支付宝支付
-(void)aliPayWithModel:(PayMentListModel *)model
{
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    //    NSString *partner = @"2088911093365661";
    NSString * partner = model.MerchantCode;
    //    NSString *seller = @"gdjlgf@126.com";
    NSString * seller = model.Email;
    //    NSString *privateKey = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBALPFYfYwCXtg1DkbEqwmuMl9jOQzNNv81Vrw8JuO1Unsvb5sq8/7VoON3ct8PJtU/5Ic3Vyc7EtPquTRN0RTTzMI3oRtAiXqqs34HJ9jCmk3B3PiDlptX9MKUdZpnNkTsU07WAF5H0faon83ae6PO05Uw04qrIPdVbW20m3IFo89AgMBAAECgYEAmzOZc3XdecsK7ZJV+JIljq756DndNN9/Q1goIeSad4wP9ErVumV/N2xPQ9IqcOBdFMQeyEoiJpLNM2b8k9xozm5hvro7r2o+QpPRA5VGg59i0sSjJb3t5TRCspOVakCcFBqFAZX6atdy366ui3jX7VVZR9BBKYs8DlwQLATLgPECQQDtC/Rg6QRJeT2ERTBmMvoT0mECILSkD+XFrJUTkOHjaQCPzmhNCi5u9E1NM1jU8syWg2qAGS7DC+/L26VeuliPAkEAwiURUsLQMmNwe0giWWeZ0p9tcN5hR5E/VYN4lG53VVGr0apfslp7/lKtDGirz3Fc46o6v4wH24QiAFObxuBJcwJANQDdTeYMfVlMtgy6e7+eR1xdMJqbiau8Vuz2EH/u4miSJZWjoMZMB6c8uaxnioYX1Pfhkm8PE7HRlqWwXnQQZQJALfYOitQ566Pk7hqenyHKpbU+eHj8+K9nGfx84E7ii11BWuqFqziGoCe8dfKVsg95WSBkthIVjh9S2VbxyvwwBwJBAIOCsJtNWmbB9F1zcz2S/8e7DkJMfqqlpdIuB7Hcyt6ZTcd6/nJwc9WttkJPMHkSvV3vu/jtOmjqFBVosiaiOLY=";
    NSString *privateKey = model.Private_Key;
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    //    order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
    order.tradeNO = self.OrderNumber;
    //    order.productName = product.subject; //商品标题
    order.productName = self.Name;
    //    order.productDescription = product.body; //商品描述
    order.productDescription = @"支付订单";
    //    order.amount =
    order.amount = [NSString stringWithFormat:@"%.2f",[self.moneyTextField.text floatValue]]; //商品价格
//    order.amount = [NSString stringWithFormat:@"%.2f",0.01];
    order.notifyURL =  @"shopNum1://"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"EFOOD7";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        //        NSLog(@"orderString -- %@",orderString);
        ZDXWeakSelf(weakSelf);
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            if ([resultDic[@"resultStatus"] integerValue] == 9000) {
                NSString * str = [resultDic objectForKey:@"result"];
                str = [str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                NSArray * arr = [str componentsSeparatedByString:@"&"];
                NSMutableArray * keys = [NSMutableArray array];
                NSMutableArray * values = [NSMutableArray array];
                for (NSString * ss in arr) {
                    NSArray * aa = [ss componentsSeparatedByString:@"="];
                    [keys addObject:aa[0]];
                    [values addObject:aa[1]];
                }
                NSDictionary * endDict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
                if ([resultDic[@"resultStatus"] integerValue] == 9000 && [endDict[@"success"] isEqualToString:@"true"]) {

                    [self updatePayStatus];

                }
            } else {
                [weakSelf showErrorMessage:@"充值失败"];
            }
        }];
    }
}

#pragma mark - 支付宝国际版
-(void)GlobalAliPayWithModel:(PayMentListModel *)model
{
    
    NSString * partner = model.MerchantCode;
    
    NSString * seller = model.Email;
    
    NSString *privateKey = model.Private_Key;
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    //    order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
    order.tradeNO = self.OrderNumber;
    //    order.productName = product.subject; //商品标题
    order.productName = self.Name;
    //    order.productDescription = product.body; //商品描述
    order.productDescription = @"支付订单";
    //    order.amount =
    order.amount = [NSString stringWithFormat:@"%.2f",[self.moneyTextField.text floatValue]]; //商品价格
    //    order.amount = [NSString stringWithFormat:@"%.2f",0.01];
    order.notifyURL =  @"shopNum1://"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    [order setValue:@{@"currency":@"AUD",@"forex_biz":@"FP"} forKey:@"extraParams"];
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"EFOOD7";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        ZDXWeakSelf(weakSelf);
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            if ([resultDic[@"resultStatus"] integerValue] == 9000) {
                NSString * str = [resultDic objectForKey:@"result"];
                str = [str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                NSArray * arr = [str componentsSeparatedByString:@"&"];
                NSMutableArray * keys = [NSMutableArray array];
                NSMutableArray * values = [NSMutableArray array];
                for (NSString * ss in arr) {
                    NSArray * aa = [ss componentsSeparatedByString:@"="];
                    [keys addObject:aa[0]];
                    [values addObject:aa[1]];
                }
                NSDictionary * endDict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
                if ([resultDic[@"resultStatus"] integerValue] == 9000 && [endDict[@"success"] isEqualToString:@"true"]) {
                    NSLog(@"支付成功");
                    [self updatePayStatus];
                }
            } else {
                [weakSelf showErrorMessage:@"支付失败"];
            }
            
        }];
        
    }
}

#pragma mark - 澳洲银联
- (void)AUDPayWithModel:(PayMentListModel *)model
{
    NSString * str = [NSString stringWithFormat:@"http://senghongwap.efood7.com/JDpay/Recharge.aspx?ordernum=%@",self.OrderNumber];
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL * url = [NSURL URLWithString:str];
    NSLog(@"AUDPayUrl - %@",str);
    OrderPayOnlineViewController * vc = [[UIStoryboard storyboardWithName:@"StoryboardIOS7" bundle:nil]instantiateViewControllerWithIdentifier:@"OrderPayOnlineViewController"];
    vc.payWebUrl = url;
    vc.str = @"澳洲银联";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 京东支付
- (void)jdPayWithModel:(PayMentListModel *)model
{
    //    问题接口【京东支付】fxv811app.groupfly.cn/JDPay/WePay/PayIndex.aspx?order=" + order【order为订单号ordernumber】
    NSString * str = [NSString stringWithFormat:@"%@/PayReturn/CZPay/JDPay/WePay/CZ_PayIndex.aspx?order=%@",kWebAppBaseUrl,self.OrderNumber];
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL * url = [NSURL URLWithString:str];
    OrderPayOnlineViewController * vc = [[UIStoryboard storyboardWithName:@"StoryboardIOS7" bundle:nil]instantiateViewControllerWithIdentifier:@"OrderPayOnlineViewController"];
    vc.payWebUrl = url;
    vc.str = @"京东支付";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 财付通支付
- (void)tenpayWithModel:(PayMentListModel *)model
{
    //    fxv811app.groupfly.cn/tenpay/payRequest.aspx?
    //    string sp_billno = Request["order_no"];
    //    string product_name = Request["product_name"];
    //    string order_price = Request["order_price"];
    //    //暂时还不知道这个参数的意义
    //    string remarkexplain = Request["remarkexplain"];
    
    NSString * str = [NSString stringWithFormat:@"%@/PayReturn/CZPay/tenpay/CZ_payRequest.aspx?order_no=%@&product_name=%@&order_price=%.2f&remarkexplain=123",kWebAppBaseUrl,self.OrderNumber,self.Name,[self.moneyTextField.text floatValue]];
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL * url = [NSURL URLWithString:str];
    NSLog(@"tenpayUrl - %@",str);
    OrderPayOnlineViewController * vc = [[UIStoryboard storyboardWithName:@"StoryboardIOS7" bundle:nil]instantiateViewControllerWithIdentifier:@"OrderPayOnlineViewController"];
    vc.payWebUrl = url;
    vc.str = @"财付通支付";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 微信支付
/// 微信支付
- (void) wechatPayWithModel:(PayMentListModel *)model {
    //创建支付签名对象 && 初始化支付签名对象
    WechatPayManager *wxpayManager = [WechatPayManager manager];
    
    CGFloat money = [self.moneyTextField.text floatValue] * 100;
    NSString *moneyString = [NSString stringWithFormat:@"%ld", (long)money];
    NSMutableDictionary *dict = [wxpayManager sendPayWithTitle:@"充值" orderPrice:moneyString notificationURL:kWebMainBaseUrl];
    
    if(dict == nil){
        //错误提示
                NSString *debug = [wxpayManager getDebugInfo];
        return;
    }
    
    NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
    
    //调起微信支付
    PayReq* req   = [[PayReq alloc] init];
    req.openID    = [dict objectForKey:@"appid"];
    req.partnerId = [dict objectForKey:@"partnerid"];
    req.prepayId  = [dict objectForKey:@"prepayid"];
    req.nonceStr  = [dict objectForKey:@"noncestr"];
    req.timeStamp = stamp.intValue;
    req.package   = [dict objectForKey:@"package"];
    req.sign      = [dict objectForKey:@"sign"];
    
    BOOL flag = [WXApi sendReq:req];
    if(flag) {
        
    }
    NSLog(@"支付结果:%d",flag);
}
#pragma mark - 微信支付回调
- (void) wxPayComplete:(NSNotification*)notification{
    NSNumber *errCode = (NSNumber*)notification.object;
    //    BuyForWechatPayApi *api = [[BuyForWechatPayApi alloc]initWithOrder:self.tradeID];
    //    [api startWithCompletionSuccess:^(id JSON, YTKBaseRequest *request) {
    //        LZLOG(@"进来了");
    //    } failure:^(YTKBaseRequest *request) {
    //        LZLOG(@"失败了");
    //    }];
    if(errCode.integerValue == 0) { // 0=WXSuccess
        [self updatePayStatus];
        
        // 告诉后台状态
        //        BuyForWechatPayApi *api = [[BuyForWechatPayApi alloc]initWithOrder:self.tradeID];
        //        [api startWithCompletionSuccess:^(id JSON, YTKBaseRequest *request) {
        //
        //        } failure:^(YTKBaseRequest *request) {
        //
        //        }];
        //
        //
        //
        //        OrderController *nextVC = [OrderController create];
        //        nextVC.OrderType = WAIT_DELIVERGOODS;
        //        [self.navigationController pushViewController:nextVC animated:YES];
    }
}

#pragma mark - 支付成功以后的更新订单
- (void)UpdatePaymentStatusWithModel {
    NSDictionary * dict = @{
                            @"OrderNumber":self.OrderNumber,
                            @"AppSign":self.config.appSign
                            };
    [[AFAppAPIClient sharedClient]getPath:@"api/order/UpdatePaymentStatus/" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"return"] integerValue] == 202) {
            //            [self LoadOrderList];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

// 生成唯一字符串
- (NSString *)fetchRandomString {
    
    CFUUIDRef uuidRef =CFUUIDCreate(NULL);
    CFStringRef uuidStringRef =CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    NSString *uniqueId = (__bridge NSString *)uuidStringRef;
    return uniqueId;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self back];
}

- (void)updatePayStatus {
    NSDictionary * dict = @{
                            @"OrderNumber":self.OrderNumber
                            };
    [[AFAppAPIClient sharedClient]postPath:@"api/UpdateAdvancePayMentLog/" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject - %@",responseObject);
        NSInteger data = [[responseObject objectForKey:@"Data"] integerValue];
        if (data == 1) {
            NSInteger x = 0;
            for (id viewController in self.navigationController.viewControllers) {
                if ([viewController isKindOfClass:[AdvanceController class]]) {
                    x = 1;
                    [self showSuccessMessage:@"充值成功"];
                    [self.navigationController popToViewController:viewController animated:YES];
                    if ([self.delegate respondsToSelector:@selector(ChongZhiDidAddEndWithVC:)]) {
                        [self.delegate ChongZhiDidAddEndWithVC:self];
                    }
                }
            }
            if (x == 0) {
                [self.navigationController popViewControllerAnimated:YES];
                if ([self.delegate respondsToSelector:@selector(ChongZhiDidAddEndWithVC:)]) {
                    [self.delegate ChongZhiDidAddEndWithVC:self];
                }
            }
        }
        else
        {
            [self showSuccessMessage:@"网络错误，请联系客服"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showSuccessMessage:@"网络错误，请联系客服"];
    }];
}


@end
