//
//  EditAddressViewController.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-9-1.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "WFSViewController.h"
#import "AddressModel.h"
#import "TSLocateView.h"

@interface EditAddressViewController : WFSViewController<UIActionSheetDelegate, UITextFieldDelegate>
@property (strong, nonatomic) AddressModel *currenAddressModel;
@property (strong, nonatomic) IBOutlet UITextField *nameTextfield;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UITextField *addressdetailTextfield;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumberTextfield;
@property (strong, nonatomic) IBOutlet UITextField *emailTextfield;
@property (strong, nonatomic) IBOutlet UIImageView *nameImageBG;

@property (nonatomic, strong) UITextField *currentTextField;
@property (strong, nonatomic) IBOutlet UIImageView *addressImageBG;
@property (strong, nonatomic) IBOutlet UIImageView *detailAddressImageBG;
@property (strong, nonatomic) IBOutlet UIImageView *phoneNumImageBG;
@property (strong, nonatomic) IBOutlet UIImageView *emailImageBG;

@property (nonatomic,strong)NSString *provinceName;
@property (nonatomic,strong)NSString *cityName;
@property (nonatomic,strong)NSString *areaName;


- (IBAction)chooseAddressClick:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;
- (IBAction)deleteAddressClick:(id)sender;
@end
