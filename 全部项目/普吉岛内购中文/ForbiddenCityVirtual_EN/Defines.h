//
//  Defines.h
//  ForbiddenCityVirtual_EN
//
//  Created by Heramerom on 13-6-24.
//  Copyright (c) 2013年 Duke Douglas. All rights reserved.
//

//返回AppDelegate指针
#define APP_DELEGATE    (AppDelegate*)[[UIApplication sharedApplication] delegate]
//获取bundle地址
#define APP_BUNDLE      [NSBundle mainBundle]
//获取系统版本号等信息
#define kDEVICE_VERSION  [[[UIDevice currentDevice] systemVersion] floatValue]
#define kDEVICE_NAME     [[UIDevice currentDevice] systemName]
#define kDEVICE_UID      [[UIDevice currentDevice] uniqueIdentifier]
//获取屏幕信息（尺寸，宽，高）
#define kLCDSIZE [[UIScreen mainScreen] bounds]
#define kLCDW kLCDSIZE.size.height
#define kLCDH kLCDSIZE.size.width

//NSUserDefaults
#define USER_DEFAULTS [NSUserDefaults standardUserDefaults]
//NSFileManager
#define FILE_MANAGER [NSFileManager defaultManager]
//NSNotificationCenter
#define NOTIFICATION_CENTER [NSNotificationCenter defaultCenter]


//释放内存
#define Release(pRet) if(pRet){ [pRet release]; pRet = nil;}
//Document文件夹路径
#define DocumentDirectory [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
//Library文件夹路径
#define LibraryDirectory [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0]

//打印函数名和所在的行(一般用在调bug)
#define Print_Func_And_Line NSLog(@"%s     %d",__func__,__LINE__)

#define kEnglishProductID @"com.chuangyifengton.phuketislandcncompleteen"
#define kChineseProductID @"com.chuangyifengton.phuketislandcncompletecn"

#define kWasEnglishPaid @"wasEnglishPaid"
#define kWasChinesePaid @"wasChinesePaid"

//免费的场景个数
#define kFreeSceneCount 6

#define wasEnglishPaid [[NSUserDefaults standardUserDefaults] boolForKey:kWasEnglishPaid]
#define wasChinesePaid [[NSUserDefaults standardUserDefaults] boolForKey:kWasChinesePaid]

//关于分享
//定义新浪微博的app key，app secret以及授权跳转地址uri
#define kSinaAppKey         @"85265888"
#define kSinaSecret          @"f195fbf04379700bceb758fcf1c29758"
#define kSinaRedirectURI     @"http://www.sina.com"

#define kWasComment @"kWasPayment"
#define wasComment [[NSUserDefaults standardUserDefaults] boolForKey:kWasComment]

//字体名
#define kFont_Name @"Arial"

#define kWas_First_Launch @"wasFirstLaunch"

#define kWas_First_Launch_Photo @"wasFirstLaunchPhoto"


//声音播放完成
#define PLAYER_FINISHED_NOTIFICATION @"player_finished_notification"

#define PLAYER_STATE_CHANGED @"player_state_changed"

//声音变化
#define PLAYER_SOUND_VALUME_CHANGED @"player_sound_valume_changed"

//Dlog
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"" fmt), ##__VA_ARGS__);
#else
#define DLog(...)
#endif


#define kFirst_Load @"kFirstLoad"

//下载完成
#define kDOWNLOAD_FINISHED_NOTIFICATION @"download_finished_notification"
//解压完成
#define kUNZIP_FINISHED_NOTIFICATION @"unzip_finished_notification"

#define kCurrent_Language @"currentLanguage"
#define CURRENTLANGUAGE [[NSUserDefaults standardUserDefaults] boolForKey:kCurrent_Language]

//当前语言环境
enum CurrentLanguage {
    Chinese = 0,
    English = 1
};
typedef NSInteger CurrentLanguage;
