
//
//  MeViewController.m
//  whxfj
//
//  Created by 司马帅帅 on 14-8-26.
//  Copyright (c) 2014年 baobin. All rights reserved.
//

#import "MeViewController.h"
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"

@interface MeViewController ()<UITextFieldDelegate>
{
    UITextField *nameText;
    UITextField *numberText;
    MBProgressHUD *HUD;
    UIView *backView;
}
@end

@implementation MeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"用户注册";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"6_nav.png"] forBarMetrics:UIBarMetricsDefault];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 50)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setText:self.title];
    self.navigationItem.titleView = titleLabel;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backButton setFrame:CGRectMake(0, 0, 30, 30)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateHighlighted];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 160)];
    [backView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:backView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 30)];
    [nameLabel setUserInteractionEnabled:YES];
    [nameLabel setBackgroundColor:[UIColor whiteColor]];
    [nameLabel setText:@" 姓     名:"];
    [backView addSubview:nameLabel];
    
    nameText = [[UITextField alloc] initWithFrame:CGRectMake(80, 0, nameLabel.frame.size.width-80, 30)];
    nameText.delegate = self;
    [nameText setBackgroundColor:[UIColor clearColor]];
    nameText.keyboardType = UIKeyboardTypeNamePhonePad;
    nameText.returnKeyType = UIReturnKeyNext;
    [nameLabel addSubview:nameText];
    [nameText becomeFirstResponder];
    
    UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(nameLabel.frame)+10, 300, 30)];
    [numberLabel setUserInteractionEnabled:YES];
    [numberLabel setBackgroundColor:[UIColor whiteColor]];
    [numberLabel setText:@" 手 机 号:"];
    [backView addSubview:numberLabel];
    
    numberText = [[UITextField alloc] initWithFrame:CGRectMake(80, 0, numberLabel.frame.size.width-80, 30)];
    numberText.keyboardType = UIKeyboardTypePhonePad;
    [numberText setBackgroundColor:[UIColor clearColor]];
    [numberLabel addSubview:numberText];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setFrame:CGRectMake(10, CGRectGetMaxY(numberLabel.frame)+30, 300, 40)];
    [loginButton setBackgroundColor:[UIColor grayColor]];
    [loginButton setTitle:@"注册" forState:UIControlStateNormal];
    [backView addSubview:loginButton];
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)login
{
    if ([self isBlankString:nameText.text] || [self isBlankString:numberText.text]) {
        [self show:MBProgressHUDModeText message:@"注册内容不能为空" customView:nil];
        [self hiddenHUDWithMessage:@"注册内容不能为空"];
    } else {
        [self loginRequest];
    }
}

- (void)loginRequest
{
    NSLog(@"请求");
    NSString *requestString = [NSString stringWithFormat:@"http://xfj.weittui.com/api.php?op=xfj_reg&name=%@&mobile=%@",nameText.text,numberText.text];
    
    NSString * encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestString, NULL, NULL,  kCFStringEncodingUTF8 ));
    
    ASIHTTPRequest *asiListRequest = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:encodedString]];
    [asiListRequest setDelegate:self];
    [asiListRequest startAsynchronous];
}

//判断一个字符串是否为空 或者 只含有空格
- (BOOL)isBlankString:(NSString *)string
{
    if (string == nil) {
        return YES;
    }
    if (string == NULL) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        return YES;
    }
    return NO;
}

#pragma Mark HUD
//展示 风火轮HUD
- (void)showActivityHUD
{
    [self show:MBProgressHUDModeIndeterminate message:@"注册中..." customView:nil];
}

//显示HUD
- (void)show:(MBProgressHUDMode)_mode message:(NSString *)_message customView:(id)_customView
{
    HUD = [[MBProgressHUD alloc] initWithView:[[UIApplication sharedApplication] keyWindow]];
    [backView addSubview:HUD];
    HUD.mode = _mode;
    HUD.customView = _customView;
    HUD.animationType = MBProgressHUDAnimationZoom;
    HUD.labelText = _message;
    [HUD show:YES];
}

//隐藏HUD
- (void)hiddenHUD
{
    [HUD hide:YES afterDelay:0.5f];
}

//隐藏HUD并给以文字提示
- (void)hiddenHUDWithMessage:(NSString *)message
{
    HUD.mode = MBProgressHUDModeText;
    HUD.labelText = message;
    [HUD hide:YES afterDelay:1.5f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([@"\n" isEqualToString:string] == YES) {
        [numberText becomeFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark ASIHTTPRequestDelegate
- (void)requestStarted:(ASIHTTPRequest *)request
{
    NSLog(@"请求开始");
    [self showActivityHUD];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"请求结束 %@", [request responseString]);
    [self hiddenHUDWithMessage:@"注册成功!"];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:1.7];
    
}

- (void)dismiss{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"请求失败");
    [self hiddenHUD];
}


@end
