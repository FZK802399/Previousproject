//
//  AppConfig.h
//  Shop
//
//  Created by Ocean Zhang on 3/26/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppConfig : NSObject

///Member Login ID
@property (nonatomic, strong) NSString *loginName;
///称昵
@property (nonatomic, strong) NSString *RealName;
///电话
@property (nonatomic, strong) NSString *Mobile;

@property (nonatomic, strong) NSString *loginPwd;

@property (nonatomic, strong) NSString *userGuid;

@property (nonatomic, strong) NSString *userEmail;

@property (nonatomic, assign) CGFloat userAdvancePayment;
///汇率
@property (nonatomic, assign) CGFloat Rate;

@property (nonatomic, assign) NSInteger userScore;

@property (nonatomic, assign) NSInteger userMemberRank;

@property (nonatomic, strong) NSString *userUrlStr;

@property (nonatomic, strong) NSString *firstRun;

@property (nonatomic, strong) NSString *appSign;

@property (nonatomic, assign) NSInteger shopCartNum;

@property (nonatomic, strong) NSMutableArray *collectGuidList;

+ (AppConfig *)sharedAppConfig;

- (void)loadConfig;

- (void)saveConfig;

- (BOOL)isLogin;

- (BOOL)userFirstRun;

- (void)clearUserInfo;

///货币转换率
+ (void)getRateWithBlock:(void(^)(CGFloat rate,NSError * error))block;
@end
