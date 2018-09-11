//
//  WechatPayManager.h
//  OnlineShop
//
//  Created by yons on 15/11/4.
//  Copyright (c) 2015年 m. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXUtil.h"
#import "ApiXml.h"
// 账号帐户资料
//更改商户把相关参数后可测试

#define APP_ID          @"wxc6fcf960b628e80d"               //APPID
#define APP_SECRET      @"eba1f757daac9ad6a6321ce894560c45" //appsecret
//商户号，填写商户对应参数
#define MCH_ID          @"1309561801"
//商户API密钥，填写相应参数
#define PARTNER_ID      @"teauCeKtReSjQXD1H8EoDrus4YIj4wBN"
//支付结果回调页面
#define NOTIFY_URL      @"http://wxpay.weixin.qq.com/pub_v2/pay/notify.v2.php"
//获取服务器端支付数据地址（商户自定义）
#define SP_URL          @"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php"
//预支付网关url地址
#define PayUrl          @"https://api.mch.weixin.qq.com/pay/unifiedorder"

@interface WechatPayManager : NSObject
//debug信息
@property (nonatomic,strong) NSMutableString *debugInfo;
@property (nonatomic,assign) NSInteger lastErrCode;//返回的错误码

//商户关键信息
@property (nonatomic,strong) NSString *appId,*mchId,*spKey;
//初始化函数
+ (instancetype) manager;
-(instancetype)initWithAppID:(NSString*)appID
                       mchID:(NSString*)mchID
                       spKey:(NSString*)key;

//获取当前的debug信息
-(NSString *) getDebugInfo;

//获取预支付订单信息（核心是一个prepayID）
- ( NSMutableDictionary *)sendPayWithTitle:(NSString*)title orderPrice:(NSString*)price notificationURL:(NSString*)notific_URL;

- ( NSMutableDictionary *)sendPayWithTitle:(NSString*)title orderPrice:(NSString*)price notificationURL:(NSString*)notific_URL orderNum:(NSString *)orderNum;

@end
