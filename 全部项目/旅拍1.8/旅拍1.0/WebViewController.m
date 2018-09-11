//
//  WebViewController.m
//  旅拍1.0
//
//  Created by 司马帅帅 on 15/7/15.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import "WebViewController.h"
#import "WebInfo.h"

@interface WebViewController ()
{
    WebInfo *_webInfo;
    UIWebView *_webView;
    WebViewType _webViewType;
}
@end

@implementation WebViewController

- (id)initWithWebInfo:(WebInfo *)webInfo webViewType:(WebViewType)webViewType
{
    self = [super init];
    if (self) {
        _webInfo = webInfo;
        _webViewType = webViewType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设置navigationbar
    [self setNavigationBar];
    
    //添加网页视图
    [self addWebView];
}

//设置navigationbar
- (void)setNavigationBar
{
    //设置navigationbar的title颜色
    NSDictionary *dictionary = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self.navigationController.navigationBar setTitleTextAttributes:dictionary];
    
    //设置navigationBar背景图片
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"lp_nav_purple.png"] forBarMetrics:UIBarMetricsDefault];
    
    //添加返回按钮
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"lp_nav_goback.png"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    //设置navigationbar上的按钮颜色
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

//添加网页视图
- (void)addWebView
{
    CGRect frame = self.view.frame;
    frame.size.height = frame.size.height-44-20;
    _webView = [[UIWebView alloc] initWithFrame:frame];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_webInfo.webUrl]]];
    [self.view addSubview:_webView];
}

//返回
- (void)back
{
    if (_webViewType == WEBVIEW_TYPE_POST) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
