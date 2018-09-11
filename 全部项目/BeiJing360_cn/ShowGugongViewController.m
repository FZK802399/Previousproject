//
//  ShowGugongViewController.m
//  BeiJing360
//
//  Created by Duke Douglas on 13-3-25.
//  Copyright (c) 2013年 __ChuangYiFengTong__. All rights reserved.
//

#import "ShowGugongViewController.h"
#import "ForbiddenCityViewController.h"

@interface ShowGugongViewController ()

@end

@implementation ShowGugongViewController

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
    UIWebView *webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 44)];
    [webview setDelegate:self];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:[self filePath]]];
    [webview loadRequest:request];
    
    [self.view addSubview:webview];
    [webview release];
    webview = nil;
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *string = [[request URL] relativeString];
    if ([string isEqualToString:@"http://quanjingke.com/"])
    {
        ForbiddenCityViewController *forbidden = [[[ForbiddenCityViewController alloc] init] autorelease];
        [self.navigationController pushViewController:forbidden animated:YES];
        return NO;
    }
    return YES;
}
//文件的路径
- (NSString *)filePath
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"tour1" ofType:@"html"];
    NSLog(@"path = %@",path);
    return  path;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
