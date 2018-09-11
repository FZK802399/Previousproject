//
//  LoadView.m
//  ShopNum1V3.1
//
//  Created by yons on 16/3/7.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import "LoadView.h"

@interface LoadView ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation LoadView

-(void)show
{
    NSData * data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"123" ofType:@"gif"]];
    self.webView.scalesPageToFit = YES;
    [self.webView loadData:data MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
}

- (void)hide
{
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
