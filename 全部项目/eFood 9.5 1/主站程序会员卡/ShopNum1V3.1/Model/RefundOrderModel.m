//
//  RefundOrderModel.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-9-5.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "RefundOrderModel.h"

@implementation RefundOrderModel

-(id)initWithAttributes:(NSDictionary *)attributes{
    
    self = [super init];
    if(!self){
        return nil;
    }
    
    _Guid = [attributes valueForKey:@"guid"];
    _returnOrderStatue = [attributes valueForKey:@"OrderStatus"] == [NSNull null] ? 0 : [[attributes valueForKey:@"OrderStatus"] integerValue];
    NSArray *tempArr = [attributes objectForKey:@"GoodSList"];
    _returnProductList = [[NSMutableArray alloc] initWithCapacity:[tempArr count]];
    for (NSDictionary *dict in tempArr) {
        ReturnGoodModel *merchandise = [[ReturnGoodModel alloc] initWithAttributes:dict];
        [_returnProductList addObject:merchandise];
    }
    
    return self;
}

+(void)getReturnOrderDetailWithparameters:(NSDictionary *)parameters andblock:(void (^)(RefundOrderModel *, NSError *))block{
    [[AFAppAPIClient sharedClient] getPath:kWebGetreturnorderStatuePath parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON){
        NSDictionary *response = [JSON objectForKey:@"data"];
        if ([response isEqual: [NSNull null]]) {
            if(block){
                block(nil, nil);
            }
        }else{
            RefundOrderModel *model = [[RefundOrderModel alloc] initWithAttributes:response];
            
            if(block){
                block(model, nil);
            }
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        if(block){
            block(nil, error);
        }
    }];


}

+(void)updateReturnOrderDetailWithparameters:(NSDictionary *)parameters andblock:(void (^)(NSInteger, NSError *))block{
    
//    NSError *testError;
//    NSData *testData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&testError];
//    NSString *testStr = [[NSString alloc] initWithBytes:[testData bytes] length:[testData length] encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",testStr);
    
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/html", nil]];
    [AFAppAPIClient sharedClient].parameterEncoding = AFJSONParameterEncoding;
    [[AFAppAPIClient sharedClient] postPath:kWebUpdatereturnorderPath parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON){
        [AFAppAPIClient sharedClient].parameterEncoding = AFFormURLParameterEncoding;
        NSInteger result = [[JSON objectForKey:@"return"] integerValue];
        if(block){
            block(result, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        if(block){
            block(-1, error);
        }
    }];

}



@end
