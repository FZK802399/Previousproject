//
//  LoginViewController.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-18.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "WFSViewController.h"



typedef enum{
    //领取积分
    LoginForIntegral = 1,
    //足迹
    LoginForFootMark = 2,
    //购物车
    LoginForShopCart = 3,
    //个人中心
    LoginForPersonal = 4,
    //收藏
    LoginForShopFavo = 5
    
} LoginViewType;

@interface LoginViewController : WFSViewController<QCheckBoxDelegate, UITextFieldDelegate>

@property (assign, nonatomic) LoginViewType FatherViewType;

@property (strong, nonatomic) IBOutlet UITextField *LoginNameTextfield;
@property (strong, nonatomic) IBOutlet UITextField *PasswordTextField;
@property (strong, nonatomic) IBOutlet UIImageView *nameImageBG;
@property (strong, nonatomic) IBOutlet UIImageView *PWDImageBG;
+ (instancetype) create;
- (IBAction)registerBtnClick:(id)sender;

- (IBAction)loginBtnClick:(id)sender;
-(void)setFatherViewType:(LoginViewType)FatherViewType;
@end
