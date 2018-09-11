
//  DZYSubmitOrderController.m
//  ShopNum1V3.1
//
//  Created by yons on 16/1/20.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import "DZYSubmitOrderController.h"
#import "DZYSubmitOrderSectionFoot.h"
#import "DZYSubmitOrderCell.h"
#import "AddressViewController.h"
#import "ConfirmPayController.h"
#import "ChooseCouponsViewController.h"
#import "WXUtil.h"

#import "OrderSubmitModel.h"

@interface DZYSubmitOrderController ()<UITableViewDataSource,UITableViewDelegate,AddressListViewControllerDelegate,UITextViewDelegate,DZYSubmitOrderSectionFootDelegate,ChooseCouponsVCDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

// 地址相关
@property (weak, nonatomic) IBOutlet UIView *addressView;
@property (weak, nonatomic) IBOutlet UILabel *addressName;
@property (weak, nonatomic) IBOutlet UILabel *addressDetail;
@property (weak, nonatomic) IBOutlet UILabel *addressPhone;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressHeight;
@property (nonatomic,strong)AddressModel * addressModel;
// 地址相关

// 留言相关
@property (weak, nonatomic) IBOutlet UIView *board;  //边框
@property (weak, nonatomic) IBOutlet UITextView *message;
@property (nonatomic,assign)CGFloat keyBoardHeight;
// 留言相关

// 配送信息
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *DispatchHeight;
@property (weak, nonatomic) IBOutlet UILabel *DispatchDetail;
@property (nonatomic,strong)NSString * DispathStr;  //配送说明
// 配送信息

// 价格相关
@property (weak, nonatomic) IBOutlet UILabel *productTotalPrice;
@property (weak, nonatomic) IBOutlet UILabel *yunfeiTotalPrice;
@property (weak, nonatomic) IBOutlet UILabel *shuiTotalPrice;
@property (weak, nonatomic) IBOutlet UILabel *allTotalPrice;
@property (weak, nonatomic) IBOutlet UILabel *totalRmbPrice;

@property (weak, nonatomic) IBOutlet UILabel *couponPriceLabel;
// vip折扣
@property (weak, nonatomic) IBOutlet UILabel *vipDiscount;


// 价格相关


///订单号
@property (nonatomic,strong)NSArray * orderNumArr;

//userId 用户id
@property (nonatomic,strong)NSString *userid;
//orderId	使用优惠券的订单id
@property (nonatomic,strong)NSString *orderId;

//codeNUM
@property (nonatomic,strong)NSString * codeString;
///交易号 （多个订单时 方便一起操作）
@property (nonatomic,strong)NSString * DealNumber;
///提交订单
@property (nonatomic,strong)NSMutableArray * submitArr;
///商品总价
@property (nonatomic,assign)CGFloat productPrice;
///总邮费
@property (nonatomic,assign)CGFloat youfeiPrice;
///总税
@property (nonatomic,assign)CGFloat shuiPrice;
///总金额
@property (nonatomic,assign)CGFloat totalPrice;
///rmb总金额
@property (nonatomic,assign)CGFloat rmbPrice;
///汇率 （转换率）
@property (nonatomic,assign)CGFloat rate;
///一个订单的邮费
@property (nonatomic,assign)CGFloat youFei;

//优惠券的价格
@property (nonatomic,assign)CGFloat  couponsPrice;
///税费Arr
@property (nonatomic,strong)NSMutableArray * shuiArr;
///商品总价arr （不包括邮费 税费）
@property (nonatomic,strong)NSMutableArray * productPriceArr;
///商品总价arr
@property (nonatomic,strong)NSMutableArray * totalPriceArr;
///rmb总价arr
@property (nonatomic,strong)NSMutableArray * rmbPriceArr;

@property (nonatomic,strong)NSString *provinceName;
@property (nonatomic,strong)NSString *cityName;
@property (nonatomic,strong)NSString *areaName;


@property (nonatomic,strong)NSString *time;
@property (nonatomic,strong)NSMutableString *outup;

@property (nonatomic, strong) DZYSubmitOrderSectionFoot * dzySubmitOrderView;

//会员卡
@property (nonatomic ,weak) NSString *cardGUID;
//商品总金额
@property(nonatomic,strong) NSString *allMoney;
//会员打折信息
@property (nonatomic,strong)NSString *userId;

@property (nonatomic ,strong)NSString *Discount;
@property(nonatomic,assign)CGFloat UseMember;
@end

static NSString *const cardID = @"f98ae50f-52a6-422c-a5e3-0a31a5bd3db3";


@implementation DZYSubmitOrderController

+(instancetype)create
{
    return [[UIStoryboard storyboardWithName:@"Center" bundle:nil]instantiateViewControllerWithIdentifier:@"DZYSubmitOrderController"];
}

-(NSMutableArray *)submitArr
{
    if (_submitArr == nil) {
        _submitArr = [NSMutableArray array];
    }
    return _submitArr;
}

-(NSMutableArray *)shuiArr
{
    if (_shuiArr == nil) {
        _shuiArr = [NSMutableArray array];
    }
    return _shuiArr;
}

-(NSMutableArray *)rmbPriceArr
{
    if (_rmbPriceArr == nil) {
        _rmbPriceArr = [NSMutableArray array];
    }
    return _rmbPriceArr;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self basicStep];
    [self chooosUseI];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //键盘弹起的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    //键盘隐藏的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)basicStep
{
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hud hide:YES];
    });
    self.navigationItem.title = @"订单详情";
    self.tableView.rowHeight = 90;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.productPriceArr = [NSMutableArray array];
    self.totalPriceArr = [NSMutableArray array];
    self.board.layer.borderWidth = 0.5;
    self.board.layer.borderColor = LINE_DARKGRAY.CGColor;
    self.board.layer.cornerRadius = 3;
    UITapGestureRecognizer * addressTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addressClick:)];
    [self.addressView addGestureRecognizer:addressTap];
    [self loadDataFromWeb];
}

-(void)loadDataFromWeb
{
    [AppConfig getRateWithBlock:^(CGFloat rate, NSError *error) {
        if (!error) {
            self.rate = rate;
            [self loadWuLiu];
            [self loadOrderNum];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.productArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray * arr = self.productArr[section];
    return arr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DZYSubmitOrderCell * cell = [[NSBundle mainBundle]loadNibNamed:@"DZYSubmitOrderCell" owner:nil options:nil].lastObject;
    cell.model = [[self.productArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    return cell;
}

-(CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 95;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    self.dzySubmitOrderView = [[NSBundle mainBundle]loadNibNamed:@"DZYSubmitOrderSectionFoot" owner:nil options:nil].lastObject;
    self.dzySubmitOrderView.aDelegate = self;
    [self.dzySubmitOrderView setYouFeiWithPrice:_youFei];
    [self.dzySubmitOrderView setCouponsPrice:_couponsPrice];
    
    NSLog(@"---------------------------------------------------------------couponsPrice=%lf ==youFei=%lf",_couponsPrice,_youFei);
    
    if (_shuiArr) {
        [self.dzySubmitOrderView setShuiPriceWithshuiPrice:[[self.shuiArr objectAtIndex:section]doubleValue]];
    }
    if (_rmbPriceArr) {
        [self.dzySubmitOrderView setRMBWithPrice:[[self.rmbPriceArr objectAtIndex:section] doubleValue]];
    }
    self.dzySubmitOrderView.productArr = [self.productArr objectAtIndex:section];
    return self.dzySubmitOrderView;
}


#pragma mark- ====================delegate====================

- (void)setDZYSubmitOrderSectionFootBlak {
    
    ChooseCouponsViewController *cvc = [[ChooseCouponsViewController alloc]init];
    //新增
    cvc.couponsDelegate = self;
    cvc.postShoopMoney=self.productTotalPrice.text;
    cvc.postArray =[NSMutableArray arrayWithArray:_productArr];
    [self.navigationController pushViewController:cvc animated:YES];
    
}


//新增
#pragma mark- ====================Choosedelegate====================

- (void)setChooseCouponsViewControllerDataInfo:(NSDictionary *)dataInfo andDiscount:(NSString *)disCount {
    
    self.couponsPrice = [dataInfo[@"money"] floatValue];
    self.codeString = dataInfo[@"code"];
 
    [self modelToDict];
    
    [self.dzySubmitOrderView setCouponsPrice:self.couponsPrice];
    [self.dzySubmitOrderView setRMBWithPrice:_rmbPrice];
    
    
    
    
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
        
        
        
        
        
        NSLog(@"-----------userId=%@ time= %@ Discount=%@",_userId,_time,_Discount);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"------------error= %@",error);
    }];
    
}
- (void)loadWuLiu
{
    AppConfig * config = [AppConfig sharedAppConfig];
    [config loadConfig];
    NSDictionary * dict = @{@"AppSign":config.appSign};
    ///这个接口返回的邮费不使用了
    [[AFAppAPIClient sharedClient]getPath:@"/api/ShopSetting/Dispatch/" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString * DispatchMemo = [responseObject objectForKey:@"DispatchMemo"] == [NSNull null] ? @"" : [responseObject objectForKey:@"DispatchMemo"];
//        self.youFei = [responseObject objectForKey:@"DispatchValue"] == [NSNull null] ? 0 :[[responseObject objectForKey:@"DispatchValue"] doubleValue];
        _DispathStr = DispatchMemo;
        [self loadAddressData];
        ///数据的转化
        [self modelToDict];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark - 读取默认地址
-(void)loadAddressData{
    AppConfig * config = [AppConfig sharedAppConfig];
    [config loadConfig];
    NSDictionary * addressDic= [NSDictionary dictionaryWithObjectsAndKeys:
                                config.loginName,@"MemLoginID",
                                config.appSign, @"AppSign", nil];
    [AddressModel getLoginUserAddressListByParameters:addressDic andblock:^(NSArray *list, NSError *error) {
        if (error) {
            
        }else {
            if (list) {
                NSArray * addressList = [NSArray arrayWithArray:list];
                if ([addressList count] > 0) {
                    self.addressModel = [addressList objectAtIndex:0];

                    
                    self.addressName.text = self.addressModel.name;
                    self.addressPhone.text = self.addressModel.mobile;
                    self.addressDetail.text = self.addressModel.address;
                    [self addressToDealWithStr:self.addressModel.address];
                }
                else
                {
                    [self addressToDealWithStr:@""];
                }
            }
        }
    }];
}

#pragma mark - 获取多个订单号
-(void)loadOrderNum
{
    AppConfig * config = [AppConfig sharedAppConfig];
    [config loadConfig];
    NSDictionary * dict = @{
                            @"count":[NSNumber numberWithInteger:_productArr.count],
                            @"AppSign":config.appSign
                            };
    [[AFAppAPIClient sharedClient]getPath:@"api/getmoreorderno/" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"OrderNumber"] isKindOfClass:[NSArray class]]) {
            self.orderNumArr = [NSArray arrayWithArray:[responseObject objectForKey:@"OrderNumber"]];
           
        }
        if ([[responseObject objectForKey:@"DealNumber"] isKindOfClass:[NSString class]]) {
            self.DealNumber = [responseObject objectForKey:@"DealNumber"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    NSLog(@"订单多个订单号%@",dict);
    
}

#pragma mark - 选择地址
-(void)addressClick:(UITapGestureRecognizer *)tap
{
    AddressViewController * advc = [[UIStoryboard storyboardWithName:@"StoryboardIOS7" bundle:nil]instantiateViewControllerWithIdentifier:@"AddressViewController"];
    advc.showType = AddressListForSelect;
    advc.delegate = self;
    [self.navigationController pushViewController:advc animated:YES];
}

#pragma mark - AddressViewController 代理
- (void)selectedAddress:(AddressModel *)address
{
    self.addressModel = address;
//    self.provinceName = address.Province;
//    self.cityName = address.City;
//    self.areaName = address.Area;
    
    
    self.addressName.text = address.name;
    self.addressPhone.text = address.mobile;
    self.addressDetail.text = address.address;
    [self addressToDealWithStr:address.address];
}

#pragma mark - 地址不超过两行时的处理
- (void)addressToDealWithStr:(NSString *)str
{
    CGFloat width = [self getWidthWithFont:13 str:str width:0].width;
    
    _DispatchDetail.text = _DispathStr;
    CGFloat height = [self getWidthWithFont:13 str:_DispathStr width:LZScreenWidth-16].height + 10;
    
    self.DispatchHeight.constant = 46 + height;
    
    UIView * view = self.tableView.tableHeaderView;
    CGRect frame = view.frame;
    if (width < LZScreenWidth - 132) {
            self.addressHeight.constant = 70 - 16;
            frame.size.height = 3 + 54 + 12 + 46 + height + 12 + 40;
            view.frame = frame;
    }
    else
    {
        self.addressHeight.constant = 70;
        frame.size.height = 3 + 70 + 12 + 46 + height + 12 + 40;
        view.frame = frame;
    }
    [self.tableView beginUpdates];
    self.tableView.tableHeaderView = view;
    [self.tableView endUpdates];
    
    [self.tableView reloadData];
}

#pragma mark - 键盘处理
//键盘弹起后处理scrollView的高度使得textfield可见
-(void)keyboardDidShow:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyboardHeight = [aValue CGRectValue].size.height;
    self.view.transform = CGAffineTransformTranslate(self.view.transform, 0, -(keyboardHeight - self.keyBoardHeight));
    self.keyBoardHeight = keyboardHeight;
}

//键盘隐藏后处理scrollview的高度，使其还原为本来的高度
-(void)keyboardDidHide:(NSNotification *)notification{
    self.view.transform = CGAffineTransformTranslate(self.view.transform, 0, self.keyBoardHeight);
    self.keyBoardHeight = 0;
}

#pragma mark - Model转化为字典  （提交订单时只能传Dict）
- (void)modelToDict
{
    
    _rmbPrice  = 0;
    _productPrice = 0;
    _shuiPrice =  0 ;
    AppConfig * config = [AppConfig sharedAppConfig];
    [config loadConfig];
    for (NSArray * arr in _productArr) {
        NSMutableArray * submitArr = [NSMutableArray array];
        CGFloat totalPrice = 0;
        CGFloat shuiPrice = 0;
        CGFloat rmbPrice = 0 ;
    
        for (OrderMerchandiseSubmitModel * submitModel in arr) {
            NSMutableDictionary *merchandiseParameters = [[NSMutableDictionary alloc] init];
//            [merchandiseParameters setObject:submitModel.Attributes forKey:@"Attributes"];
            [merchandiseParameters setObject:[NSNumber numberWithInteger:submitModel.BuyNumber] forKey:@"BuyNumber"];
            [merchandiseParameters setObject:[NSNumber numberWithFloat:submitModel.BuyPrice] forKey:@"BuyPrice"];
            [merchandiseParameters setObject:[NSNumber numberWithFloat:submitModel.VipCountMoner] forKey:@"VipCountMoner"];
            [merchandiseParameters setObject:@"" forKey:@"Attributes"];
            [merchandiseParameters setObject:submitModel.Guid forKey:@"Guid"];
//            [merchandiseParameters setObject:[NSNumber numberWithFloat:submitModel.MarketPrice] forKey:@"MarketPrice"];
//            [merchandiseParameters setObject:config.loginName forKey:@"MemLoginID"];
//            [merchandiseParameters setObject:submitModel.Name forKey:@"Name"];
            [merchandiseParameters setObject:submitModel.OriginalImge forKey:@"OriginalImge"];
            [merchandiseParameters setObject:submitModel.ProductGuid forKey:@"ProductGuid"];
            //获取个人信息会员信息
          
            if (submitModel.CouponRule) {
                [merchandiseParameters setObject:submitModel.CouponRule forKey:@"CouponRule"];
            }
          
//            [merchandiseParameters setObject:submitModel.ShopID forKey:@"ShopID"];
//            [merchandiseParameters setObject:submitModel.ShopName forKey:@"ShopName"];
//            [merchandiseParameters setObject:submitModel.SpecificationName forKey:@"DetailedSpecifications"];
            [merchandiseParameters setObject:@"abc" forKey:@"DetailedSpecifications"];
//            [merchandiseParameters setObject:submitModel.CreateTimeStr forKey:@"CreateTime"];
            [merchandiseParameters setObject:submitModel.ExtensionAttriutes forKey:@"ExtensionAttriutes"];
            [merchandiseParameters setObject:@"0" forKey:@"IsJoinActivity"];
            [merchandiseParameters setObject:@"0" forKey:@"IsPresent"];
//            [merchandiseParameters setObject:submitModel.SpecificationValue forKey:@"SpecificationValue"];
            [submitArr addObject:merchandiseParameters];
            totalPrice += submitModel.BuyNumber * submitModel.BuyPrice;
            shuiPrice += submitModel.IncomeTax * submitModel.BuyNumber;
            rmbPrice += submitModel.BuyNumber * submitModel.MarketPrice;
            
        }
        ///商品总价
        _productPrice += totalPrice;
        if (_productPrice>=50) {
            NSLog(@"Discountppppppppppp%@",_Discount);
            float usemember=[_Discount floatValue]/10;
            NSLog(@"usemember=================%f",usemember);
            //优惠的价格
            float priceMoner=_productPrice*(1-usemember);
            NSLog(@"priceMoner=======%f",priceMoner);
            
            _UseMember=priceMoner;
        }
        else{
            _UseMember=0;
        }
        NSLog(@"_productPrice=======%f",_productPrice);
        _shuiPrice += shuiPrice;
        NSLog(@"_SplitPostageMoney===%f",_SplitPostageMoney);
        if (self.productArr.count == 1 && _productPrice < _SplitPostageMoney) {
            _youFei = _PostageMoney;
        }
            //商品总价（不包括邮费 税费）
         [self.productPriceArr addObject:[NSNumber numberWithDouble:totalPrice]];
            //税费
        [self.shuiArr addObject:[NSNumber numberWithDouble:shuiPrice]];
        
        
        //商品总价arr
        [self.totalPriceArr addObject:[NSNumber numberWithDouble:totalPrice + shuiPrice + _youFei-_couponsPrice-_UseMember]];
           ///提交订单
        [self.submitArr addObject:submitArr];
        
        ///计算rmb价格
        CGFloat rmb = (_youFei + shuiPrice-_couponsPrice-_UseMember)/self.rate + rmbPrice;
             //RMB总价
        [self.rmbPriceArr addObject:[NSNumber numberWithDouble:rmb]];
        _rmbPrice += rmb;
        
            }
    ///这个地方有点问题 有邮费的情况 是肯定只有一个订单的
    self.youfeiPrice = _youFei*_productArr.count;
    
    self.totalPrice = _productPrice + _youfeiPrice + _shuiPrice-_couponsPrice-_UseMember;
    
    self.productTotalPrice.text = [NSString stringWithFormat:@"AU$%.2f",_productPrice];
     NSLog(@"_----这是总价%@",self.productTotalPrice.text);
    self.yunfeiTotalPrice.text = [NSString stringWithFormat:@"AU$%.2f",_youfeiPrice];
    
    self.shuiTotalPrice.text = [NSString stringWithFormat:@"AU$%.2f",_shuiPrice];
 
    self.allTotalPrice.text = [NSString stringWithFormat:@"AU$%.2f",_totalPrice]; //总价
    self.allMoney=self.allTotalPrice.text;
    NSLog(@"_----这是实际付款的总价%@",self.allTotalPrice.text);
    
    self.totalRmbPrice.text = [NSString stringWithFormat:@"约¥%.2f",_rmbPrice];
    self.vipDiscount.text = [NSString stringWithFormat:@"-AU$%.2f",_UseMember];
    self.couponPriceLabel.text = [NSString stringWithFormat:@"-AU$%.2f",_couponsPrice];
   
     NSLog(@"assdaddsa%@",self.submitArr);
}
//优惠券

#pragma mark - 提交订单
- (IBAction)submitOrder:(id)sender {
  
    if (self.addressModel == nil) {
        [self showErrorMessage:@"请选择收获地址"];
        return;
    }
    if (self.orderNumArr == nil) {
        [self showErrorMessage:@"网络错误"];
        return;
    }
    if (_productPrice<=_couponsPrice) {
        [MBProgressHUD showSuccess:@"亲，您还未达到优惠券使用金额哦"];
        return;
    }
    [self submitWithSender:sender];
}

- (void)submitWithSender:(UIButton *)sender
{
    sender.userInteractionEnabled = NO;
    AppConfig * config = [AppConfig sharedAppConfig];
    [config loadConfig];
    NSMutableArray * resultArr = [NSMutableArray array];
    for (NSArray * arr in _productArr) {
        NSInteger i = [_productArr indexOfObject:arr];
        
        
        NSString * orderNum = [_orderNumArr[i] objectForKey:@"OrderNumber"];
        NSString * message = [self.message.text isEqualToString:@""]||[self.message.text isEqualToString:@"请输入留言（不超过40字）"] ? @"无" : self.message.text;
        NSNumber * productPrice = [self.productPriceArr objectAtIndex:i];
        NSNumber * totalPrice = [self.totalPriceArr objectAtIndex:i];
        NSNumber * rmbPrice = [self.rmbPriceArr objectAtIndex:i];
        
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        [dict setObject:self.addressModel.address forKey:@"Address"];

       
        [dict setObject:[NSString stringWithFormat:@"%lf",_couponsPrice] forKey:@"CouponMoney"];
        
        [dict setObject:[NSString stringWithFormat:@"%@",self.codeString] forKey:@"CouponNumber"];
        [dict setObject:[NSNumber numberWithInteger:self.addressModel.MemberI]  forKey:@"Discount "];
       
        
        [dict setObject:allTrim(message) forKey:@"ClientToSellerMsg"];//留言
        [dict setObject:[NSNumber numberWithDouble:_youFei]  forKey:@"DispatchPrice"];//运费
        [dict setObject:@0 forKey:@"InsurePrice"];//保值运费
//        [dict setObject:_selectPostType.Guid forKey:@"DispatchModeGuid"];
        //[dict setObject:@"拆单" forKey:@"DispatchModeName"];
//        [dict setObject:self.addressModel.email forKey:@"Email"];
//        [dict setObject:@"dzy8023@163.com" forKey:@"Email"];
        [dict setObject:self.addressModel.email forKey:@"Email"];
        [dict setObject:config.loginName forKey:@"MemLoginID"];
        [dict setObject:self.addressModel.mobile forKey:@"Mobile"];
        [dict setObject:self.addressModel.name forKey:@"Name"];
        
        [dict setObject:orderNum forKey:@"OrderNumber"];
        [dict setObject:self.DealNumber forKey:@"DealNumber"];
//        [dict setObject:@"" forKey:@"OutOfStockOperate"];
        //        [_submitDataDic setObject:_selectPayType.Guid forKey:@"PaymentGuid"];
//        [dict setObject:@"0" forKey:@"PostType"];
        [dict setObject:@1 forKey:@"PayType"];  //如果不添加选择支付方式 则默认传@1 在线支付
        [dict setObject:self.addressModel.postalcode forKey:@"Postalcode"];
        [dict setObject:[NSMutableArray arrayWithArray:_submitArr[i]] forKey:@"ProductList"];
        
        [dict setObject:productPrice forKey:@"ProductPrice"];  //商品总价
        [dict setObject:self.addressModel.addressCode forKey:@"RegionCode"];
        [dict setObject:totalPrice forKey:@"ShouldPayPrice"];  //总价
        [dict setObject:rmbPrice forKey:@"RMBMoney"]; //rmb价格
        [dict setObject:@"0" forKey:@"Tel"];
//        [dict setObject:[NSNumber numberWithDouble:price] forKey:@"orderPrice"];
//        [dict setObject:orderNum forKey:@"TradeID"];
//        [dict setObject:[NSNumber numberWithInteger:self.useScore] forKey:@"UseScore"];
//        [dict setObject:config.appSign forKey:@"AppSign"];
        [dict setObject:@"-1" forKey:@"JoinActiveType"];
        [dict setObject:@"0" forKey:@"ActvieContent"];
        ///新增 添加身份证正反面 号码
        [dict setObject:self.addressModel.IdCardFront forKey:@"IdCardFront"];
        [dict setObject:self.addressModel.IdCardVerso forKey:@"IdCardVerso"];
        [dict setObject:self.addressModel.IDCard forKey:@"IDCard"];
        [resultArr addObject:dict];
     //   NSLog(@"resultarr=========%@",resultArr);
    }

    NSDictionary * addDict = @{
                               @"ListOrder":resultArr,
                               @"AppSign":config.appSign
                               };
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/html", nil]];
    [AFAppAPIClient sharedClient].parameterEncoding = AFJSONParameterEncoding;
    
    
    NSLog(@"!!!!!!!!!!!@@@@@@@@@@@###########$$$$$$$$$$$&&&&&&&&&&&&&&&&&&&&&&&&&&&&&!!!!!!!addDict========%@",addDict);
    
    
    [[AFAppAPIClient sharedClient]postPath:@"api/MoreOrderAdd/" parameters:addDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"tes======================%@",[responseObject objectForKey:@"ListOrder"]);
        NSLog(@"return------------------ = %@",[responseObject objectForKey:@"return"]);
        sender.userInteractionEnabled = YES;
        NSInteger result = [[responseObject objectForKey:@"return"] integerValue];
        if (result == 202) {
            
            ConfirmPayController * vc = [[UIStoryboard storyboardWithName:@"StoryboardIOS7" bundle:nil]instantiateViewControllerWithIdentifier:@"ConfirmPayController"];
            vc.orderNumber = self.DealNumber;
            vc.totalPrice = self.totalPrice;
            vc.rmbPrice = self.rmbPrice;
            for (NSArray * arr in _productArr) {
                NSInteger i = [_productArr indexOfObject:arr];
                NSString * orderNum = [_orderNumArr[i] objectForKey:@"OrderNumber"];
                vc.order = orderNum;
                _orderId = orderNum;
            }
            //couponCode	优惠券编号
            //userId 用户id
            //orderId	使用优惠券的订单id
            if ([_codeString length]==0) {
                NSLog(@"没有使用优惠券");
            }
            else
            {
            NSString *appsign = [[NSUserDefaults standardUserDefaults]objectForKey:@"Shop_Web_AppSign"];
            NSString *memLoginID = [[NSUserDefaults standardUserDefaults]objectForKey:@"Shop_Login_Name"];
            
            
            NSDictionary *caidy = [NSDictionary dictionaryWithObjectsAndKeys:
                                   appsign,@"Appsign",
                                   memLoginID,@"MemLoginID",
                                   nil];
            [[AFAppAPIClient sharedClient]getPath:kWebAccountInfoPath parameters:caidy success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                
                _userid = responseObject[@"AccoutInfo"][@"ID"];
               
                [self getAddSecret];
                NSLog(@"---------------------userId=%@ ------ orderId=%@---  couponCode=%@-----time=%@----------validation=%@",_userid,_orderId,_codeString,_time,_outup);
                
                
                NSDictionary *coupons = [NSDictionary dictionaryWithObjectsAndKeys:
                                       _codeString,@"couponCode",_userid,@"userId",_orderId,@"orderId",_time,@"time",_outup,@"validation",nil];
             
                [[AFAppAPIClient sharedClient]getPath:kWebAppUseCoupon parameters:coupons success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    
                    NSLog(@"优惠券使用情况---------------=%@",responseObject);
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                    
                    NSLog(@"error=====------====----------------------------------------===%@",error);
                    
                    
                }];


                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                
                NSLog(@"error=====------====----------------------------------------===%@",error);
                
                
             }];
            }
            
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [self showErrorMessage:@"交易失败请重新购买"];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        sender.userInteractionEnabled = YES;
        [self showErrorMessage:@"交易失败请重新购买"];
    }];
}

-(void)getAddSecret
{

    NSString *str1 = @"coupon";
    NSString *str2 = @"efood7";
    
    NSString *string = [str1 stringByAppendingString:str2];
    NSLog(@"%@", string);
    
    
    
    long long tim = [self getDateTimeTOMilliSeconds:[NSDate date]];
    NSLog(@"===============================----------------=============%llu",tim);
    
    
    _time = [NSString stringWithFormat:@"%llu",tim];
    NSString *str =[NSString stringWithFormat:@"%llu%@",tim,string];
    
    
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest );
    
    _outup = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {[_outup appendFormat:@"%02X", digest[i]];}
    
    

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


/// 成功信息
- (void)showSuccessMessage:(NSString *)message {
    [MBProgressHUD showSuccess:message];
}

// 错误信息
- (void)showErrorMessage:(NSString *)message {
    [MBProgressHUD showError:message];
}

#pragma mark - textViewDelegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return YES;
    }
    if (range.location>=40)
    {
        return NO;
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (
        [textView.text isEqualToString:@"请输入留言（不超过40字）"]) {
        textView.text = @"";
        textView.textColor = FONT_BLACK;
    }
    return YES;
}

- (CGSize )getWidthWithFont:(CGFloat )font str:(NSString *)string width:(CGFloat )width
{
    if (width == 0) {
        return [string boundingRectWithSize:CGSizeMake(LZScreenWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
    }
    else
    {
        return [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
    }
    
}
@end
