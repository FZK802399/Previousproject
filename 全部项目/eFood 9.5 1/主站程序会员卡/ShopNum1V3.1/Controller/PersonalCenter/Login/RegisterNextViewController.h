//
//  RegisterNextViewController.h
//  ShopNum1V3.1
//
//  Created by Mac on 15/11/26.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "WFSViewController.h"

@interface RegisterNextViewController : WFSViewController

@property (strong, nonatomic) IBOutlet UITextField *passwordTextfield;
@property (strong, nonatomic) IBOutlet UITextField *surepassword;
@property (strong, nonatomic) IBOutlet UITextField *recommnedPersonTextfield;
@property (copy, nonatomic) NSString *userName;
@property (copy, nonatomic) NSString *countryCode;
@end
