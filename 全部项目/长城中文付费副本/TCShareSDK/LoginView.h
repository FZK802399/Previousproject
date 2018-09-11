//
//  LoginView.h
//  TCShare
//
//  Created by Heramerom on 13-8-13.
//  Copyright (c) 2013年 Duke Douglas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginView : UIView
{
    UIWebView *_webView;
    UIButton *_closeButton;
    UIView *_modalBackgroundView;
    UIActivityIndicatorView *_indicatorView;
    UIInterfaceOrientation _previousOrientation;
}

@property (nonatomic, strong) UIWebView *webView;


- (void)show;

- (void)showWithURL:(NSURL *)url;

- (void)hide;

@end
