//
//  ChangePayPWDViewController.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-9-12.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "WFSViewController.h"

@interface ChangePayPWDViewController : WFSViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *oldPayPassword;
@property (strong, nonatomic) IBOutlet UITextField *payPassword;
@property (strong, nonatomic) IBOutlet UITextField *surePassword;

@property (weak, nonatomic) IBOutlet UIImageView *oldImageBG;
@property (strong, nonatomic) IBOutlet UIImageView *changeImageBG;
@property (strong, nonatomic) IBOutlet UIImageView *sureImageBG;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

- (IBAction)changeBtnClick:(id)sender;
@end
