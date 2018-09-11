//
//  UesrInfoModel.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-15.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import <Foundation/Foundation.h>

/*{
 "Guid": "4f401b3d-667a-4eea-bbab-0d6ec9ec3377",
 "MemLoginID": "sara",
 "Pwd": "21218cca77804d2ba1922c33e0151105",
 "Email": "0",
 "AdvancePayment": 0.00,
 "LevelName": "普通会员",
 "Score": 1000400,
 "RankScore": 0,
 "MemberRankGuid": "1bc69586-fc0d-4feb-8756-579c6b326fa5",
 "RememberMe": false,
 "Discount": 10.00,
 "Photo": null,
 "Mobile": "0",
 "Url": "http://fxv85.nrqiang.com",
 "PayPwd": "e10adc3949ba59abbe56e057f20f883e"
 }
 */

@interface UserInfoModel : NSObject

@property (nonatomic, strong) NSString *loginName;

@property (nonatomic, strong) NSString *userGuid;

@property (nonatomic, strong) NSString *userEmail;

@property (nonatomic, assign) CGFloat userAdvancePayment;

@property (nonatomic, assign) NSInteger userScore;

@property (nonatomic, assign) NSInteger userMemberRank;

@property (nonatomic, strong) NSURL *userUrl;

@property (nonatomic, strong) NSString *userPwd;

@property (nonatomic, strong) NSString *userPayPwd;

@property (nonatomic, strong) NSString *userMobile;

@property (nonatomic, strong) NSURL *userPhoto;

@property (nonatomic, strong) NSString *userPhotoStr;
///称昵
@property (nonatomic, strong) NSString * RealName;

@property (nonatomic, copy) NSNumber * NoPaymentCount;
@property (nonatomic, copy) NSNumber * NoShippedCount;
@property (nonatomic, copy) NSNumber * NoReceivedCount;
@property (nonatomic, copy) NSNumber * MessageCount;


- (id)initWithAttributes:(NSDictionary *)attributes;

//验证用户名是否存在
+ (void)userNameIsExistByParamer:(NSDictionary *)parameters andblocks:(void(^)(bool isExist, NSError *error))block;
//验证用户手机号码是否存在
+ (void)userPhoneNumberIsExistByParamer:(NSDictionary *)parameters andblocks:(void(^)(bool isExist, NSError *error))block;
//注册用户
+ (void)registerUserByParamer:(NSDictionary *)parameters andblocks:(void(^)(bool isSuccess, NSError *error))block;
//用户登陆
+ (void)userLoginByParamer:(NSDictionary *)parameters andblocks:(void(^)(NSInteger result, NSError *error))block;
//获取用户信息
+ (void)getUserInfoByParamer:(NSDictionary *)parameters andblocks:(void(^)(UserInfoModel *user, NSError *error))block;
//更新用户积分
+ (void)updateUserScoreByParamer:(NSDictionary *)parameters andblocks:(void(^)(NSInteger result, NSError *error))block;


///登录密码修改
+ (void)changeLoginPwdByParamer:(NSDictionary *)parameters andblocks:(void(^)(NSInteger result, NSError *error))block;

///支付密码修改
+ (void)changePayPwdByParamer:(NSDictionary *)parameters andblocks:(void(^)(NSInteger result, NSError *error))block;

///check密码
+ (void)checkPayPwdByParamer:(NSDictionary *)parameters andblocks:(void(^)(NSInteger result, NSError *error))block;

// 2015.11.26
/// 获取验证码
+ (void)fetchValidateCodeByPhone:(NSString *)phone blocks:(void(^)(NSString *code, NSError *error))block;
//获取国际验证码
+ (void)fetchValidateYMGCodeByPhone:(NSString *)phone blocks:(void(^)(NSString *code, NSError *error))block;

///登录密码重置
+ (void)resetLoginPwdByParamer:(NSDictionary *)parameters andblocks:(void(^)(BOOL result, NSError *error))block;

/// 第三方登录接口
+ (void)thirdPartyLoginByParamer:(NSDictionary *)parameters andblocks:(void(^)(UserInfoModel *user, NSError *error))block;

@end
