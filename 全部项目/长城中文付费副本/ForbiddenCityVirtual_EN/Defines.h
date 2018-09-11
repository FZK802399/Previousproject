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


#define kPaid @"WasPaid"
#define kDownload @"WasDownload"
#define kUnzip @"WasUnzip"


//是否已经购买
#define kWas_Paid [[NSUserDefaults standardUserDefaults] boolForKey:kPaid]
//是否已经下载
#define kWas_Download [[NSUserDefaults standardUserDefaults] boolForKey:kDownload]
//是否已经解压
#define kWas_Unzip [[NSUserDefaults standardUserDefaults] boolForKey:kUnzip]

//内购产品id
#define kEnglishProductID @"com.chuangyifengtong.changchengquanjingyouenglish"
#define kSnowProductID @"com.chuangyifengtong.changchengquanjingyousnow"

//是否已经内购
#define kWasEnglishPaid @"wasEnglishPaid"
#define kWasSnowPaid @"wasSnowPaid"

#define WasEnglishPaid [[NSUserDefaults standardUserDefaults] boolForKey:kWasEnglishPaid]
#define WasSnowPaid [[NSUserDefaults standardUserDefaults] boolForKey:kWasSnowPaid]

//关于评论
#define kWasComment @"wasComment"
#define WasComment [[NSUserDefaults standardUserDefaults] boolForKey:kWasComment]

//关于分享
//定义新浪微博的app key，app secret以及授权跳转地址uri
#define kSinaAppKey         @"85265888"
#define kSinaSecret          @"f195fbf04379700bceb758fcf1c29758"
#define kSinaRedirectURI     @"http://www.sina.com"

//定义腾讯微博的key secret 以及授权用的跳转地址url
#define kTCAppKey @"801352050"
#define kTCSecret @"cfe5059cfd0316c0438af78241192cdc"
#define kTCRedirectUrl @"https://itunes.apple.com/us/app/mei-li-zhong-guo/id577660010?ls=1&mt=8"

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

#define CURRENTLANGUAGE [[NSUserDefaults standardUserDefaults] integerForKey:kCurrent_Language]

//当前语言环境
enum CurrentLanguage {
    Chinese = 0,
    English = 1
};
typedef NSInteger CurrentLanguage;
