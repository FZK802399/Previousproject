//
//  ForgetPwdViewController.m
//  ShopNum1V3.1
//
//  Created by Mac on 15/11/26.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "ForgetPwdViewController.h"
#import "ForgetPwdNextViewController.h"
#import "UserInfoModel.h"
#import "HKCountryChangController.h"
#import "HKCountry.h"

@interface ForgetPwdViewController ()<CountryChangControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *validateCodeTextField;

@property (weak, nonatomic) IBOutlet UIButton *fetchValidateCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (strong,nonatomic) NSTimer *timer;
@property (copy, nonatomic) NSString *code;

@property (weak, nonatomic) IBOutlet UILabel *countryNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryCodeLabel;
@end

@implementation ForgetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadLeftBackBtn];
    // Do any additional setup after loading the view.
    self.nextButton.layer.cornerRadius = 3.0f;
}



// 获取验证码
- (IBAction)fetchValidateCode:(id)sender {
    // kSegueForgetPwdNext
    
//    if (allTrim(self.userNameTextField.text).length == 0 || ![self isMobileNumber:self.userNameTextField.text]) {
//        [self showAlertWithMessage:@"请填写正确手机号码"];
//        return;
//    }
//    if (self.userNameTextField.text.length != 11) {
//        [self showAlertWithMessage:@"请填写正确手机号码"];
//        return;
//    }
    if (self.userNameTextField.text.length == 0) {
        [self showAlertWithMessage:@"先填写手机号码！"];
        return;
    }
    
    self.timer = nil;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startTime) userInfo:nil repeats:YES];
    self.fetchValidateCodeButton.userInteractionEnabled = NO;
    
//    ZDXWeakSelf(weakSelf);
//    [UserInfoModel fetchValidateCodeByPhone:self.userNameTextField.text blocks:^(NSString *code, NSError *error) {
//        if (error) {
//            [weakSelf showAlertWithMessage:@"网络错误"];
//        } else {
//            if (code) {
//                NSLog(@"Code: %@", code);
//                if ([code isEqualToString:@"手机号已经存在！"]) {
//                    [weakSelf showAlertWithMessage:@"手机号已被注册！"];
//                    [weakSelf stopCounting];
//                } else if ([code isEqualToString:@"未知错误"]) {
//                    [weakSelf showAlertWithMessage:@"获取失败！"];
//                    [weakSelf stopCounting];
//                } else if ([code isEqualToString:@"密码错误"]) {
//                    [weakSelf showAlertWithMessage:@"获取失败！"];
//                    [weakSelf stopCounting];
//                } else {
//                    [weakSelf showSuccessMessage:@"已发送，请注意查收哟~"];
//                    weakSelf.code = code;
//                }
//            } else {
//                [weakSelf showAlertWithMessage:@"获取验证码失败"];
//            }
//        }
//    }];
    ZDXWeakSelf(weakSelf);
    if ([self.countryCodeLabel.text isEqualToString:@"+86"]) {
        [UserInfoModel fetchValidateCodeByPhone:self.userNameTextField.text blocks:^(NSString *code, NSError *error) {
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
        NSString *phoneNum = self.userNameTextField.text;
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
// 下一步
- (IBAction)forgetPwdNext:(id)sender {
//    if (![self isMobileNumber:self.userNameTextField.text]) {
//        [self showAlertWithMessage:@"请填写正确手机号码"];
//        return;
//    }
    if (self.userNameTextField.text.length != 11) {
        [self showAlertWithMessage:@"请填写正确手机号码"];
        return;
    }

    if (allTrim(self.validateCodeTextField.text).length == 0) {
        [self showAlertWithMessage:@"请填写验证码"];
        return;
    }
    if (!self.code) {
        [self showAlertWithMessage:@"请获取验证码"];
        return;
    }
    if (![self.code isEqualToString:allTrim(self.validateCodeTextField.text)]) {
        [self showAlertWithMessage:@"输入验证码有误"];
        return;
    }
    // 验证用户名是否存在
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"Mobile"] = allTrim(self.userNameTextField.text);
    dict[@"AppSign"] = self.appConfig.appSign;
    [UserInfoModel userPhoneNumberIsExistByParamer:dict andblocks:^(bool isExist, NSError *error) {
        if (error) {
            [self showAlertWithMessage:@"网络错误"];
        } else {
            if (isExist) {
                [self performSegueWithIdentifier:@"kSegueForgetPwdNext" sender:self];
            } else {
                [self showAlertWithMessage:@"用户名不存在"];
                return;
            }
        }
    }];    

}

static  NSTimeInterval currentTime = 59;
-(void) startTime{
    if (currentTime<=0) {
        [self stopCounting];
    }else{
        NSString *str = [NSString stringWithFormat:@"%dS后重新获取", (int)currentTime];
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    NSString * MOBILE = @"^1((3|4|5|7|8)[0－9])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:mobileNum];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"kSegueForgetPwdNext"]) {
        ForgetPwdNextViewController *forgetNextVC = [segue destinationViewController];
        forgetNextVC.userName = self.userNameTextField.text;
    }else if([segue.identifier isEqualToString:@"forgetPwdToCountryChang"]){
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
