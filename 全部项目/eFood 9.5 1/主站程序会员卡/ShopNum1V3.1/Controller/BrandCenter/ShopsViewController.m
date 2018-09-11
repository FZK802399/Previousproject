//
//  ShopsViewController.m
//  ShopNum1V3.1
//
//  Created by Mac on 15/5/29.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "ShopsViewController.h"

@interface ShopsViewController () <UIWebViewDelegate>
{
    UIWebView *_webView;
}
@end


@implementation ShopsViewController

//自定义一个webview视图
-(void)loadView
{
    _webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view = _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.shopName;
    [self loadLeftBackBtn];
    //1.加载登录页面(获取未授权的Request Token)  请求授权接口文件
    //https比较安全 http
    NSURL *url = [NSURL URLWithString:self.webSiteUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request]; //加载url地址页面
    
    //2.设置代理
    _webView.delegate = self;
}

#pragma mark - webview的代理方法
#pragma mark - 当webView开始加载请求就会调用
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    //显示指示器
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.labelText = @"正在加载中...";
//    hud.dimBackground = YES; //背景灰色颜色
}

#pragma mark - 当webView请求完毕就会调用的方法
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //请求完毕后隐藏加载器
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
