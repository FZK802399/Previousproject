//
//  RegisterViewController.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-19.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterNextViewController.h"
#import "UserInfoModel.h"
#import "MoreDetailViewController.h"
#import "HKCountryChangController.h"
#import "HKCountry.h"

@interface RegisterViewController ()<CountryChangControllerDelegate>
{
    NSInteger currentTime;
}
@property (weak, nonatomic) IBOutlet UIButton *fetchValidateCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (strong,nonatomic) NSTimer *timer;
@property (copy, nonatomic) NSString *code;

@property (weak, nonatomic) IBOutlet UILabel *countryNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryCodeLabel;
@end

@implementation RegisterViewController
{
    BOOL isAgree;
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
    currentTime = 59;
//    self.nameImageBG.layer.borderWidth = 1;
//    self.nameImageBG.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
//    
//    self.PWDImageBG.layer.borderWidth = 1;
//    self.PWDImageBG.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
//    
//    self.sureImageBG.layer.borderWidth = 1;
//    self.sureImageBG.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
//    
//    self.recommendImageBg.layer.borderWidth = 1;
//    self.recommendImageBg.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
    
    
    //适配ios6、7
    CGFloat orgineY = 112;
    orgineY = [self MatchIOS7:orgineY];
    
    ZJSwitch * switchBtn1 = [[ZJSwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 66, orgineY, 60, 32)];
    switchBtn1.tag = 101;
    [switchBtn1 setOnText:@"abc"];
    [switchBtn1 setOffText:@"***"];
    [switchBtn1 setOnTintColor:[UIColor barTitleColor]];
    [switchBtn1 addTarget:self action:@selector(switchBtnChangeValue:) forControlEvents:UIControlEventValueChanged];

//    self.passwordTextfield.rightView = switchBtn1;
//    self.passwordTextfield.rightViewMode = UITextFieldViewModeAlways;
//    [self.view addSubview:switchBtn1];
    
    ZJSwitch * switchBtn2 = [[ZJSwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 66, orgineY + 50, 60, 32)];
    switchBtn2.tag = 102;
    [switchBtn2 setOnText:@"abc"];
    [switchBtn2 setOffText:@"***"];
    [switchBtn2 setOnTintColor:[UIColor barTitleColor]];
    [switchBtn2 addTarget:self action:@selector(switchBtnChangeValue:) forControlEvents:UIControlEventValueChanged];
   
//    self.surepassword.rightView = switchBtn2;
//    self.surepassword.rightViewMode = UITextFieldViewModeAlways;
//    [self.view addSubview:switchBtn2];
    
    QCheckBox * autoLoginbtn = [[QCheckBox alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.validateCodeTextfield.frame) + 10, 50, 25)];
    [autoLoginbtn setDelegate:self];
    [autoLoginbtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [autoLoginbtn setTitle:@"同意" forState:UIControlStateNormal];
    [autoLoginbtn setTitleColor:[UIColor colorWithWhite:0.322 alpha:1.000] forState:UIControlStateNormal];
    autoLoginbtn.checked = YES;
    [self.view addSubview:autoLoginbtn];
    isAgree = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyboard)];
    [self.view addGestureRecognizer:tap];
    // Do any additional setup after loading the view.
    
    self.nextButton.layer.cornerRadius = 3.0f;
    self.fetchValidateCodeButton.layer.cornerRadius = 2.0f;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopCounting];
}

-(void)switchBtnChangeValue:(id)sender{
//    ZJSwitch * tempBtn = (ZJSwitch *)sender;
//    if (tempBtn.tag == 101) {
//        if (tempBtn.on) {
//            [self.passwordTextfield setSecureTextEntry:NO];
//        } else {
//            [self.passwordTextfield setSecureTextEntry:YES];
//        }
//    }else{
//        if (tempBtn.on) {
//            [self.surepassword setSecureTextEntry:NO];
//        } else {
//            [self.surepassword setSecureTextEntry:YES];
//        }
//    
//    }
}

- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked{
    if (checked) {
        isAgree = YES;
    }else{
        isAgree = NO;
    }
}


- (BOOL)NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (BOOL)isTelNumber:(NSString *)tel{
    NSString *telNum = @"((\\d{11})|^((\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1})|(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1}))$)";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", telNum];
    
    if([regextestmobile evaluateWithObject:tel] == YES){
        return YES;
    }
    return NO;
}


- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    NSString * MOBILE = @"^1((3|4|5|7|8)[0－9])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:mobileNum];
}


- (BOOL)isCanUseName:(NSString *)name{
    
    if ([self NSStringIsValidEmail:name]||[self isMobileNumber:name]) {
        return YES;
    }
    
    //只能使用字母汉字中文注册
    NSString *regex = @"^[a-zA-Z0-9\u4e00-\u9fa5]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//    NSString *CanUseName = @"[`~!@#$%^&*()+=|{}':;',//[//].<>/?~！@#AU$%……&*（）——+|{}【】‘；：”“’。，、？]";
//    
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CanUseName];
    
    if([pred evaluateWithObject:name] == YES){
        return YES;
    }
    return NO;
}

- (void)resignKeyboard {
    [self.nameTextfield resignFirstResponder];
    [self.validateCodeTextfield resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSMutableString *text = [NSMutableString stringWithString:textField.text];
    [text replaceCharactersInRange:range withString:string];
    return [text length] <= 30;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//下一步按钮点击
- (IBAction)nextStepClick:(id)sender {
    
//    kSegueRegisterNext
    
    if (!isAgree) {
        [self showAlertWithMessage:@"未同意用户协议"];
        return;
    }
//    if (![self isMobileNumber:self.nameTextfield.text]) {
//        [self showAlertWithMessage:@"请填写正确手机号码"];
//        return;
//    }
    if (self.nameTextfield.text.length != 11) {
        [self showAlertWithMessage:@"请填写正确手机号码"];
        return;
    }
    if (allTrim(self.validateCodeTextfield.text).length == 0) {
        [self showAlertWithMessage:@"请填写验证码"];
        return;
    }
    if (!self.code) {
        [self showAlertWithMessage:@"请获取验证码"];
        return;
    }
    if (![self.code isEqualToString:allTrim(self.validateCodeTextfield.text)]) {
        [self showAlertWithMessage:@"输入验证码有误"];
        return;
    }
    [self performSegueWithIdentifier:@"kSegueRegisterNext" sender:self];
    // 验证用户名是否存在
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    dict[@"Mobile"] = allTrim(self.nameTextfield.text);
//    dict[@"AppSign"] = self.appConfig.appSign;
//    [UserInfoModel userPhoneNumberIsExistByParamer:dict andblocks:^(bool isExist, NSError *error) {
//        if (error) {
//            [self showAlertWithMessage:@"网络错误"];
//        } else {
//            if (isExist) {
//                [self showAlertWithMessage:@"手机号已被注册"];
//
//            } else {
//                [self performSegueWithIdentifier:@"kSegueRegisterNext" sender:self];
//            }
//        }
//    }];    
}

#pragma mark - 协议
- (IBAction)userProtocolClick:(id)sender {
    
//    [self performSegueWithIdentifier:kSegueRegistertoProtocol sender:self];
    MoreDetailViewController *moreVC = ZDX_VC(@"StoryboardIOS7", @"MoreDetailViewController");
    moreVC.htmlStr = @"http://senghongwap.efood7.com/pages/userAgreement.html";
    [self.navigationController pushViewController:moreVC animated:YES];
}

// 获取验证码
- (IBAction)fetchValidateCode:(id)sender {
//    if (allTrim(self.nameTextfield.text).length == 0 || ![self isMobileNumber:self.nameTextfield.text]) {
//        [self showAlertWithMessage:@"请填写正确手机号码"];
//        return;
//    }
    if (self.nameTextfield.text.length == 0) {
        [self showAlertWithMessage:@"先填写手机号码！"];
        return;
    }
    
    // 验证用户名是否存在
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"Mobile"] = allTrim(self.nameTextfield.text);
        dict[@"AppSign"] = self.appConfig.appSign;
        [UserInfoModel userPhoneNumberIsExistByParamer:dict andblocks:^(bool isExist, NSError *error) {
            if (error) {
                [self showAlertWithMessage:@"网络错误"];
            } else {
                if (isExist) {
                    [self showAlertWithMessage:@"手机号已被注册"];
                } else {
                    [self getCode];
                }
            }
        }];
}

-(void)getCode
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startTime) userInfo:nil repeats:YES];
    self.fetchValidateCodeButton.userInteractionEnabled = NO;
    
    ZDXWeakSelf(weakSelf);
    if ([self.countryCodeLabel.text isEqualToString:@"+86"]) {
        [UserInfoModel fetchValidateCodeByPhone:self.nameTextfield.text blocks:^(NSString *code, NSError *error) {
            if (error) {
                [weakSelf showAlertWithMessage:@"网络错误"];
            } else {
                if (code) {
                    NSLog(@"Code: %@", code);
                    if ([code isEqualToString:@"手机号已经存在！"]) {
                        [weakSelf showAlertWithMessage:@"手机号已被注册！"];
                        [weakSelf stopCounting];
                    } else if ([code isEqualToString:@"未知错误"]) {
                        [weakSelf showAlertWithMessage:@"获取失败！"];
                        [weakSelf stopCounting];
                    } else if ([code isEqualToString:@"密码错误"]) {
                        [weakSelf showAlertWithMessage:@"获取失败！"];
                        [weakSelf stopCounting];
                    } else {
                        [weakSelf showSuccessMessage:@"已发送，请注意查收哟~"];
                        weakSelf.code = code;
                    }
                } else {
                    [weakSelf showAlertWithMessage:@"获取验证码失败"];
                }
            }
        }];
    }else{
        NSString *code = [self.countryCodeLabel.text substringFromIndex:1];
        NSString *phoneNum = self.nameTextfield.text;
        if ([[phoneNum substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"0"]) {
            phoneNum = [phoneNum substringFromIndex:1];
        }
        NSString *param = [NSString stringWithFormat:@"00%@%@",code,phoneNum];
        [UserInfoModel fetchValidateYMGCodeByPhone:param blocks:^(NSString *code, NSError *error) {
            if (error) {
                [weakSelf showAlertWithMessage:@"网络错误"];
            } else {
                if (code) {
                    NSLog(@"Code: %@", code);
                    if ([code isEqualToString:@"手机号已经存在！"]) {
                        [weakSelf showAlertWithMessage:@"手机号已被注册！"];
                        [weakSelf stopCounting];
                    } else if ([code isEqualToString:@"未知错误"]) {
                        [weakSelf showAlertWithMessage:@"获取失败！"];
                        [weakSelf stopCounting];
                    } else if ([code isEqualToString:@"密码错误"]) {
                        [weakSelf showAlertWithMessage:@"获取失败！"];
                        [weakSelf stopCounting];
                    } else {
                        [weakSelf showSuccessMessage:@"已发送，请注意查收哟~"];
                        weakSelf.code = code;
                    }
                } else {
                    [weakSelf showAlertWithMessage:@"获取验证码失败"];
                }
            }
        }];
    }
   
}

//static  NSTimeInterval currentTime = 59;
-(void) startTime{
    if (currentTime == 0) {
        [self stopCounting];
    }else{
        NSString *str = [NSString stringWithFormat:@"%ldS后重新获取", currentTime];
        self.fetchValidateCodeButton.backgroundColor = RGB(220.0, 220.0, 220.0);
        [self.fetchValidateCodeButton setTitleColor:RGB(119.0, 119.0, 119.0) forState:UIControlStateNormal];
        [self.fetchValidateCodeButton setTitle:str forState:UIControlStateNormal];
    }
    currentTime--;
}

/// 停止倒计时
-(void) stopCounting{
    currentTime = 59;
    [self.timer invalidate];
    self.fetchValidateCodeButton.userInteractionEnabled = YES;
    self.fetchValidateCodeButton.backgroundColor = MAIN_BLUE;
    [self.fetchValidateCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.fetchValidateCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"kSegueRegisterNext"]) {
        RegisterNextViewController *registerNextVC = [segue destinationViewController];
        registerNextVC.userName = self.nameTextfield.text;
        registerNextVC.countryCode = self.countryCodeLabel.text;
    }else if([segue.identifier isEqualToString:@"segueToCountryChang"]){
        HKCountryChangController *countryChangVc = [segue destinationViewController];
        countryChangVc.delegate = self;
    }
}

-(void)countryChangController:(HKCountryChangController *)countryChangVc didFinishedSelectCountry:(HKCountry *)country
{
//    NSLog(@"快成功了");
    self.countryCodeLabel.text = country.Code;
    self.countryNameLabel.text = country.country;
}
@end
