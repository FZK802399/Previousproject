//
//  TCShareSDK.h
//  TCShare
//
//  Created by Heramerom on 13-8-12.
//  Copyright (c) 2013年 Duke Douglas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginView.h"

@protocol TCWeiboShareDelegate <NSObject>

@optional
- (void)weiboWasSuccessLogin;
- (void)weiboWasFaildLogin;

- (void)shareFinishedWithResult:(NSString *)result;
- (void)shareFaildWithError:(NSError *)error;

@end


@interface TCShareSDK : NSObject<UIWebViewDelegate, NSURLConnectionDataDelegate, NSURLConnectionDelegate>
{
    NSURLConnection *_connection;
    NSMutableData *_responseData;
    
    NSOperationQueue *_requestQueue;
    LoginView *_loginView;
}

@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *refreshToken;
@property (nonatomic, strong) NSString *openID;
@property (nonatomic, assign) double expireTime;
@property (nonatomic, strong) NSString *openKey;

@property (nonatomic, strong) UIWebView *loginWeb;
@property (nonatomic, assign) id<TCWeiboShareDelegate> delegate;

- (id)initWithWebView:(UIWebView *)aLoginWeb;

- (void)loginOnWebView:(UIWebView *)aLoginWeb;

- (id)initWithDelegate:(id<TCWeiboShareDelegate>)aDelegate;

- (void)login;
- (void)logout;

- (BOOL)isAuthorizeExpired;

- (BOOL)weiboHasAreadyLogin;

- (void)shareWithMessage:(NSString *)aMessage;

- (void)shareWithMessage:(NSString *)aMessage andPic:(NSData *)picData;


@end
