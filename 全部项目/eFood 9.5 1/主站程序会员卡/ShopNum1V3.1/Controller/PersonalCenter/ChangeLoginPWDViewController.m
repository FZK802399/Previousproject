//
//  ChangeLoginPWDViewController.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-9-12.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "ChangeLoginPWDViewController.h"
#include "UserInfoModel.h"

@interface ChangeLoginPWDViewController ()

@end

@implementation ChangeLoginPWDViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"Rect :%@", NSStringFromCGRect(self.surePassword.frame));
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadLeftBackBtn];
    
    self.oldImageBG.layer.borderWidth = 0.5;
    self.oldImageBG.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
    
    self.cahngeImageBG.layer.borderWidth = 0.5;
    self.cahngeImageBG.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
    
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
    
    //    self.oldPassword.rightView = switchBtn1;
    //    self.oldPassword.rightViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:switchBtn1];
    
    ZJSwitch * switchBtn2 = [[ZJSwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 66, orgineY + 54, 60, 32)];
    switchBtn2.tag = 102;
    [switchBtn2 setOnText:@"abc"];
    [switchBtn2 setOffText:@"***"];
    [switchBtn2 setOnTintColor:[UIColor barTitleColor]];
    [switchBtn2 addTarget:self action:@selector(switchBtnChangeValue:) forControlEvents:UIControlEventValueChanged];
    
    //    self.changepassword.rightView = switchBtn2;
    //    self.changepassword.rightViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:switchBtn2];
    
    ZJSwitch * switchBtn3 = [[ZJSwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 66, orgineY + 108, 60, 32)];
    switchBtn3.tag = 103;
    [switchBtn3 setOnText:@"abc"];
    [switchBtn3 setOffText:@"***"];
    [switchBtn3 setOnTintColor:[UIColor barTitleColor]];
    [switchBtn3 addTarget:self action:@selector(switchBtnChangeValue:) forControlEvents:UIControlEventValueChanged];
    
    //    self.surePassword.rightView = switchBtn3;
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
            [self.oldPassword setSecureTextEntry:NO];
        } else {
            [self.oldPassword setSecureTextEntry:YES];
        }
    }else if(tempBtn.tag == 102){
        if (tempBtn.on) {
            [self.changepassword setSecureTextEntry:NO];
        } else {
            [self.changepassword setSecureTextEntry:YES];
        }
        
    }else{
        if (tempBtn.on) {
            [self.surePassword setSecureTextEntry:NO];
        } else {
            [self.surePassword setSecureTextEntry:YES];
        }
    
    }
}

- (void)resignKeyboard {
    [self.oldPassword resignFirstResponder];
    [self.changepassword resignFirstResponder];
    [self.surePassword resignFirstResponder];
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

- (IBAction)updateBtnClick:(id)sender {
    
    
    if (allTrim(self.oldPassword.text).length == 0) {
        [self showAlertWithMessage:@"请先输入旧密码"];
        return;
    }
    
    if (allTrim(self.changepassword.text).length < 6) {
        [self showAlertWithMessage:@"请先输入6个字符以上的新密码"];
        return;
    }
    
    if (![allTrim(self.changepassword.text) isEqualToString:allTrim(self.surePassword.text)]) {
        [self showAlertWithMessage:@"两次输入的新密码不一致"];
        return;
    }
    
    [self.appConfig loadConfig];
    if (![allTrim(self.oldPassword.text) isEqualToString:self.appConfig.loginPwd]) {
        [self showAlertWithMessage:@"原始密码输入错误"];
        return;
    }
    
    NSDictionary * logDic = [NSDictionary dictionaryWithObjectsAndKeys:
                             self.appConfig.loginName,@"MemLoginID",
                             self.appConfig.loginPwd,@"oldPwd",
                             allTrim(self.changepassword.text),@"newPwd",
                             kWebAppSign,@"AppSign", nil];
    
    ZDXWeakSelf(weakSelf);
    [UserInfoModel changeLoginPwdByParamer:logDic andblocks:^(NSInteger result, NSError *error) {
        if (error) {
            [weakSelf showErrorMessage:@"网络错误"];
        }else {
//            NSLog(@"result == %d", result);
            if (result == 200) {
                [weakSelf.appConfig loadConfig];
                weakSelf.appConfig.loginPwd = allTrim(self.changepassword.text);
                [weakSelf.appConfig saveConfig];
                [weakSelf showSuccessMesaageInWindow:@"修改成功"];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else{
                [weakSelf showAlertWithMessage:@"修改失败"];
            }
        
        }
    }];

    
}
@end
