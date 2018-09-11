//
//  FootMarkModel.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-11.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "FootMarkModel.h"
/*
"data": [
         {
             "id": "e7d72a8c-fdf0-49ae-b42b-9a532abf2601",
             "ProductGuid": "ffc0e8a6-da1a-4927-b1e5-000cdee4d83f",
             "ProductName": "卓尔诗婷 维吉尼亚神圣金缕梅面膜",
             "ProductOriginalImge": "/ImgUpload/20140429151056977.jpg",
             "ProductMarketPrice": 20.11,
             "ProductShopPrice": 10.12,
             "MemLoginID": "liulei",
             "CreateTime": "2014/08/07 16:57:36"
         }
         ]
*/
@implementation FootMarkModel

@synthesize ID = _ID, ProductGuid = _ProductGuid, ProductName = _ProductName, ProductOriginalImage = _ProductOriginalImage, ProductImageURL = _ProductImageURL, ProductMarketPrice = _ProductMarketPrice, ProductShopPrice = _ProductShopPrice, MemLoginID = _MemLoginID, CreateTime = _CreateTime;

- (id)initWithAttributes:(NSDictionary *)attributes{
    self = [super init];
    if(!self){
        return nil;
    }
    
    _ID = [attributes valueForKey:@"id"];
    _ProductGuid = [attributes valueForKey:@"ProductGuid"];
    _ProductName = [attributes valueForKey:@"ProductName"];
    _ProductOriginalImage = [attributes valueForKey:@"ProductOriginalImge"];
    _ProductMarketPrice = [attributes valueForKey:@"ProductMarketPrice"] == [NSNull null] ? 0 : [[attributes valueForKey:@"ProductMarketPrice"] floatValue];
    _ProductShopPrice = [attributes valueForKey:@"ProductShopPrice"] == [NSNull null] ? 0 : [[attributes valueForKey:@"ProductShopPrice"] floatValue];
    _MemLoginID = [attributes valueForKey:@"MemLoginID"];
    _CreateTime = [attributes valueForKey:@"CreateTime"];
    
    return self;

}

-(NSURL *)ProductImageURL{
    return [NSURL URLWithString:_ProductOriginalImage];
}

+ (void)getFootMarkListByparameters:(NSDictionary *)parameters andblock:(void(^)(NSArray *FootMarklist, NSError *error))block{
    [[AFAppAPIClient sharedClient] getPath:kWebFootMarkPath parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON){
        NSArray *bannerFromResponse = [JSON objectForKey:@"data"];
        NSMutableArray *mutableBanner = [NSMutableArray arrayWithCapacity:[bannerFromResponse count]];
        
        for (NSDictionary *attributes in bannerFromResponse) {
            FootMarkModel *footmark = [[FootMarkModel alloc] initWithAttributes:attributes];
            [mutableBanner addObject:footmark];
        }
        
        if(block){
            block([NSArray arrayWithArray:mutableBanner],nil);
        }
    }failure:^(AFHTTPRequestOperation *operation,NSError *error){
        if(block){
            block([NSArray array],error);
        }
    }];
}

+(void)deleteFootMarkByparameters:(NSDictionary *)parameters andblock:(void (^)(NSInteger , NSError *))block{

//    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
//    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_2312_80);
//    [AFAppAPIClient sharedClient].stringEncoding = gbkEncoding;
//    [[AFAppAPIClient sharedClient] setDefaultHeader:@"Accept" value:@"text/html"];
//    [AFAppAPIClient sharedClient].parameterEncoding = AFJSONParameterEncoding;
    
    [[AFAppAPIClient sharedClient] getPath:kWebDeleteFootMarkPath parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON){
        NSInteger returnFromResponse = [[JSON objectForKey:@"return"] intValue];

        if(block){
            block(returnFromResponse,nil);
        }
    }failure:^(AFHTTPRequestOperation *operation,NSError *error){
        if(block){
            block(404,error);
        }
    }];

}

+(void)addFootMarkByparameters:(NSDictionary *)parameters andblock:(void (^)(NSInteger, NSError *))block{
    
//    NSError *testError;
//    NSData *testData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&testError];
//    NSString *testStr = [[NSString alloc] initWithBytes:[testData bytes] length:[testData length] encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",testStr);
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/html", nil]];
    //    @"/api/orderpricecaculate/"
    [AFAppAPIClient sharedClient].parameterEncoding = AFJSONParameterEncoding;
    [[AFAppAPIClient sharedClient] postPath:kWebAddFootMarkPath parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON){
        [AFAppAPIClient sharedClient].parameterEncoding = AFFormURLParameterEncoding;
        NSInteger returnFromResponse = [JSON objectForKey:@"return"] == [NSNull null] ? 0 :[[JSON objectForKey:@"return"] intValue];
        
        if(block){
            block(returnFromResponse,nil);
        }
    }failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [AFAppAPIClient sharedClient].parameterEncoding = AFFormURLParameterEncoding;
        if(block){
            block(404,error);
        }
    }];


}

@end
