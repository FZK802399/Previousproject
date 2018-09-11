//
//  FXModel.m
//  ShopNum1V3.1
//
//  Created by yons on 15/11/28.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "FXModel.h"

@implementation FXModel
-(instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        _MemLoginID = [dict objectForKey:@"MemLoginID"];
        _CommendPeople = [dict objectForKey:@"CommendPeople"];
        _lvl = [[dict objectForKey:@"lvl"] integerValue];
        _Profit = [[dict objectForKey:@"Profit"] floatValue];
        _Photo = [dict objectForKey:@"Photo"];
    }
    return self;
}

+(void)getFXListWithBlock:(void(^)(NSArray *,CGFloat ,CGFloat ,NSError *))block
{
    AppConfig * config = [AppConfig sharedAppConfig];
    [config loadConfig];
    NSDictionary * dict = @{
                            @"MemLoginID":config.loginName,
                            @"AppSign":config.appSign
                            };
    NSMutableArray * arr = [NSMutableArray array];
    [[AFAppAPIClient sharedClient]getPath:@"api/getdistributor/" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray * dataArr = [[[responseObject objectForKey:@"Data"] objectForKey:@"Distributor"] isEqual:[NSNull null]]?[NSArray array]:[[responseObject objectForKey:@"Data"] objectForKey:@"Distributor"];
        CGFloat today = [[[[responseObject objectForKey:@"Data"] objectForKey:@"Profit"] objectForKey:@"0"] floatValue];
        CGFloat total = [[[[responseObject objectForKey:@"Data"] objectForKey:@"Profit"] objectForKey:@"1"] floatValue];
        for (NSDictionary * dict in dataArr) {
            FXModel * model = [[FXModel alloc]initWithDict:dict];
            [arr addObject:model];
//            switch (model.lvl) {
//                case 1:
//                    [lvl1 addObject:model];
//                    break;
//                case 2:
//                    [lvl2 addObject:model];
//                    break;
//                case 3:
//                    [lvl3 addObject:model];
//                    break;
//            }
        }
        if (block) {
            block([NSArray arrayWithArray:arr],today,total,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil,0.00,0.00,error);
        }
    }];
}

@end
