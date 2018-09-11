//
//  MyGroupDetailModel.m
//  ShopNum1V3.1
//
//  Created by yons on 16/3/8.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import "MyGroupDetailModel.h"

@implementation MyGroupDetailModel

-(instancetype)initWithDict:(NSDictionary *)Dict
{
    self = [super init];
    if (self) {
        _CreateTime = [Dict objectForKey:@"CreateTime"];
        _Guid = [Dict objectForKey:@"Guid"];
        _Level = [Dict objectForKey:@"Level"];
        _MemLoginID = [Dict objectForKey:@"MemLoginID"];
        _OrderMoney = [[Dict objectForKey:@"OrderMoney"] doubleValue];
        _OrderNumber = [Dict objectForKey:@"OrderNumber"];
        _OrderProfit = [Dict objectForKey:@"OrderProfit"];
        _PercentPaid = [Dict objectForKey:@"PercentPaid"];
        _Profit = [[Dict objectForKey:@"Profit"] doubleValue];
        _SourceMember = [Dict objectForKey:@"SourceMember"];
    }
    return self;
}

+(void)getGroupMemberDetailWithMemLoginID:(NSString *)MemLoginID andBlock:(void(^)(NSArray * arr,NSError * error))block
{
    AppConfig * config = [AppConfig sharedAppConfig];
    [config loadConfig];
    NSDictionary * dict = @{
                            @"AppSign":config.appSign,
                            @"SourceMember":MemLoginID
                            };
    [[AFAppAPIClient sharedClient]getPath:@"/api/MemberRecommndProfit/" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"Data"]isKindOfClass:[NSArray class]]) {
            NSArray * arr = [responseObject objectForKey:@"Data"];
            NSMutableArray * dataArr = [NSMutableArray array];
            for (NSDictionary * dict in arr) {
                MyGroupDetailModel * model = [[MyGroupDetailModel alloc]initWithDict:dict];
                [dataArr addObject:model];
            }
            if (block) {
                block([NSArray arrayWithArray:dataArr],nil);
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
    //    http://senghongapp.efood7.com/api/MemberRecommndProfit/?AppSign=7c97d1a7629d85a6c60ea810e850bffb&SourceMember=18234470834
}

@end

