//
//  UesrInfoModel.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-15.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

- (id)initWithAttributes:(NSDictionary *)attributes{
    self = [super init];
    if(!self){
        return self;
    }
    self.userGuid = [attributes objectForKey:@"Guid"];
    self.loginName = [attributes objectForKey:@"MemLoginID"];
    self.userEmail = [attributes objectForKey:@"Email"];
    self.userAdvancePayment = [attributes objectForKey:@"AdvancePayment"] == [NSNull null] ? 0 :[[attributes objectForKey:@"AdvancePayment"] doubleValue];
    self.userScore = [attributes objectForKey:@"Score"] == [NSNull null] ? 0 :[[attributes objectForKey:@"Score"] intValue];
    self.userMemberRank = [attributes objectForKey:@"RankScore"] == [NSNull null] ? 0 :[[attributes objectForKey:@"RankScore"] intValue];
    self.userUrl = [NSURL URLWithString:[attributes objectForKey:@"Url"] == [NSNull null] ? @"" :[attributes objectForKey:@"Url"]];
    self.userPwd = [attributes objectForKey:@"Pwd"];
    self.userPayPwd = [attributes objectForKey:@"PayPwd"];
    self.userPhotoStr = [attributes objectForKey:@"Photo"] == [NSNull null] ? @"" : [attributes objectForKey:@"Photo"];
    self.RealName = [attributes objectForKey:@"RealName"] == [NSNull null] ? @"" : [attributes objectForKey:@"RealName"];
    self.userMobile = [attributes objectForKey:@"Mobile"];
    
    return self;
}

-(NSURL *)userPhoto{

    return [NSURL URLWithString:self.userPhotoStr];
}

+ (void)getUserInfoByParamer:(NSDictionary *)parameters andblocks:(void(^)(UserInfoModel *user, NSError *error))block{

    [[AFAppAPIClient sharedClient] getPath:kWebAccountInfoPath parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON){
        NSDictionary *userDict = [JSON objectForKey:@"AccoutInfo"];
        if (![userDict isEqual:[NSNull null]]) {
            UserInfoModel *userInfo = [[UserInfoModel alloc] initWithAttributes:userDict];
            userInfo.NoPaymentCount = [JSON objectForKey:@"NoPaymentCount"];
            userInfo.NoShippedCount = [JSON objectForKey:@"NoShippedCount"];
            userInfo.NoReceivedCount = [JSON objectForKey:@"NoReceivedCount"];
            userInfo.MessageCount = [JSON objectForKey:@"MessageCount"];
            if(block){
                block(userInfo, nil);
            }
            
        }else{
            if(block){
                block(nil, nil);
            }
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        if(block){
            block(nil, error);
        }
    }];
}

+ (void)registerUserByParamer:(NSDictionary *)parameters andblocks:(void(^)(bool isSuccess, NSError *error))block{
    
    [[AFAppAPIClient sharedClient] getPath:kWebUserRegistPath parameters:parameters success:^(AFHTTPRequestOperation *operation,id JSON){
        
        NSInteger result = [[JSON objectForKey:@"return"] integerValue];
        BOOL isSucceed = NO;
        if(result == 202){
            isSucceed = YES;
        }
        if(block){
            block(isSucceed, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        if(block){
            block(NO, error);
        }
    }];

}


+ (void)userLoginByParamer:(NSDictionary *)parameters andblocks:(void (^)(NSInteger result, NSError *))block{

    [[AFAppAPIClient sharedClient] getPath:kWebUserLogInPath parameters:parameters success:^(AFHTTPRequestOperation *operation,id JSON){
        
        NSInteger result = [[JSON objectForKey:@"return"] integerValue];
//        NSLog(@"result == %d", result);
        if(block){
            block(result,nil);
        }
    } failure:^(AFHTTPRequestOperation *opertaion, NSError *error){
        if(block){
            block(-1, error);
        }
    }];
}


+ (void)userNameIsExistByParamer:(NSDictionary *)parameters andblocks:(void(^)(bool isExist, NSError *error))block{
    
    [[AFAppAPIClient sharedClient] getPath:kWebUserNameIsExistPath parameters:parameters success:^(AFHTTPRequestOperation *operation,id JSON){
        BOOL userIsExist = [[JSON objectForKey:@"return"] boolValue];
//        NSLog(@"%@",JSON);
        if(block){
            block(userIsExist,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        if(block){
            block(YES,error);
        }
    }];
}

+ (void)userPhoneNumberIsExistByParamer:(NSDictionary *)parameters andblocks:(void(^)(bool isExist, NSError *error))block{
    
    [[AFAppAPIClient sharedClient] getPath:kWebUserMobileIsExistPath parameters:parameters success:^(AFHTTPRequestOperation *operation,id JSON){
        BOOL userIsExist = [[JSON objectForKey:@"return"] boolValue];
        if(block){
            block(userIsExist,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        if(block){
            block(YES,error);
        }
    }];
}

+ (void)updateUserScoreByParamer:(NSDictionary *)parameters andblocks:(void(^)(NSInteger result, NSError *error))block{
    
    [[AFAppAPIClient sharedClient] getPath:kWebUpdateScorePath parameters:parameters success:^(AFHTTPRequestOperation *operation,id JSON){
        
        NSInteger result = [[JSON objectForKey:@"return"] integerValue];
        
        if(block){
            block(result,nil);
        }
    } failure:^(AFHTTPRequestOperation *opertaion, NSError *error){
        if(block){
            block(-1, error);
        }
    }];

}

+(void)changeLoginPwdByParamer:(NSDictionary *)parameters andblocks:(void (^)(NSInteger, NSError *))block{
    [[AFAppAPIClient sharedClient] getPath:kWebChangeLogInPWDPath parameters:parameters success:^(AFHTTPRequestOperation *operation,id JSON){
        
        NSInteger result = [[JSON objectForKey:@"return"] integerValue];
        
        if(block){
            block(result,nil);
        }
    } failure:^(AFHTTPRequestOperation *opertaion, NSError *error){
        if(block){
            block(-1, error);
        }
    }];
}

+(void)changePayPwdByParamer:(NSDictionary *)parameters andblocks:(void (^)(NSInteger, NSError *))block{
    [[AFAppAPIClient sharedClient] getPath:kWebChangePayPWDPath parameters:parameters success:^(AFHTTPRequestOperation *operation,id JSON){
        
        NSInteger result = [[JSON objectForKey:@"return"] integerValue];
        
        if(block){
            block(result,nil);
        }
    } failure:^(AFHTTPRequestOperation *opertaion, NSError *error){
        if(block){
            block(-1, error);
        }
    }];
}

+(void)checkPayPwdByParamer:(NSDictionary *)parameters andblocks:(void (^)(NSInteger, NSError *))block{
    [[AFAppAPIClient sharedClient] getPath:kWebCheckPayPWDPath parameters:parameters success:^(AFHTTPRequestOperation *operation,id JSON){
        
        NSInteger result = [[JSON objectForKey:@"return"] integerValue];
        
        if(block){
            block(result,nil);
        }
    } failure:^(AFHTTPRequestOperation *opertaion, NSError *error){
        if(block){
            block(-1, error);
        }
    }];
}


+ (void)fetchValidateCodeByPhone:(NSString *)phone blocks:(void(^)(NSString *code, NSError *error))block {
    [[AFAppAPIClient sharedClient] getPath:[NSString stringWithFormat:@"/api/GetMobileCode/?Mobile=%@", phone] parameters:nil success:^(AFHTTPRequestOperation *operation,id JSON){
        NSString *result = nil;
        if ([JSON objectForKey:@"Data"]) {
            result = [JSON objectForKey:@"Data"];
        } else {
            result = [JSON objectForKey:@"ErrorMessage"];
        }
        if(block){
            block(result,nil);
        }
    } failure:^(AFHTTPRequestOperation *opertaion, NSError *error){
        if(block){
            block(nil, error);
        }
    }];

}

+ (void)fetchValidateYMGCodeByPhone:(NSString *)phone blocks:(void(^)(NSString *code, NSError *error))block {
    [[AFAppAPIClient sharedClient] getPath:[NSString stringWithFormat:@"api/GetYMGJMobileCode/?Mobile=%@", phone] parameters:nil success:^(AFHTTPRequestOperation *operation,id JSON){
        NSString *result = nil;
        if ([JSON objectForKey:@"Data"]) {
            result = [JSON objectForKey:@"Data"];
        } else {
            result = [JSON objectForKey:@"ErrorMessage"];
        }
        if(block){
            block(result,nil);
        }
    } failure:^(AFHTTPRequestOperation *opertaion, NSError *error){
        if(block){
            block(nil, error);
        }
    }];
    
}

///登录密码重置
+ (void)resetLoginPwdByParamer:(NSDictionary *)parameters andblocks:(void(^)(BOOL result, NSError *error))block {
    [[AFAppAPIClient sharedClient] getPath:@"/api/ResetPassWrod/?" parameters:parameters success:^(AFHTTPRequestOperation *operation,id JSON){
        
        BOOL result = [[JSON objectForKey:@"Data"] boolValue];
        
        if(block){
            block(result,nil);
        }
    } failure:^(AFHTTPRequestOperation *opertaion, NSError *error){
        if(block){
            block(-1, error);
        }
    }];
}

// 第三方登录
+ (void)thirdPartyLoginByParamer:(NSDictionary *)parameters andblocks:(void(^)(UserInfoModel *user, NSError *error))block {
    [[AFAppAPIClient sharedClient] postPath:@"/api/ThirdLogin/?" parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON){
        NSDictionary *userDict = [JSON objectForKey:@"Data"];
        if (![userDict isEqual:[NSNull null]]) {
            UserInfoModel *userInfo = [[UserInfoModel alloc] initWithAttributes:userDict];
            if(block){
                block(userInfo, nil);
            }
        }else{
            if(block){
                block(nil, nil);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        if(block){
            block(nil, error);
        }
    }];
}

@end
