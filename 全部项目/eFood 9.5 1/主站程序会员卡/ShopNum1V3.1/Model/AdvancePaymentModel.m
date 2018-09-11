//
//  AdvancePaymentModel.m
//  ShopNum1V3.1
//
//  Created by yons on 15/11/13.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "AdvancePaymentModel.h"
#import "AFAppAPIClient.h"
@implementation AdvancePaymentModel
-(instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        _CreateTime = [dict objectForKey:@"CreateTime"];
        _CreateUser = [dict objectForKey:@"CreateUser"];
        _CurrentAdvancePayment = [[dict objectForKey:@"CurrentAdvancePayment"] doubleValue];
        _Date = [dict objectForKey:@"Date"];
        _Guid = [dict objectForKey:@"Guid"];
        _IsDeleted = [[dict objectForKey:@"IsDeleted"] integerValue];
        _LastOperateMoney = [[dict objectForKey:@"LastOperateMoney"] doubleValue];
        _MemLoginID = [dict objectForKey:@"MemLoginID"];
        _Memo = [dict objectForKey:@"Memo"] == [NSNull null] ? @"":[dict objectForKey:@"Memo"];
        _OperateMoney = [[dict objectForKey:@"OperateMoney"]doubleValue];
        _OperateType = [[dict objectForKey:@"OperateType"]integerValue];
    }
    return self;
}

+(void)getAdvancePaymentModifyLogByParamer:(NSDictionary *)parameters andblock:(void (^)(NSArray *, NSError *))block
{
    [[AFAppAPIClient sharedClient]getPath:kWebGetAdvancePaymentModifyLog parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray * arr = [responseObject objectForKey:@"data"] == [NSNull null] ? nil : [responseObject objectForKey:@"data"];
        NSMutableArray * modelArr = [NSMutableArray array];
        if(arr)
        {
            for (NSDictionary * dict in arr) {
                AdvancePaymentModel * model = [[AdvancePaymentModel alloc]initWithDict:dict];
                [modelArr addObject:model];
            }
        }
        if (block) {
            block([NSArray arrayWithArray:modelArr],nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block([NSArray array],nil);
        }
    }];
}


@end
