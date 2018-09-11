//
//  DetailViewController.m
//  whxfj
//
//  Created by 司马帅帅 on 14-8-23.
//  Copyright (c) 2014年 baobin. All rights reserved.
//

#import "DetailViewController.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "ShareViewController.h"

@interface DetailViewController ()<UIWebViewDelegate>
{
    UIWebView *webView;
    MBProgressHUD *HUD;
    ShareViewController *shareViewController;
}
@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        shareViewController = [[ShareViewController alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
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
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [shareButton setFrame:CGRectMake(0, 0, 30, 30)];
    [shareButton setBackgroundImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
    [shareButton setBackgroundImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateHighlighted];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    if (isIos7System) {
        webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, -44-20, self.view.frame.size.width, self.view.frame.size.height)];
    } else {
        webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, -44-20, self.view.frame.size.width, self.view.frame.size.height+20)];
    }
    webView.delegate = self;
    [self.view addSubview:webView];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrlString]]];
    
    NSLog(@"webUrl %@", self.webUrlString);

}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)share
{
    shareViewController.webUrlString = self.webUrlString;
    shareViewController.titleString = self.titleString;
    if ([self isConnectionAvailable]) {
        [shareViewController showShareViewInView:self.view];
    } else {
        [self show:MBProgressHUDModeText message:@"当前网络不可用，不能进行分享！" customView:nil];
        [self hiddenHUDShort];
    }
}

//判断网络连接是否正常
- (BOOL)isConnectionAvailable {
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            NSLog(@"网络状态 notReachable");
            isExistenceNetwork = NO;
            break;
        case ReachableViaWiFi:
            NSLog(@"网络状态 WIFI");
            isExistenceNetwork = YES;
            break;
        case ReachableViaWWAN:
            NSLog(@"网络状态 3G");
            isExistenceNetwork = YES;
            break;
    }
    return isExistenceNetwork;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark HUD
//展示HUD
- (void)show:(MBProgressHUDMode)mode_ message:(NSString *)message_ customView:(id)customView_
{
    HUD = [[MBProgressHUD alloc] initWithView:[[UIApplication sharedApplication] keyWindow]];
    [self.navigationController.view addSubview:HUD];
    HUD.mode = mode_;
    HUD.customView = customView_;
    HUD.animationType = MBProgressHUDAnimationZoom;
    HUD.labelText = message_;
    [HUD show:YES];
}

//隐藏HUD 时间短
- (void)hiddenHUDShort
{
    [HUD hide:YES afterDelay:0.5f];
}

#pragma mark UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self show:MBProgressHUDModeIndeterminate message:nil customView:nil];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hiddenHUDShort];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hiddenHUDShort];
}
@end
