//
//  QQViewController.m
//  MSSideBarMenu
//
//  Created by baobin on 14-3-6.
//  Copyright (c) 2014年 baobin. All rights reserved.
//

#import "QQViewController.h"
//#import "WebListInfo.h"

@interface QQViewController ()<TencentSessionDelegate>
{
    TencentOAuth *tencentOAuth;
}
@end

@implementation QQViewController

- (void)dealloc
{
    NSLog(@"QQViewController dealloc");
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //注册QQ
        tencentOAuth = [[TencentOAuth alloc] initWithAppId:kQQAppID andDelegate:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

//分享链接
- (void)sendQQWithWebUrlString:(NSString*)webUrlString_ andTitle:(NSString *)titleString_
{
    NSURL *url = [NSURL URLWithString:webUrlString_];
    NSString *title = @"文化消费季";
    NSString *description = titleString_;
    
    QQApiObject *newsObj = [QQApiNewsObject objectWithURL:url title:title description:description previewImageData:UIImagePNGRepresentation([UIImage imageNamed:@"shareicon"]) targetContentType:QQApiURLTargetTypeNews];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    QQApiSendResultCode send = [QQApiInterface sendReq:req];
    
    [self handSendResult:send];
}

////分享链接
//- (void)sendQQWithWebListInfo:(WebListInfo *)webListInfo_
//{
//    NSURL *url = [NSURL URLWithString:webListInfo_.webUrl];
//    NSURL *imageUrl = [NSURL URLWithString:webListInfo_.webImageUrl];
//    NSString *title = webListInfo_.webTitle;
//    
//    NSString *description;
//    
//    if (![self isBlankString:[USER_DEFAULT objectForKey:@"UserName"]]) {
//        description = [NSString stringWithFormat:@"%@的旅拍(%@幅照片)\n时间:%@\n来自旅拍",[USER_DEFAULT objectForKey:@"UserName"], webListInfo_.imageCount, webListInfo_.shareWebDateline];
//    } else {
//        description = [NSString stringWithFormat:@"旅拍(%@幅照片)\n时间:%@\n来自旅拍", webListInfo_.imageCount, webListInfo_.shareWebDateline];
//    }
//    
//    
//    QQApiObject *newsObj = [QQApiNewsObject objectWithURL:url title:title description:description previewImageURL:imageUrl targetContentType:QQApiURLTargetTypeNews];
//    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
//    QQApiSendResultCode send = [QQApiInterface sendReq:req];
//    
//    [self handSendResult:send];
//}

- (void)handSendResult:(QQApiSendResultCode)sendResult
{
    NSLog(@"send Result %d",sendResult);
    switch (sendResult) {
        case EQQAPISENDSUCESS:
            NSLog(@"QQ发送成功");
            break;
        case EQQAPISENDFAILD:
            NSLog(@"QQ发送失败");
            break;
        case EQQAPIQQNOTINSTALLED:
            NSLog(@"未安装QQ");
            break;
        default:
            break;
    }
}

//判断一个字符串是否为空 或者 只含有空格
- (BOOL)isBlankString:(NSString *)string
{
    if (string == nil) {
        return YES;
    }
    if (string == NULL) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        return YES;
    }
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tencentDidLogin
{
    NSLog(@"tencentDidLogin");
}

- (void)tencentDidNotLogin:(BOOL)cancelled
{
    NSLog(@"tencentDidNotLogin");
}

- (void)tencentDidNotNetWork
{
    NSLog(@"tencentDidNotNetWork");
}
@end
