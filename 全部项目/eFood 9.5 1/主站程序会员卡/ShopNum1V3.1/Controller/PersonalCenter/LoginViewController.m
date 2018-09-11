//
//  LoginViewController.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-18.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "LoginViewController.h"
#import "ZJSwitch.h"
#import "UserInfoModel.h"
#import "RegisterViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "EMIMHelper.h"
#import "HKCountryChangController.h"
#import "HKCountry.h"


@interface LoginViewController ()<CountryChangControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *countryNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryCodeLabel;

@end

@implementation LoginViewController

@synthesize FatherViewType;

+ (instancetype) create{
    return [[UIStoryboard storyboardWithName:@"StoryboardIOS7" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];
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
    
    [self.navigationController setNavigationBarHidden:NO];
//    [self.tabBarController.tabBar setHidden:YES];
    self.nameImageBG.layer.borderWidth = 1;
    self.nameImageBG.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
    
    self.PWDImageBG.layer.borderWidth = 1;
    self.PWDImageBG.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
    
    [self loadLeftBackBtn];
//    [self loadRightBtn];
    
    CGFloat orgineY = 62;
    orgineY = [self MatchIOS7:orgineY];
    
    ZJSwitch * switchBtn = [[ZJSwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 66, orgineY, 60, 32)];
    [switchBtn setOnText:@"abc"];
    [switchBtn setOffText:@"***"];
    [switchBtn setOnTintColor:[UIColor barTitleColor]];
    [switchBtn addTarget:self action:@selector(switchBtnChangeValue:) forControlEvents:UIControlEventValueChanged];
//    [self.view addSubview:switchBtn];
    
//    self.PasswordTextField.rightView = switchBtn;
//    self.PasswordTextField.rightViewMode = UITextFieldViewModeAlways;
    
    QCheckBox * autoLoginbtn = [[QCheckBox alloc] initWithDelegate:self];
    autoLoginbtn.frame = CGRectMake(10, orgineY + 50, 103, 25);
    [autoLoginbtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [autoLoginbtn setTitle:@"自动登录" forState:UIControlStateNormal];
    [autoLoginbtn setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
    autoLoginbtn.checked = YES;
//    [self.view addSubview:autoLoginbtn];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyboard)];
    [self.view addGestureRecognizer:tap];
    [self.PasswordTextField setSecureTextEntry:YES];
    // Do any additional setup after loading the view.
    
    self.loginButton.layer.cornerRadius = 3.0f;
}


- (void)loadLeftBackBtn {
    
    UIImage * backImage = [UIImage imageNamed:@"back"];
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, backImage.size.width, backImage.size.height);
    [backBtn setBackgroundImage:backImage forState:UIControlStateNormal];
    //    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [backBtn addTarget:self action:self.presentingViewController ? @selector(dismiss) : @selector(back) forControlEvents:UIControlEventTouchUpInside];
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
    }else{
        negativeSpacer.width = 0;
    }
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, barBtnItem, nil];
    //    self.navigationItem.leftBarButtonItem = barBtnItem;
}

- (void)back{
    [self.appConfig loadConfig];
    [self.navigationController popViewControllerAnimated:YES];
    if(![self.appConfig isLogin]){
        [UIHelper gotoTabbar:0];
    }
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
    if(![self.appConfig isLogin]){
        [UIHelper gotoTabbar:0];
    }
}

-(void)loadRightBtn {
    UIButton * registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame = CGRectMake(0, 0, 71, 33);
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:registerBtn];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    /**
     *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-5时，间距正好调整
     *  为0；width为正数时，正好相反，相当于往左移动width数值个像素
     */
    if (kCurrentSystemVersion >= 7.0) {
        negativeSpacer.width = -20;
    }else{
        negativeSpacer.width = -10;
    }
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, barBtnItem, nil];
    
    
//    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(registerBtnClick:)];
//    self.navigationItem.rightBarButtonItem = rightBtn;

}

- (void)resignKeyboard {
    [self.LoginNameTextfield resignFirstResponder];
    [self.PasswordTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

-(void)switchBtnChangeValue:(id)sender{
    ZJSwitch * tempBtn = (ZJSwitch *)sender;
    if (tempBtn.on) {
        [self.PasswordTextField setSecureTextEntry:NO];
    } else {
        [self.PasswordTextField setSecureTextEntry:YES];
    }

}

- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked{
    if (checked) {
    }
}


-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSMutableString *text = [NSMutableString stringWithString:textField.text];
    [text replaceCharactersInRange:range withString:string];
    return [text length] <= 30;
} 



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    RegisterViewController * rvc = [segue destinationViewController];
    if ([segue.identifier isEqualToString:kSegueLoginToResigter]) {
        if ([rvc respondsToSelector:@selector(setRegisterViewType:)]) {
            rvc.registerViewType = self.FatherViewType;
        }
    }else if([segue.identifier isEqualToString:@"loginToCountryChang"]){
        HKCountryChangController *countryChangVc = [segue destinationViewController];
        countryChangVc.delegate = self;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

-(void)countryChangController:(HKCountryChangController *)countryChangVc didFinishedSelectCountry:(HKCountry *)country
{
    //    NSLog(@"快成功了");
    self.countryCodeLabel.text = country.Code;
    self.countryNameLabel.text = country.country;
}


- (IBAction)registerBtnClick:(id)sender {
    [self performSegueWithIdentifier:kSegueLoginToResigter sender:self];
}

- (IBAction)forgetPwd:(id)sender {
    [self performSegueWithIdentifier:@"kSegueForgetPwd" sender:self];
}

- (IBAction)loginBtnClick:(id)sender {
//    [self thirdPartyLoginWithID:@"346687963" loginType:@"0"];
    
    if (allTrim(self.LoginNameTextfield.text).length == 0) {
        [self showAlertWithMessage:@"请先输入用户名"];
        return;
    }
    
    if (allTrim(self.PasswordTextField.text).length == 0) {
        [self showAlertWithMessage:@"请先输入密码"];
        return;
    }
    
    //显示指示器
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.labelText = @"正在加载中...";
//    hud.dimBackground = YES; //背景灰色颜色
    
    [self.appConfig loadConfig];
    if (self.LoginNameTextfield.text.length > 0 && self.PasswordTextField.text.length > 0) {
        
        NSDictionary * nameDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                  allTrim(self.LoginNameTextfield.text),@"MemLoginID",
                                  kWebAppSign, @"AppSign",
                                  nil];
        [UserInfoModel userNameIsExistByParamer:nameDic andblocks:^(bool isExist, NSError *error) {
            if (error) {
                [self showAlertWithMessage:@"网络错误"];
            }else {
                if (!isExist) {
                    [self showAlertWithMessage:@"用户名不存在"];
                    return;
                }else{
                    NSDictionary * loginDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                               allTrim(self.LoginNameTextfield.text),@"MemLoginID",
                                               allTrim(self.PasswordTextField.text), @"Pwd",
                                               allTrim(self.countryCodeLabel.text),@"MobileCountryCode",//新加区号
                                               kWebAppSign, @"AppSign",nil];
                    [UserInfoModel userLoginByParamer:loginDic andblocks:^(NSInteger result, NSError *error) {
                        if(error){
                            
                            [TSMessage showNotificationWithTitle:NSLocalizedString(@"获取信息错误，点击屏幕重新加载", nil)
                                                        subtitle:NSLocalizedString(@"网络连接失败，请检查网络设置", nil)
                                                            type:TSMessageNotificationTypeError];
                            
                        }else{
                            if (result == 202) {
                                
                                [self.appConfig loadConfig];
                                self.appConfig.loginName = allTrim(self.LoginNameTextfield.text);
                                self.appConfig.loginPwd = allTrim(self.PasswordTextField.text);
                               
                                [self.appConfig saveConfig];
                                [self loadUserScore];
                                switch (self.FatherViewType) {
                                    case LoginForPersonal:
                                        [self.navigationController popViewControllerAnimated:YES];

                                        [UIHelper gotoTabbar:3];

                                        break;
                                    case LoginForShopCart:
                                        [self dismissViewControllerAnimated:YES completion:nil];
                                        [UIHelper gotoTabbar:3];
                                        break;
                                    case LoginForShopFavo:
                                        [self.navigationController popViewControllerAnimated:YES];
                                        break;
                                    case LoginForFootMark:
                                        [self.navigationController popViewControllerAnimated:YES];
                                        break;
                                    case LoginForIntegral:
                                        [self.navigationController popViewControllerAnimated:YES];
                                        break;                                        
                                    default:
                                        [self dismissViewControllerAnimated:YES completion:nil];
                                        [UIHelper gotoTabbar:0];
                                        break;
                                       

                                }
                                ///环信退出登录
                                [[EMIMHelper defaultHelper] logoffEasemobSDK];
                            }else {
                                [self showAlertWithMessage:@"用户名或密码输入错误!"];
                                return;
                            }   
                        }
                        
                    }];
                }
            }
        }];
    }
}

//视图即将展示
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self.appConfig isLogin]) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [UIHelper gotoTabbar:3];
    }
    
}


-(void)loadUserScore{
    
    NSDictionary * userinfoDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                  self.appConfig.loginName, @"MemLoginID",
                                  kWebAppSign, @"AppSign",nil];
    
    [UserInfoModel getUserInfoByParamer:userinfoDic andblocks:^(UserInfoModel *user, NSError *error) {
        if(error){
            
            [TSMessage showNotificationWithTitle:NSLocalizedString(@"获取信息错误，点击屏幕重新加载", nil)
                                        subtitle:NSLocalizedString(@"网络连接失败，请检查网络设置", nil)
                                            type:TSMessageNotificationTypeError];
            
        }else{
            //首先判断是否有数据
            if (user) {
                self.appConfig.loginName = user.loginName;
                self.appConfig.loginPwd = user.userPwd;
                self.appConfig.userGuid = user.userGuid;
                self.appConfig.userEmail = user.userEmail;
                self.appConfig.userScore = user.userScore;
                self.appConfig.userAdvancePayment = user.userAdvancePayment;
                self.appConfig.userMemberRank = user.userMemberRank;
                
                NSString * picStr = [NSString stringWithFormat:@"%@%@",kWebMainBaseUrl,user.userPhotoStr];
                self.appConfig.RealName = [user.RealName isEqual:[NSNull null]]?user.loginName:user.RealName;
                self.appConfig.userUrlStr = picStr;
                [self.appConfig saveConfig];                
            }
        }
        
    }];
}

#pragma mark - 第三方登录
- (IBAction)WeChat:(id)sender {
    [ShareSDK getUserInfo:SSDKPlatformTypeWechat
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             
             NSLog(@"uid=%@",user.uid);
             NSLog(@"%@",user.credential);
             NSLog(@"token=%@",user.credential.token);
             NSLog(@"nickname=%@",user.nickname);
             [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
             [self thirdPartyLoginWithID:user.uid loginType:@"1"];
         }
         else if (state == SSDKResponseStateCancel)
         {
             //             NSLog(@"%@",error);
         }
         else if (state == SSDKResponseStateBegin)
         {
             //             NSLog(@"%@",error);
         }
         else
         {
             NSLog(@"%@",error);
             [self showAlertWithMessage:@"登录失败"];
         }
         
     }];
}

- (IBAction)Sina:(id)sender {
    [ShareSDK getUserInfo:SSDKPlatformTypeSinaWeibo
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             
             NSLog(@"uid=%@",user.uid);
             NSLog(@"%@",user.credential);
             NSLog(@"token=%@",user.credential.token);
             NSLog(@"nickname=%@",user.nickname);
             [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
             [self thirdPartyLoginWithID:user.uid loginType:@"2"];
         }
         else if (state == SSDKResponseStateCancel)
         {
             //             NSLog(@"%@",error);
         }
         else if (state == SSDKResponseStateBegin)
         {
             //             NSLog(@"%@",error);
         }
         else
         {
             NSLog(@"%@",error);
             [self showAlertWithMessage:@"登录失败"];
         }
         
     }];
}

- (IBAction)tencent:(id)sender {
    //例如QQ的登录
    [ShareSDK getUserInfo:SSDKPlatformTypeQQ
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             NSLog(@"uid=%@",user.uid);
             NSLog(@"icon=%@",user.icon);
             NSLog(@"%@",user.credential);
             NSLog(@"token=%@",user.credential.token);
             NSLog(@"nickname=%@",user.nickname);
             [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
             [self thirdPartyLoginWithID:user.uid loginType:@"0"];
         }
         else if (state == SSDKResponseStateCancel)
         {
             //             NSLog(@"%@",error);
         }
         else if (state == SSDKResponseStateBegin)
         {
             //             NSLog(@"%@",error);
         }
         else
         {
             NSLog(@"%@",error);
             [self showAlertWithMessage:@"登录失败"];
         }
         
     }];
}

// 处理第三方登录
- (void)thirdPartyLoginWithID:(NSString *)ID loginType:(NSString *)type {
    [self.appConfig loadConfig];
    
    // /api/ThirdLogin/?type=1&openId=alsdfoaielkhnsdfkhaskjdfhl&appSign=dd2800a447530e29215bb1e7d97b9d18
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"type"] = type;
    dict[@"openId"] = ID;
    dict[@"appSign"] = self.appConfig.appSign;
    [UserInfoModel thirdPartyLoginByParamer:dict andblocks:^(UserInfoModel *user, NSError *error) {
        if (error) {
            [self showAlertWithMessage:@"网络异常"];
        } else {
            if (user) {
                // 保存用户信息，并登录
                [self.appConfig loadConfig];
                self.appConfig.loginName = user.loginName;
                self.appConfig.loginPwd = user.userPwd;
                [self.appConfig saveConfig];
                [self dismissViewControllerAnimated:YES completion:nil];
//                [UIHelper gotoTabbar:0];
            }
        }
    }];
}

@end
