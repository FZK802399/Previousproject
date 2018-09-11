//
//  ChooseCanCouponsViewController.m
//  ShopNum1V3.1
//
//  Created by 森泓投资 on 16/8/16.
//  Copyright © 2016年 WFS. All rights reserved.
//

#import "ChooseCanCouponsViewController.h"
#import "CouponsModel.h"
#import "CanMakeCouponsTableViewCell.h"
#import "WXUtil.h"
#import "OrderMerchandiseSubmitModel.h"

@interface ChooseCanCouponsViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    UITableView *_tableView;
    NSMutableArray *_dataLists;
    UIButton *_chooseBtn;
    BOOL _click;
}
//优惠券时间
@property (nonatomic,strong)NSString *time;

@property (nonatomic,strong)NSMutableString *outup;
@property (nonatomic,strong)NSString *userId;

@property (nonatomic ,strong)NSString *Discount;
//优惠券id
@property (nonatomic,strong)NSString *couponId;

//优惠券卡号
@property (nonatomic,strong)NSString *couponCode;

@property (nonatomic ,strong)CanMakeCouponsTableViewCell *cell;
@property(nonatomic,strong)NSString *member;
@property(nonatomic,strong)NSMutableArray *indepathArry;
@end


@implementation ChooseCanCouponsViewController

static NSString *const ID = @"Cell";

- (void)viewDidLoad {
    self.indepathArry=[NSMutableArray array];
    _click = YES;
    [super viewDidLoad];
    NSString *str1 = @"coupon";
    NSString *str2 = @"efood7";
     NSLog(@"sadsdsdaasdsadsadsdasdsasad%@",self.shoopMoney);
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
    
    NSLog(@"time =======%@  validation=======%@",_time,_outup);

    [self initViewData];
    [self initViewUI];
}

//判断优惠券是不是可以用的方法@"1"->可以用 @“0”－>不可以用
-(void)canUse:(CouponsModel *)model1{
    
    
    
}


-(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString
{
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
}

-(void)initViewData
{
    _dataLists  = [[NSMutableArray alloc]init];
    
}

-(void)initViewUI
{
    _nnum=0;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,120, SCREEN_WIDTH, SCREEN_HEIGHT-150) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   // _tableView.backgroundColor = [UIColor colorWithRed:245/255.0 green:246/255.0 blue:247/255.0 alpha:1.0];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CanMakeCouponsTableViewCell class]) bundle:nil] forCellReuseIdentifier:ID];
    
    [self.view addSubview:_tableView];
    
    
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
        NSLog(@"_member=================%@",_member);
    
   
    
   
    NSLog(@"-----------userId=%@ time= %@ validation=%@",_userId,_time,_outup);
    
    NSDictionary *cadiy= [NSDictionary dictionaryWithObjectsAndKeys:
                          _userId,@"userId",_time,@"time",_outup,@"validation",
                          nil];
    
    [[AFAppAPIClient sharedClient]getPath:kWebAppGetUserAllCoupon parameters:cadiy success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"----------用户所有优惠券----------------=%@",responseObject);
        NSArray *str= responseObject[@"data"];
       
        for (NSMutableDictionary *ob in str){
            
            _couponId = ob[@"couponId"];
           
            NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:_couponId,@"couponId",_time,@"time",_outup,@"validation",_couponCode,@"Discount",nil];
            
            [[AFAppAPIClient sharedClient]getPath:kWebAppGetCouponRuleByCouponId parameters:info success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"----优惠券使用规则--==%@",responseObject);
                NSLog(@"sadsdsdaasdsadsadsdasdsasad%@",self.shoopMoney);
                CouponsModel *cardItem =[[CouponsModel alloc]init];
                cardItem.money =[NSString stringWithFormat:@"%ld",(long)[responseObject[@"result"][@"amount"]intValue]];
                //满减的金额
                cardItem.moneyMake= responseObject[@"result"][@"couponDescription"];
                cardItem.coupons = @"澳元优惠券";
                cardItem.cardCode = ob[@"code"];
                cardItem.isUse = [ob[@"isUse"]integerValue];
                cardItem.CPtype=responseObject[@"result"][@"couponType"];
                cardItem.RTtype=responseObject[@"result"][@"rangeType"];
                cardItem.UseMoney=responseObject[@"result"][@"use"];
                cardItem.appointType =responseObject[@"result"][@"appointType"];
                
                int rtType=[cardItem.RTtype intValue];
                NSString *RtType=[NSString stringWithFormat:@"%d",rtType];
                NSString *shoopMoney=self.shoopMoney;
                shoopMoney=[shoopMoney substringFromIndex:3];
                //商品的总金额
                int shoopAllMoney=[shoopMoney intValue];
                int MoneyUse=[cardItem.UseMoney intValue];
                
                NSLog(@"444444444444444MoneyUse=%d",MoneyUse);
                NSLog(@"444444444444444cardItem.RTtype=%@",RtType);
                for (int i= 0; i<self.shopArray.count; i++) {
                    if ([cardItem.canUseCon isEqualToString:@"1"]) {
                        
                        NSLog(@"ffffffffffffffff%@",cardItem.canUseCon);
                        break;
                     
                    }
                    NSArray *arr  = self.shopArray[i];
                    
                    for (OrderMerchandiseSubmitModel *model in arr) {
                        if ([cardItem.canUseCon isEqualToString:@"1"]) {
                            
                            NSLog(@"ffffffffffffffff%@",cardItem.canUseCon);
                            break;
                            
                            
                        }
                        NSLog(@"model.CouponRule======%@",model.CouponRule);
                        
                        NSDictionary *dic =[self parseJSONStringToNSDictionary:model.CouponRule];
                      
                        int result = [dic[@"result"]intValue];
                        if (result==1) {
                            NSArray *arr = dic [@"Rule"];
                            NSLog(@"arr =======%@",arr);
                            for (NSDictionary * dic1 in arr) {
                                int  full = [dic1[@"full"]intValue];
                                int Goods = [dic1 [@"Goods"] intValue];
                                int type  = [dic1 [@"type"] intValue];
                                NSLog(@"优惠券的金额%d消费的总金额 %d full=%dGoods =%dtype= %d result=%d model1.RTtype=%@ appointType=%@",MoneyUse,shoopAllMoney,full,Goods,type,result,cardItem.RTtype,cardItem.appointType);
                                if ([RtType isEqualToString:@"1"])
                                {
                                    if (full==1&&shoopAllMoney>=MoneyUse) {
                                        cardItem.canUseCon =@"1";
                                        break;
                                    }else {
                                        
                                        cardItem.canUseCon    = @"0";
                                    }
                                }else if ([RtType isEqualToString:@"2"]){
                                    
                                    if (Goods ==1 ) {
                                        cardItem.canUseCon =@"1";
                                        break;
                                    }else{
                                        cardItem.canUseCon = @"0";
                                    }
                                    //RTtype是3时
                                }else{
                                    int appoint = [cardItem.appointType intValue];
                                    if (appoint == type) {
                                        cardItem.canUseCon = @"1";
                                        break;
                                    }else{
                                        cardItem.canUseCon = @"0";
                                    }
                                    
                                }
                                
                                
                                
                            }
                            
                        }
                        else
                        {
                            cardItem.canUseCon =@"0";
                            
                        }
                        
                        
                    }
                }
              
                
             
               
                NSLog(@"---%@---%@---%@-",cardItem.CPtype,cardItem.RTtype,cardItem.UseMoney);
                cardItem.time = [NSString stringWithFormat:@"使用期限：%@",responseObject[@"result"][@"endTime"]];
                //需要转换的字符串
                cardItem.date = responseObject[@"result"][@"endTime"];
                //设置转换格式
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                //NSString转NSDate
                NSDate *date=[formatter dateFromString:cardItem.date];
        
                long long shijian = [self getDateTimeTOMilliSeconds:[NSDate date]];
                long long shi = [self getDateTimeTOMilliSeconds:date];
                long long shijiancha = shi - shijian;
                NSLog(@"优惠券能否使用qqqqqq%@",cardItem.canUseCon);
                if (shijiancha<0){
                [_dataLists removeObject:cardItem];
                  _nnumb = _nnumb +1;
                }
                else if (cardItem.isUse==1)
                {
                [_dataLists removeObject:cardItem];
                   
                }
                else if ([cardItem.canUseCon isEqualToString:@"0"])
                {
                [_dataLists removeObject:cardItem];
                }
                else{                   
                    //NSString *num = [NSString stringWithFormat:@"%lu",_num];
                    
//                    [_dataLists addObject:cardItem];
//                     _num = _num+1;
                   
                                            [_dataLists addObject:cardItem];
                                             _nnum = _nnum+1;
                }
                NSLog(@" -----numb-----=%lu",_nnumb);
                NSLog(@" -----num-----=%lu",_nnum);
               
                
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                
                [defaults setInteger:_nnum forKey:@"num"];
                [defaults setInteger:_nnumb forKey:@"numb"];
                [defaults synchronize];
                
                [_tableView reloadData];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"------------error= %@",error);
            }];
            
        }
        
        
        //
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error= %@",error);
    }];
    
    
    
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error= %@",error);
    }];
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataLists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   
    
    _cell=[_tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!_cell) {
        _cell = [[CanMakeCouponsTableViewCell alloc]initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:ID];
    }
    _cell.selectionStyle =UITableViewCellSelectionStyleNone;
    _cell.cmodel = _dataLists[indexPath.row];
    
    
    return _cell;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 100;
    
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



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.indepathArry.count==0) {
        CouponsModel *cmodel = _dataLists [indexPath.row];
        CanMakeCouponsTableViewCell *cell =[tableView cellForRowAtIndexPath:indexPath];
        NSString *rttype=[NSString stringWithFormat:@"%@",cmodel.RTtype];
        if (cell.didSelect==NO) {
            [self.indepathArry addObject:indexPath];
            cell.didSelect=YES;
            if ([rttype isEqualToString:@"1"]) {
                cell.backImageView.image =[UIImage imageNamed:@"oneone"];
            }else if ([rttype isEqualToString:@"2"]){
                cell.backImageView.image =[UIImage imageNamed:@"twotwo"];
            }else{
                cell.backImageView.image =[UIImage imageNamed:@"threethree"];
            }
            
        }else{
            [self.indepathArry removeObject:indexPath];
            cell.didSelect =YES;
            if ([cmodel.RTtype isEqualToString:@"1"]) {
                cell.backImageView.image =[UIImage imageNamed:@"one"];
            }else if ([cmodel.RTtype isEqualToString:@"2"]){
                cell.backImageView.image =[UIImage imageNamed:@"two"];
            }else{
                cell.backImageView.image =[UIImage imageNamed:@"three"];
            }
            
            
        }
        

    }else
    
    {
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    
        CouponsModel *cmodel = _dataLists [indexPath.row];
        CanMakeCouponsTableViewCell *cell =[tableView cellForRowAtIndexPath:indexPath];
        NSString *rttype=[NSString stringWithFormat:@"%@",cmodel.RTtype];
        if (cell.didSelect==NO) {
            [self.indepathArry addObject:indexPath];
            cell.didSelect=YES;
            if ([rttype isEqualToString:@"1"]) {
                cell.backImageView.image =[UIImage imageNamed:@"oneone"];
            }else if ([rttype isEqualToString:@"2"]){
                cell.backImageView.image =[UIImage imageNamed:@"twotwo"];
            }else{
                cell.backImageView.image =[UIImage imageNamed:@"threethree"];
            }
            
        }else{
            [self.indepathArry removeObject:indexPath];
            cell.didSelect =YES;
            if ([cmodel.RTtype isEqualToString:@"1"]) {
                cell.backImageView.image =[UIImage imageNamed:@"one"];
            }else if ([cmodel.RTtype isEqualToString:@"2"]){
                cell.backImageView.image =[UIImage imageNamed:@"two"];
            }else{
                cell.backImageView.image =[UIImage imageNamed:@"three"];
            }
            
            
        }
    }
    
    _click = NO;
    if (_click==NO) {
//        [_cell setBackgroundImage:[UIImage imageNamed:@"yanjings"] forState:UIControlStateNormal];
        [_cell.backImage setBackgroundColor:[UIColor redColor]];
               _click = YES;
    }
    else  if (_click==YES) {
        [_cell.backImage setBackgroundColor:[UIColor yellowColor]];
        _click = YES;
    }

    
     self.moneyCount  =((CouponsModel *)_dataLists[indexPath.row]).money;
     self.cardCodeCount = ((CouponsModel *)_dataLists[indexPath.row]).cardCode;
    NSLog(@"-----------click--能点-cell-----=%@",self.moneyCount);
    NSLog(@"-----------click--能点-cell-----=%@",((CouponsModel *)_dataLists[indexPath.row]).cardCode);

   
    //((CouponsModel *)_dataLists[indexPath.row]).backImage.image = [UIImage imageNamed:@"didCoupons"];
    
    _chooseBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _chooseBtn.frame  =CGRectMake(SCREEN_WIDTH/2-50, SCREEN_HEIGHT-40, 100, 40);
    [_chooseBtn setTitle:@"确认" forState:UIControlStateNormal];
    [_chooseBtn setTintColor:[UIColor whiteColor]];
    _chooseBtn.titleLabel.font  = [UIFont boldSystemFontOfSize:18];
    _chooseBtn.layer.cornerRadius = 5;
    [_chooseBtn setBackgroundColor:[UIColor colorWithRed:247/255.0 green:85/255.0 blue:45/255.0 alpha:1.0f]];
    [_chooseBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_chooseBtn];
    
    NSLog(@"---------%@",_cell.moneyLabel.text);
}

-(void)btnClick
{
    
    //新增
    NSDictionary *param = @{@"money":self.moneyCount,@"code":self.cardCodeCount};//传值的东西
    if (self.aDelegate&&[self.aDelegate respondsToSelector:@selector(setChooseCanViewControllerDataInfo:andDisCount:)]) {
        [self.aDelegate setChooseCanViewControllerDataInfo:param andDisCount:_Discount];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
