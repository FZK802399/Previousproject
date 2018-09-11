//
//  TransferSuccess.m
//  ShopNum1V3.1
//
//  Created by 森泓投资 on 16/7/13.
//  Copyright © 2016年 WFS. All rights reserved.
//

#import "TransferSuccess.h"
#import "MBProgressHUD+LZ.h"
#import "CardInformationVC.h"
#import "CardNumberItem.h"
#import "AFNetworking.h"
#import "WXUtil.h"

#define MAINSCREENwidth   [UIScreen mainScreen].bounds.size.width
#define MAINSCREENheight  [UIScreen mainScreen].bounds.size.height
#define WINDOWFirst        [[[UIApplication sharedApplication] windows] firstObject]
#define RGBa(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define AlertViewJianGe 19.5

@interface TransferSuccess ()

@property (nonatomic ,assign ) NSString *numbers;
@property (nonatomic,strong)NSString *time;
@property (nonatomic,strong)NSMutableString *outup;
@property (nonatomic,strong)NSString *tim;
@property (nonatomic,strong)NSMutableString *outu;
@property (nonatomic,strong)NSString *userId;
@property (nonatomic,strong)NSString *myId;

@end

@implementation TransferSuccess

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
            self.bGView = view;
        }
        
        self.center = CGPointMake(MAINSCREENwidth/2, MAINSCREENheight/2);
        self.bounds = CGRectMake(0, 0, MAINSCREENwidth, AlertViewHeight);
        [WINDOWFirst addSubview:self];
        
        UILabel *BoxTop = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, MAINSCREENwidth-2*AlertViewJianGe, 30)];
        BoxTop.backgroundColor = [UIColor colorWithWhite:0.956 alpha:1.000];
        BoxTop.textAlignment = NSTextAlignmentCenter;
        BoxTop.text = @"转赠";
        [self addSubview:BoxTop];
        
        UIView *middleView = [[UIView alloc] initWithFrame:CGRectMake(20, 29, MAINSCREENwidth-2*AlertViewJianGe, 200)];
        middleView.backgroundColor = [UIColor whiteColor];
        [self addSubview:middleView];
        
        UILabel *MembershipCardNumber = [[UILabel alloc] init];
        MembershipCardNumber.frame = CGRectMake(30, 50, BoxTop.frame.size.width, 20);
        //MembershipCardNumber.text = @"卡号：a111";
        MembershipCardNumber.font = [UIFont systemFontOfSize:15];
       
        MembershipCardNumber.textColor = [UIColor blackColor];
        [self addSubview:MembershipCardNumber];
        self.MembershipCardNumber = MembershipCardNumber;
        
        UILabel *FaceVlace = [[UILabel alloc] init];
        FaceVlace.frame = CGRectMake(30, 80, BoxTop.frame.size.width, 20);
        //FaceVlace.text = @"面值：1000 ";
        FaceVlace.font = [UIFont systemFontOfSize:15];
       
        FaceVlace.textColor = [UIColor blackColor];
        [self addSubview:FaceVlace];
        self.FaceVlace = FaceVlace;
        
        //转赠方
        UILabel *DonationParty = [[UILabel alloc] init];
        DonationParty.frame = CGRectMake(30, 110, BoxTop.frame.size.width, 20);
        //DonationParty.text = @"收卡方：1812345678";
        DonationParty.font = [UIFont systemFontOfSize:15];
      
        DonationParty.textColor = [UIColor blackColor];
        [self addSubview:DonationParty];
        self.DonationParty = DonationParty;
        
        //收卡方
        UILabel *CardReceivingParty = [[UILabel alloc] init];
        CardReceivingParty.frame = CGRectMake(30, 130, BoxTop.frame.size.width, 20);
        //CardReceivingParty.text = @"赠卡方：12365478";
        CardReceivingParty.font = [UIFont systemFontOfSize:15];
     
        CardReceivingParty.textColor = [UIColor blackColor];
        [self addSubview:CardReceivingParty];
        self.CardReceivingParty = CardReceivingParty;
        
        UIButton *LastStep = [UIButton buttonWithType:UIButtonTypeCustom];
        LastStep.frame = CGRectMake(AlertViewJianGe + 50, 180, AlertViewJianGe +80, 30);
        LastStep.backgroundColor = [UIColor colorWithRed:248/255.0 green:124/255.0 blue:19/255.0 alpha:1];
        [LastStep setTitle:@"上一步" forState:UIControlStateNormal];
        [LastStep setTintColor:[UIColor whiteColor]];
        [LastStep addTarget:self action:@selector(laststep:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:LastStep];
        self.LastStep = LastStep;
        
        UIButton *Confirm = [UIButton buttonWithType:UIButtonTypeCustom];
        Confirm.frame = CGRectMake(AlertViewJianGe * 2 + 180 , 180, AlertViewJianGe + 80, 30);
        Confirm.backgroundColor = [UIColor colorWithRed:248/255.0 green:124/255.0 blue:19/255.0 alpha:1];
        [Confirm setTitle:@"确认转赠" forState:UIControlStateNormal];
        [Confirm setTintColor:[UIColor whiteColor]];
        [Confirm addTarget:self action:@selector(yes:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:Confirm];
        self.Confirm = Confirm;
        
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
    __weak TransferSuccess *weakSelf = self;
    [UIView animateWithDuration:.3 animations:^{
        weakSelf.transform = CGAffineTransformScale(weakSelf.transform,1.2,1.2);
        [self.bGView removeFromSuperview];
        
    } completion:^(BOOL finished) {
    
    }];
}

-(void)yes:(UIButton *)sender
{
    
    
    NSLog(@"------1111111-----=%@  ----22222-----=%@, -----3333-----=%@ ------44444-------=%@",_cardCode,_amount,_receive,_sender);
    
    
    NSString *appsign = [[NSUserDefaults standardUserDefaults]objectForKey:@"Shop_Web_AppSign"];
    
    NSLog(@"shop_web_appsign==========--------11111111-------=========%@  memLoginId===========--------111-------==========%@",appsign,_receive);
    NSDictionary *caidy = [NSDictionary dictionaryWithObjectsAndKeys:
                           appsign,@"Appsign",
                           _receive,@"MemLoginID",
                           nil];
    [[AFAppAPIClient sharedClient]getPath:kWebAccountInfoPath parameters:caidy success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"------------------------------%@",responseObject);
        NSString *account = responseObject[@"AccoutInfo"];
      
        if ([account isEqual:[NSNull null]]) {
            
            
            
            
            NSString *appsign = [[NSUserDefaults standardUserDefaults]objectForKey:@"Shop_Web_AppSign"];
            NSString *memLoginID = [[NSUserDefaults standardUserDefaults]objectForKey:@"Shop_Login_Name"];
            
            NSDictionary *dudu = [NSDictionary dictionaryWithObjectsAndKeys:
                                   appsign,@"Appsign",
                                   memLoginID,@"MemLoginID",
                                   nil];
            [[AFAppAPIClient sharedClient]getPath:kWebAccountInfoPath parameters:dudu success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
               
                _myId = responseObject[@"AccoutInfo"][@"ID"];
               
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
                
                
                NSLog(@"--------memLoginID=%@---appsign=%@----id=%@------cardNo=%@-------giveLoginId=%@--------pwd=%@------",memLoginID,appsign,_myId,_cardCode,_receive,pwd);
                
                NSDictionary *userDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                      appsign,@"appSign",
                                      memLoginID,@"memLoginId",_myId,@"id",_cardCode,@"cardNo",_receive,@"giveLoginId",pwd,@"pwd",
                                      nil];

                [[AFAppAPIClient sharedClient]postPath:kWebAppGiveCard parameters:userDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    //
                    NSLog(@"-----------responseObject=%@-------------",responseObject);
                    NSInteger info = [responseObject[@"return"]integerValue];
                    NSString *errorCode = responseObject[@"ErrorCode"];
                    if (info==202) {
                        
                        NSString *str1 = @"card";
                        NSString *str2 = @"efood7";
                        
                        NSString *string = [str1 stringByAppendingString:str2];
                        NSLog(@"%@", string);
                        
                        
                        
                        
                        long long tim = [self getDateTimeTOMilliSeconds:[NSDate date]];
                        NSLog(@"===============================----------------=============%llu",tim);
                        
                        
                        _tim = [NSString stringWithFormat:@"%llu",tim];
                        NSString *str =[NSString stringWithFormat:@"%llu%@",tim,string];
                        NSLog(@"md5====str==========%@",str);
                        
                        
                        const char *cStr = [str UTF8String];
                        unsigned char digest[CC_MD5_DIGEST_LENGTH];
                        CC_MD5( cStr, (unsigned int)strlen(cStr), digest );
                        
                        _outu = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
                        
                        for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
                        {[_outu appendFormat:@"%02X", digest[i]];}
                        
                        NSLog(@"output=======%@",_outu);
                        

                        
                        NSDictionary *caidy = [NSDictionary dictionaryWithObjectsAndKeys:
                                               _cardCode,@"cardCode",
                                               _pass,@"password",@"-1000",@"userId",
                                               _tim,@"time",_outu,@"validation",
                                               nil];
                        
                        
                        [[AFAppAPIClient sharedClient]getPath:kWebAppBindingCardUrl parameters:caidy success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            
                            NSLog(@"responseObject====---------------------==%@",responseObject);
                            NSInteger code = [responseObject[@"result"]integerValue];
                            NSString *message = responseObject[@"message"];
                            
                            if (code==1) {
                                
                                NSDictionary *caidy = [NSDictionary dictionaryWithObjectsAndKeys:
                                                       _receive,@"mobile",
                                                       @"有人给你送卡了，快去注册领取吧",@"message",
                                                       nil];

                                
                                [[AFAppAPIClient sharedClient]getPath:KWebSend parameters:caidy success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    
                                    
                                    NSLog(@"-----消息有没发----respon-=%@",responseObject);
                                    NSInteger code = [responseObject[@"Data"]integerValue];
                                    
                                    if (code!=0){
                                        [MBProgressHUD showSuccess:@"用户尚未注册,已发送短信通知"];
                                        self.transform = CGAffineTransformScale(self.transform,0,0);
                                        __weak TransferSuccess *weakSelf = self;
                                        [UIView animateWithDuration:.3 animations:^{
                                            weakSelf.transform = CGAffineTransformScale(weakSelf.transform,1.2,1.2);
                                            [self.bGView removeFromSuperview];
                                            
                                        } completion:^(BOOL finished) {
                                            
                                        }];
                                        if (self.delegate&&[self.delegate respondsToSelector:@selector(transferSuccessHidden)]) {
                                            [self.delegate transferSuccessHidden];
                                        }

                                    
                                    }
                                    
                                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    
                                }];
                                
                                
                                
                            }
                            else if (code==0&&[message isEqualToString:@"该卡号已经被绑定"]){
                                
                               
                            }
                            else if (code==0&&[message isEqualToString:@"密码不能为空"]){
                                
                                
                            }
                            else if (code==0&&[message isEqualToString:@"卡号不能为空"]){
                                
                                                            }
                            else if (code==0&&[message isEqualToString:@"卡号或者密码错误"]){
                                
                                
                            }
                            
                            else if (code==0&&[message isEqualToString:@"绑定失败"]){
                                
                                                           }
                            
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            
                            
                            NSLog(@"error=====------====----------------------------------------===%@",error);
                            
                        }];
                        
                
                        
                    }
                    else if ([errorCode isEqualToString:@"106"])
                    {
                    
                        [MBProgressHUD showSuccess:@"赠送用户名不能为空"];
                        self.transform = CGAffineTransformScale(self.transform,0,0);
                        __weak TransferSuccess *weakSelf = self;
                        [UIView animateWithDuration:.3 animations:^{
                            weakSelf.transform = CGAffineTransformScale(weakSelf.transform,1.2,1.2);
                            [self.bGView removeFromSuperview];
                            
                        } completion:^(BOOL finished) {
                            
                        }];
                        if (self.delegate&&[self.delegate respondsToSelector:@selector(transferSuccessHidden)]) {
                            [self.delegate transferSuccessHidden];
                        }

                    
                    }
                    
                    else if ([errorCode isEqualToString:@"该卡已过期"])
                    {
                        
                        [MBProgressHUD showSuccess:@"该卡已过期"];
                        self.transform = CGAffineTransformScale(self.transform,0,0);
                        __weak TransferSuccess *weakSelf = self;
                        [UIView animateWithDuration:.3 animations:^{
                            weakSelf.transform = CGAffineTransformScale(weakSelf.transform,1.2,1.2);
                            [self.bGView removeFromSuperview];
                            
                        } completion:^(BOOL finished) {
                            
                        }];
                        if (self.delegate&&[self.delegate respondsToSelector:@selector(transferSuccessHidden)]) {
                            [self.delegate transferSuccessHidden];
                        }
                        
                        
                    }
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    //
                    
                    
                     NSLog(@"-----------error=%@-------------",error);
                    
                }];
                
                
                
                
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                NSLog(@"------------====--------=====--------------error=%@",error);
                
            }];
            
         
            
            
            
            
            
            
            
            
            
            
          
            
        }
        else {
             _userId = responseObject[@"AccoutInfo"][@"ID"];
        NSLog(@"sendUserId==---------==---------------------==%@",_userId);
        
        
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
        
        
        NSLog(@"--------1111=%@     ------------22222222=%@   ---------3333=%@   -------44444=%@",_cardCode,_userId,_time,_outup);
        NSDictionary *caidy = [NSDictionary dictionaryWithObjectsAndKeys:
                               _cardCode,@"cardCode",
                               _userId,@"userId",
                               _time,@"time",_outup,@"validation",
                               nil];
        
        
        [[AFAppAPIClient sharedClient]getPath:kWebAppBindingCardUrl parameters:caidy success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"responseObject====---------------------==%@",responseObject);
            NSInteger code = [responseObject[@"result"]integerValue];
            NSString *message = responseObject[@"message"];
            
            if (code==1) {
                [MBProgressHUD showSuccess:@"转赠成功"];
                self.transform = CGAffineTransformScale(self.transform,0,0);
                __weak TransferSuccess *weakSelf = self;
                [UIView animateWithDuration:.3 animations:^{
                    weakSelf.transform = CGAffineTransformScale(weakSelf.transform,1.2,1.2);
                    [self.bGView removeFromSuperview];
                    
                } completion:^(BOOL finished) {
                    
                }];
                if (self.delegate&&[self.delegate respondsToSelector:@selector(transferSuccessHidden)]) {
                    [self.delegate transferSuccessHidden];
                }
                
                
            }

            else if (code==0&&[message isEqualToString:@"该卡号已经被绑定"]){
                
                [MBProgressHUD showSuccess:@"该卡号已经被绑定"];
            }
            else if (code==0&&[message isEqualToString:@"密码不能为空"]){
                
                [MBProgressHUD showSuccess:@"密码不能为空"];
            }
            else if (code==0&&[message isEqualToString:@"卡号不能为空"]){
                
                [MBProgressHUD showSuccess:@"卡号不能为空"];
            }
            else if (code==0&&[message isEqualToString:@"卡号或者密码错误"]){
                
                [MBProgressHUD showSuccess:@"卡号或者密码错误"];
            }
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            
            NSLog(@"error=====------====----------------------------------------===%@",error);
            
        }];

        }
       
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        NSLog(@"error=====------====----------------------------------------===%@",error);
        
        
        
    }];
    
    


//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:_amount,@"amount",
//                              _cardNumber,@"cardCode",
//                              _cardPass,@"password",_time,@"time",_outup,@"validation",
//                              nil];
//        
//        [[AFAppAPIClient sharedClient] getPath:kWebAppUseCardMoneyUrl parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            
//            ///购物卡
//            NSLog(@"--------------------------============----------------------responseObject=%@",responseObject);
//            NSInteger code = [responseObject[@"result"]integerValue];
//            //NSString *message = responseObject[@"message"];
//            
//            if (code==1) {
//                [MBProgressHUD showSuccess:@"充值成功"];
//            }
//            else if (code==0){
//                
//                [MBProgressHUD showSuccess:@"充值失败"];
//            }
//            
//            
//            
//            
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"------------====--------=====--------------error=%@",error);
//        }];
//        
//        
//        [MBProgressHUD showSuccess:@"充值成功"];
//    });
}

@end
