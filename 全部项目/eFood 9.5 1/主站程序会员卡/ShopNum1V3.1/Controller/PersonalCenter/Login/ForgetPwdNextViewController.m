//
//  ForgetPwdNextViewController.m
//  ShopNum1V3.1
//
//  Created by Mac on 15/11/26.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "ForgetPwdNextViewController.h"
#import "UserInfoModel.h"

@interface ForgetPwdNextViewController ()

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *surePasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;


@end

@implementation ForgetPwdNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadLeftBackBtn];
    // Do any additional setup after loading the view.    
    self.submitButton.layer.cornerRadius = 3.0f;
}


// 提交重置密码请求
- (IBAction)resetPwd:(id)sender {
    if (allTrim(self.passwordTextField.text).length == 0 || allTrim(self.passwordTextField.text).length < 6) {
        [self showAlertWithMessage:@"请输入正确新密码格式"];
        return;
    }
    if (allTrim(self.surePasswordTextField.text).length == 0 || allTrim(self.surePasswordTextField.text).length < 6) {
        [self showAlertWithMessage:@"请输入正确旧密码格式"];
        return;
    }
    if (![allTrim(self.surePasswordTextField.text) isEqualToString:allTrim(self.passwordTextField.text)]) {
        [self showAlertWithMessage:@"两次输入密码不相同"];
        return;
    }
    NSDictionary * logDic = [NSDictionary dictionaryWithObjectsAndKeys:
                             self.userName,@"MemLoginID",
                             allTrim(self.passwordTextField.text),@"newPassWord",
                             kWebAppSign,@"AppSign", nil];
//    /api/ResetPassWrod/?MemLoginID=mike&newPassWord=123456&AppSing=9991fa8f663fe072a54ba7cce6341e4b
    
    [UserInfoModel resetLoginPwdByParamer:logDic andblocks:^(BOOL result, NSError *error) {
        if (error) {
            [self showAlertWithMessage:@"网络错误"];
        }else {
            //            NSLog(@"result == %d", result);
            if (result) {
                [MBProgressHUD showSuccess:@"重置密码成功"];
                self.appConfig.loginName = allTrim(self.userName);
                self.appConfig.loginPwd = allTrim(self.passwordTextField.text);
                [self.appConfig saveConfig];
                [self.navigationController popToRootViewControllerAnimated:YES];
                [UIHelper gotoTabbar:3];
                
            }else{
                [self showAlertWithMessage:@"重置密码失败"];
            }
            
        }
    }];

    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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
