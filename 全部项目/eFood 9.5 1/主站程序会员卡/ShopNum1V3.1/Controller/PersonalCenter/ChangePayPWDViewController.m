//
//  ChangePayPWDViewController.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-9-12.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "ChangePayPWDViewController.h"
#import "UserInfoModel.h"

@interface ChangePayPWDViewController ()

@end

@implementation ChangePayPWDViewController

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
    self.oldImageBG.layer.borderWidth = 0.5;
    self.oldImageBG.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
    
    self.changeImageBG.layer.borderWidth = 0.5;
    self.changeImageBG.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
    
    self.sureImageBG.layer.borderWidth = 0.5;
    self.sureImageBG.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
    
    
    self.navigationController.navigationBar.translucent = YES;
    //适配ios6、7
    CGFloat orgineY = 16;
    orgineY = [self MatchIOS7:orgineY];
    
    ZJSwitch * switchBtn1 = [[ZJSwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 66, orgineY, 60, 32)];
    switchBtn1.tag = 101;
    [switchBtn1 setOnText:@"abc"];
    [switchBtn1 setOffText:@"***"];
    [switchBtn1 setOnTintColor:[UIColor barTitleColor]];
    [switchBtn1 addTarget:self action:@selector(switchBtnChangeValue:) forControlEvents:UIControlEventValueChanged];
    
//    self.payPassword.rightView = switchBtn1;
//    self.payPassword.rightViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:switchBtn1];
    
    ZJSwitch * switchBtn2 = [[ZJSwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 66, orgineY + 54, 60, 32)];
    switchBtn2.tag = 102;
    [switchBtn2 setOnText:@"abc"];
    [switchBtn2 setOffText:@"***"];
    [switchBtn2 setOnTintColor:[UIColor barTitleColor]];
    [switchBtn2 addTarget:self action:@selector(switchBtnChangeValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:switchBtn2];
    
    ZJSwitch * switchBtn3 = [[ZJSwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 66, orgineY + 108, 60, 32)];
    switchBtn3.tag = 103;
    [switchBtn3 setOnText:@"abc"];
    [switchBtn3 setOffText:@"***"];
    [switchBtn3 setOnTintColor:[UIColor barTitleColor]];
    [switchBtn3 addTarget:self action:@selector(switchBtnChangeValue:) forControlEvents:UIControlEventValueChanged];
    
//    self.surePassword.rightView = switchBtn2;
//    self.surePassword.rightViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:switchBtn3];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyboard)];
    [self.view addGestureRecognizer:tap];
    // Do any additional setup after loading the view.
    
    self.submitButton.layer.cornerRadius = 3.0f;
}

-(void)switchBtnChangeValue:(id)sender{
    ZJSwitch * tempBtn = (ZJSwitch *)sender;
    if (tempBtn.tag == 101) {
        if (tempBtn.on) {
            [self.oldPayPassword setSecureTextEntry:NO];
        } else {
            [self.oldPayPassword setSecureTextEntry:YES];
        }
    }else if(tempBtn.tag == 102){
        if (tempBtn.on) {
            [self.payPassword setSecureTextEntry:NO];
        } else {
            [self.payPassword setSecureTextEntry:YES];
        }        
    } else if (tempBtn.tag == 103) {
        if (tempBtn.on) {
            [self.surePassword setSecureTextEntry:NO];
        } else {
            [self.surePassword setSecureTextEntry:YES];
        }
    }
}

- (void)resignKeyboard {
    [self.oldPayPassword resignFirstResponder];
    [self.payPassword resignFirstResponder];
    [self.surePassword resignFirstResponder];
}

-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSMutableString *text = [NSMutableString stringWithString:textField.text];
    [text replaceCharactersInRange:range withString:string];
    return [text length] <= 30;
}

- (IBAction)changeBtnClick:(id)sender {
    
    if (allTrim(self.oldPayPassword.text).length== 0) {
        [self showAlertWithMessage:@"请输入支付密码"];
        return;
    }
    
    if (allTrim(self.payPassword.text).length < 6) {
        [self showAlertWithMessage:@"请输入6个字符以上的新密码"];
        return;
    }
    
    if (![allTrim(self.payPassword.text) isEqualToString:allTrim(self.surePassword.text)]) {
        [self showAlertWithMessage:@"两次输入的新密码不一致"];
        return;
    }
    
    
    NSDictionary * checkDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               self.appConfig.loginName,@"MemLoginID",
                               allTrim(self.oldPayPassword.text),@"PayPwd",
                               kWebAppSign,@"AppSign", nil];
    
    ZDXWeakSelf(weakSelf);
    [UserInfoModel checkPayPwdByParamer:checkDic andblocks:^(NSInteger result, NSError *error){
        if (error) {
            [weakSelf showErrorMessage:@"网络异常"];
        } else {
            if (result == 200) {
                [weakSelf modifyPayPassword];
            } else {
                [weakSelf showErrorMessage:@"支付密码错误"];
            }
        }
    }];
}
        
- (void)modifyPayPassword {
    NSDictionary * payDic = [NSDictionary dictionaryWithObjectsAndKeys:
                             self.appConfig.loginName,@"MemLoginID",
                             allTrim(self.payPassword.text),@"PayPwd",
                             kWebAppSign,@"AppSign", nil];
    
    ZDXWeakSelf(weakSelf);
    [UserInfoModel changePayPwdByParamer:payDic andblocks:^(NSInteger result, NSError *error) {
        if (error) {
            [weakSelf showErrorMessage:@"网络错误"];
        }else {
            if (result == 200) {
                [weakSelf showSuccessMesaageInWindow:@"修改成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [weakSelf showAlertWithMessage:@"修改失败"];
            }
        }
    }];
}
@end
