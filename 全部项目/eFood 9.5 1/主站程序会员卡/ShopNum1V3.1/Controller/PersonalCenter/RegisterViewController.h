//
//  RegisterViewController.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-19.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "WFSViewController.h"
#import "LoginViewController.h"

@interface RegisterViewController : WFSViewController<UITextFieldDelegate, QCheckBoxDelegate>
@property (strong, nonatomic) IBOutlet UITextField *nameTextfield;
@property (strong, nonatomic) IBOutlet UITextField *validateCodeTextfield;


- (IBAction)userProtocolClick:(id)sender;

@property (assign, nonatomic) LoginViewType registerViewType;

//下一步按钮点击
- (IBAction)nextStepClick:(id)sender;
@end
