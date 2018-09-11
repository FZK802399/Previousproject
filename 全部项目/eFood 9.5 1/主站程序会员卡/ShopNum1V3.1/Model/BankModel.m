//
//  BankModel.m
//  ShopNum1V3.1
//
//  Created by yons on 16/3/8.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import "BankModel.h"

@implementation BankModel
-(instancetype)initWithDict:(NSDictionary *)Dict
{
    self = [super init];
    if (self) {
        _Guid = [Dict objectForKey:@"Guid"];
        _BankAccountName = [Dict objectForKey:@"BankAccountName"];
        _BankAccountNumber = [Dict objectForKey:@"BankAccountNumber"];
        _BankName = [Dict objectForKey:@"BankName"];
        _CreateTime = [Dict objectForKey:@"CreateTime"];
        _CreateUser = [Dict objectForKey:@"CreateUser"];
        _IsDeleted = [[Dict objectForKey:@"IsDeleted"] integerValue];
        _MemLoginID = [Dict objectForKey:@"MemLoginID"];
        _Mobile = [Dict objectForKey:@"Mobile"];
        _ModifyTime = [Dict objectForKey:@"ModifyTime"];
        _ModifyUser = [Dict objectForKey:@"ModifyUser"];
        ///户主
        _isSelected = NO;
    }
    return self;
}

+ (void)getBankListWithBlock:(void (^)(NSArray *, NSError *))block
{
    AppConfig * config = [AppConfig sharedAppConfig];
    [config loadConfig];
    NSDictionary * dict = @{
                            @"MemLoginID":config.loginName
                            };
    [[AFAppAPIClient sharedClient]getPath:@"/api/GetMemberBankAccount/" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"Data"]isKindOfClass:[NSArray class]]) {
            NSArray * dataArr = [responseObject objectForKey:@"Data"];
            NSMutableArray * arr = [NSMutableArray array];
            for (NSDictionary * dict in dataArr) {
                BankModel * model = [[BankModel alloc]initWithDict:dict];
                [arr addObject:model];
            }
            if (block) {
                block([NSArray arrayWithArray:arr],nil);
            }
        }
        else
        {
            if (block) {
                block(nil,nil);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil,error);
        }
    }];
}

@end

