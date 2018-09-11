//
//  TCShareSDK.m
//  TCShare
//
//  Created by Heramerom on 13-8-12.
//  Copyright (c) 2013年 Duke Douglas. All rights reserved.
//

#import "TCShareSDK.h"
#import "TCWeiboConfig.h"
#import "GetIPAddress.h"
#import "LoginView.h"

@implementation TCShareSDK

@synthesize nickname = _nickname;
@synthesize accessToken = _accessToken;
@synthesize name = _name;
@synthesize refreshToken = _refreshToken;
@synthesize expireTime = _expireTime;
@synthesize openID = _openID;


- (void)dealloc
{
    [_nickname release]; _nickname = nil;
    [_accessToken release]; _accessToken = nil;
    [_name release]; _name = nil;
    [_refreshToken release]; _refreshToken = nil;
    [_openID release]; _openID = nil;
    [_openKey release]; _openKey = nil;
    
    [super dealloc];
}

- (id)initWithWebView:(UIWebView *)aLoginWeb
{
    if (self = [super init])
    {
        [aLoginWeb setDelegate:self];
    }
    return self;
}

- (id)init
{
    if (self = [super init])
    {
        [self loadTokenInfos];
    }
    return self;
}

- (id)initWithDelegate:(id<TCWeiboShareDelegate>)aDelegate
{
    if (self = [super init])
    {
        _delegate = aDelegate;
        [self loadTokenInfos];
    }
    return self;
}

- (void)loginOnWebView:(UIWebView *)aLoginWeb
{
//    if ([self weiboHasAreadyLogin])
//    {
//        return;
//    }
    if (aLoginWeb == nil)
    {
        [self login];
    }
    else
    {
        NSString *string = [NSString stringWithFormat:@"%@?appfrom=ios&response_type=token&redirect_uri=%@&htmlVersion=1&client_id=%@",kWBAuthorizeURL, TCRedirectURI, TCAPPKey];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:string]];
        [aLoginWeb setDelegate:self];
        [aLoginWeb loadRequest:request];
    }
}

- (void)login
{
    _loginView = [[LoginView alloc] init];
    [_loginView.webView setDelegate:self];
    NSString *string = [NSString stringWithFormat:@"%@?appfrom=ios&response_type=token&redirect_uri=%@&htmlVersion=1&client_id=%@",kWBAuthorizeURL, TCRedirectURI, TCAPPKey];
    [_loginView showWithURL:[NSURL URLWithString:string]];
}

- (void)logout
{
    self.accessToken = nil;
    self.name = nil;
    self.refreshToken = nil;
    self.openID = nil;
    self.expireTime =0;
    self.openKey = nil;
    
    [self deleteTokenInfos];
}

- (void)shareWithMessage:(NSString *)aMessage
{
    if (![self weiboHasAreadyLogin])
    {
        return;
    }
    NSString *postString = [NSString stringWithFormat:@"format=json&content=%@&oauth_consumer_key=%@&access_token=%@&openid=%@&clientip=%@&oauth_version=2.a&scope=all", aMessage, TCAPPKey, self.accessToken, self.openID, [self getIPAddress]];
    NSData *data = [postString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *urlStr = [NSString stringWithFormat:@"https://open.t.qq.com/api/t/add"];
    NSURL *url = [[NSURL alloc] initWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPBody:data];
    [request setHTTPMethod:@"POST"];
    [url release];
    if (_connection != nil)
    {
        return;
    }
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)shareWithMessage:(NSString *)aMessage andPic:(NSData *)picData
{
    if (![self weiboHasAreadyLogin])
    {
        return;
    }
    NSString *url = [NSString stringWithFormat:@"https://open.t.qq.com/api/t/add_pic?scope=all&clientip=%@&oauth_version=2.a&access_token=%@&oauth_consumer_key=%@&openid=%@", [self getIPAddress], self.accessToken, TCAPPKey, self.openID];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
														   cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
													   timeoutInterval:180.0f];
    [request setHTTPMethod:@"POST"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", kRequestStringBoundary];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[self postBodyWithMessage:aMessage andPic:picData]];
    
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (NSData *)postBodyWithMessage:(NSString *)aMessage andPic:(NSData *)aPic
{
    NSString *bodyPrefixString = [NSString stringWithFormat:@"--%@\r\n", kRequestStringBoundary];
    NSString *bodySuffixString = [NSString stringWithFormat:@"\r\n--%@--\r\n", kRequestStringBoundary];
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[bodyPrefixString dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *string = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n",@"appfrom", kAppFrom];
    [body appendData:[string dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[bodyPrefixString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *content = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n", @"content", aMessage];
    [body appendData:[content dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[bodyPrefixString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *clientip = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n", @"clientip", [self getIPAddress]];
    [body appendData:[clientip dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[bodyPrefixString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *format = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n", @"format", @"json"];
    [body appendData:[format dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[bodyPrefixString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *compatibleflag = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n", @"compatibleflag", @"0"];
    [body appendData:[compatibleflag dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[bodyPrefixString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *picString = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\";filename=\"%@\"\r\n", @"pic", aPic];
    [body appendData:[picString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[@"Content-Type:\"image/jpeg\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:aPic];
    [body appendData:[bodySuffixString dataUsingEncoding:NSUTF8StringEncoding]];
    
    return body;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _responseData = [[NSMutableData alloc] initWithCapacity:10];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSString *string = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    [_delegate shareFinishedWithResult:string];
    [string release];
    
    [_connection release];
    _connection = nil;
    [_responseData release];
    _responseData = nil;
}

- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error
{
    [_delegate shareFaildWithError:error];
}

#pragma mark -
#pragma mark web view delegate method
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = [[NSString alloc] initWithString:request.URL.absoluteString];
    NSRange range = [urlString rangeOfString:@"access_token="];
    if (range.location != NSNotFound){
        NSRange scope = [urlString rangeOfString:@"#"];
        NSString *code = [urlString substringFromIndex:scope.location + scope.length];
        [_loginView hide];
        [self saveAccessTokenInfo:code];
        [_delegate weiboWasSuccessLogin];
        return NO;
    }
    [urlString release];
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


// 存储刷新accesstoken信息
- (void)saveAccessTokenInfo:(NSString *)code{
    NSDictionary *accessDic = [self createDicforAccesstoken:code];
    if ([accessDic objectForKey:@"errorCode"] == nil) {
        self.accessToken = [accessDic objectForKey:@"access_token"];
        self.expireTime = [[accessDic objectForKey:@"expires_in"] intValue]+[[NSDate date] timeIntervalSince1970];
        self.name = [accessDic objectForKey:@"name"];
        self.refreshToken = [accessDic objectForKey:@"refresh_token"];
        if ([accessDic objectForKey:@"openid"] != nil) {
            self.openID = [accessDic objectForKey:@"openid"];
        }
        if ([accessDic objectForKey:@"openkey"] != nil) {
            self.openKey = [accessDic objectForKey:@"openkey"];
        }
        if ([accessDic objectForKey:@"nick"] != nil)
        {
            self.nickname = [accessDic objectForKey:@"nick"];
        }
    }
    [self storeTokenInfos];
}

//创建字典存储返回信息
- (NSDictionary *)createDicforAccesstoken:(NSString *)returnString{
    NSMutableDictionary *accessDic = [[NSMutableDictionary alloc] initWithCapacity:6];
    NSArray *returnArray = [[NSArray alloc] initWithArray:[returnString componentsSeparatedByString:@"&"]];
    for (int i = 0; i < [returnArray count]; i++) {
        NSArray *array = [[returnArray objectAtIndex:i] componentsSeparatedByString:@"="];
        [accessDic setObject:[array objectAtIndex:1]forKey:[array objectAtIndex:0]];
    }
    [returnArray release];
    return [accessDic autorelease];
}

- (NSString *)getIPAddress
{
    InitAddresses();
    GetIPAddresses();
    GetHWAddresses();
    return [NSString stringWithFormat:@"%s", ip_names[1]];
}

- (void)storeTokenInfos
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setValue:self.name forKey:kName];
    [userDefault setValue:self.nickname forKey:kNickname];
    [userDefault setValue:self.accessToken forKey:kAccessToken];
    [userDefault setValue:self.refreshToken forKey:kRefreshToken];
    [userDefault setValue:self.openKey forKey:kOpenKey];
    [userDefault setValue:self.openID forKey:kOpenID];
    [userDefault setDouble:self.expireTime forKey:kExpiresIn];
    [userDefault synchronize];
}

- (void)deleteTokenInfos
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:kName];
    [userDefault removeObjectForKey:kNickname];
    [userDefault removeObjectForKey:kAccessToken];
    [userDefault removeObjectForKey:kRefreshToken];
    [userDefault removeObjectForKey:kOpenID];
    [userDefault removeObjectForKey:kOpenKey];
    [userDefault removeObjectForKey:kExpiresIn];
    [userDefault synchronize];
}

- (BOOL)isAuthorizeExpired
{
    if ([[NSDate date] timeIntervalSince1970] > self.expireTime){
        [self deleteTokenInfos];
        return YES;
    }
    return NO;
}

- (BOOL)weiboHasAreadyLogin
{
    if ([self isAuthorizeExpired])
    {
        return NO;
    }
    return YES;
}

- (void)loadTokenInfos
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    self.name = [userDefault stringForKey:kName];
    self.nickname = [userDefault stringForKey:kNickname];
    self.accessToken = [userDefault stringForKey:kAccessToken];
    self.refreshToken = [userDefault stringForKey:kRefreshToken];
    self.expireTime = [userDefault doubleForKey:kExpiresIn];
    self.openID = [userDefault stringForKey:kOpenID];
    self.openKey = [userDefault stringForKey:kOpenKey];
}

@end
