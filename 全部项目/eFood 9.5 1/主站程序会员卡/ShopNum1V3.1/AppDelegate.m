//
//  AppDelegate.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-4.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

/// ShareSDK
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//＝＝＝＝＝＝＝＝＝＝以下是各个平台SDK的头文件，根据需要继承的平台添加＝＝＝
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//以下是腾讯SDK的依赖库：
//libsqlite3.dylib

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"
/// ShareSDK

#import "AppDelegate.h"
#import "AppSignModel.h"
#import "BaseViewController.h"
#import "YMJNewfeatureViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "payRequsestHandler.h"
#import <QuartzCore/QuartzCore.h>
#import "AFNetworking.h"
#define kWechatAppID        @"wxc6fcf960b628e80d"
#define kWechatAppSecret    @"eba1f757daac9ad6a6321ce894560c45"

#define kQQAppID            @"1105107663"
#define kQQAPPKEY           @"daXh3Gj3d0u5ivn4"

#define kSinaAppID          @"2386890754"
#define kSinaAPPSecret      @"debd3b9fa1414745afed4ed48e453896"
#define kSinaAPPRedirectUri @"http://www.efood7.com"
#define kSinaAPPCancelRedirectUri @"http://www.efood7.com"


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    _appConfig = [AppConfig sharedAppConfig];
    [self chooseRootViewController];
    //在程序启动的时候状态栏隐藏,启动后显示状态栏的方法
    [application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
#pragma mark - 微信注册
    //向微信注册
    [self registeredWechat];
    // 配置导航栏
    [self setupNavigationBar];
    // 配置工具栏
    [self setupTabBar];
    // 配置分享功能
    [self setupShareSDK];
    // 配置环信环境
    [self setupEaseMobApplication:application launchOptions:launchOptions];

    
    
   
//    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
//    NSDictionary *myDic = [userDefaultes dictionaryForKey:@"dict"];
//    NSString *t =myDic[@"_t"];
//    if ([t length]>0) {
//        NSDictionary *dic=@{@"_t":myDic[@"_t"]};
//        [AFNetWorkingClient PostTheDataFromServer:@"server/portal/session/current.json" parameters:dic success:^(id responseObject) {
//            NSLog(@"ninininininininininininin=%@",responseObject);
//            NSInteger code=[responseObject[@"code"]integerValue];
//            
//            if  (code==200)
//            {
//                Session *session = [Session GetInstance];
//                session.dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:myDic[@"_t"],responseObject[@"data"][@"id"], responseObject[@"data"][@"name"],responseObject[@"data"][@"mobile"],responseObject[@"data"][@"mobileConfirm"],responseObject[@"data"][@"type"],nil] forKeys:[NSArray arrayWithObjects:@"_t",@"id", @"name",@"mobile",@"mobileConfirm",@"type",nil]];
//                
//                ApplicationDelegate.loginDic = session.dict;
//                NSLog(@"-----5555556666677777=%@",ApplicationDelegate.loginDic);
//            }
//        } failure:^(NSError *error) {
//            
//        }];
//    }
   
    
    
    return YES;
}

- (void)setupEaseMobApplication:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions {
    
    //registerSDKWithAppKey:注册的appKey，详细见下面注释。
    //apnsCertName:推送证书名(不需要加后缀)，详细见下面注释。EFOOD7_Deve  EFOOD7_Push
  //[[EaseMob sharedInstance] registerSDKWithAppKey:@"shanghaisenhong#food7" apnsCertName:@"EFOOD7"];
    [[EaseMob sharedInstance] registerSDKWithAppKey:@"shanghaisenhong#food7" apnsCertName:@"shengchan" otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:NO]}];//最后这个参数为是否打印LOG
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    //iOS8 注册APNS
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge |
        UIUserNotificationTypeSound |
        UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    }
    else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
}

- (void)setupNavigationBar {
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithWhite:0.205 alpha:1.000]];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"baisebeijing"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    self.window.clipsToBounds = YES;
    
    
    ///导航栏返回的背景图片 bg_goback.png
    UIImage *backImg = [[UIImage imageNamed:@"back"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backImg
                                                      forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-20, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    NSDictionary *barAttributes = [NSDictionary dictionaryWithObjectsAndKeys:FONT_BLACK,NSForegroundColorAttributeName,
                                   [UIFont systemFontOfSize:15.0f],NSFontAttributeName, nil];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:barAttributes forState:UIControlStateNormal];
    
    NSDictionary *barTitleAttributes = [NSDictionary dictionaryWithObjectsAndKeys:FONT_BLACK,NSForegroundColorAttributeName,
                                        [UIFont boldSystemFontOfSize:17.0f],NSFontAttributeName, nil];
    
    [[UINavigationBar appearance] setTitleTextAttributes:barTitleAttributes];
    
}

- (void)setupTabBar {
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor barTitleColor]];

    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor barTitleColor],NSForegroundColorAttributeName,
                                                       nil]
                                             forState:UIControlStateSelected];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor colorWithRed:0.369 green:0.392 blue:0.427 alpha:1.000],NSForegroundColorAttributeName,
                                                       nil]
                                             forState:UIControlStateNormal];
}

- (void)setupShareSDK {
    [ShareSDK registerApp:@"f699a8a6d7d0"
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ),]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:kSinaAppID
                                           appSecret:kSinaAPPSecret
                                         redirectUri:kSinaAPPRedirectUri
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:kWechatAppID
                                       appSecret:kWechatAppSecret];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:kQQAppID
                                      appKey:kQQAPPKEY
                                    authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
}

#pragma mark - 判断是否出现版本新特性
-(void) chooseRootViewController {
    //此为找到plist文件中得版本号suo'dui所对应的键
    NSString *key = (NSString *)kCFBundleVersionKey;
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"alreadyUsings"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"alreadyUsings"];
        // 1.从plist中取出版本号
        NSString *lastVersion = [NSBundle mainBundle].infoDictionary[key];
        [[NSUserDefaults  standardUserDefaults] setObject:lastVersion forKey:key];
        [[NSUserDefaults  standardUserDefaults] synchronize];
        self.window.rootViewController = [[YMJNewfeatureViewController alloc]init];
    }else {
        // 1.从plist中取出版本号
        NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
        // 2.从沙盒中取出上次存储的版本号
        NSString *lastVersion = [[NSUserDefaults  standardUserDefaults] objectForKey:key];
//        NSLog(@"currentVersion=%@;lastVersion=%@",currentVersion,lastVersion);
        if([currentVersion isEqualToString:lastVersion]) {
            //不是第一次使用这个版本
            //去调用主界面的内容
            self.window.rootViewController = [[UIStoryboard storyboardWithName:@"StoryboardIOS7" bundle:nil] instantiateInitialViewController];
        }else{
            //版本号不一样：第一次使用新版本
            //将新版本号写入沙盒
            [[NSUserDefaults  standardUserDefaults] setObject:currentVersion forKey:key];
            [[NSUserDefaults  standardUserDefaults] synchronize];
            //显示版本新特性界面
            self.window.rootViewController = [[YMJNewfeatureViewController alloc] init];
        }
    }
}

//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
//{
//    NSString *alert = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
//    if (application.applicationState == UIApplicationStateActive) {
//        // Nothing to do if applicationState is Inactive, the iOS already displayed an alert view.
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Did receive a Remote Notification"
//                                                            message:[NSString stringWithFormat:@"The application received this remote notification while it was running:\n%@", alert]
//                                                           delegate:self
//                                                  cancelButtonTitle:@"OK"
//                                                  otherButtonTitles:nil];
//        [alertView show];
//    }

//}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationWillTerminate:application];
}

/// iOS9 之前
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //如果极简开发包不可用，会跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给开发包
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"result = %@",resultDic);
        }];
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
        
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"result = %@",resultDic);
        }];
    }
    
    
#pragma mark - 微信设置代理
    return [WXApi handleOpenURL:url delegate:self];

    return YES;
}

///iOS 9以后
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary*)options{
    //如果极简开发包不可用，会跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给开发包
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"result = %@",resultDic);
        }];
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
        
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"result = %@",resultDic);
        }];
    }
    
    
#pragma mark - 微信设置代理
    return [WXApi handleOpenURL:url delegate:self];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}

// 注册了推送功能，iOS 会自动回调以下方法，得到deviceToken
// 将得到的deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSLog(@"---Token--%@", deviceToken);
    [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
}

// 注册deviceToken失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    [[EaseMob sharedInstance] application:application didFailToRegisterForRemoteNotificationsWithError:error];
    NSLog(@"error -- %@",error);
}


-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if(viewController == [tabBarController.viewControllers objectAtIndex:2] ||
       viewController == [tabBarController.viewControllers objectAtIndex:3] ||
       viewController == [tabBarController.viewControllers objectAtIndex:4]) {
        [_appConfig loadConfig];
        if (![_appConfig isLogin]) {
             return NO;
        }
    }
    return YES;
}

#pragma mark - 微信平台
- (void) registeredWechat {
    [WXApi registerApp:kWechatAppID];
}
-(void) onReq:(BaseReq*)req
{
    NSLog(@"onReq");
}
/// 微信支付后 回调
-(void) onResp:(BaseResp*)resp
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationWXPayComplete object:@(resp.errCode)];
}

#pragma mark - 环信
- (void)didReceiveMessage:(EMMessage *)message
{
    [[NSNotificationCenter defaultCenter] postNotificationName:HUANXIN_RECEIVE_NOTICE object:nil];
}
@end
