//
//  TiXianModel.m
//  ShopNum1V3.1
//
//  Created by yons on 16/3/8.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import "TiXianModel.h"

@implementation TiXianModel
-(instancetype)initWithDict:(NSDictionary *)Dict
{
    self = [super init];
    if (self) {
        _Guid = [Dict objectForKey:@"Guid"];
        _OrderNumber = [Dict objectForKey:@"OrderNumber"];
        _OperateType = [[Dict objectForKey:@"OperateType"] integerValue];
        _CurrentAdvancePayment = [[Dict objectForKey:@"CurrentAdvancePayment"] doubleValue];
        _OperateMoney = [[Dict objectForKey:@"OperateMoney"] doubleValue];
        _Date = [Dict objectForKey:@"Date"];
        _OperateStatus = [[Dict objectForKey:@"OperateStatus"] integerValue];
        _Memo = [[Dict objectForKey:@"Memo"] isEqual:[NSNull null]] ? @"" : [Dict objectForKey:@"Memo"];
        _UserMemo = [[Dict objectForKey:@"UserMemo"] isEqual:[NSNull null]] ? @"" : [Dict objectForKey:@"UserMemo"];
        _MemLoginID = [Dict objectForKey:@"MemLoginID"];
        _PaymentGuid = [Dict objectForKey:@"PaymentGuid"];
        _PaymentName = [[Dict objectForKey:@"PaymentName"] isEqual:[NSNull null]] ? @"" : [Dict objectForKey:@"PaymentName"];
        _IsDeleted = [[Dict objectForKey:@"IsDeleted"] integerValue];
        _Bank = [Dict objectForKey:@"Bank"];
        _TrueName = [Dict objectForKey:@"TrueName"];
        _Account = [Dict objectForKey:@"Account"];
        _OperateMember = [[Dict objectForKey:@"OperateMember"] isEqual:[NSNull null]] ? @"" : [Dict objectForKey:@"OperateMember"];
    }
    return self;
}

+ (void)getHistoryListWithBlock:(void(^)(NSArray * arr,NSError * error))block
{
    AppConfig * config = [AppConfig sharedAppConfig];
    [config loadConfig];
    NSDictionary * dict = @{
                            @"MemLoginID":config.loginName
                            };
    [[AFAppAPIClient sharedClient]getPath:@"/api/GetAdvancePaymentApplyLog/" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"Data"]isKindOfClass:[NSArray class]]) {
            NSArray * dataArr = [responseObject objectForKey:@"Data"];
            NSMutableArray * arr = [NSMutableArray array];
            for (NSDictionary * dict in dataArr) {
                TiXianModel * model = [[TiXianModel alloc]initWithDict:dict];
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
