//
//  EditAddressViewController.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-9-1.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "EditAddressViewController.h"

@interface EditAddressViewController ()<UIAlertViewDelegate>

@end

@implementation EditAddressViewController
{
    NSString * regionCode;

}

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
    [self loadRightBtn];
    
    self.nameImageBG.layer.borderWidth = 1;
    self.nameImageBG.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
    
    self.addressImageBG.layer.borderWidth = 1;
    self.addressImageBG.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
    
    self.detailAddressImageBG.layer.borderWidth = 1;
    self.detailAddressImageBG.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
    
    self.phoneNumImageBG.layer.borderWidth = 1;
    self.phoneNumImageBG.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
    
    self.emailImageBG.layer.borderWidth = 1;
    self.emailImageBG.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
    
    if (_currenAddressModel == nil) {
        self.title = @"新增地址";
        [self.deleteBtn setHidden:YES];
    }else {
        self.title = @"编辑地址";
        [self.deleteBtn setHidden:NO];
        [self updateViewAddress];
    }
    [self registerForKeyboardNotifications];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    self.deleteBtn.layer.cornerRadius = 3.0f;
    
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)updateViewAddress{
    self.nameTextfield.text = _currenAddressModel.name;
    self.addressLabel.text = _currenAddressModel.address;
    self.addressLabel.textColor = [UIColor blackColor];
    self.phoneNumberTextfield.text = _currenAddressModel.mobile;
    self.emailTextfield.text = _currenAddressModel.email;
}

- (void)resignKeyboard {
    [self.currentTextField resignFirstResponder];
}

-(void)loadRightBtn{
    UIButton * registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame = CGRectMake(0, 0, 71, 33);
    [registerBtn setTitle:@"完成" forState:UIControlStateNormal];
    [registerBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [registerBtn setTitleColor:FONT_BLACK forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(finshBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:registerBtn];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    /**
     *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-5时，间距正好调整
     *  为0；width为正数时，正好相反，相当于往左移动width数值个像素
     */
    if (kCurrentSystemVersion >= 7.0) {
        negativeSpacer.width = -20;
    }else{
        negativeSpacer.width = -10;
    }
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, barBtnItem, nil];
    
    
    //    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(registerBtnClick:)];
//    self.navigationItem.rightBarButtonItem = barBtnItem;
    
}

-(void)finshBtnClick:(id)sender{
    NSString *emailStr = @"";
    if (allTrim(self.nameTextfield.text).length == 0) {
        [self showAlertWithMessage:@"请先输入姓名"];
        return;
    }
    
    if (allTrim(self.addressLabel.text).length == 0 || [self.addressLabel.text isEqualToString:@"请选择地址区域"]) {
        [self showAlertWithMessage:@"请先选择地区"];
        return;
    }
    
    if (allTrim(self.addressdetailTextfield.text).length == 0) {
        [self showAlertWithMessage:@"请先输入详细地址"];
        return;
    }
    
    if (allTrim(self.phoneNumberTextfield.text).length == 0) {
        [self showAlertWithMessage:@"请先输入手机号码"];
        return;
    }
    
//    if (allTrim(self.emailTextfield.text).length == 0) {
//        [self showAlertWithMessage:@"请先输入邮箱地址"];
//        return;
//    }
    
    if (![self isMobileNumber:allTrim(self.phoneNumberTextfield.text)]) {
        [self showAlertWithMessage:@"手机号码输入格式错误"];
        return;
    }
    
    if (![self NSStringIsValidEmail:allTrim(self.emailTextfield.text)]&&allTrim(self.emailTextfield.text).length > 0) {
        [self showAlertWithMessage:@"邮箱地址输入格式错误"];
        return;
    }else{
        emailStr = allTrim(self.emailTextfield.text).length > 0 ? allTrim(self.emailTextfield.text) : @"";
    }

//    for (UIBarButtonItem  * item in self.navigationItem.rightBarButtonItems) {
//        [item setEnabled:NO];
//    }

    if (_currenAddressModel == nil) {
        // IsDefault   IdCardFront   IdCardVerso
        NSDictionary * addDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 kWebAppSign,@"AppSign",
                                 regionCode, @"Code",
                                 allTrim(self.nameTextfield.text), @"NAME",
                                 emailStr,@"Email",
                                 allTrim(self.phoneNumberTextfield.text),@"Mobile",
                                 @"",@"Tel",
                                 self.appConfig.loginName, @"MemLoginID",
                                 @"430079",@"Postalcode",
                                 [allTrim(self.addressLabel.text) stringByAppendingString:allTrim(self.addressdetailTextfield.text)],@"Address",nil];
        [AddressModel addAddressWithParameters:addDic andlbock:^(NSInteger result, NSError *error) {
            if (error) {
                
            }else {
                if (result == 202) {
                    [self showSuccessMesaageInWindow:@"添加收货地址成功"];
                    [self.navigationController popViewControllerAnimated:YES];
                }else {
                    [self showErrorMessage:@"添加收货地址失败"];
                }
            
            }
        }];
    }else {
        NSString * temp;
        if (regionCode) {
            temp = regionCode;
        }else{
            temp = _currenAddressModel.addressCode;
        }
        NSDictionary * editDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 kWebAppSign,@"AppSign",
                                 temp, @"Code",
                                 allTrim(self.nameTextfield.text), @"NAME",
                                 emailStr,@"Email",
                                 allTrim(self.phoneNumberTextfield.text),@"Mobile",
                                 _currenAddressModel.tel,@"Tel",
                                 _currenAddressModel.guid, @"Guid",
                                 @"430070",@"Postalcode",
                                 [allTrim(self.addressLabel.text) stringByAppendingString:allTrim(self.addressdetailTextfield.text)],@"Address",nil];
        [AddressModel editAddressWithParameters:editDic andblock:^(NSInteger result, NSError *error){
            if (error) {
                
            }else {
                if (result == 202) {
                    [self showSuccessMesaageInWindow:@"修改收货地址成功"];
                    [self.navigationController popViewControllerAnimated:YES];
                }else {
                    [self showErrorMessage:@"修改收货地址失败"];
                }
                
            }
        }];
    
    }

}


- (BOOL)NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (BOOL)isTelNumber:(NSString *)tel{
    NSString *telNum = @"((\\d{11})|^((\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1})|(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1}))$)";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", telNum];
    
    if([regextestmobile evaluateWithObject:tel] == YES){
        return YES;
    }
    return NO;
}


- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    NSString * MOBILE = @"^1((3|4|5|7|8)[0－9])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:mobileNum];
}



- (void)registerForKeyboardNotifications{
    
    
    // keyboard notification
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        
        float animationTime = [[note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
        NSValue *rectValue = [note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardFrame = [rectValue CGRectValue];
    
        float instance= self.currentTextField.frame.origin.y + self.currentTextField.frame.size.height + keyboardFrame.size.height - SCREEN_HEIGHT;
        if (kCurrentSystemVersion < 7.0) {
            instance += 64;
        }
        if (instance > 0) {
            [UIView animateWithDuration:animationTime animations:^{

                self.view.frame = CGRectMake(0, -instance, self.view.frame.size.width, self.view.frame.size.height);
            }];
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        
        float animationTime = [[note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
        
        [UIView animateWithDuration:animationTime animations:^{

            self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }];
    
}



#pragma mark -UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _currentTextField = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    TSLocateView * loca = (TSLocateView *)actionSheet;
    if(buttonIndex == 0) {
        
    }else {
        self.provinceName = loca.procinelocate.name;
        self.cityName = loca.citylocate.name;
        self.areaName = loca.regionlocate.name;
        
        self.addressLabel.textColor = [UIColor blackColor];
        self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@", loca.procinelocate.name, loca.citylocate.name ,loca.regionlocate.name];
        if (loca.regionlocate) {
            regionCode = [NSString stringWithFormat:@"%@",loca.regionlocate.code];
        }else {
            regionCode = [NSString stringWithFormat:@"%@",loca.citylocate.code];
        }
//        NSLog(@"regionCode = %@",regionCode);
    }
}


- (IBAction)chooseAddressClick:(id)sender {
    [self.currentTextField resignFirstResponder];
    TSLocateView *locateView = [[TSLocateView alloc] initWithTitle:@"选择城市" delegate:self];
    [locateView showInView:self.view];
}


- (IBAction)deleteAddressClick:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"确定删除收货地址"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确定", @"取消", nil];
    alertView.tag = 1000;
    [alertView show];
    
    
//    DXAlertView *alertdelete = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"确定删除收货地址" leftButtonTitle:@"确定" rightButtonTitle:@"取消"];
//    [alertdelete show];
//    
//    alertdelete.leftBlock = ^() {
//        NSDictionary *deleteDic = [NSDictionary dictionaryWithObjectsAndKeys:
//                                   _currenAddressModel.guid,@"Guid",
//                                   kWebAppSign, @"AppSign", nil];
//        [AddressModel deleteAddressWithParameters:deleteDic andblock:^(NSInteger result, NSError *error) {
//            if (error) {
//                
//            }else{
//                if (result == 202) {
////                    [self showAlertWithMessage:@"删除收货地址成功"];
//                    [self.navigationController popViewControllerAnimated:YES];
//                }
//            }
//        }];
//    };
//    alertdelete.rightBlock = ^() {
//        
//    };
//    alertdelete.dismissBlock = ^() {
//
//    };
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    NSLog(@"buttonIndex == %d", buttonIndex);
    if (buttonIndex == 0 && alertView.tag == 1000) {
        NSDictionary *deleteDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                   _currenAddressModel.guid,@"Guid",
                                   kWebAppSign, @"AppSign", nil];
        [AddressModel deleteAddressWithParameters:deleteDic andblock:^(NSInteger result, NSError *error) {
            if (error) {
                
            }else{
                if (result == 202) {
                    //                    [self showAlertWithMessage:@"删除收货地址成功"];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        }];
    }
}

-(void)alertViewCancel:(UIAlertView *)alertView{


}



@end
