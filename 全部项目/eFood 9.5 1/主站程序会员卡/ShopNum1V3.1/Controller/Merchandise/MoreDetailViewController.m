//
//  MoreDetailViewController.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-25.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "MoreDetailViewController.h"
#import "LoadView.h"
@interface MoreDetailViewController ()<UIWebViewDelegate>

@end

@implementation MoreDetailViewController

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
    LoadView * view = [[NSBundle mainBundle]loadNibNamed:@"LoadView" owner:nil options:nil].lastObject;
    view.tag = 99;
    view.frame = self.view.bounds;
    [self.view addSubview:view];
    [view show];
    
//    self.title = @"商品详情";
    
    //webView  显示商品详细
    self.detailWebView.scalesPageToFit = NO;
    self.detailWebView.delegate = self;
    if (self.htmlStr.length > 0) {
        [self.detailWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.htmlStr]]];
    }else{
//        [self showAlertWithMessage:@"无手机版本的详情"];
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        LoadView * view = (LoadView *)[self.view viewWithTag:99];
        [view hide];
    });
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

@end
