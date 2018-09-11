//
//  ConfirmPayController.m
//  ShopNum1V3.1
//
//  Created by yons on 15/11/18.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "ConfirmPayController.h"
#import "AFAppAPIClient.h"
#import "AppConfig.h"
#import "UserInfoModel.h"
#import "OrderDetailModel.h"
#import "OrderMerchandiseIntroModel.h"
#import "ConfirmView.h"
#import "ConfirmViewTwo.h"
#import "PayMentListModel.h"
#import "AdvancePaymentModel.h"
#import "ConfirmPayCell.h"
#import "AppConfig.h"
#import "OrderController.h"
#import "DzyPopView.h"
#import "AFAppAPIClient.h"
#import "OrderPayOnlineViewController.h"
#import "SubmitOrderViewController.h"
#import "OrderListController.h"
#import "YiYuanGouOrderListViewController.h"
#import "ShoppingCartViewController.h"
#import "LimitSaleDetailViewController.h"
#import "YiYuanGouDetailViewController.h"
#import "YiYuanGouOrderListViewController.h"
#import "DZYMerchandiseDetailController.h"
#import "WXUtil.h"
//-------------------------------------------------------------------------------
///支付宝相关
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
///微信相关
#import "payRequsestHandler.h"
#import "WXApi.h"
#import "WechatPayManager.h"

@interface ConfirmPayController ()<UITableViewDelegate,UITableViewDataSource,DzyPopDelegate, UIAlertViewDelegate>
@property (nonatomic,strong)NSMutableArray * arr;
@property (nonatomic,strong)AppConfig * config;

@property (nonatomic,strong)NSString *time;
@property (nonatomic,strong)NSMutableString *outup;

@property (nonatomic,strong)NSString *str;
@property (nonatomic,strong)NSString *pass;


@property (weak, nonatomic) IBOutlet UITableView *tableView;
///输入支付密码
@property(nonatomic,strong)DzyPopView * passWordView;
///预存款
@property (nonatomic,assign)CGFloat money;
@end

@implementation ConfirmPayController
{
    NSString *payPwd;
}

-(NSMutableArray *)arr
{
    if (_arr == nil) {
        _arr = [NSMutableArray array];
    }
    return _arr;
}

-(DzyPopView *)passWordView
{
    if (!_passWordView) {
        _passWordView = [[DzyPopView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _passWordView.delegate = self;
    }
    return _passWordView;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxPayComplete:) name:kNotificationWXPayComplete object:nil];
    [self loadMoney];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *str1 = @"card";
    NSString *str2 = @"efood7";
    
    NSString *string = [str1 stringByAppendingString:str2];
    NSLog(@"%@", string);
    
    
    
    
    long long tim = [self getDateTimeTOMilliSeconds:[NSDate date]];
    NSLog(@"===============================----------------=============%llu",tim);
    
    
    _time = [NSString stringWithFormat:@"%llu",tim];
    NSString *str =[NSString stringWithFormat:@"%llu%@",tim,string];
    NSLog(@"md5====str==========%@",str);
    
    
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest );
    
    _outup = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {[_outup appendFormat:@"%02X", digest[i]];}
    
    NSLog(@"output=======%@",_outup);
    

    [self setupBackButton];
    [self setupModel];
}

- (void)setupBackButton {
    UIImage * backImage = [UIImage imageNamed:@"back"];
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, backImage.size.width, backImage.size.height);
    [backBtn setBackgroundImage:backImage forState:UIControlStateNormal];
    //    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    /**
     *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-5时，间距正好调整
     *  为0；width为正数时，正好相反，相当于往左移动width数值个像素
     */
    if (kCurrentSystemVersion >= 7.0) {
        negativeSpacer.width = -10;
    }else {
        negativeSpacer.width = 0;
    }
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, barBtnItem, nil];
}

- (void)back {
    for (id viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[ShoppingCartViewController class]]||
            [viewController isKindOfClass:[DZYMerchandiseDetailController class]]||
            [viewController isKindOfClass:[LimitSaleDetailViewController class]]||
            [viewController isKindOfClass:[YiYuanGouDetailViewController class]]||
            [viewController isKindOfClass:[YiYuanGouOrderListViewController class]]||
            [viewController isKindOfClass:[OrderListController class]]) {
            [self.navigationController popToViewController:viewController animated:YES];
        }
    }
}

- (void)setupModel {
    if ([self.orderNumber hasPrefix:@"J"]) {
        [self basicStep];
        [self loadDataFromWeb];
    }
    else
    {
        if (self.orderNumber && self.orderNumber.length > 0) {
            NSDictionary * orderDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                       self.orderNumber,@"OrderNumber",
                                       kWebAppSign,@"AppSign", nil];
            [OrderDetailModel getOrderDetailWithparameters:orderDic andblock:^(OrderDetailModel *model, NSError *error) {
                if (error) {
                    
                }else {
                    if (model) {
                        self.model = model;
                        [self basicStep];
                    }
                }
            }];
        } else {
            [self basicStep];
        }
        [self loadDataFromWeb];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.passWordView removeFromSuperview];
    [self.view endEditing:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationWXPayComplete object:nil];
}

-(void)basicStep
{
    [self setTableHeaderView];
    self.config = [AppConfig sharedAppConfig];
    [self.config loadConfig];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)setTableHeaderView
{
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 106)];
    ConfirmViewTwo * view = [[NSBundle mainBundle]loadNibNamed:@"ConfirmViewTwo" owner:nil options:nil].firstObject;
    view.totalPrice.text = [NSString stringWithFormat:@"AU$: %.2f",self.totalPrice];
    if (self.rmbPrice > 0) {
        view.RmbPrice.text = [NSString stringWithFormat:@"约¥ %.2f",self.rmbPrice];
    }
    else{
        AppConfig * config = [AppConfig sharedAppConfig];
        [config loadConfig];
        view.RmbPrice.text = [NSString stringWithFormat:@"约¥ %.2f",self.totalPrice/config.Rate];
    }
    view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 106);
    [headerView addSubview:view];
    self.tableView.tableHeaderView = headerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadMoney
{
    AppConfig * config = [AppConfig sharedAppConfig];
    [config loadConfig];
    NSDictionary * dict =@{
                           @"MemLoginID":config.loginName,
                           @"AppSign":config.appSign
                           };
    [AdvancePaymentModel getAdvancePaymentModifyLogByParamer:dict andblock:^(NSArray *List, NSError *error) {
        if (List.count > 0) {
            AdvancePaymentModel * model = List.firstObject;
            self.money = model.LastOperateMoney;
        }
    }];
}

-(void)loadDataFromWeb
{
    [PayMentListModel getListWithBlock:^(NSArray *List, NSError *error) {
        [self.arr removeAllObjects];
        if (self.saleType == SaleTypeYiYuanGou) {
            NSMutableArray * arr = [NSMutableArray array];
            for (PayMentListModel * model in List) {
                if (![model.PaymentType isEqualToString:@"PreDeposits.aspx"]) {
                    [arr addObject:model];
                }
            }
            [self.arr addObjectsFromArray:arr];
        }
        else
        {
            [self.arr addObjectsFromArray:List];
        }
        [self.tableView reloadData];
    }];
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
    PayMentListModel * model ;
    for (PayMentListModel * m in self.arr) {
        if (m.isSelected == YES) {
            model = m;
        }
    }
    
    if (model == nil) {
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择支付方式" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    UIButton * btn = sender;
    btn.userInteractionEnabled = NO;
    
    AppConfig * config = [AppConfig sharedAppConfig];
    [config loadConfig];
    NSDictionary * dict = @{
                            @"OrderNumber":self.orderNumber,
                            @"PaymentGuid":model.Guid,
                            @"PaymentName":[NSString stringWithFormat:@"%@(iOS)",model.NAME],
                            @"MemLoginID":config.loginName,
                            @"AppSign":config.appSign
                            };
    ///更改支付类型
    [PayMentListModel upDatePayMentWithDict:dict block:^(NSInteger result, NSError *error) {
        btn.userInteractionEnabled = YES;
        if (result == 202) {
            if ([model.PaymentType isEqualToString:@"PreDeposits.aspx"]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"账户余额\nAU$%.2f",self.money] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alertView.delegate = self;
                [alertView setAlertViewStyle:UIAlertViewStyleSecureTextInput];
                UITextField *password = [alertView textFieldAtIndex:0];
                password.placeholder = @"请输入支付密码";
                [alertView show];
            }
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
            [MBProgressHUD showError:@"网络错误，请稍候再试。"];
        }
    }];
}

#pragma mark - 预存款支付代理
-(void)payMoneyWithView:(DzyPopView *)view str:(NSString *)str section:(NSInteger)section
{

    if (self.money < self.totalPrice) {
        [self showErrorMessage:@"余额不足"];
        return;
    }
    NSDictionary * checkDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                self.appConfig.loginName,@"MemLoginID",
                                allTrim(str),@"PayPwd",
                                kWebAppSign,@"AppSign", nil];

    
    [UserInfoModel checkPayPwdByParamer:checkDic andblocks:^(NSInteger result, NSError *error){
        if (error) {
            
        }else {
            if (result == 200) {
                NSString * url = [NSString stringWithFormat:@"api/order/BuyAdvancePayment/%@",self.config.loginName];
                NSDictionary * dict;
                if ([self.orderNumber hasPrefix:@"J"]) {
                    dict = @{
                             @"DealNumber":self.orderNumber,
                             @"OrderNumber":@(-1),
                             @"PayPwd":str,
                             @"AppSign":self.config.appSign
                             };
                }
                else
                {
                    dict = @{
                             @"DealNumber":@(-1),
                             @"OrderNumber":self.orderNumber,
                             @"PayPwd":str,
                             @"AppSign":self.config.appSign
                             };
                }
                ZDXWeakSelf(weakSelf);
                [[AFAppAPIClient sharedClient]getPath:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSLog(@"------------------------------------------------------====================%@",responseObject);
                    NSInteger sbool  = [[responseObject objectForKey:@"sbool"] integerValue];
                    if (sbool == 1) {
                        [weakSelf.passWordView dismiss];
                        [weakSelf showSuccessMesaageInWindow:@"付款成功"];
                       
                        NSLog(@"---------------------%@ %@",self.order,self.config.appSign);
                      NSDictionary  *dic = @{
                                 @"OrderNumber":self.order,
                                 @"AppSign":self.config.appSign
                                 };
                        
                        [[AFAppAPIClient sharedClient]getPath:@"api/orderget/" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            NSLog(@"------购买成打印订单信息-----=====%@",responseObject);
                            ////
                            
                            id str= responseObject[@"Orderinfo"][@"ProductList"];
                            NSLog(@"-------------------------%@",str);
                            for (NSMutableDictionary *ob in str){
                            NSString *stt = ob[@"ProductGuid"];
                            NSLog(@"---------------------%@",stt);
                                
                                
                          //500的卡
                            if ([stt isEqualToString:@"e4bb3f07-3bb2-4cf1-9ae9-8e3e0018f4cc"]) {
                                NSLog(@"-------------------购物卡-------------");
                                
                               // ------------------------------------------生成卡-------------------------------------
                                
                                
                                
                                NSDictionary *caidy = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                                      @"1",@"numbers",
                                                                                      @"500",@"amount",
                                                                                      _time,@"time",_outup,@"validation",
                                                                                      nil];
                                
                                
                                [[AFAppAPIClient sharedClient]getPath:kWebAppGetVirtualCardsUrl parameters:caidy success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    id arr = responseObject[@"result"];
                                    for (NSMutableDictionary *obb in arr) {
                                        _str = obb[@"cardCode"];
                                         _pass  = obb[@"password"];
                                    }
                                   
                                        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                                               _str,@"cardCode",_time,@"time",_outup,@"validation",
                                                               nil];
                                    
                                    
                                        [[AFAppAPIClient sharedClient]getPath:kWebAppActiveCard parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    
                                            
                                            //获取用户信息
                                            
                                            NSString *appsign = [[NSUserDefaults standardUserDefaults]objectForKey:@"Shop_Web_AppSign"];
                                            NSString *memLoginID = [[NSUserDefaults standardUserDefaults]objectForKey:@"Shop_Login_Name"];
                                           
                                            NSDictionary *ca = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                   appsign,@"Appsign",
                                                                   memLoginID,@"MemLoginID",
                                                                   nil];
                                            [[AFAppAPIClient sharedClient]getPath:kWebAccountInfoPath parameters:ca success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                
                                                NSLog(@"responseObject====——————————==%@",responseObject);
                                                NSString *userId = responseObject[@"AccoutInfo"][@"ID"];
                                                NSDictionary *dudu = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      _str,@"cardCode",
                                                                      _pass,@"password",userId,@"userId",
                                                                      _time,@"time",_outup,@"validation",
                                                                      nil];
                                                
                                                
                                                [[AFAppAPIClient sharedClient]getPath:kWebAppBindingCardUrl parameters:dudu success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                    
                                                    NSLog(@"responseObject====---------------------==%@",responseObject);
                                                    NSInteger code = [responseObject[@"result"]integerValue];
                                                    NSString *message = responseObject[@"message"];
                                                    
                                                    if (code==1) {
                                                        //[MBProgressHUD showSuccess:@"验证成功"];
                                                    }
                                                    else if (code==0&&[message isEqualToString:@"该卡号已经被绑定"]){
                                                        
                                                        //[MBProgressHUD showSuccess:@"该卡号已经被绑定"];
                                                    }
                                                    
                                                    else if (code==0&&[message isEqualToString:@"绑定失败"]){
                                                        
                                                        //[MBProgressHUD showSuccess:@"绑定失败"];
                                                    }
                                                    
                                                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                    
                                                    
                                                    NSLog(@"error=====------====----------------------------------------===%@",error);
                                                    
                                                }];
                                           

                                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                
                                                
                                                                                                NSLog(@"error=====------====----------------------------------------===%@",error);
                                                                                                
                                                                                            }];
  
                                            
                                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                            
                                        }];
                                    

                                    
                                    
                                    
                                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    NSLog(@"error=%@",error);
                                }];

                                
                            }
                                //1000的卡
                            else if ([stt isEqualToString:@"e4bb3f07-3bb2-4cf1-1ae9-8e3e0018f4cc"]) {
                                    NSLog(@"-------------------购物卡-------------");
                                    
                                    // ------------------------------------------生成卡-------------------------------------
                                    
                                    
                                    
                                    NSDictionary *caidy = [NSDictionary dictionaryWithObjectsAndKeys:
                                                           @"1",@"numbers",
                                                           @"1000",@"amount",
                                                           _time,@"time",_outup,@"validation",
                                                           nil];
                                    
                                    
                                    [[AFAppAPIClient sharedClient]getPath:kWebAppGetVirtualCardsUrl parameters:caidy success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        id arr = responseObject[@"result"];
                                        for (NSMutableDictionary *obb in arr) {
                                            _str = obb[@"cardCode"];
                                            _pass  = obb[@"password"];
                                        }
                                        
                                        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                                             _str,@"cardCode",_time,@"time",_outup,@"validation",
                                                             nil];
                                        
                                        
                                        [[AFAppAPIClient sharedClient]getPath:kWebAppActiveCard parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                            
                                            
                                            //获取用户信息
                                            
                                            NSString *appsign = [[NSUserDefaults standardUserDefaults]objectForKey:@"Shop_Web_AppSign"];
                                            NSString *memLoginID = [[NSUserDefaults standardUserDefaults]objectForKey:@"Shop_Login_Name"];
                                            
                                            NSDictionary *ca = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                appsign,@"Appsign",
                                                                memLoginID,@"MemLoginID",
                                                                nil];
                                            [[AFAppAPIClient sharedClient]getPath:kWebAccountInfoPath parameters:ca success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                
                                                NSLog(@"responseObject====——————————==%@",responseObject);
                                                NSString *userId = responseObject[@"AccoutInfo"][@"ID"];
                                                NSDictionary *dudu = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      _str,@"cardCode",
                                                                      _pass,@"password",userId,@"userId",
                                                                      _time,@"time",_outup,@"validation",
                                                                      nil];
                                                
                                                
                                                [[AFAppAPIClient sharedClient]getPath:kWebAppBindingCardUrl parameters:dudu success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                    
                                                    NSLog(@"responseObject====---------------------==%@",responseObject);
                                                    NSInteger code = [responseObject[@"result"]integerValue];
                                                    NSString *message = responseObject[@"message"];
                                                    
                                                    if (code==1) {
                                                        //[MBProgressHUD showSuccess:@"验证成功"];
                                                    }
                                                    else if (code==0&&[message isEqualToString:@"该卡号已经被绑定"]){
                                                        
                                                        //[MBProgressHUD showSuccess:@"该卡号已经被绑定"];
                                                    }
                                                    
                                                    else if (code==0&&[message isEqualToString:@"绑定失败"]){
                                                        
                                                        //[MBProgressHUD showSuccess:@"绑定失败"];
                                                    }
                                                    
                                                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                    
                                                    
                                                    NSLog(@"error=====------====----------------------------------------===%@",error);
                                                    
                                                }];
                                                
                                                
                                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                
                                                
                                                NSLog(@"error=====------====----------------------------------------===%@",error);
                                                
                                            }];
                                            
                                            
                                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                            
                                        }];
                                        
                                        
                                        
                                        
                                        
                                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        NSLog(@"error=%@",error);
                                    }];
                                    
                                    
                                }
                                //2000的卡
                            else if ([stt isEqualToString:@"e4bb3f07-3bb2-4cf1-2ae9-8e3e0018f4cc"]) {
                                NSLog(@"-------------------购物卡-------------");
                                
                                // ------------------------------------------生成卡-------------------------------------
                                
                                
                                
                                NSDictionary *caidy = [NSDictionary dictionaryWithObjectsAndKeys:
                                                       @"1",@"numbers",
                                                       @"2000",@"amount",
                                                       _time,@"time",_outup,@"validation",
                                                       nil];
                                
                                
                                [[AFAppAPIClient sharedClient]getPath:kWebAppGetVirtualCardsUrl parameters:caidy success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    id arr = responseObject[@"result"];
                                    for (NSMutableDictionary *obb in arr) {
                                        _str = obb[@"cardCode"];
                                        _pass  = obb[@"password"];
                                    }
                                    
                                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                                         _str,@"cardCode",_time,@"time",_outup,@"validation",
                                                         nil];
                                    
                                    
                                    [[AFAppAPIClient sharedClient]getPath:kWebAppActiveCard parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        
                                        
                                        //获取用户信息
                                        
                                        NSString *appsign = [[NSUserDefaults standardUserDefaults]objectForKey:@"Shop_Web_AppSign"];
                                        NSString *memLoginID = [[NSUserDefaults standardUserDefaults]objectForKey:@"Shop_Login_Name"];
                                        
                                        NSDictionary *ca = [NSDictionary dictionaryWithObjectsAndKeys:
                                                            appsign,@"Appsign",
                                                            memLoginID,@"MemLoginID",
                                                            nil];
                                        [[AFAppAPIClient sharedClient]getPath:kWebAccountInfoPath parameters:ca success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                            
                                            NSLog(@"responseObject====——————————==%@",responseObject);
                                            NSString *userId = responseObject[@"AccoutInfo"][@"ID"];
                                            NSDictionary *dudu = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  _str,@"cardCode",
                                                                  _pass,@"password",userId,@"userId",
                                                                  _time,@"time",_outup,@"validation",
                                                                  nil];
                                            
                                            
                                            [[AFAppAPIClient sharedClient]getPath:kWebAppBindingCardUrl parameters:dudu success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                
                                                NSLog(@"responseObject====---------------------==%@",responseObject);
                                                NSInteger code = [responseObject[@"result"]integerValue];
                                                NSString *message = responseObject[@"message"];
                                                
                                                if (code==1) {
                                                    //[MBProgressHUD showSuccess:@"验证成功"];
                                                }
                                                else if (code==0&&[message isEqualToString:@"该卡号已经被绑定"]){
                                                    
                                                    //[MBProgressHUD showSuccess:@"该卡号已经被绑定"];
                                                }
                                                
                                                else if (code==0&&[message isEqualToString:@"绑定失败"]){
                                                    
                                                    //[MBProgressHUD showSuccess:@"绑定失败"];
                                                }
                                                
                                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                
                                                
                                                NSLog(@"error=====------====----------------------------------------===%@",error);
                                                
                                            }];
                                            
                                            
                                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                            
                                            
                                            NSLog(@"error=====------====----------------------------------------===%@",error);
                                            
                                        }];
                                        
                                        
                                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        
                                    }];
                                    
                                    
                                    
                                    
                                    
                                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    NSLog(@"error=%@",error);
                                }];
                                
                                
                            }
                                //3000的卡
                            else if ([stt isEqualToString:@"e4bb3f07-3bb2-4cf1-3ae9-8e3e0018f4cc"]) {
                                NSLog(@"-------------------购物卡-------------");
                                
                                // ------------------------------------------生成卡-------------------------------------
                                
                                
                                
                                NSDictionary *caidy = [NSDictionary dictionaryWithObjectsAndKeys:
                                                       @"1",@"numbers",
                                                       @"3000",@"amount",
                                                       _time,@"time",_outup,@"validation",
                                                       nil];
                                
                                
                                [[AFAppAPIClient sharedClient]getPath:kWebAppGetVirtualCardsUrl parameters:caidy success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    id arr = responseObject[@"result"];
                                    for (NSMutableDictionary *obb in arr) {
                                        _str = obb[@"cardCode"];
                                        _pass  = obb[@"password"];
                                    }
                                    
                                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                                         _str,@"cardCode",_time,@"time",_outup,@"validation",
                                                         nil];
                                    
                                    
                                    [[AFAppAPIClient sharedClient]getPath:kWebAppActiveCard parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        
                                        
                                        //获取用户信息
                                        
                                        NSString *appsign = [[NSUserDefaults standardUserDefaults]objectForKey:@"Shop_Web_AppSign"];
                                        NSString *memLoginID = [[NSUserDefaults standardUserDefaults]objectForKey:@"Shop_Login_Name"];
                                        
                                        NSDictionary *ca = [NSDictionary dictionaryWithObjectsAndKeys:
                                                            appsign,@"Appsign",
                                                            memLoginID,@"MemLoginID",
                                                            nil];
                                        [[AFAppAPIClient sharedClient]getPath:kWebAccountInfoPath parameters:ca success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                            
                                            NSLog(@"responseObject====——————————==%@",responseObject);
                                            NSString *userId = responseObject[@"AccoutInfo"][@"ID"];
                                            NSDictionary *dudu = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  _str,@"cardCode",
                                                                  _pass,@"password",userId,@"userId",
                                                                  _time,@"time",_outup,@"validation",
                                                                  nil];
                                            
                                            
                                            [[AFAppAPIClient sharedClient]getPath:kWebAppBindingCardUrl parameters:dudu success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                
                                                NSLog(@"responseObject====---------------------==%@",responseObject);
                                                NSInteger code = [responseObject[@"result"]integerValue];
                                                NSString *message = responseObject[@"message"];
                                                
                                                if (code==1) {
                                                    //[MBProgressHUD showSuccess:@"验证成功"];
                                                }
                                                else if (code==0&&[message isEqualToString:@"该卡号已经被绑定"]){
                                                    
                                                    //[MBProgressHUD showSuccess:@"该卡号已经被绑定"];
                                                }
                                                
                                                else if (code==0&&[message isEqualToString:@"绑定失败"]){
                                                    
                                                    //[MBProgressHUD showSuccess:@"绑定失败"];
                                                }
                                                
                                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                
                                                
                                                NSLog(@"error=====------====----------------------------------------===%@",error);
                                                
                                            }];
                                            
                                            
                                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                            
                                            
                                            NSLog(@"error=====------====----------------------------------------===%@",error);
                                            
                                        }];
                                        
                                        
                                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        
                                    }];
                                    
                                    
                                    
                                    
                                    
                                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    NSLog(@"error=%@",error);
                                }];
                                
                                
                            }
                                //5000的卡
                            else if ([stt isEqualToString:@"e4bb3f07-3bb2-4cf1-4ae9-8e3e0018f4cc"]) {
                                NSLog(@"-------------------购物卡-------------");
                                
                                // ------------------------------------------生成卡-------------------------------------
                                
                                
                                
                                NSDictionary *caidy = [NSDictionary dictionaryWithObjectsAndKeys:
                                                       @"1",@"numbers",
                                                       @"5000",@"amount",
                                                       _time,@"time",_outup,@"validation",
                                                       nil];
                                
                                
                                [[AFAppAPIClient sharedClient]getPath:kWebAppGetVirtualCardsUrl parameters:caidy success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    id arr = responseObject[@"result"];
                                    for (NSMutableDictionary *obb in arr) {
                                        _str = obb[@"cardCode"];
                                        _pass  = obb[@"password"];
                                    }
                                    
                                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                                         _str,@"cardCode",_time,@"time",_outup,@"validation",
                                                         nil];
                                    
                                    
                                    [[AFAppAPIClient sharedClient]getPath:kWebAppActiveCard parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        
                                        
                                        //获取用户信息
                                        
                                        NSString *appsign = [[NSUserDefaults standardUserDefaults]objectForKey:@"Shop_Web_AppSign"];
                                        NSString *memLoginID = [[NSUserDefaults standardUserDefaults]objectForKey:@"Shop_Login_Name"];
                                        
                                        NSDictionary *ca = [NSDictionary dictionaryWithObjectsAndKeys:
                                                            appsign,@"Appsign",
                                                            memLoginID,@"MemLoginID",
                                                            nil];
                                        [[AFAppAPIClient sharedClient]getPath:kWebAccountInfoPath parameters:ca success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                            
                                            NSLog(@"responseObject====——————————==%@",responseObject);
                                            NSString *userId = responseObject[@"AccoutInfo"][@"ID"];
                                            NSDictionary *dudu = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  _str,@"cardCode",
                                                                  _pass,@"password",userId,@"userId",
                                                                  _time,@"time",_outup,@"validation",
                                                                  nil];
                                            
                                            
                                            [[AFAppAPIClient sharedClient]getPath:kWebAppBindingCardUrl parameters:dudu success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                
                                                NSLog(@"responseObject====---------------------==%@",responseObject);
                                                NSInteger code = [responseObject[@"result"]integerValue];
                                                NSString *message = responseObject[@"message"];
                                                
                                                if (code==1) {
                                                    //[MBProgressHUD showSuccess:@"验证成功"];
                                                }
                                                else if (code==0&&[message isEqualToString:@"该卡号已经被绑定"]){
                                                    
                                                    //[MBProgressHUD showSuccess:@"该卡号已经被绑定"];
                                                }
                                                
                                                else if (code==0&&[message isEqualToString:@"绑定失败"]){
                                                    
                                                    //[MBProgressHUD showSuccess:@"绑定失败"];
                                                }
                                                
                                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                
                                                
                                                NSLog(@"error=====------====----------------------------------------===%@",error);
                                                
                                            }];
                                            
                                            
                                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                            
                                            
                                            NSLog(@"error=====------====----------------------------------------===%@",error);
                                            
                                        }];
                                        
                                        
                                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        
                                    }];
                                    
                                    
                                    
                                    
                                    
                                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    NSLog(@"error=%@",error);
                                }];
                                
                                
                            }
                           else
                           {
                               //http://192.168.3.134/api/orderget/?AppSign=cb1c87daddc9a1827a24b3704f32a72f&OrderNumber=201608181327326298

                               NSLog(@"-------------------普通商品-------------");
    
                           
                           }
                            }
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            NSLog(@"error = %@",error);
                        }];
                        
                        
                        
                        
                        for (id viewController in weakSelf.navigationController.viewControllers) {
                            if ([viewController isKindOfClass:[OrderListController class]]) {
                                [weakSelf.navigationController popToViewController:viewController animated:YES];
                                if ([viewController respondsToSelector:@selector(operationEndWithController:)]) {
                                    [viewController operationEndWithController:weakSelf];
                                }
                                return;
                            } else if ([viewController isKindOfClass:[YiYuanGouOrderListViewController class]]) {
                                [weakSelf.navigationController popToViewController:viewController animated:YES];
                                return;
                            }
                        }
                        
                        if (self.saleType == SaleTypeYiYuanGou) {
                            YiYuanGouOrderListViewController *yiYuanGouListVC = ZDX_VC(@"StoryboardIOS7", @"YiYuanGouOrderListViewController");
                            [self.navigationController pushViewController:yiYuanGouListVC animated:YES];
                            return;
                        }                        
                        OrderListController * vc = [[OrderListController alloc]init];
                        vc.OrderType = ALL_ORDER;
                        vc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                    } else {
                        [weakSelf showErrorMessage:@"付款失败"];
                    }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [weakSelf showErrorMessage:@"付款失败"];
                }];
            }else{
                [self showAlertWithMessage:@"支付密码错误"];
                return;
            }
        }
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
    order.tradeNO = self.orderNumber;
    //    order.productName = product.subject; //商品标题
    order.productName = self.model == nil ? @"跨境购": self.model.Name;
    //    order.productDescription = product.body; //商品描述
    order.productDescription = @"支付订单";
//    order.amount =
    CGFloat price = self.model == nil ? self.totalPrice : self.model.ShouldPayPrice;
    order.amount = [NSString stringWithFormat:@"%.2f",price]; //商品价格
//    order.amount = [NSString stringWithFormat:@"%.2f",0.01];
    order.notifyURL =  @"http://senghongwap.efood7.com/alipaynat/notify_url.aspx"; //回调URL
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
                    NSLog(@"支付成功");
                    [weakSelf UpdatePaymentStatusWithModel:weakSelf.model];
                    NSDictionary  *dic = @{
                                           @"OrderNumber":self.order,
                                           @"AppSign":self.config.appSign
                                           };
                    
                    [[AFAppAPIClient sharedClient]getPath:@"api/orderget/" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        NSLog(@"------购买成打印订单信息-----=====%@",responseObject);
                        ////
                        
                        id str= responseObject[@"Orderinfo"][@"ProductList"];
                        NSLog(@"-------------------------%@",str);
                        for (NSMutableDictionary *ob in str){
                            NSString *stt = ob[@"ProductGuid"];
                            NSLog(@"---------------------%@",stt);
                            
                            
                            
                            //500的卡
                            if ([stt isEqualToString:@"e4bb3f07-3bb2-4cf1-9ae9-8e3e0018f4cc"]) {
                                NSLog(@"-------------------购物卡-------------");
                                
                                // ------------------------------------------生成卡-------------------------------------
                                
                                
                                
                                NSDictionary *caidy = [NSDictionary dictionaryWithObjectsAndKeys:
                                                       @"1",@"numbers",
                                                       @"500",@"amount",
                                                       _time,@"time",_outup,@"validation",
                                                       nil];
                                
                                
                                [[AFAppAPIClient sharedClient]getPath:kWebAppGetVirtualCardsUrl parameters:caidy success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    id arr = responseObject[@"result"];
                                    for (NSMutableDictionary *obb in arr) {
                                        _str = obb[@"cardCode"];
                                        _pass  = obb[@"password"];
                                    }
                                    
                                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                                         _str,@"cardCode",_time,@"time",_outup,@"validation",
                                                         nil];
                                    
                                    
                                    [[AFAppAPIClient sharedClient]getPath:kWebAppActiveCard parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        
                                        
                                        //获取用户信息
                                        
                                        NSString *appsign = [[NSUserDefaults standardUserDefaults]objectForKey:@"Shop_Web_AppSign"];
                                        NSString *memLoginID = [[NSUserDefaults standardUserDefaults]objectForKey:@"Shop_Login_Name"];
                                        
                                        NSDictionary *ca = [NSDictionary dictionaryWithObjectsAndKeys:
                                                            appsign,@"Appsign",
                                                            memLoginID,@"MemLoginID",
                                                            nil];
                                        [[AFAppAPIClient sharedClient]getPath:kWebAccountInfoPath parameters:ca success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                            
                                            NSLog(@"responseObject====——————————==%@",responseObject);
                                            NSString *userId = responseObject[@"AccoutInfo"][@"ID"];
                                            NSDictionary *dudu = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  _str,@"cardCode",
                                                                  _pass,@"password",userId,@"userId",
                                                                  _time,@"time",_outup,@"validation",
                                                                  nil];
                                            
                                            
                                            [[AFAppAPIClient sharedClient]getPath:kWebAppBindingCardUrl parameters:dudu success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                
                                                NSLog(@"responseObject====---------------------==%@",responseObject);
                                                NSInteger code = [responseObject[@"result"]integerValue];
                                                NSString *message = responseObject[@"message"];
                                                
                                                if (code==1) {
                                                    //[MBProgressHUD showSuccess:@"验证成功"];
                                                }
                                                else if (code==0&&[message isEqualToString:@"该卡号已经被绑定"]){
                                                    
                                                    //[MBProgressHUD showSuccess:@"该卡号已经被绑定"];
                                                }
                                                
                                                else if (code==0&&[message isEqualToString:@"绑定失败"]){
                                                    
                                                    //[MBProgressHUD showSuccess:@"绑定失败"];
                                                }
                                                
                                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                
                                                
                                                NSLog(@"error=====------====----------------------------------------===%@",error);
                                                
                                            }];
                                            
                                            
                                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                            
                                            
                                            NSLog(@"error=====------====----------------------------------------===%@",error);
                                            
                                        }];
                                        
                                        
                                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        
                                    }];
                                    
                                    
                                    
                                    
                                    
                                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    NSLog(@"error=%@",error);
                                }];
                                
                                
                            }
                            //1000的卡
                            else if ([stt isEqualToString:@"e4bb3f07-3bb2-4cf1-1ae9-8e3e0018f4cc"]) {
                                NSLog(@"-------------------购物卡-------------");
                                
                                // ------------------------------------------生成卡-------------------------------------
                                
                                
                                
                                NSDictionary *caidy = [NSDictionary dictionaryWithObjectsAndKeys:
                                                       @"1",@"numbers",
                                                       @"1000",@"amount",
                                                       _time,@"time",_outup,@"validation",
                                                       nil];
                                
                                
                                [[AFAppAPIClient sharedClient]getPath:kWebAppGetVirtualCardsUrl parameters:caidy success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    id arr = responseObject[@"result"];
                                    for (NSMutableDictionary *obb in arr) {
                                        _str = obb[@"cardCode"];
                                        _pass  = obb[@"password"];
                                    }
                                    
                                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                                         _str,@"cardCode",_time,@"time",_outup,@"validation",
                                                         nil];
                                    
                                    
                                    [[AFAppAPIClient sharedClient]getPath:kWebAppActiveCard parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        
                                        
                                        //获取用户信息
                                        
                                        NSString *appsign = [[NSUserDefaults standardUserDefaults]objectForKey:@"Shop_Web_AppSign"];
                                        NSString *memLoginID = [[NSUserDefaults standardUserDefaults]objectForKey:@"Shop_Login_Name"];
                                        
                                        NSDictionary *ca = [NSDictionary dictionaryWithObjectsAndKeys:
                                                            appsign,@"Appsign",
                                                            memLoginID,@"MemLoginID",
                                                            nil];
                                        [[AFAppAPIClient sharedClient]getPath:kWebAccountInfoPath parameters:ca success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                            
                                            NSLog(@"responseObject====——————————==%@",responseObject);
                                            NSString *userId = responseObject[@"AccoutInfo"][@"ID"];
                                            NSDictionary *dudu = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  _str,@"cardCode",
                                                                  _pass,@"password",userId,@"userId",
                                                                  _time,@"time",_outup,@"validation",
                                                                  nil];
                                            
                                            
                                            [[AFAppAPIClient sharedClient]getPath:kWebAppBindingCardUrl parameters:dudu success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                
                                                NSLog(@"responseObject====---------------------==%@",responseObject);
                                                NSInteger code = [responseObject[@"result"]integerValue];
                                                NSString *message = responseObject[@"message"];
                                                
                                                if (code==1) {
                                                    //[MBProgressHUD showSuccess:@"验证成功"];
                                                }
                                                else if (code==0&&[message isEqualToString:@"该卡号已经被绑定"]){
                                                    
                                                    //[MBProgressHUD showSuccess:@"该卡号已经被绑定"];
                                                }
                                                
                                                else if (code==0&&[message isEqualToString:@"绑定失败"]){
                                                    
                                                    //[MBProgressHUD showSuccess:@"绑定失败"];
                                                }
                                                
                                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                
                                                
                                                NSLog(@"error=====------====----------------------------------------===%@",error);
                                                
                                            }];
                                            
                                            
                                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                            
                                            
                                            NSLog(@"error=====------====----------------------------------------===%@",error);
                                            
                                        }];
                                        
                                        
                                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        
                                    }];
                                    
                                    
                                    
                                    
                                    
                                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    NSLog(@"error=%@",error);
                                }];
                                
                                
                            }
                            //2000的卡
                            else if ([stt isEqualToString:@"e4bb3f07-3bb2-4cf1-2ae9-8e3e0018f4cc"]) {
                                NSLog(@"-------------------购物卡-------------");
                                
                                // ------------------------------------------生成卡-------------------------------------
                                
                                
                                
                                NSDictionary *caidy = [NSDictionary dictionaryWithObjectsAndKeys:
                                                       @"1",@"numbers",
                                                       @"2000",@"amount",
                                                       _time,@"time",_outup,@"validation",
                                                       nil];
                                
                                
                                [[AFAppAPIClient sharedClient]getPath:kWebAppGetVirtualCardsUrl parameters:caidy success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    id arr = responseObject[@"result"];
                                    for (NSMutableDictionary *obb in arr) {
                                        _str = obb[@"cardCode"];
                                        _pass  = obb[@"password"];
                                    }
                                    
                                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                                         _str,@"cardCode",_time,@"time",_outup,@"validation",
                                                         nil];
                                    
                                    
                                    [[AFAppAPIClient sharedClient]getPath:kWebAppActiveCard parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        
                                        
                                        //获取用户信息
                                        
                                        NSString *appsign = [[NSUserDefaults standardUserDefaults]objectForKey:@"Shop_Web_AppSign"];
                                        NSString *memLoginID = [[NSUserDefaults standardUserDefaults]objectForKey:@"Shop_Login_Name"];
                                        
                                        NSDictionary *ca = [NSDictionary dictionaryWithObjectsAndKeys:
                                                            appsign,@"Appsign",
                                                            memLoginID,@"MemLoginID",
                                                            nil];
                                        [[AFAppAPIClient sharedClient]getPath:kWebAccountInfoPath parameters:ca success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                            
                                            NSLog(@"responseObject====——————————==%@",responseObject);
                                            NSString *userId = responseObject[@"AccoutInfo"][@"ID"];
                                            NSDictionary *dudu = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  _str,@"cardCode",
                                                                  _pass,@"password",userId,@"userId",
                                                                  _time,@"time",_outup,@"validation",
                                                                  nil];
                                            
                                            
                                            [[AFAppAPIClient sharedClient]getPath:kWebAppBindingCardUrl parameters:dudu success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                
                                                NSLog(@"responseObject====---------------------==%@",responseObject);
                                                NSInteger code = [responseObject[@"result"]integerValue];
                                                NSString *message = responseObject[@"message"];
                                                
                                                if (code==1) {
                                                    //[MBProgressHUD showSuccess:@"验证成功"];
                                                }
                                                else if (code==0&&[message isEqualToString:@"该卡号已经被绑定"]){
                                                    
                                                    //[MBProgressHUD showSuccess:@"该卡号已经被绑定"];
                                                }
                                                
                                                else if (code==0&&[message isEqualToString:@"绑定失败"]){
                                                    
                                                    //[MBProgressHUD showSuccess:@"绑定失败"];
                                                }
                                                
                                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                
                                                
                                                NSLog(@"error=====------====----------------------------------------===%@",error);
                                                
                                            }];
                                            
                                            
                                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                            
                                            
                                            NSLog(@"error=====------====----------------------------------------===%@",error);
                                            
                                        }];
                                        
                                        
                                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        
                                    }];
                                    
                                    
                                    
                                    
                                    
                                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    NSLog(@"error=%@",error);
                                }];
                                
                                
                            }
                            //3000的卡
                            else if ([stt isEqualToString:@"e4bb3f07-3bb2-4cf1-3ae9-8e3e0018f4cc"]) {
                                NSLog(@"-------------------购物卡-------------");
                                
                                // ------------------------------------------生成卡-------------------------------------
                                
                                
                                
                                NSDictionary *caidy = [NSDictionary dictionaryWithObjectsAndKeys:
                                                       @"1",@"numbers",
                                                       @"3000",@"amount",
                                                       _time,@"time",_outup,@"validation",
                                                       nil];
                                
                                
                                [[AFAppAPIClient sharedClient]getPath:kWebAppGetVirtualCardsUrl parameters:caidy success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    id arr = responseObject[@"result"];
                                    for (NSMutableDictionary *obb in arr) {
                                        _str = obb[@"cardCode"];
                                        _pass  = obb[@"password"];
                                    }
                                    
                                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                                         _str,@"cardCode",_time,@"time",_outup,@"validation",
                                                         nil];
                                    
                                    
                                    [[AFAppAPIClient sharedClient]getPath:kWebAppActiveCard parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        
                                        
                                        //获取用户信息
                                        
                                        NSString *appsign = [[NSUserDefaults standardUserDefaults]objectForKey:@"Shop_Web_AppSign"];
                                        NSString *memLoginID = [[NSUserDefaults standardUserDefaults]objectForKey:@"Shop_Login_Name"];
                                        
                                        NSDictionary *ca = [NSDictionary dictionaryWithObjectsAndKeys:
                                                            appsign,@"Appsign",
                                                            memLoginID,@"MemLoginID",
                                                            nil];
                                        [[AFAppAPIClient sharedClient]getPath:kWebAccountInfoPath parameters:ca success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                            
                                            NSLog(@"responseObject====——————————==%@",responseObject);
                                            NSString *userId = responseObject[@"AccoutInfo"][@"ID"];
                                            NSDictionary *dudu = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  _str,@"cardCode",
                                                                  _pass,@"password",userId,@"userId",
                                                                  _time,@"time",_outup,@"validation",
                                                                  nil];
                                            
                                            
                                            [[AFAppAPIClient sharedClient]getPath:kWebAppBindingCardUrl parameters:dudu success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                
                                                NSLog(@"responseObject====---------------------==%@",responseObject);
                                                NSInteger code = [responseObject[@"result"]integerValue];
                                                NSString *message = responseObject[@"message"];
                                                
                                                if (code==1) {
                                                    //[MBProgressHUD showSuccess:@"验证成功"];
                                                }
                                                else if (code==0&&[message isEqualToString:@"该卡号已经被绑定"]){
                                                    
                                                    //[MBProgressHUD showSuccess:@"该卡号已经被绑定"];
                                                }
                                                
                                                else if (code==0&&[message isEqualToString:@"绑定失败"]){
                                                    
                                                    //[MBProgressHUD showSuccess:@"绑定失败"];
                                                }
                                                
                                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                
                                                
                                                NSLog(@"error=====------====----------------------------------------===%@",error);
                                                
                                            }];
                                            
                                            
                                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                            
                                            
                                            NSLog(@"error=====------====----------------------------------------===%@",error);
                                            
                                        }];
                                        
                                        
                                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        
                                    }];
                                    
                                    
                                    
                                    
                                    
                                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    NSLog(@"error=%@",error);
                                }];
                                
                                
                            }
                            //5000的卡
                            else if ([stt isEqualToString:@"e4bb3f07-3bb2-4cf1-4ae9-8e3e0018f4cc"]) {
                                NSLog(@"-------------------购物卡-------------");
                                
                                // ------------------------------------------生成卡-------------------------------------
                                
                                
                                
                                NSDictionary *caidy = [NSDictionary dictionaryWithObjectsAndKeys:
                                                       @"1",@"numbers",
                                                       @"5000",@"amount",
                                                       _time,@"time",_outup,@"validation",
                                                       nil];
                                
                                
                                [[AFAppAPIClient sharedClient]getPath:kWebAppGetVirtualCardsUrl parameters:caidy success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    id arr = responseObject[@"result"];
                                    for (NSMutableDictionary *obb in arr) {
                                        _str = obb[@"cardCode"];
                                        _pass  = obb[@"password"];
                                    }
                                    
                                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                                         _str,@"cardCode",_time,@"time",_outup,@"validation",
                                                         nil];
                                    
                                    
                                    [[AFAppAPIClient sharedClient]getPath:kWebAppActiveCard parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        
                                        
                                        //获取用户信息
                                        
                                        NSString *appsign = [[NSUserDefaults standardUserDefaults]objectForKey:@"Shop_Web_AppSign"];
                                        NSString *memLoginID = [[NSUserDefaults standardUserDefaults]objectForKey:@"Shop_Login_Name"];
                                        
                                        NSDictionary *ca = [NSDictionary dictionaryWithObjectsAndKeys:
                                                            appsign,@"Appsign",
                                                            memLoginID,@"MemLoginID",
                                                            nil];
                                        [[AFAppAPIClient sharedClient]getPath:kWebAccountInfoPath parameters:ca success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                            
                                            NSLog(@"responseObject====——————————==%@",responseObject);
                                            NSString *userId = responseObject[@"AccoutInfo"][@"ID"];
                                            NSDictionary *dudu = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  _str,@"cardCode",
                                                                  _pass,@"password",userId,@"userId",
                                                                  _time,@"time",_outup,@"validation",
                                                                  nil];
                                            
                                            
                                            [[AFAppAPIClient sharedClient]getPath:kWebAppBindingCardUrl parameters:dudu success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                
                                                NSLog(@"responseObject====---------------------==%@",responseObject);
                                                NSInteger code = [responseObject[@"result"]integerValue];
                                                NSString *message = responseObject[@"message"];
                                                
                                                if (code==1) {
                                                    //[MBProgressHUD showSuccess:@"验证成功"];
                                                }
                                                else if (code==0&&[message isEqualToString:@"该卡号已经被绑定"]){
                                                    
                                                    //[MBProgressHUD showSuccess:@"该卡号已经被绑定"];
                                                }
                                                
                                                else if (code==0&&[message isEqualToString:@"绑定失败"]){
                                                    
                                                    //[MBProgressHUD showSuccess:@"绑定失败"];
                                                }
                                                
                                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                
                                                
                                                NSLog(@"error=====------====----------------------------------------===%@",error);
                                                
                                            }];
                                            
                                            
                                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                            
                                            
                                            NSLog(@"error=====------====----------------------------------------===%@",error);
                                            
                                        }];
                                        
                                        
                                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        
                                    }];
                                    
                                    
                                    
                                    
                                    
                                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    NSLog(@"error=%@",error);
                                }];
                                
                                
                            }

                            else
                            {
                                //http://192.168.3.134/api/orderget/?AppSign=cb1c87daddc9a1827a24b3704f32a72f&OrderNumber=201608181327326298
                                
                                NSLog(@"-------------------普通商品-------------");
                                
                                
                            }
                        }
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"error = %@",error);
                    }];
                    

                    
                }
            } else {
                [weakSelf showErrorMessage:@"支付失败"];
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
    order.tradeNO = self.orderNumber;
    //    order.productName = product.subject; //商品标题
    order.productName = self.model == nil ? @"跨境购": self.model.Name;
    //    order.productDescription = product.body; //商品描述
    order.productDescription = @"支付订单";
    //    order.amount =
    CGFloat price = self.model == nil ? self.totalPrice : self.model.ShouldPayPrice;
    order.amount = [NSString stringWithFormat:@"%.2f",price]; //商品价格
    //    order.amount = [NSString stringWithFormat:@"%.2f",0.01];
    order.notifyURL =  @"http://senghongwap.efood7.com/alipaynat/notify_url.aspx"; //回调URL
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
                    [weakSelf UpdatePaymentStatusWithModel:weakSelf.model];
                    NSDictionary  *dic = @{
                                           @"OrderNumber":self.order,
                                           @"AppSign":self.config.appSign
                                           };
                    
                    [[AFAppAPIClient sharedClient]getPath:@"api/orderget/" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        NSLog(@"------购买成打印订单信息-----=====%@",responseObject);
                        ////
                        
                        id str= responseObject[@"Orderinfo"][@"ProductList"];
                        NSLog(@"-------------------------%@",str);
                        for (NSMutableDictionary *ob in str){
                            NSString *stt = ob[@"ProductGuid"];
                            NSLog(@"---------------------%@",stt);
                            
                            
                            
                            //500的卡
                            if ([stt isEqualToString:@"e4bb3f07-3bb2-4cf1-9ae9-8e3e0018f4cc"]) {
                                NSLog(@"-------------------购物卡-------------");
                                
                                // ------------------------------------------生成卡-------------------------------------
                                
                                
                                
                                NSDictionary *caidy = [NSDictionary dictionaryWithObjectsAndKeys:
                                                       @"1",@"numbers",
                                                       @"500",@"amount",
                                                       _time,@"time",_outup,@"validation",
                                                       nil];
                                
                                
                                [[AFAppAPIClient sharedClient]getPath:kWebAppGetVirtualCardsUrl parameters:caidy success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    id arr = responseObject[@"result"];
                                    for (NSMutableDictionary *obb in arr) {
                                        _str = obb[@"cardCode"];
                                        _pass  = obb[@"password"];
                                    }
                                    
                                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                                         _str,@"cardCode",_time,@"time",_outup,@"validation",
                                                         nil];
                                    
                                    
                                    [[AFAppAPIClient sharedClient]getPath:kWebAppActiveCard parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        
                                        
                                        //获取用户信息
                                        
                                        NSString *appsign = [[NSUserDefaults standardUserDefaults]objectForKey:@"Shop_Web_AppSign"];
                                        NSString *memLoginID = [[NSUserDefaults standardUserDefaults]objectForKey:@"Shop_Login_Name"];
                                        
                                        NSDictionary *ca = [NSDictionary dictionaryWithObjectsAndKeys:
                                                            appsign,@"Appsign",
                                                            memLoginID,@"MemLoginID",
                                                            nil];
                                        [[AFAppAPIClient sharedClient]getPath:kWebAccountInfoPath parameters:ca success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                            
                                            NSLog(@"responseObject====——————————==%@",responseObject);
                                            NSString *userId = responseObject[@"AccoutInfo"][@"ID"];
                                            NSDictionary *dudu = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  _str,@"cardCode",
                                                                  _pass,@"password",userId,@"userId",
                                                                  _time,@"time",_outup,@"validation",
                                                                  nil];
                                            
                                            
                                            [[AFAppAPIClient sharedClient]getPath:kWebAppBindingCardUrl parameters:dudu success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                
                                                NSLog(@"responseObject====---------------------==%@",responseObject);
                                                NSInteger code = [responseObject[@"result"]integerValue];
                                                NSString *message = responseObject[@"message"];
                                                
                                                if (code==1) {
                                                    //[MBProgressHUD showSuccess:@"验证成功"];
                                                }
                                                else if (code==0&&[message isEqualToString:@"该卡号已经被绑定"]){
                                                    
                                                    //[MBProgressHUD showSuccess:@"该卡号已经被绑定"];
                                                }
                                                
                                                else if (code==0&&[message isEqualToString:@"绑定失败"]){
                                                    
                                                    //[MBProgressHUD showSuccess:@"绑定失败"];
                                                }
                                                
                                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                
                                                
                                                NSLog(@"error=====------====----------------------------------------===%@",error);
                                                
                                            }];
                                            
                                            
                                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                            
                                            
                                            NSLog(@"error=====------====----------------------------------------===%@",error);
                                            
                                        }];
                                        
                                        
                                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        
                                    }];
                                    
                                    
                                    
                                    
                                    
                                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    NSLog(@"error=%@",error);
                                }];
                                
                                
                            }
                            //1000的卡
                            else if ([stt isEqualToString:@"e4bb3f07-3bb2-4cf1-1ae9-8e3e0018f4cc"]) {
                                NSLog(@"-------------------购物卡-------------");
                                
                                // ------------------------------------------生成卡-------------------------------------
                                
                                
                                
                                NSDictionary *caidy = [NSDictionary dictionaryWithObjectsAndKeys:
                                                       @"1",@"numbers",
                                                       @"1000",@"amount",
                                                       _time,@"time",_outup,@"validation",
                                                       nil];
                                
                                
                                [[AFAppAPIClient sharedClient]getPath:kWebAppGetVirtualCardsUrl parameters:caidy success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    id arr = responseObject[@"result"];
                                    for (NSMutableDictionary *obb in arr) {
                                        _str = obb[@"cardCode"];
                                        _pass  = obb[@"password"];
                                    }
                                    
                                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                                         _str,@"cardCode",_time,@"time",_outup,@"validation",
                                                         nil];
                                    
                                    
                                    [[AFAppAPIClient sharedClient]getPath:kWebAppActiveCard parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        
                                        
                                        //获取用户信息
                                        
                                        NSString *appsign = [[NSUserDefaults standardUserDefaults]objectForKey:@"Shop_Web_AppSign"];
                                        NSString *memLoginID = [[NSUserDefaults standardUserDefaults]objectForKey:@"Shop_Login_Name"];
                                        
                                        NSDictionary *ca = [NSDictionary dictionaryWithObjectsAndKeys:
                                                            appsign,@"Appsign",
                                                            memLoginID,@"MemLoginID",
                                                            nil];
                                        [[AFAppAPIClient sharedClient]getPath:kWebAccountInfoPath parameters:ca success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                            
                                            NSLog(@"responseObject====——————————==%@",responseObject);
                                            NSString *userId = responseObject[@"AccoutInfo"][@"ID"];
                                            NSDictionary *dudu = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  _str,@"cardCode",
                                                                  _pass,@"password",userId,@"userId",
                                                                  _time,@"time",_outup,@"validation",
                                                                  nil];
                                            
                                            
                                            [[AFAppAPIClient sharedClient]getPath:kWebAppBindingCardUrl parameters:dudu success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                
                                                NSLog(@"responseObject====---------------------==%@",responseObject);
                                                NSInteger code = [responseObject[@"result"]integerValue];
                                                NSString *message = responseObject[@"message"];
                                                
                                                if (code==1) {
                                                    //[MBProgressHUD showSuccess:@"验证成功"];
                                                }
                                                else if (code==0&&[message isEqualToString:@"该卡号已经被绑定"]){
                                                    
                                                    //[MBProgressHUD showSuccess:@"该卡号已经被绑定"];
                                                }
                                                
                                                else if (code==0&&[message isEqualToString:@"绑定失败"]){
                                                    
                                                    //[MBProgressHUD showSuccess:@"绑定失败"];
                                                }
                                                
                                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                
                                                
                                                NSLog(@"error=====------====----------------------------------------===%@",error);
                                                
                                            }];
                                            
                                            
                                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                            
                                            
                                            NSLog(@"error=====------====----------------------------------------===%@",error);
                                            
                                        }];
                                        
                                        
                                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        
                                    }];
                                    
                                    
                                    
                                    
                                    
                                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    NSLog(@"error=%@",error);
                                }];
                                
                                
                            }
                            //2000的卡
                            else if ([stt isEqualToString:@"e4bb3f07-3bb2-4cf1-2ae9-8e3e0018f4cc"]) {
                                NSLog(@"-------------------购物卡-------------");
                                
                                // ------------------------------------------生成卡-------------------------------------
                                
                                
                                
                                NSDictionary *caidy = [NSDictionary dictionaryWithObjectsAndKeys:
                                                       @"1",@"numbers",
                                                       @"2000",@"amount",
                                                       _time,@"time",_outup,@"validation",
                                                       nil];
                                
                                
                                [[AFAppAPIClient sharedClient]getPath:kWebAppGetVirtualCardsUrl parameters:caidy success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    id arr = responseObject[@"result"];
                                    for (NSMutableDictionary *obb in arr) {
                                        _str = obb[@"cardCode"];
                                        _pass  = obb[@"password"];
                                    }
                                    
                                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                                         _str,@"cardCode",_time,@"time",_outup,@"validation",
                                                         nil];
                                    
                                    
                                    [[AFAppAPIClient sharedClient]getPath:kWebAppActiveCard parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        
                                        
                                        //获取用户信息
                                        
                                        NSString *appsign = [[NSUserDefaults standardUserDefaults]objectForKey:@"Shop_Web_AppSign"];
                                        NSString *memLoginID = [[NSUserDefaults standardUserDefaults]objectForKey:@"Shop_Login_Name"];
                                        
                                        NSDictionary *ca = [NSDictionary dictionaryWithObjectsAndKeys:
                                                            appsign,@"Appsign",
                                                            memLoginID,@"MemLoginID",
                                                            nil];
                                        [[AFAppAPIClient sharedClient]getPath:kWebAccountInfoPath parameters:ca success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                            
                                            NSLog(@"responseObject====——————————==%@",responseObject);
                                            NSString *userId = responseObject[@"AccoutInfo"][@"ID"];
                                            NSDictionary *dudu = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  _str,@"cardCode",
                                                                  _pass,@"password",userId,@"userId",
                                                                  _time,@"time",_outup,@"validation",
                                                                  nil];
                                            
                                            
                                            [[AFAppAPIClient sharedClient]getPath:kWebAppBindingCardUrl parameters:dudu success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                
                                                NSLog(@"responseObject====---------------------==%@",responseObject);
                                                NSInteger code = [responseObject[@"result"]integerValue];
                                                NSString *message = responseObject[@"message"];
                                                
                                                if (code==1) {
                                                    //[MBProgressHUD showSuccess:@"验证成功"];
                                                }
                                                else if (code==0&&[message isEqualToString:@"该卡号已经被绑定"]){
                                                    
                                                    //[MBProgressHUD showSuccess:@"该卡号已经被绑定"];
                                                }
                                                
                                                else if (code==0&&[message isEqualToString:@"绑定失败"]){
                                                    
                                                    //[MBProgressHUD showSuccess:@"绑定失败"];
                                                }
                                                
                                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                
                                                
                                                NSLog(@"error=====------====----------------------------------------===%@",error);
                                                
                                            }];
                                            
                                            
                                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                            
                                            
                                            NSLog(@"error=====------====----------------------------------------===%@",error);
                                            
                                        }];
                                        
                                        
                                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        
                                    }];
                                    
                                    
                                    
                                    
                                    
                                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    NSLog(@"error=%@",error);
                                }];
                                
                                
                            }
                            //3000的卡
                            else if ([stt isEqualToString:@"e4bb3f07-3bb2-4cf1-3ae9-8e3e0018f4cc"]) {
                                NSLog(@"-------------------购物卡-------------");
                                
                                // ------------------------------------------生成卡-------------------------------------
                                
                                
                                
                                NSDictionary *caidy = [NSDictionary dictionaryWithObjectsAndKeys:
                                                       @"1",@"numbers",
                                                       @"3000",@"amount",
                                                       _time,@"time",_outup,@"validation",
                                                       nil];
                                
                                
                                [[AFAppAPIClient sharedClient]getPath:kWebAppGetVirtualCardsUrl parameters:caidy success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    id arr = responseObject[@"result"];
                                    for (NSMutableDictionary *obb in arr) {
                                        _str = obb[@"cardCode"];
                                        _pass  = obb[@"password"];
                                    }
                                    
                                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                                         _str,@"cardCode",_time,@"time",_outup,@"validation",
                                                         nil];
                                    
                                    
                                    [[AFAppAPIClient sharedClient]getPath:kWebAppActiveCard parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        
                                        
                                        //获取用户信息
                                        
                                        NSString *appsign = [[NSUserDefaults standardUserDefaults]objectForKey:@"Shop_Web_AppSign"];
                                        NSString *memLoginID = [[NSUserDefaults standardUserDefaults]objectForKey:@"Shop_Login_Name"];
                                        
                                        NSDictionary *ca = [NSDictionary dictionaryWithObjectsAndKeys:
                                                            appsign,@"Appsign",
                                                            memLoginID,@"MemLoginID",
                                                            nil];
                                        [[AFAppAPIClient sharedClient]getPath:kWebAccountInfoPath parameters:ca success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                            
                                            NSLog(@"responseObject====——————————==%@",responseObject);
                                            NSString *userId = responseObject[@"AccoutInfo"][@"ID"];
                                            NSDictionary *dudu = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  _str,@"cardCode",
                                                                  _pass,@"password",userId,@"userId",
                                                                  _time,@"time",_outup,@"validation",
                                                                  nil];
                                            
                                            
                                            [[AFAppAPIClient sharedClient]getPath:kWebAppBindingCardUrl parameters:dudu success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                
                                                NSLog(@"responseObject====---------------------==%@",responseObject);
                                                NSInteger code = [responseObject[@"result"]integerValue];
                                                NSString *message = responseObject[@"message"];
                                                
                                                if (code==1) {
                                                    //[MBProgressHUD showSuccess:@"验证成功"];
                                                }
                                                else if (code==0&&[message isEqualToString:@"该卡号已经被绑定"]){
                                                    
                                                    //[MBProgressHUD showSuccess:@"该卡号已经被绑定"];
                                                }
                                                
                                                else if (code==0&&[message isEqualToString:@"绑定失败"]){
                                                    
                                                    //[MBProgressHUD showSuccess:@"绑定失败"];
                                                }
                                                
                                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                
                                                
                                                NSLog(@"error=====------====----------------------------------------===%@",error);
                                                
                                            }];
                                            
                                            
                                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                            
                                            
                                            NSLog(@"error=====------====----------------------------------------===%@",error);
                                            
                                        }];
                                        
                                        
                                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        
                                    }];
                                    
                                    
                                    
                                    
                                    
                                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    NSLog(@"error=%@",error);
                                }];
                                
                                
                            }
                            //5000的卡
                            else if ([stt isEqualToString:@"e4bb3f07-3bb2-4cf1-4ae9-8e3e0018f4cc"]) {
                                NSLog(@"-------------------购物卡-------------");
                                
                                // ------------------------------------------生成卡-------------------------------------
                                
                                
                                
                                NSDictionary *caidy = [NSDictionary dictionaryWithObjectsAndKeys:
                                                       @"1",@"numbers",
                                                       @"5000",@"amount",
                                                       _time,@"time",_outup,@"validation",
                                                       nil];
                                
                                
                                [[AFAppAPIClient sharedClient]getPath:kWebAppGetVirtualCardsUrl parameters:caidy success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    id arr = responseObject[@"result"];
                                    for (NSMutableDictionary *obb in arr) {
                                        _str = obb[@"cardCode"];
                                        _pass  = obb[@"password"];
                                    }
                                    
                                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                                         _str,@"cardCode",_time,@"time",_outup,@"validation",
                                                         nil];
                                    
                                    
                                    [[AFAppAPIClient sharedClient]getPath:kWebAppActiveCard parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        
                                        
                                        //获取用户信息
                                        
                                        NSString *appsign = [[NSUserDefaults standardUserDefaults]objectForKey:@"Shop_Web_AppSign"];
                                        NSString *memLoginID = [[NSUserDefaults standardUserDefaults]objectForKey:@"Shop_Login_Name"];
                                        
                                        NSDictionary *ca = [NSDictionary dictionaryWithObjectsAndKeys:
                                                            appsign,@"Appsign",
                                                            memLoginID,@"MemLoginID",
                                                            nil];
                                        [[AFAppAPIClient sharedClient]getPath:kWebAccountInfoPath parameters:ca success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                            
                                            NSLog(@"responseObject====——————————==%@",responseObject);
                                            NSString *userId = responseObject[@"AccoutInfo"][@"ID"];
                                            NSDictionary *dudu = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  _str,@"cardCode",
                                                                  _pass,@"password",userId,@"userId",
                                                                  _time,@"time",_outup,@"validation",
                                                                  nil];
                                            
                                            
                                            [[AFAppAPIClient sharedClient]getPath:kWebAppBindingCardUrl parameters:dudu success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                
                                                NSLog(@"responseObject====---------------------==%@",responseObject);
                                                NSInteger code = [responseObject[@"result"]integerValue];
                                                NSString *message = responseObject[@"message"];
                                                
                                                if (code==1) {
                                                    //[MBProgressHUD showSuccess:@"验证成功"];
                                                }
                                                else if (code==0&&[message isEqualToString:@"该卡号已经被绑定"]){
                                                    
                                                    //[MBProgressHUD showSuccess:@"该卡号已经被绑定"];
                                                }
                                                
                                                else if (code==0&&[message isEqualToString:@"绑定失败"]){
                                                    
                                                    //[MBProgressHUD showSuccess:@"绑定失败"];
                                                }
                                                
                                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                
                                                
                                                NSLog(@"error=====------====----------------------------------------===%@",error);
                                                
                                            }];
                                            
                                            
                                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                            
                                            
                                            NSLog(@"error=====------====----------------------------------------===%@",error);
                                            
                                        }];
                                        
                                        
                                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        
                                    }];
                                    
                                    
                                    
                                    
                                    
                                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    NSLog(@"error=%@",error);
                                }];
                                
                                
                            }

                            else
                            {
                                //http://192.168.3.134/api/orderget/?AppSign=cb1c87daddc9a1827a24b3704f32a72f&OrderNumber=201608181327326298
                                
                                NSLog(@"-------------------普通商品-------------");
                                
                                
                            }
                        }
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"error = %@",error);
                    }];
                    

                }
            } else {
                [weakSelf showErrorMessage:@"支付失败"];
            }

        }];
        
    }
}

#pragma mark - 京东支付
- (void)jdPayWithModel:(PayMentListModel *)model
{
//    问题接口【京东支付】fxv811app.groupfly.cn/JDPay/WePay/PayIndex.aspx?order=" + order【order为订单号ordernumber】
    NSString * str = [NSString stringWithFormat:@"%@/PayReturn/ZFPay/JDPay/WePay/PayIndex.aspx?order=%@",kWebAppBaseUrl,self.model.OrderNumber];
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL * url = [NSURL URLWithString:str];
    OrderPayOnlineViewController * vc = [[UIStoryboard storyboardWithName:@"StoryboardIOS7" bundle:nil]instantiateViewControllerWithIdentifier:@"OrderPayOnlineViewController"];
    vc.payWebUrl = url;
    vc.str = @"京东支付";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 澳洲银联
- (void)AUDPayWithModel:(PayMentListModel *)model
{
    NSString * str = [NSString stringWithFormat:@"http://senghongwap.efood7.com/JDpay/FrontPay.aspx?ordernum=%@",self.orderNumber];
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL * url = [NSURL URLWithString:str];
    NSLog(@"AUDPayUrl - %@",str);
    OrderPayOnlineViewController * vc = [[UIStoryboard storyboardWithName:@"StoryboardIOS7" bundle:nil]instantiateViewControllerWithIdentifier:@"OrderPayOnlineViewController"];
    vc.payWebUrl = url;
    vc.str = @"澳洲银联";
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
    NSString * str = [NSString stringWithFormat:@"%@/PayReturn/ZFPay/tenpay/payRequest.aspx?order_no=%@&product_name=%@&order_price=%.2f&remarkexplain=%@",kWebAppBaseUrl,self.model.OrderNumber,self.model.Name,self.model.ShouldPayPrice,@"123"];
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
    
    CGFloat money = self.totalPrice * 100;
    NSString *moneyString = [NSString stringWithFormat:@"%ld", (long)money];
    NSMutableDictionary *dict = [wxpayManager sendPayWithTitle:@"支付订单" orderPrice:moneyString notificationURL:kWebMainBaseUrl];

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
        [self UpdatePaymentStatusWithModel:self.model];
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
- (void)UpdatePaymentStatusWithModel:(OrderDetailModel *)model
{
    NSDictionary * dict;
    if ([self.orderNumber hasPrefix:@"J"]) {
        dict = @{
                 @"DealNumber":self.orderNumber,
                 @"OrderNumber":@(-1),
                 @"AppSign":self.config.appSign
                 };
    }
    else
    {
        dict = @{
                 @"DealNumber":@(-1),
                 @"OrderNumber":self.orderNumber,
                 @"AppSign":self.config.appSign
                 };
    }

    ZDXWeakSelf(weakSelf);
    [[AFAppAPIClient sharedClient]getPath:@"api/order/UpdatePaymentStatus/" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"return"] integerValue] == 202) {
            [weakSelf showSuccessMesaageInWindow:@"支付成功"];
//            OrderListController * vc = [[OrderListController alloc]init];
//            vc.OrderType = WAIT_DELIVERGOODS;
//            vc.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:vc animated:YES];
            
            for (id viewController in weakSelf.navigationController.viewControllers) {
                if ([viewController isKindOfClass:[OrderListController class]]) {
                    [weakSelf.navigationController popToViewController:viewController animated:YES];
                    if ([viewController respondsToSelector:@selector(operationEndWithController:)]) {
                        [viewController operationEndWithController:weakSelf];
                    }
                    return;
                } else if ([viewController isKindOfClass:[YiYuanGouOrderListViewController class]]) {
                    [weakSelf.navigationController popToViewController:viewController animated:YES];
                    return;
                }
            }
            
            if (self.saleType == SaleTypeYiYuanGou) {
                YiYuanGouOrderListViewController *yiYuanGouListVC = ZDX_VC(@"StoryboardIOS7", @"YiYuanGouOrderListViewController");
                [self.navigationController pushViewController:yiYuanGouListVC animated:YES];
                return;
            }
            OrderListController * vc = [[OrderListController alloc]init];
            vc.OrderType = ALL_ORDER;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [weakSelf showErrorMessage:@"网络错误，请联系客服"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf showErrorMessage:@"网络错误，请联系客服"];
    }];
}

#pragma mark - AlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        payPwd = [alertView textFieldAtIndex:0].text;
        if (payPwd.length > 0) {
            [self payMoneyWithView:nil str:payPwd section:0];
        } else {
            [self showErrorMessage:@"支付密码不可为空"];
        }
    }
}

//将时间戳转换为NSDate类型
-(NSDate *)getDateTimeFromMilliSeconds:(long long) miliSeconds
{
    NSTimeInterval tempMilli = miliSeconds;
    NSTimeInterval seconds = tempMilli/1000.0;//这里的.0一定要加上，不然除下来的数据会被截断导致时间不一致
    NSLog(@"传入的时间戳=%f",seconds);
    return [NSDate dateWithTimeIntervalSince1970:seconds];
}

//将NSDate类型的时间转换为时间戳,从1970/1/1开始
-(long long)getDateTimeTOMilliSeconds:(NSDate *)datetime
{
    NSTimeInterval interval = [datetime timeIntervalSince1970];
    NSLog(@"转换的时间戳=%f",interval);
    long long totalMilliseconds = interval*1000 ;
    NSLog(@"totalMilliseconds=%llu",totalMilliseconds);
    return totalMilliseconds;
}

@end
