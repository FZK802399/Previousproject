//
//  UpdateReturnOrderViewController.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-9-9.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "UpdateReturnOrderViewController.h"
#import "RefundOrderModel.h"
#import "RefundOrderController.h"
@interface UpdateReturnOrderViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end

@implementation UpdateReturnOrderViewController

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
//    [self loadLeftBackBtn];
//    [self loadRightShortCutBtn];
//    [self loadRightBtn];
    self.submitButton.layer.cornerRadius = 3.0f;
    
    self.companyView.layer.borderWidth = 1;
    self.companyView.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
    
    self.NumberView.layer.borderWidth = 1;
    self.NumberView.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    // Do any additional setup after loading the view.
}

- (void)resignKeyboard {
    [self.logisticsCompany resignFirstResponder];
    [self.logisticsNumber resignFirstResponder];
}

-(void)loadRightBtn{
    UIButton * registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame = CGRectMake(0, 0, 71, 33);
    [registerBtn setTitle:@"完成" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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
    //    self.navigationItem.rightBarButtonItem = rightBtn;
    
}


-(IBAction)finshBtnClick:(id)sender{
    
    if (allTrim(self.logisticsCompany.text).length == 0) {
        [self showAlertWithMessage:@"请填写物流公司"];
        return;
    }
    
    if (allTrim(self.logisticsNumber.text).length == 0) {
        [self showAlertWithMessage:@"请填写运单号"];
        return;
    }
    

    NSDictionary * addDic = [NSDictionary dictionaryWithObjectsAndKeys:
                             kWebAppSign,@"AppSign",
                             allTrim(self.logisticsCompany.text), @"MainDistribution",
                             allTrim(self.logisticsNumber.text), @"StreamOrder",
                             self.appConfig.loginName,@"OperateUserID",
                             self.returnOrderGuid, @"Guid",
                             nil];
    [RefundOrderModel updateReturnOrderDetailWithparameters:addDic andblock:^(NSInteger result, NSError *error) {
        if (error) {
            [self showErrorMessage:@"网络错误"];
        } else {
            if (result == 202) {
//                [self showAlertWithMessage:@"更新退货订单成功"];
//                NSLog(@"更新退货订单成功");
//                [self.navigationController popToRootViewControllerAnimated:YES];

                for (id viewController in self.navigationController.viewControllers) {
                    if ([viewController isKindOfClass:[RefundOrderController class]]) {
                        [self.navigationController popToViewController:viewController animated:YES];
                        [self showSuccessMesaageInWindow:@"提交成功"];
                    }
                }
            } else {
                [self showErrorMessage:@"提交失败"];
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"提交失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//                [alert show];
            }
        }
    }];
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.logisticsCompany) {
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 16) {
            return NO;
        }
    }
    if (textField == self.logisticsNumber) {
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 20) {
            return NO;
        }
    }
    return YES;
}

@end
