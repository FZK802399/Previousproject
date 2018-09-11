//
//  InputCardNumberVC.m
//  ShopNum1V3.1
//
//  Created by 森泓投资 on 16/7/8.
//  Copyright © 2016年 WFS. All rights reserved.
//

#import "InputCardNumberVC.h"
#import "MembershipCardTV.h"
#import "UIView+Frame.h"
#import "LZButton.h"
#import "SecondHeaderView.h"
#import "MBProgressHUD+LZ.h"
#import "AFNetworking.h"
#import "CardInformationVC.h"
#import "CardNumberItem.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "WXUtil.h"
#import "UserInfoModel.h"

@interface InputCardNumberVC ()
//会员卡号
@property (weak, nonatomic) UITextField *MembershipCardNumber;
//会员密码
@property (weak, nonatomic) UITextField *MemberPassWord;
//验证卡号
@property (weak, nonatomic) UIButton *Verification;
//注意事项
@property (weak, nonatomic) UIButton *BeCareful;
//上方的绿色横线
@property (weak, nonatomic) UIView *GreenBarTop;
//下方的绿色横线
@property (weak, nonatomic) UIView *GreenBarBottom;
//卡号数据
@property (nonatomic ,strong) NSArray *cardCodes;
//密码数据
@property (nonatomic ,strong) NSArray *password;


@property (nonatomic,strong)NSString *time;
@property (nonatomic,strong)NSMutableString *outup;
@property (nonatomic,strong)NSString *userId;

@property (nonatomic,strong)NSString *pwd;

@property (strong, nonatomic) UITextField *LoginNameTextfield;
@property (strong, nonatomic) UITextField *PasswordTextField;
@end

@implementation InputCardNumberVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpViewFrame];
    
    
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
    

 
}

-(void)setUpViewFrame
{
 
    _LoginNameTextfield = [[UITextField alloc] initWithFrame:CGRectMake(30, 109, SCREEN_WIDTH - 60, 40)];
    _LoginNameTextfield.tintColor = [UIColor grayColor];
    _LoginNameTextfield.placeholder = @"请输入会员卡卡号";
    [self.view addSubview:_LoginNameTextfield];
    
    _PasswordTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, 155, SCREEN_WIDTH - 60, 40)];
    _PasswordTextField.tintColor = [UIColor grayColor];
    _PasswordTextField.secureTextEntry = YES;
    _PasswordTextField.placeholder = @"请输入会员卡密码";
    [self.view addSubview:_PasswordTextField];
    
    UIButton *Verification = [UIButton buttonWithType:UIButtonTypeSystem];
    Verification.frame = CGRectMake(30, 221, [UIScreen mainScreen].bounds.size.width - 60, 40);
    Verification.titleLabel.font = [UIFont systemFontOfSize:15];
    [Verification setTitle:@"验证该卡" forState:UIControlStateNormal];
    [Verification setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [Verification.layer setMasksToBounds:YES];
    [Verification.layer setCornerRadius:5.0f];
    Verification.backgroundColor = [UIColor colorWithRed:61/255.0 green:163/255.0 blue:171/255.0 alpha:1.000];
    [Verification addTarget:self action:@selector(VerificationCardNumber) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Verification];
    
    UIButton *BeCareful = [UIButton buttonWithType:UIButtonTypeCustom];
    BeCareful.frame = CGRectMake(30, 270, 60, 30);
    BeCareful.titleLabel.font = [UIFont systemFontOfSize:13];
    [BeCareful setTitle:@"注意事项:" forState:UIControlStateNormal];
    [BeCareful setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.view addSubview:BeCareful];

    
    UIView *GreenBarTop = [[UIView alloc]initWithFrame:CGRectMake(30, 150, SCREEN_WIDTH - 60, 1)];
    GreenBarTop.backgroundColor = [UIColor colorWithRed:61/255.0 green:163/255.0 blue:171/255.0 alpha:1.000];
    [self.view addSubview:GreenBarTop];
    
    UIView *GreenBarBottom = [[UIView alloc] initWithFrame:CGRectMake(30, 195, SCREEN_WIDTH - 60, 1)];
    GreenBarBottom.backgroundColor = [UIColor colorWithRed:61/255.0 green:163/255.0 blue:171/255.0 alpha:1.000];
    [self.view addSubview:GreenBarBottom];

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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



-(void)VerificationCardNumber
{
  
    
    
    // Shop_Login_User_Url_Str Shop_Login_User_First_Run  Shop_Login_User_MemberRank  Shop_Login_User_Score

    
    
//       NSString *sdd = [[NSUserDefaults standardUserDefaults]objectForKey:@"Shop_Web_AppSign"];
//       NSLog(@"FRGFRTFHBGFGDGSDFDGFGSDFGDSGD===============%@",sdd);
//       
//    _userId= [[NSUserDefaults standardUserDefaults]objectForKey:@"Shop_Login_User_Guid"];
//    NSLog(@"11111111=%@222222=%@3333333=%@44444=%@5555555=%@",_LoginNameTextfield.text,_PasswordTextField.text,_outup,_userId,_time);

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
        
        NSLog(@"userId==————==——————————==%@",_userId);
    
    
        //_pwd = ApplicationDelegate.loginDic[@"pwd"];
        
        NSLog(@"userId=======================================================%@ &&&&& %@",_userId,_pwd);
   
    

//http://192.168.3.134/api/accountget/?AppSign=044de1e47eb20ef387adfd6d89d254da&MemLoginID=15821042423
    
       
    
    
    NSLog(@"！！！！！！！！！！！！=========================================%@%@%@%@%@",_LoginNameTextfield.text, _PasswordTextField.text,_userId,_time,_outup);
    
 //------------------------------------------生成卡-------------------------------------
    
//    
//    NSDictionary *caidy = [NSDictionary dictionaryWithObjectsAndKeys:
//                                                      @"1",@"numbers",
//                                                      @"500",@"amount",
//                                                      _time,@"time",_outup,@"validation",
//                                                      nil];
//[[AFAppAPIClient sharedClient]getPath:kWebAppGetVirtualCardsUrl parameters:caidy success:^(AFHTTPRequestOperation *operation, id responseObject) {
//    NSLog(@"----DDDD=============%@",responseObject);
//} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//    NSLog(@"error=%@",error);
//}];
    
    
  //-----------------------------------------绑定卡-------------------------------------
  
    NSDictionary *caidy = [NSDictionary dictionaryWithObjectsAndKeys:
                           _LoginNameTextfield.text,@"cardCode",
                           _PasswordTextField.text,@"password",_userId,@"userId",
                           _time,@"time",_outup,@"validation",
                           nil];
    
    
    [[AFAppAPIClient sharedClient]getPath:kWebAppBindingCardUrl parameters:caidy success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSLog(@"responseObject====---------------------==%@",responseObject);
        NSInteger code = [responseObject[@"result"]integerValue];
        NSString *message = responseObject[@"message"];
        
        if (code==1) {
            [MBProgressHUD showSuccess:@"验证成功"];
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
        
        else if (code==0&&[message isEqualToString:@"绑定失败"]){
            
            [MBProgressHUD showSuccess:@"绑定失败"];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        NSLog(@"error=====------====----------------------------------------===%@",error);
        
    }];
    
    
    
    
    
    
//--------------------------------------------------激活卡----------------------------
  
//    NSDictionary *caidy = [NSDictionary dictionaryWithObjectsAndKeys:
//                           @"0500ST17273141",@"cardCode",_time,@"time",_outup,@"validation",
//                           nil];
//
//   
//    [[AFAppAPIClient sharedClient]getPath:kWebAppActiveCard parameters:caidy success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        
//        NSLog(@"-----------------------------------respon = %@",responseObject);
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];


//
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        NSLog(@"error=====------====----------------------------------------===%@",error);
        
    }];
    



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
