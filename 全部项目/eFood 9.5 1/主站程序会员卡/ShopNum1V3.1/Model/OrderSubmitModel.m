//
//  OrderSubmitModel.m
//  Shop
//
//  Created by Ocean Zhang on 4/16/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import "OrderSubmitModel.h"
#import "OrderMerchandiseSubmitModel.h"

@implementation OrderSubmitModel

@synthesize Address = _Address;
@synthesize DispatchPrice = _DispatchPrice;
@synthesize Email = _Email;
@synthesize MemLoginID = _MemLoginID;
@synthesize Mobile = _Mobile;
@synthesize Name = _Name;
@synthesize OrderNumber = _OrderNumber;
@synthesize PaymentGuid = _PaymentGuid;
@synthesize PostType = _PostType;
@synthesize Postalcode = _Postalcode;

@synthesize productList = _productList;

@synthesize ProductPrice = _ProductPrice;
@synthesize RegionCode = _RegionCode;
@synthesize ShouldPayPrice = _ShouldPayPrice;
@synthesize tel = _tel;
@synthesize orderPrice = _orderPrice;

+ (void)generalOrderNumberWithparameters:(NSDictionary *)parameters andBolock:(void (^)(NSString *, NSError *))block{

    [[AFAppAPIClient sharedClient] getPath:kWebCreatOrderNumberPath parameters:parameters success:^(AFHTTPRequestOperation *operation,id JSON){
        
//        NSString* date;
//        
//        NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
//        //[formatter setDateFormat:@"YYYY.MM.dd.hh.mm.ss"];
//        [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss:SSS"];
//        date = [formatter stringFromDate:[NSDate date]];
//        NSString *timeNow = [[NSString alloc] initWithFormat:@"%@", date];
        
        
        NSString *orderNumber = [JSON objectForKey:@"OrderNumber"];
        if(block){
            block(orderNumber,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        if(block){
            block(nil,error);
        }
    }];
}
///添加订单
+ (void)addOrderModelWithparameters:(NSDictionary *)parameters andblock:(void (^)(NSInteger, NSError *))block{
    
  
    NSData *arrData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *JSONString = [[NSString alloc] initWithData:arrData encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",JSONString);
    
//    NSError *testError;
//    NSData *testData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&testError];
//    NSString *testStr = [[NSString alloc] initWithBytes:[testData bytes] length:[testData length] encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",testStr);

    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/html", nil]];
//    @"/api/orderpricecaculate/"
    [AFAppAPIClient sharedClient].parameterEncoding = AFJSONParameterEncoding;
    [[AFAppAPIClient sharedClient] postPath:kWebPostOrderPath parameters:parameters success:^(AFHTTPRequestOperation *operation,id JSON){
        [AFAppAPIClient sharedClient].parameterEncoding = AFFormURLParameterEncoding;
        NSLog(@"%------------------------------------------------------------------------------------------------@",JSON);
        NSInteger result = [[JSON objectForKey:@"return"] integerValue];
        
        if(block){
            block(result, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [AFAppAPIClient sharedClient].parameterEncoding = AFFormURLParameterEncoding;
        if(block){
            block(-1, error);
        }
    }];
}
///添加积分订单
+ (void)AddScoreOrderPostPriceWithparameters:(NSDictionary *)parameters andblock:(void (^)(NSInteger, NSError *))block{
    
    
    NSError *testError;
    NSData *testData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&testError];
    NSString *testStr = [[NSString alloc] initWithBytes:[testData bytes] length:[testData length] encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",testStr);
    
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/html", nil]];
    //    @"/api/orderpricecaculate/"
    [AFAppAPIClient sharedClient].parameterEncoding = AFJSONParameterEncoding;
    [[AFAppAPIClient sharedClient] postPath:kWebPostScoreOrderPath parameters:parameters success:^(AFHTTPRequestOperation *operation,id JSON){
        [AFAppAPIClient sharedClient].parameterEncoding = AFFormURLParameterEncoding;
//        NSLog(@"%@",JSON);
        NSInteger result = [[JSON objectForKey:@"return"] integerValue];
        
        if(block){
            block(result, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [AFAppAPIClient sharedClient].parameterEncoding = AFFormURLParameterEncoding;
        if(block){
            block(NO, error);
        }
    }];
}
///扣除用户积分
+ (void)PayScoreOrderWithparameters:(NSDictionary *)parameters andblock:(void (^)(NSInteger, NSError *))block{
    
    [[AFAppAPIClient sharedClient] getPath:kWebServiceCutMemberScorePath parameters:parameters success:^(AFHTTPRequestOperation *operation,id JSON){
        [AFAppAPIClient sharedClient].parameterEncoding = AFFormURLParameterEncoding;
//        NSLog(@"%@",JSON);
        NSInteger result = [[JSON objectForKey:@"return"] integerValue];
        
        if(block){
            block(result, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [AFAppAPIClient sharedClient].parameterEncoding = AFFormURLParameterEncoding;
        if(block){
            block(404, error);
        }
    }];
}

///获取订单邮费
+(void)getPostPriceWithparameters:(NSDictionary *)parameters andblock:(void (^)(NSDictionary *, NSError *))block{
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/html", nil]];
    [AFAppAPIClient sharedClient].parameterEncoding = AFJSONParameterEncoding;
    [[AFAppAPIClient sharedClient] postPath:kWeborderpricecaculatePath parameters:parameters success:^(AFHTTPRequestOperation *operation,id JSON){
        [AFAppAPIClient sharedClient].parameterEncoding = AFFormURLParameterEncoding;
        
        NSDictionary *orderDic = [JSON objectForKey:@"Data"];
//        NSLog(@"orderDic == %@", orderDic);
        if(block){
            block(orderDic, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [AFAppAPIClient sharedClient].parameterEncoding = AFFormURLParameterEncoding;
        if(block){
            block([NSDictionary dictionary], error);
        }
    }];
}
///获取积分订单邮费
+(void)getScoreOrderPostPriceWithparameters:(NSDictionary *)parameters andblock:(void (^)(NSDictionary *, NSError *))block{
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/html", nil]];
    [AFAppAPIClient sharedClient].parameterEncoding = AFJSONParameterEncoding;
    [[AFAppAPIClient sharedClient] postPath:kWebScoreOrderDispatchmodelistbycodePath parameters:parameters success:^(AFHTTPRequestOperation *operation,id JSON){
        [AFAppAPIClient sharedClient].parameterEncoding = AFFormURLParameterEncoding;
//        NSLog(@"orderDic == %@", JSON);
        NSDictionary *orderDic = [JSON objectForKey:@"DATA"];
        
        if(block){
            block(orderDic, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
//        NSLog(@"orderDic == %@", error);
        [AFAppAPIClient sharedClient].parameterEncoding = AFFormURLParameterEncoding;
        if(block){
            block([NSDictionary dictionary], error);
        }
    }];
}

///获取积分换算金额
+(void)getScorePriceWithparameters:(NSDictionary *)parameters andblock:(void (^)(CGFloat, NSError *))block{

    [[AFAppAPIClient sharedClient] getPath:kWebServiceGetScorepricePath parameters:parameters success:^(AFHTTPRequestOperation *operation,id JSON){

        CGFloat scorePrice = [JSON objectForKey:@"ScorePrice"] == nil ? 0 : [[JSON objectForKey:@"ScorePrice"] floatValue];
        if(block){
            block(scorePrice,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        if(block){
            block(0,error);
        }
    }];

}

@end
