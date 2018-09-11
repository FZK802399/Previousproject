//
//  EMIMHelper.m
//  CustomerSystem-ios
//
//  Created by dhc on 15/3/28.
//  Copyright (c) 2015年 easemob. All rights reserved.
//

#import "EMIMHelper.h"

#import "EaseMob.h"
#import "LocalDefine.h"

static EMIMHelper *helper = nil;

@implementation EMIMHelper

@synthesize appkey = _appkey;
@synthesize cname = _cname;
@synthesize nickname = _nickname;

@synthesize username = _username;
@synthesize password = _password;

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        _appkey = [userDefaults objectForKey:kAppKey];
        if ([_appkey length] == 0) {
            _appkey = kDefaultAppKey;
            [userDefaults setObject:_appkey forKey:kAppKey];
        }
        
        _cname = [userDefaults objectForKey:kCustomerName];
        if ([_cname length] == 0) {
            _cname = kDefaultCustomerName;
            [userDefaults setObject:_cname forKey:kCustomerName];
        }
        
        _nickname = [userDefaults objectForKey:kCustomerNickname];
        if ([_nickname length] == 0) {
            _nickname = @"";
            [userDefaults setObject:_nickname forKey:kCustomerNickname];
        }
        
        _username = [userDefaults objectForKey:@"username"];
        _password = [userDefaults objectForKey:@"password"];
    }
    
    return self;
}

+ (instancetype)defaultHelper
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[EMIMHelper alloc] init];
    });
    
    return helper;
}

#pragma mark - login

- (void)loginEasemobSDK
{
    EaseMob *easemob = [EaseMob sharedInstance];
    if (![easemob.chatManager isLoggedIn] || ([_username length] == 0 || [_password length] == 0)) {
        if ([_username length] == 0 || [_password length] == 0) {
//            UIDevice *device = [UIDevice currentDevice];//创建设备对象
//            NSString *deviceUID = [[NSString alloc] initWithString:[[device identifierForVendor] UUIDString]];
//            if ([deviceUID length] == 0) {
//                CFUUIDRef uuid = CFUUIDCreate(NULL);
//                if (uuid)
//                {
//                    deviceUID = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, uuid);
//                    CFRelease(uuid);
//                }
//            }
//            _username = [deviceUID stringByReplacingOccurrencesOfString:@"-" withString:@""];
            AppConfig * config = [AppConfig sharedAppConfig];
            [config loadConfig];
            if (![config isLogin]) {
                int i = (arc4random() % 10000) + 10000;
                _username = [NSString stringWithFormat:@"%d",i];
            }
            else{
                _username = config.loginName;
            }
            _password = @"123456";
            [easemob.chatManager asyncRegisterNewAccount:_username password:_password withCompletion:^(NSString *username, NSString *password, EMError *error) {
                if (!error || error.errorCode == EMErrorServerDuplicatedAccount) {
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//                    [userDefaults setObject:@"username" forKey:_username];
//                    [userDefaults setObject:@"password" forKey:_password];
                    [userDefaults setObject:_username forKey:@"username"];
                    [userDefaults setObject:_password forKey:@"password"];
                    [easemob.chatManager asyncLoginWithUsername:_username password:_password completion:^(NSDictionary *loginInfo, EMError *error) {
                        [easemob.chatManager setApnsNickname:@"EFOOD7"];
                        [easemob.chatManager enableDeliveryNotification];
                        // 获取全局APNS配置
                        EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
                        // 显示全部信息
                        options.displayStyle = ePushNotificationDisplayStyle_messageSummary;
                        // 设置免打扰时段，设置后，在改时间内不收推送
                        options.noDisturbStatus = ePushNotificationNoDisturbStatusClose;
//                        options.nickname = @"EFOOD7";
//                        options.noDisturbingStartH = 22;
//                        options.noDisturbingEndH = 8;
//                        [[EaseMob sharedInstance].chatManager asyncUpdatePushOptions:options];
                        [[EaseMob sharedInstance].chatManager asyncUpdatePushOptions:options completion:^(EMPushNotificationOptions *options, EMError *error) {
                            if (!error) {
                            }
                        } onQueue:nil];
                        
                        
                        [[NSNotificationCenter defaultCenter]postNotificationName:HUANXIN_LOGINEND_NOTICE object:nil];
                    } onQueue:nil];
                }
            } onQueue:nil];
        }
        else{
            [easemob.chatManager asyncLoginWithUsername:_username password:_password completion:^(NSDictionary *loginInfo, EMError *error) {
                [easemob.chatManager setApnsNickname:@"EFOOD7"];
                [easemob.chatManager enableDeliveryNotification];
                // 获取全局APNS配置
                EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
                // 显示全部信息
                options.displayStyle = ePushNotificationDisplayStyle_messageSummary;
                // 设置免打扰时段，设置后，在改时间内不收推送
                options.noDisturbStatus = ePushNotificationNoDisturbStatusClose;
//                options.nickname = @"EFOOD7";
//                options.noDisturbingStartH = 22;
//                options.noDisturbingEndH = 8;
                //                        [[EaseMob sharedInstance].chatManager asyncUpdatePushOptions:options];
                [[EaseMob sharedInstance].chatManager asyncUpdatePushOptions:options completion:^(EMPushNotificationOptions *options, EMError *error) {
                    if (!error) {
                    }
                } onQueue:nil];

                
                [[NSNotificationCenter defaultCenter]postNotificationName:HUANXIN_LOGINEND_NOTICE object:nil];
            } onQueue:nil];
        }
    }
    else{
        [[NSNotificationCenter defaultCenter]postNotificationName:HUANXIN_LOGINEND_NOTICE object:nil];
    }
}

#pragma mark - logoff
- (void)logoffEasemobSDK
{
    EaseMob *easemob = [EaseMob sharedInstance];
//    if ([easemob.chatManager isLoggedIn]/* || ([_username length] != 0 || [_password length] != 0)*/) {
        [easemob.chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults removeObjectForKey:@"username"];
            [userDefaults removeObjectForKey:@"password"];
            _username = nil;
            _password = nil;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:HUANXIN_LOGOFFEND_NOTICE object:nil];
        } onQueue:nil];
//    }
}

#pragma mark - info

- (void)setNickname:(NSString *)nickname
{
    if ([nickname length] > 0 && ![nickname isEqualToString:_nickname]) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:nickname forKey:kCustomerNickname];
        _nickname = nickname;
    }
}

- (void)setCname:(NSString *)cname
{
    if ([cname length] > 0 && ![cname isEqualToString:_cname]) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:cname forKey:kCustomerName];
        _cname = cname;
    }
}

- (void)refreshHelperData
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _appkey = [userDefaults objectForKey:kAppKey];
    if ([_appkey length] == 0) {
        _appkey = kDefaultAppKey;
        [userDefaults setObject:_appkey forKey:kAppKey];
    }
    
    _cname = [userDefaults objectForKey:kCustomerName];
    if ([_cname length] == 0) {
        _cname = kDefaultCustomerName;
        [userDefaults setObject:_cname forKey:kCustomerName];
    }
    
    _nickname = [userDefaults objectForKey:kCustomerNickname];
    if ([_nickname length] == 0) {
        _nickname = @"";
        [userDefaults setObject:_nickname forKey:kCustomerNickname];
    }
    
    [userDefaults removeObjectForKey:@"username"];
    [userDefaults removeObjectForKey:@"password"];
    _username = nil;
    _password = nil;
}

@end
