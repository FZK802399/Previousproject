//
//  ChangeLoginPWDViewController.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-9-12.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "WFSViewController.h"

@interface ChangeLoginPWDViewController : WFSViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *oldPassword;
@property (strong, nonatomic) IBOutlet UITextField *changepassword;
@property (strong, nonatomic) IBOutlet UITextField *surePassword;

@property (strong, nonatomic) IBOutlet UIImageView *oldImageBG;
@property (strong, nonatomic) IBOutlet UIImageView *cahngeImageBG;
@property (strong, nonatomic) IBOutlet UIImageView *sureImageBG;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;



- (IBAction)updateBtnClick:(id)sender;

@end
