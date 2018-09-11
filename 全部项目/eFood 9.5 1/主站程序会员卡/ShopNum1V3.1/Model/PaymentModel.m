//
//  PaymentForAlipay.m
//  Shop
//
//  Created by Ocean Zhang on 5/6/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import "PaymentModel.h"
#import "AFAppAPIClient.h"
#import "AppConfig.h"

@implementation PaymentModel

@synthesize Guid = _Guid;
@synthesize PaymentType = _PaymentType;
@synthesize name = _name;
@synthesize MerchantCode = _MerchantCode;
@synthesize IsCOD = _IsCOD;
@synthesize ForAdvancePayment = _ForAdvancePayment;
@synthesize OrderID = _OrderID;
@synthesize IsPercent = _IsPercent;
@synthesize Charge = _Charge;
@synthesize SecondKey = _SecondKey;
@synthesize paytype = _paytype;
@synthesize Public_Key = _Public_Key;
@synthesize Private_Key = _Private_Key;

- (id)initWithAttribute:(NSDictionary *)attribute{
    self = [super init];
    if(self){
        _Guid = [attribute objectForKey:@"Guid"] == [NSNull null] ? @"" :[attribute objectForKey:@"Guid"];
        _PaymentType = [attribute objectForKey:@"PaymentType"] == [NSNull null] ? @"" :[attribute objectForKey:@"PaymentType"];
        _name = [attribute objectForKey:@"NAME"] == [NSNull null] ? @"" :[attribute objectForKey:@"NAME"];
        _MerchantCode = [attribute objectForKey:@"MerchantCode"] == [NSNull null] ? @"" :[attribute objectForKey:@"MerchantCode"];
        _IsCOD = [[attribute objectForKey:@"IsCOD"] intValue];
        _ForAdvancePayment = [attribute objectForKey:@"ForAdvancePayment"] == [NSNull null] ? @"" :[attribute objectForKey:@"ForAdvancePayment"];
        _OrderID = [[attribute objectForKey:@"OrderID"] intValue];
        _IsPercent = [[attribute objectForKey:@"IsPercent"] intValue];
        _Charge = [[attribute objectForKey:@"Charge"] floatValue];
        _SecondKey = [attribute objectForKey:@"SecondKey"] == [NSNull null] ? @"" :[attribute objectForKey:@"SecondKey"];
        _Email = [attribute objectForKey:@"Email"] == [NSNull null] ? @"" :[attribute objectForKey:@"Email"];
        _paytype = [attribute objectForKey:@"paytype"] == [NSNull null] ? @"" :[attribute objectForKey:@"paytype"];
        _Public_Key = [attribute objectForKey:@"Public_Key"] == [NSNull null] ? @"" :[attribute objectForKey:@"Public_Key"];
        _Private_Key = [attribute objectForKey:@"Private_Key"] == [NSNull null] ? @"" :[attribute objectForKey:@"Private_Key"];
    }
    return self;
}

//支付方式列表
+ (void)getPaymentwithParameters:(NSDictionary *)parameters andbolock:(void (^)(NSArray *, NSError *))block{
    
    [[AFAppAPIClient sharedClient] getPath:kWebGetPaymentListPath parameters:parameters success:^(AFHTTPRequestOperation *operation,id JSON){
     
        NSArray *response = [JSON objectForKey:@"data"];
        NSMutableArray *shopList = [NSMutableArray arrayWithCapacity:[response count]];
        for (NSDictionary *dict in response) {
            PaymentModel *model = [[PaymentModel alloc] initWithAttribute:dict];
            [shopList addObject:model];
        }
        
        if(block){
            block(shopList, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        if(block){
            block(nil,error);
        }
    }];
}

//预存款支付
+ (void)payWithAdvanceWithParameters:(NSDictionary *)parameters andblock:(void (^)(BOOL, NSError *))block{
    
    [[AFAppAPIClient sharedClient] getPath:kWebAdvancePayPath parameters:parameters success:^(AFHTTPRequestOperation *operation,id JSON){
        BOOL result = [[JSON objectForKey:@"return"] boolValue];
        
        if(block){
            block(result, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        if(block){
            block(NO,error);
        }
    }];
}

+ (void)returnGoodsWithOrderGuid:(NSString *)guid andblock:(void (^)(BOOL, NSError *))block{
    AppConfig *config = [AppConfig sharedAppConfig];
    [config loadConfig];
    
    NSString *url = [NSString stringWithFormat:@"api/order/Returnofgoods/%@/%@",guid,config.loginName];
    NSString *utfUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[AFAppAPIClient sharedClient2] getPath:utfUrl parameters:nil success:^(AFHTTPRequestOperation *operation,id JSON){
        BOOL result = [[JSON objectForKey:@"return"] boolValue];
        
        if(block){
            block(result, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        if(block){
            block(NO,error);
        }
    }];
}

+ (void)postReturnGood:(NSMutableDictionary *)postData andblock:(void (^)(BOOL, NSError *))block{
    NSString *url = @"api/order/Returnofgoods2";
    NSString *utfUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [AFAppAPIClient sharedClient2].parameterEncoding = AFJSONParameterEncoding;
    [[AFAppAPIClient sharedClient2] postPath:utfUrl parameters:postData success:^(AFHTTPRequestOperation *operation,id JSON){
        [AFAppAPIClient sharedClient2].parameterEncoding = AFFormURLParameterEncoding;
        BOOL result = [[JSON objectForKey:@"return"] boolValue];
        
        if(block){
            block(result, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [AFAppAPIClient sharedClient2].parameterEncoding = AFFormURLParameterEncoding;
        if(block){
            block(NO, error);
        }
    }];
}

+ (void)postProductComment:(NSMutableDictionary *)postData andblock:(void (^)(NSInteger, NSError *))block{
    NSString *url = @"api/ProductComment/Add";
    NSString *utfUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [AFAppAPIClient sharedClient2].parameterEncoding = AFJSONParameterEncoding;
    [[AFAppAPIClient sharedClient2] postPath:utfUrl parameters:postData success:^(AFHTTPRequestOperation *operation,id JSON){
        [AFAppAPIClient sharedClient2].parameterEncoding = AFFormURLParameterEncoding;
        NSInteger result = [[JSON objectForKey:@"return"] integerValue];
        
        if(block){
            block(result, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [AFAppAPIClient sharedClient2].parameterEncoding = AFFormURLParameterEncoding;
        if(block){
            block(NO, error);
        }
    }];
}

@end
