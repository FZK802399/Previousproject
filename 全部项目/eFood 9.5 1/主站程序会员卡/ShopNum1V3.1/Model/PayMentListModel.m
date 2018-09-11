//
//  PayMentListModel.m
//  ShopNum1V3.1
//
//  Created by yons on 15/11/19.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "PayMentListModel.h"
#import "AppConfig.h"
//@property(nonatomic,strong)NSString * Guid;
/////支付方式
//@property(nonatomic,strong)NSString * PaymentType;
/////中文名
//@property(nonatomic,strong)NSString * NAME;
//@property(nonatomic,strong)NSString * MerchantCode;
//@property(nonatomic,strong)NSString * IsCOD;
//@property(nonatomic,strong)NSString * ForAdvancePayment;
//@property(nonatomic,strong)NSString * OrderID;
//@property(nonatomic,strong)NSString * IsPercent;
//@property(nonatomic,strong)NSString * Charge;
/////公钥
//@property(nonatomic,strong)NSString * Public_Key;
/////私钥
//@property(nonatomic,strong)NSString * Private_Key;
/////合作身份者ID
//@property(nonatomic,strong)NSString * Partner;
//@property(nonatomic,strong)NSString * Email;
//@property(nonatomic,strong)NSString * SecretKey;
@implementation PayMentListModel
-(instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if(self)
    {
        _Guid = [dict objectForKey:@"Guid"];
        _PaymentType = [dict objectForKey:@"PaymentType"];
        _NAME = [dict objectForKey:@"NAME"];
        _MerchantCode = [dict objectForKey:@"MerchantCode"];
        _IsCOD = [dict objectForKey:@"IsCOD"];
        _ForAdvancePayment = [dict objectForKey:@"ForAdvancePayment"];
        _OrderID = [dict objectForKey:@"OrderID"];
        _IsPercent = [dict objectForKey:@"IsPercent"];
        _Charge = [dict objectForKey:@"Charge"];
        _Public_Key = [dict objectForKey:@"Public_Key"];
        _Private_Key = [dict objectForKey:@"Private_Key"];
        _Partner = [dict objectForKey:@"Partner"];
        _Email = [dict objectForKey:@"Email"];
        _SecretKey = [dict objectForKey:@"SecretKey"];
        _isSelected = NO;
    }
    return self;
}

+(instancetype)modelWithDict:(NSDictionary *)dict
{
    return [[PayMentListModel alloc]initWithDict:dict];
}

+(void)getListWithBlock:(void(^)(NSArray * List,NSError * error))block
{
    AppConfig * config = [AppConfig sharedAppConfig];
    [config loadConfig];
    NSDictionary * dict = @{
                            @"Source":@"iOS",
                            @"AppSign":config.appSign
                            };
    [[AFAppAPIClient sharedClient] getPath:@"api/PayMentList" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray * dataArr = [responseObject objectForKey:@"Data"] == [NSNull null] ? nil:[responseObject objectForKey:@"Data"];
        NSMutableArray * arr = [NSMutableArray arrayWithCapacity:dataArr.count];
        if (dataArr) {
            for (NSDictionary * dd in dataArr) {
                PayMentListModel * model = [PayMentListModel modelWithDict:dd];
                [arr addObject:model];
            }
        }
        if (block) {
            block([NSArray arrayWithArray:arr],nil);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil,error);
        }
    }];
}

+(void)upDatePayMentWithDict:(NSDictionary *)dict block:(void(^)(NSInteger result,NSError * error))block
{
    [[AFAppAPIClient sharedClient]postPath:@"api/UpdatePayMent/" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            NSInteger result = [[responseObject objectForKey:@"Data"] integerValue];
            if (block) {
                block(result,nil);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(-1,error);
        }
    }];
}
@end
