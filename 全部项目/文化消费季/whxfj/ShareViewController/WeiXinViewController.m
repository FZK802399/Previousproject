//
//  WeiXinViewController.m
//  MSSideBarMenu
//
//  Created by baobin on 14-3-5.
//  Copyright (c) 2014年 baobin. All rights reserved.
//

#import "WeiXinViewController.h"
//#import "WebListInfo.h"

@interface WeiXinViewController ()

@end

@implementation WeiXinViewController

- (void)dealloc
{
    NSLog(@"WeiXinViewController dealloc");
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //注册微信
        [WXApi registerApp:kWXAppID];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)onResp:(BaseResp *)resp
{
    if (resp.errCode == 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(weiXinShareSucceed)]) {
            [self.delegate weiXinShareSucceed];
        }
    }
}

//分享网址
- (void)sendWeiXinWithWebUrlString:(NSString*)webUrlString_ andScene:(int)scene_ andTitle:(NSString *)titleString_
{
    if ([WXApi isWXAppInstalled]) {
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = @"文化消费季";
        message.description = titleString_;
        
        UIImage *thumbImage = [self imageWithImage:[UIImage imageNamed:@"shareicon.png"] scaledToSize:CGSizeMake(114, 114)];
        [message setThumbImage:thumbImage];
        WXWebpageObject *webpageObject = [WXWebpageObject object];
        webpageObject.webpageUrl = webUrlString_;
        
        message.mediaObject = webpageObject;
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = scene_;
        
        [WXApi sendReq:req];
    } else {
        NSLog(@"没安装微信");
        if (self.delegate && [self.delegate respondsToSelector:@selector(weiXinNotInstall)]) {
            [self.delegate weiXinNotInstall];
        }
    }

}

//将image生成尺寸为newSize的新的newImage并且返回
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    //把矩形图片变为正方形图片
    CGRect rect;
    if (image.size.height>image.size.width) {
        rect = CGRectMake(0, (image.size.height-image.size.width)/2, image.size.width, image.size.width);
    } else if (image.size.height<image.size.width) {
        rect = CGRectMake((image.size.width-image.size.height)/2, 0, image.size.height, image.size.height);
    } else {
        rect = CGRectMake(0, 0, image.size.width, image.size.width);
    }
    image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([image CGImage], rect)];

    //把正方形图片变为114*114的图片
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
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

@end
