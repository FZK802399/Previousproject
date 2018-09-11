//
//  OrderPayOnlineViewController.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-9-3.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "OrderPayOnlineViewController.h"
#import "DZYMerchandiseDetailController.h"
#import "ShoppingCartViewController.h"
#import "LimitSaleDetailViewController.h"
#import "AdvanceController.h"
#import "OrderListController.h"
#import "LoadView.h"
@interface OrderPayOnlineViewController ()<NSURLConnectionDelegate,UIWebViewDelegate>
{
    NSURLRequest * originRequest;
}
@property (nonatomic,assign)BOOL isAuthed;
@property (nonatomic,strong)NSURL *currenURL;
@end

@implementation OrderPayOnlineViewController


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
    [self updateLeftBtn];
    
    LoadView * view = [[NSBundle mainBundle]loadNibNamed:@"LoadView" owner:nil options:nil].lastObject;
    view.tag = 99;
    view.frame = self.view.bounds;
    [self.view addSubview:view];
    [view show];
    
    self.navigationItem.title = _str;
    NSURLRequest *request = [NSURLRequest requestWithURL:self.payWebUrl];
    self.payWebView.delegate = self;
    [self.payWebView loadRequest:request];
}

- (void)updateLeftBtn
{
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)back
{
    for (id vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[OrderListController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            if ([vc respondsToSelector:@selector(operationEndWithController:)]) {
                [vc operationEndWithController:self];
            }
            return;
        }
        if ([vc isKindOfClass:[DZYMerchandiseDetailController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
        if ([vc isKindOfClass:[ShoppingCartViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
        if ([vc isKindOfClass:[LimitSaleDetailViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
        if ([vc isKindOfClass:[AdvanceController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        LoadView * view = (LoadView *)[self.view viewWithTag:99];
        [view hide];
    });
}
- (BOOL)webView:(UIWebView *)awebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"%@",request.URL);
    NSString * str = [NSString stringWithFormat:@"%@",request.URL];
    if ([str rangeOfString:@"callback.action"].location != NSNotFound) {
        [self back];
        return NO;
    }
    return YES;
}

//- (BOOL)webView:(UIWebView *)awebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
//{
//    NSString* scheme = [[request URL] scheme];
//    NSLog(@"scheme = %@",scheme);
//    //判断是不是https
//    if ([scheme isEqualToString:@"https"]) {
//        //如果是https:的话，那么就用NSURLConnection来重发请求。从而在请求的过程当中吧要请求的URL做信任处理。
//        if (!self.isAuthed) {
//            originRequest = request;
//            NSURLConnection* conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//            [conn start];
//            [awebView stopLoading];
//            return NO;
//        }
//    }
//
//    NSURL *theUrl = [request URL];
//    self.currenURL = theUrl;
//    return YES;
//}
//
//- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
//{
//    
//    if ([challenge previousFailureCount]== 0) {
//        self.isAuthed = YES;
//        
//        //NSURLCredential 这个类是表示身份验证凭据不可变对象。凭证的实际类型声明的类的构造函数来确定。
//        NSURLCredential* cre = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
//        //告诉服务器客户端信任证书
//        [challenge.sender useCredential:cre forAuthenticationChallenge:challenge];
//    }
//}
//
//- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
//{
//    
//    NSLog(@"%@",request);
//    return request;
//    
//}
//
//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
//{
//    
//    self.isAuthed = YES;
//    //webview 重新加载请求。
//    [self.payWebView loadRequest:originRequest];
//    [connection cancel];
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
