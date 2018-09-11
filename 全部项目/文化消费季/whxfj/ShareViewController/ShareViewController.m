//
//  ShareViewController.m
//  MSSideBarMenu
//
//  Created by baobin on 14-3-4.
//  Copyright (c) 2014年 baobin. All rights reserved.
//

#import "ShareViewController.h"
#import <MessageUI/MessageUI.h>
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "WeiXinViewController.h"
#import "QQViewController.h"

#define SHARE_OPAQUE_BLACK_COLOR [UIColor colorWithRed:1.0/255.0 green:1.0/255.0 blue:1.0/255.0 alpha:0.5f]
#define SHARE_CONTENT_WHITE_COLOR [UIColor colorWithRed:239.0/255.0f green:239.0/255.0f blue:239.0/255.0f alpha:1.0f]
#define SHARE_CONTENT_HEIGHT 250

@interface ShareViewController () <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, WeiXinShareDelegate, UIGestureRecognizerDelegate>
{
    UIView *shareMenuContentView;//用来承载分享菜单的视图
    MBProgressHUD *HUD;
    
    WeiXinViewController *weixinViewController;
    QQViewController *qqViewController;
}
@end

@implementation ShareViewController

- (void)dealloc
{
    NSLog(@"ShareViewController dealloc");
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//展示shareView
- (void)showShareViewInView:(UIView *)view_
{
    [view_.window addSubview:self.view];
    [UIView setAnimationsEnabled:YES];
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.view.backgroundColor = SHARE_OPAQUE_BLACK_COLOR;
                         [shareMenuContentView setFrame:CGRectMake(0, self.view.bounds.size.height-SHARE_CONTENT_HEIGHT, self.view.bounds.size.width, SHARE_CONTENT_HEIGHT)];
                     }
                     completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    
    //给self.view添加tapGesture手势 激发dismiss
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    
    //初始化shareMenuContentView
    shareMenuContentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, SHARE_CONTENT_HEIGHT)];
    UITapGestureRecognizer *tapGestureDoNothing = [[UITapGestureRecognizer alloc] init];
    tapGestureDoNothing.delegate = self;
    [shareMenuContentView addGestureRecognizer:tapGestureDoNothing];
    shareMenuContentView.backgroundColor = SHARE_CONTENT_WHITE_COLOR;
    [self.view addSubview:shareMenuContentView];
    
    UILabel *shareMenuLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
    [shareMenuLabel setBackgroundColor:[UIColor clearColor]];
    [shareMenuLabel setText:@"分享旅拍"];
    [shareMenuLabel setFont:[UIFont systemFontOfSize:15]];
    [shareMenuLabel setTextColor:[UIColor blackColor]];
    [shareMenuLabel setTextAlignment:NSTextAlignmentCenter];
    [shareMenuContentView addSubview:shareMenuLabel];
    
    UIImage *shareMenuFootImage = [UIImage imageNamed:@"ShareMenuFooter_light.png"];
    UIImageView *shareMenuFootView = [[UIImageView alloc] initWithFrame:CGRectMake(0, shareMenuContentView.frame.size.height-shareMenuFootImage.size.height, shareMenuContentView.frame.size.width, shareMenuFootImage.size.height)];
    [shareMenuFootView setUserInteractionEnabled:YES];
    [shareMenuFootView setImage:shareMenuFootImage];
    [shareMenuContentView addSubview:shareMenuFootView];
    
    //添加取消按钮
    UIImage *shareMenuCancelImageNormal = [UIImage imageNamed:@"ShareMenuCancel_light_normal.png"];
    UIImage *shareMenuCancelImageSelected = [UIImage imageNamed:@"ShareMenuCancel_light_selected.png"];
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setFrame:CGRectMake(10, 10, shareMenuFootView.frame.size.width-10-10, shareMenuFootView.frame.size.height-10-10)];
    [cancelButton setBackgroundImage:[shareMenuCancelImageNormal stretchableImageWithLeftCapWidth:10 topCapHeight:0]forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:[shareMenuCancelImageSelected stretchableImageWithLeftCapWidth:10 topCapHeight:0]forState:UIControlStateHighlighted];
    [cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [shareMenuFootView addSubview:cancelButton];
    
    //初始化分享控制器
    [self initShareViewController];
    
    //初始化分享按钮
    [self initShareButtons];
}

//初始化分享控制器
- (void)initShareViewController
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    //初始化weixinViewController
    weixinViewController = delegate.weixinViewController;
    weixinViewController.delegate = self;
    
    //初始化qqViewController
    qqViewController = delegate.qqViewController;
}

//初始化分享按钮
- (void)initShareButtons
{
    NSArray *platforms = @[SOCIAL_SHARE_PLATFORM_WEIXIN,
                           SOCIAL_SHARE_PLATFORM_WEIXIN_TIMELINE,
                           SOCIAL_SHARE_PLATFORM_QQ,
                           SOCIAL_SHARE_PLATFORM_EMAIL,
                           SOCIAL_SHARE_PLATFORM_SMS,
                           SOCIAL_SHARE_PLATFORM_COPY];
    
    for (int i=0; i<platforms.count; i++) {
        //初始化透明的背景视图backView用来确定分享按钮的中心点坐标
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0+i%4*80, 10+i/4*80, 80, 80)];
        [backView setBackgroundColor:[UIColor clearColor]];
        [shareMenuContentView addSubview:backView];
        
        //根据platform获得相应的分享按钮 和 分享按钮标签
        NSString *platform = [platforms objectAtIndex:i];
        UIButton *button = [self getShareButtonWithPlatform:platform];
        UILabel *buttonLabel = [self getShareButtonLabelWithPlatform:platform];
        
        [backView addSubview:buttonLabel];
        [button setCenter:backView.center];
        [shareMenuContentView addSubview:button];
    }
}

//根据platform获得相应的分享按钮
- (UIButton *)getShareButtonWithPlatform:(NSString *)platform
{
    UIImage *sinaweiboIconImageNormal = [UIImage imageNamed:@"SocialSharePlatformIcon_sinaweibo.png"];
    UIImage *sinaweiboIconImageHighlight = [UIImage imageNamed:@"SocialSharePlatformIcon_sinaweibo_night.png"];
    UIImage *tencentweiboIconImageNormal = [UIImage imageNamed:@"SocialSharePlatformIcon_qqweibo.png"];
    UIImage *tencentweiboIconImageHighlight = [UIImage imageNamed:@"SocialSharePlatformIcon_qqweibo_night.png"];
    UIImage *weixinIconImageNormal = [UIImage imageNamed:@"SocialSharePlatformIcon_weixin.png"];
    UIImage *weixinIconImageHighlight = [UIImage imageNamed:@"SocialSharePlatformIcon_weixin_night.png"];
    UIImage *weixinTimelineIconImageNormal = [UIImage imageNamed:@"SocialSharePlatformIcon_weixinTimeline.png"];
    UIImage *weixinTimelineIconImageHighlight = [UIImage imageNamed:@"SocialSharePlatformIcon_weixinTimeline_night.png"];
    UIImage *qqIconImageNormal = [UIImage imageNamed:@"SocialSharePlatformIcon_qqfriend.png"];
    UIImage *qqIconImageHighlight = [UIImage imageNamed:@"SocialSharePlatformIcon_qqfriend_night.png"];
    UIImage *emailIconImageNormal = [UIImage imageNamed:@"SocialSharePlatformIcon_email.png"];
    UIImage *emailIconImageHighlight = [UIImage imageNamed:@"SocialSharePlatformIcon_email_night.png"];
    UIImage *smsIconImageNormal = [UIImage imageNamed:@"SocialSharePlatformIcon_sms.png"];
    UIImage *smsIconImageHighlight = [UIImage imageNamed:@"SocialSharePlatformIcon_sms_night.png"];
    UIImage *copyIconImageNormal = [UIImage imageNamed:@"SocialSharePlatformIcon_copy.png"];
    UIImage *copyIconImageHighlight = [UIImage imageNamed:@"SocialSharePlatformIcon_copy_night.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([platform isEqualToString:SOCIAL_SHARE_PLATFORM_SINAWEIBO]) {
        [button setBackgroundImage:sinaweiboIconImageNormal forState:UIControlStateNormal];
        [button setBackgroundImage:sinaweiboIconImageHighlight forState:UIControlStateHighlighted];
        [button setTitle:SOCIAL_SHARE_PLATFORM_SINAWEIBO forState:UIControlStateNormal];
    } else if ([platform isEqualToString:SOCIAL_SHARE_PLATFORM_TENCENTWEIBO]) {
        [button setBackgroundImage:tencentweiboIconImageNormal forState:UIControlStateNormal];
        [button setBackgroundImage:tencentweiboIconImageHighlight forState:UIControlStateHighlighted];
        [button setTitle:SOCIAL_SHARE_PLATFORM_TENCENTWEIBO forState:UIControlStateNormal];
    } else if ([platform isEqualToString:SOCIAL_SHARE_PLATFORM_WEIXIN]) {
        [button setBackgroundImage:weixinIconImageNormal forState:UIControlStateNormal];
        [button setBackgroundImage:weixinIconImageHighlight forState:UIControlStateHighlighted];
        [button setTitle:SOCIAL_SHARE_PLATFORM_WEIXIN forState:UIControlStateNormal];
    } else if ([platform isEqualToString:SOCIAL_SHARE_PLATFORM_WEIXIN_TIMELINE]) {
        [button setBackgroundImage:weixinTimelineIconImageNormal forState:UIControlStateNormal];
        [button setBackgroundImage:weixinTimelineIconImageHighlight forState:UIControlStateHighlighted];
        [button setTitle:SOCIAL_SHARE_PLATFORM_WEIXIN_TIMELINE forState:UIControlStateNormal];
    } else if ([platform isEqualToString:SOCIAL_SHARE_PLATFORM_QQ]) {
        [button setBackgroundImage:qqIconImageNormal forState:UIControlStateNormal];
        [button setBackgroundImage:qqIconImageHighlight forState:UIControlStateHighlighted];
        [button setTitle:SOCIAL_SHARE_PLATFORM_QQ forState:UIControlStateNormal];
    } else if ([platform isEqualToString:SOCIAL_SHARE_PLATFORM_EMAIL]) {
        [button setBackgroundImage:emailIconImageNormal forState:UIControlStateNormal];
        [button setBackgroundImage:emailIconImageHighlight forState:UIControlStateHighlighted];
        [button setTitle:SOCIAL_SHARE_PLATFORM_EMAIL forState:UIControlStateNormal];
    } else if ([platform isEqualToString:SOCIAL_SHARE_PLATFORM_SMS]) {
        [button setBackgroundImage:smsIconImageNormal forState:UIControlStateNormal];
        [button setBackgroundImage:smsIconImageHighlight forState:UIControlStateHighlighted];
        [button setTitle:SOCIAL_SHARE_PLATFORM_SMS forState:UIControlStateNormal];
    } else if ([platform isEqualToString:SOCIAL_SHARE_PLATFORM_COPY]) {
        [button setBackgroundImage:copyIconImageNormal forState:UIControlStateNormal];
        [button setBackgroundImage:copyIconImageHighlight forState:UIControlStateHighlighted];
        [button setTitle:SOCIAL_SHARE_PLATFORM_COPY forState:UIControlStateNormal];
    }
    [button addTarget:self action:@selector(shareButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, sinaweiboIconImageNormal.size.width, sinaweiboIconImageNormal.size.height)];
    [button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor clearColor] forState:UIControlStateHighlighted];
    
    return button;
}

//根据platform获得相应的分享按钮的标签
- (UILabel *)getShareButtonLabelWithPlatform:(NSString *)platform
{
    UILabel *buttonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 80, 20)];
    [buttonLabel setBackgroundColor:[UIColor clearColor]];
    [buttonLabel setTextAlignment:NSTextAlignmentCenter];
    [buttonLabel setFont:[UIFont systemFontOfSize:12]];
    if ([platform isEqualToString:SOCIAL_SHARE_PLATFORM_SINAWEIBO]) {
        [buttonLabel setText:@"新浪微博"];
    } else if ([platform isEqualToString:SOCIAL_SHARE_PLATFORM_TENCENTWEIBO]) {
        [buttonLabel setText:@"腾讯微博"];
    } else if ([platform isEqualToString:SOCIAL_SHARE_PLATFORM_WEIXIN]) {
        [buttonLabel setText:@"微信好友"];
    } else if ([platform isEqualToString:SOCIAL_SHARE_PLATFORM_WEIXIN_TIMELINE]) {
        [buttonLabel setText:@"朋友圈"];
    } else if ([platform isEqualToString:SOCIAL_SHARE_PLATFORM_QQ]) {
        [buttonLabel setText:@"QQ"];
    } else if ([platform isEqualToString:SOCIAL_SHARE_PLATFORM_EMAIL]) {
        [buttonLabel setText:@"邮件"];
    } else if ([platform isEqualToString:SOCIAL_SHARE_PLATFORM_SMS]) {
        [buttonLabel setText:@"短信"];
    } else if ([platform isEqualToString:SOCIAL_SHARE_PLATFORM_COPY]) {
        [buttonLabel setText:@"复制链接"];
    }
    return buttonLabel;
}

//点击分享按钮
- (void)shareButtonPress:(UIButton *)button
{
    NSLog(@"button title %@", button.currentTitle);
    if ([button.currentTitle isEqualToString:SOCIAL_SHARE_PLATFORM_SINAWEIBO]) {
        NSLog(@"分享新浪微博");
       
    } else if ([button.currentTitle isEqualToString:SOCIAL_SHARE_PLATFORM_TENCENTWEIBO]) {
        NSLog(@"分享腾讯微博");
        
    } else if ([button.currentTitle isEqualToString:SOCIAL_SHARE_PLATFORM_WEIXIN]) {
        NSLog(@"分享微信好友");
        [weixinViewController sendWeiXinWithWebUrlString:self.webUrlString andScene:WXSceneSession andTitle:self.titleString];
    } else if ([button.currentTitle isEqualToString:SOCIAL_SHARE_PLATFORM_WEIXIN_TIMELINE]) {
        NSLog(@"分享微信朋友圈");
        
    } else if ([button.currentTitle isEqualToString:SOCIAL_SHARE_PLATFORM_QQ]) {
        NSLog(@"分享QQ");
        [qqViewController sendQQWithWebUrlString:self.webUrlString andTitle:self.titleString];
    } else if ([button.currentTitle isEqualToString:SOCIAL_SHARE_PLATFORM_EMAIL]) {
        NSLog(@"分享邮件");
        //判断是否可以发送Email
        BOOL canSendEmail = [MFMailComposeViewController canSendMail];
        if (canSendEmail) {
            MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];
            NSString *subjectString = [NSString stringWithFormat:@"惠民文化季: %@",self.titleString];
            NSString *bodyString = [NSString stringWithFormat:@"惠民文化季: %@ %@",self.titleString,self.webUrlString];
            [mailComposeViewController setSubject:subjectString];
            [mailComposeViewController setMessageBody:bodyString isHTML:YES];
            [mailComposeViewController setMailComposeDelegate:self];
            [self presentViewController:mailComposeViewController animated:YES completion:nil];
        } else {
            [self show:MBProgressHUDModeText message:@"您的设备没有开通发送邮件的功能" customView:nil];
            [self hiddenHUDLong];
        }
        
    } else if ([button.currentTitle isEqualToString:SOCIAL_SHARE_PLATFORM_SMS]) {
        NSLog(@"分享短信");
        //判断是否可以发送短信
        BOOL canSendMessage = [MFMessageComposeViewController canSendText];
        if (canSendMessage) {
            //创建短信视图控制器
            MFMessageComposeViewController *messageComposeViewController = [[MFMessageComposeViewController alloc] init];
            NSString *bodyString = [NSString stringWithFormat:@"惠民文化季: %@ %@",self.titleString,self.webUrlString];
            [messageComposeViewController setBody:bodyString];
            messageComposeViewController.messageComposeDelegate = self;
            [self presentViewController:messageComposeViewController animated:YES completion:nil];
        } else {
            NSLog(@"您的设备没有发送短信的功能");
            [self show:MBProgressHUDModeText message:@"您的设备没有发送短信的功能" customView:nil];
            [self hiddenHUDLong];
        }
    } else if ([button.currentTitle isEqualToString:SOCIAL_SHARE_PLATFORM_COPY]) {
        NSLog(@"分享复制");
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:self.webUrlString];
        [self show:MBProgressHUDModeText message:@"复制链接成功" customView:nil];
        [self hiddenHUDLong];
    }
}


//隐藏shareView
- (void)dismiss
{
    [UIView setAnimationsEnabled:YES];
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.view.backgroundColor = [UIColor clearColor];
                         [shareMenuContentView setFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, SHARE_CONTENT_HEIGHT)];
                     }
                     completion:^(BOOL finished) {
                         [self.view removeFromSuperview];
                         if (self.delegate && [self.delegate respondsToSelector:@selector(shareViewDismiss)]) {
                             [self.delegate shareViewDismiss];
                         }
                     }];
}

#pragma mark HUD
//展示HUD
- (void)show:(MBProgressHUDMode)mode_ message:(NSString *)message_ customView:(id)customView_
{
    HUD = [[MBProgressHUD alloc] initWithView:[[UIApplication sharedApplication] keyWindow]];
    [self.view addSubview:HUD];
    HUD.mode = mode_;
    HUD.customView = customView_;
    HUD.animationType = MBProgressHUDAnimationZoom;
    HUD.labelText = message_;
    [HUD show:YES];
}

//隐藏HUD
- (void)hiddenHUDShort
{
    [HUD hide:YES afterDelay:0.2f];
}

//隐藏HUD 1.0秒以后
- (void)hiddenHUDLong
{
    [HUD hide:YES afterDelay:2.0f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    return YES;
}

#pragma mark MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"取消发送邮件");
            break;
        case MFMailComposeResultSent:
            NSLog(@"发送邮件成功");
            [self show:MBProgressHUDModeText message:@"发送邮件成功" customView:nil];
            [self hiddenHUDLong];
            break;
        case MFMailComposeResultFailed:
            NSLog(@"发送邮件失败");
            [self show:MBProgressHUDModeText message:@"发送邮件失败" customView:nil];
            [self hiddenHUDLong];
            break;
        case MFMailComposeResultSaved:
            NSLog(@"发送邮件保存");
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
        case MessageComposeResultCancelled:
            NSLog(@"取消发送短信");
            break;
        case MessageComposeResultFailed:
            NSLog(@"发送短信失败");
            [self show:MBProgressHUDModeText message:@"发送短信失败" customView:nil];
            [self hiddenHUDLong];
            break;
        case MessageComposeResultSent:
            NSLog(@"发送短信成功");
            [self show:MBProgressHUDModeText message:@"发送短信成功" customView:nil];
            [self hiddenHUDLong];
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark WeiXinShareDelegate
- (void)weiXinShareSucceed
{
    [self show:MBProgressHUDModeText message:@"分享微信成功" customView:nil];
    [self hiddenHUDLong];
}

- (void)weiXinNotInstall
{
    [self show:MBProgressHUDModeText message:@"您没有安装微信客户端" customView:nil];
    [self hiddenHUDLong];
}

@end
