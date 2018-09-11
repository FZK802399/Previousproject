//
//  RechargeView.m
//  ShopNum1V3.1
//
//  Created by 森泓投资 on 16/7/11.
//  Copyright © 2016年 WFS. All rights reserved.
//

#import "RechargeView.h"
#import "CardNumberInformation.h"
#import "MBProgressHUD+LZ.h"
#import "CardNumberItem.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "WXUtil.h"


#define MAINSCREENwidth   [UIScreen mainScreen].bounds.size.width
#define MAINSCREENheight  [UIScreen mainScreen].bounds.size.height
#define WINDOWFirst       [[[UIApplication sharedApplication] windows] firstObject]
#define RGBa(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#define AlertViewJianGe 19.5

@interface RechargeView ()
//消费金额
@property (nonatomic ,copy) NSString *amount;
//卡号
@property (nonatomic ,copy) NSString *cardCode;
//密码
@property (nonatomic ,copy) NSString *password;

//加密账户密码
@property (nonatomic,copy)NSString *pwd;
@property (nonatomic,copy)NSString *userId;


@property (nonatomic,copy)NSString *key;
@end

@implementation RechargeView

-(instancetype)initWithAlertViewHeight:(CGFloat)height
{
    self=[super init];
    if (self) {
        CGFloat AlertViewHeight = height;
        if (self.bGView==nil) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREENwidth, MAINSCREENheight)];
            view.backgroundColor = [UIColor grayColor];
            view.alpha = 0.2;
            [WINDOWFirst addSubview:view];
            self.bGView =view;
            
        }
        
        self.center = CGPointMake(MAINSCREENwidth/2, MAINSCREENheight/2);
        self.bounds = CGRectMake(0, 0, MAINSCREENwidth, AlertViewHeight);
        [WINDOWFirst addSubview:self];
        
        _BoxTop = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, MAINSCREENwidth-2*AlertViewJianGe, 30)];
        _BoxTop.backgroundColor = [UIColor colorWithWhite:0.956 alpha:1.000];
        _BoxTop.textAlignment = NSTextAlignmentCenter;
        _BoxTop.text = @"充值";
        [self addSubview:_BoxTop];
        
        _middleView = [[UIView alloc] initWithFrame:CGRectMake(20, 29, MAINSCREENwidth-2*AlertViewJianGe, 200)];
        _middleView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_middleView];
        
        _MembershipCardNumber = [[UILabel alloc] init];
        _MembershipCardNumber.frame = CGRectMake(60, 80, _BoxTop.frame.size.width, 20);
        
        
        //MembershipCardNumber.text = @"会员卡卡号：AB12345678";
        _MembershipCardNumber.font = [UIFont systemFontOfSize:15];
      
        _MembershipCardNumber.textColor = [UIColor blackColor];
        [self addSubview:_MembershipCardNumber];
        self.MembershipCardNumber = _MembershipCardNumber;
        
        _FaceVlace = [[UILabel alloc] init];
        _FaceVlace.frame = CGRectMake(60, 100, _BoxTop.frame.size.width, 20);
        //FaceVlace.text = @"会员卡面值：AU$1000 (约￥4750)";
        _FaceVlace.font = [UIFont systemFontOfSize:15];
 
        _FaceVlace.textColor = [UIColor blackColor];
        [self addSubview:_FaceVlace];
        self.FaceVlace = _FaceVlace;
        
        _LastStep = [UIButton buttonWithType:UIButtonTypeCustom];
        _LastStep.frame = CGRectMake(AlertViewJianGe + 50, 180, AlertViewJianGe +80, 30);
        _LastStep.backgroundColor = [UIColor colorWithRed:248/255.0 green:124/255.0 blue:19/255.0 alpha:1];
        [_LastStep setTitle:@"上一步" forState:UIControlStateNormal];
        [_LastStep setTintColor:[UIColor whiteColor]];
        [_LastStep addTarget:self action:@selector(laststep:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_LastStep];
        self.LastStep = _LastStep;
        
       _Confirm = [UIButton buttonWithType:UIButtonTypeCustom];
        _Confirm.frame = CGRectMake(AlertViewJianGe * 2 + 180 , 180, AlertViewJianGe + 80, 30);
        _Confirm.backgroundColor = [UIColor colorWithRed:248/255.0 green:124/255.0 blue:19/255.0 alpha:1];
        [_Confirm setTitle:@"确认充值" forState:UIControlStateNormal];
        [_Confirm setTintColor:[UIColor whiteColor]];
        [_Confirm addTarget:self action:@selector(Yes:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_Confirm];
        self.Confirm = _Confirm;
        
    }
    return self;
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




-(void)laststep:(UIButton *)sender
{
    
   
                self.transform = CGAffineTransformScale(self.transform,0,0);
                __weak RechargeView *weakSelf = self;
                [UIView animateWithDuration:.3 animations:^{
                    weakSelf.transform = CGAffineTransformScale(weakSelf.transform,1.2,1.2);
                    [self.bGView removeFromSuperview];
                    
                } completion:^(BOOL finished) {

                }];
}

-(void)Yes:(UIButton *)sender
{
    
    NSString *str1 = @"card";
    NSString *str2 = @"efood7";
    
    NSString *string = [str1 stringByAppendingString:str2];
    NSLog(@"%@", string);
    
    long long tim = [self getDateTimeTOMilliSeconds:[NSDate date]];
    
    _time = [NSString stringWithFormat:@"%llu",tim];
    NSString *str =[NSString stringWithFormat:@"%llu%@",tim,string];
    
    
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest );
    
    _outup = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {[_outup appendFormat:@"%02X", digest[i]];}
  
    
    NSString *appSign = [[NSUserDefaults standardUserDefaults]objectForKey:@"Shop_Web_AppSign"];
    NSString *memLoginId = [[NSUserDefaults standardUserDefaults]objectForKey:@"Shop_Login_Name"];
    
    
    
    //获取用户信息
    
    NSString *appsign = [[NSUserDefaults standardUserDefaults]objectForKey:@"Shop_Web_AppSign"];
    NSString *memLoginID = [[NSUserDefaults standardUserDefaults]objectForKey:@"Shop_Login_Name"];
    
    NSLog(@"shop_web_appsign===================%@  memLoginId=====================%@",appsign,memLoginID);
    
    
    NSLog(@"shop_web_appsign==========————11111111———=========%@  memLoginId===========————111———==========%@",appsign,memLoginID);
    NSDictionary *caidy = [NSDictionary dictionaryWithObjectsAndKeys:
                           appsign,@"Appsign",
                           memLoginID,@"MemLoginID",
                           nil];
    [[AFAppAPIClient sharedClient]getPath:kWebAccountInfoPath parameters:caidy success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"responseObject====——————————==%@",responseObject);
        _userId = responseObject[@"AccoutInfo"][@"ID"];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"------------====--------=====--------------error=%@",error);
    }];
    

    
    if (_cardAmount==500) {
      
        _key = @"c4a1f5c18fcd32a9";
    }
    else if (_cardAmount==1000)
    {
    
        _key = @"e44020604c7373fb";
    }
    else if (_cardAmount==2000)
    {
        
        _key = @"40c8655ca08866b7";
    }
    else if (_cardAmount==3000)
    {
        
        _key = @"a2344dab5bc83cdc";
    }
    else if (_cardAmount==5000)
    {
        
        _key = @"2594be86502d52be";
    }
    
    NSString *cardNo = _cardNumber;
   
    NSString *passWord = [[NSUserDefaults standardUserDefaults]objectForKey:@"Shop_Login_Password"];
    NSMutableString *pwd = [NSMutableString stringWithCapacity:0];
    
    for (int i=0; i<passWord.length; i++) {
        
        char a = [passWord characterAtIndex:i];
        NSArray *arr1=@[@",",@".",@"/",@"-",@" ",@":",@"=",@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z"];
        NSArray *arr2=@[ @",",@"%",@"/",@"-",@" ",@":",@"0",@"d",@"4",@"I",@"E",@"=",@"7",@"5",@"6",@"s",@"y",@"D",@"x",@"F",@"w",@"G",@"h",@"J",@"K",@"2",@"3",@"L",@"M",@"c",@"e",@"Q",@"f",@"g",@"O",@"j",@"l",@"N",@"i",@"p",@"P",@"k",@"T",@"a",@"H",@"W",@"n",@"X",@"Y",@"1",@"U",@"Z",@"b",@"m",@"o",@"q",@"r",@"8",@"B",@"9",@"R",@"S",@"C",@"t",@"u",@"A",@"v",@"V",@"z"];
        for (int j=0; j<[arr1 count]; j++) {
            char  b= [arr1[j] characterAtIndex:0];
            if (a==b) {
                a=[arr2[j] characterAtIndex:0];
                break;
            }
            else
            {
                a=a;
            }
            
        }
        
        [pwd appendFormat:@"%c",a];
    }
  
    //NSString *pwd=@"IHIXy6ydyWYn6saad6Wd7I=W4Y4H=d=W";
   NSLog(@"----------------------------1234567899023445678788=%@ %@ %@ %@ %@ %@ ",appSign,memLoginId,_userId,_key,cardNo,pwd);
    
    
    
    _account = [NSString stringWithFormat:@"%ld",_cardAmount];
    NSLog(@"cardNumber==========%@ faceValue==========%@ cardPass==============%@  time=====================%@ validation============%@",_cardNumber,_account,_cardPass,_time,_outup);
    
   
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:_account,@"amount",
                                                                        _cardNumber,@"cardCode",
                                                                        _cardPass,@"password",_time,@"time",_outup,@"validation",
                                                                        nil];
        
        [[AFAppAPIClient sharedClient] getPath:kWebAppUseCardMoneyUrl parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            ///购物卡消费
            NSLog(@"--------------------------============----------------------responseObject=%@",responseObject);
            NSInteger code = [responseObject[@"result"]integerValue];
            NSString *message = responseObject[@"message"];
            
            if (code==1) {
               // [MBProgressHUD showSuccess:@"充值成功"];
  //------------------------------- 给账户余额充值--------------------
                NSLog(@"----------------------------1234567899023445678788=%@ %@ %@ %@ %@ %@ ",appSign,memLoginId,_userId,_key,cardNo,pwd);

                NSDictionary *rechargeDict = [NSDictionary dictionaryWithObjectsAndKeys:appSign,@"appSign",
                                              memLoginId,@"memLoginId",
                                              _userId,@"id",_key,@"key",cardNo,@"cardNo",pwd,@"pwd",
                                              nil];

               [[AFAppAPIClient sharedClient]postPath:@"api/Recharge/" parameters:rechargeDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
                   
                   NSLog(@"--------------------------------&&&&&&&&&&&&&&&&&=%@",responseObject);
                   //[MBProgressHUD showSuccess:@"充值成功"];
                   
                   [MBProgressHUD showSuccess:@"充值成功"];
                   self.transform = CGAffineTransformScale(self.transform,0,0);
                   __weak RechargeView *weakSelf = self;
                   [UIView animateWithDuration:.3 animations:^{
                       weakSelf.transform = CGAffineTransformScale(weakSelf.transform,1.2,1.2);
                       [self.bGView removeFromSuperview];
                       
                   } completion:^(BOOL finished) {
                       
                   }];

                   
                   
               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   NSLog(@"error =%@",error);
               }];
                
                
                
            }
            else if (code==0&&[message isEqualToString:@"消费金额不能为0"]){
                
                [MBProgressHUD showSuccess:@"消费金额不能为0"];
            }

            else if (code==0&&[message isEqualToString:@"该卡未在使用期内，不能使用"]){
                
                [MBProgressHUD showSuccess:@"该卡未在使用期内，不能使用"];
            }
            else if (code==0&&[message isEqualToString:@"该卡还未激活，不能使用"]){
                
                [MBProgressHUD showSuccess:@"该卡还未激活，不能使用"];
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"------------====--------=====--------------error=%@",error);
        }];

       
        
    });
}


@end
