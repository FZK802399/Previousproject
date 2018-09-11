//
//  BrandModel.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-9.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "BrandModel.h"

#import "AFJSONRequestOperation.h"
#import "AFHTTPClient.h"

@implementation BrandModel
@synthesize guid = _guid, name = _name, logoUrl = _logoUrl, logoStr = _logoStr,webSiteUrl = _webSiteUrl, keyWords = _keyWords, remark = _remark, description = _description, createUser = _createUser;


-(id)initWithAttributes:(NSDictionary *)attributes{
    self = [super init];
    if(!self){
        return nil;
    }
    
    _guid = [attributes valueForKey:@"Guid"];
    _name = [attributes valueForKey:@"Name"];
    _logoStr = [attributes valueForKey:@"Logo"];
    _webSiteUrl = [attributes valueForKey:@"WebSite"];
    _keyWords = [attributes valueForKey:@"Keywords"];
    _remark = [attributes valueForKey:@"Remark"];
    _description = [attributes valueForKey:@"Description"];
    _createUser = [attributes valueForKey:@"CreateUser"];
    
    return self;
}

//+(void)getAllBrandsByParamerDict:(NSDictionary *)dcit andBlocks:(void (^)(NSArray *, NSError *))block {
//    AFHTTPClient * a = [[AFHTTPClient alloc] init];
//    [a getPath:<#(NSString *)#> parameters:<#(NSDictionary *)#> success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];
//}

+(void)getAllBrandsByParamer:(NSDictionary *)parameters andBlocks:(void (^)(NSArray *, NSError *))block {
    
    NSString *url = [NSString stringWithFormat:@"%@?",kWebServiceAllBandsPath];
    NSString *utfUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[AFAppAPIClient sharedClient] getPath:utfUrl parameters:parameters
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *bannerFromResponse =  (NSArray *)responseObject[@"Data"];
//        NSLog(@"%@", bannerFromResponse);
        NSMutableArray *mutableBanner = [NSMutableArray arrayWithCapacity:[bannerFromResponse count]];
        
        for (NSDictionary *attributes in bannerFromResponse) {
            BrandModel *brand = [[BrandModel alloc] initWithAttributes:attributes];
            [mutableBanner addObject:brand];
        }
        if(block){
            block([NSArray arrayWithArray:mutableBanner],nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(block){
            block([NSArray array],error);
        }
    }];
}


// 获取分类下的品牌列表 api/product/brandlist/
+ (void)getBrandListByParamer:(NSDictionary *)parameters andBlocks:(void (^)(NSArray *brandList,NSError *error))block {
     NSString *url = [NSString stringWithFormat:@"api/product/brandlist/%@",parameters[@"ProductCategoryID"]];
    NSLog(@"URL : %@", url);
//    NSString *url = [NSString stringWithFormat:@"api/product/brandlist/%@",@"1"];
    
    [[AFAppAPIClient sharedClient] getPath:url parameters:nil
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
//           NSArray *bannerFromResponse =  (NSArray *)responseObject[@"data"];
           NSArray *bannerFromResponse = responseObject;
//           NSLog(@"%@", bannerFromResponse);
           NSMutableArray *mutableBanner = [NSMutableArray arrayWithCapacity:[bannerFromResponse count]];
           
           for (NSDictionary *attributes in bannerFromResponse) {
               BrandModel *brand = [[BrandModel alloc] initWithAttributes:attributes];
               [mutableBanner addObject:brand];
           }
           if(block){
               block([NSArray arrayWithArray:mutableBanner],nil);
           }
       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           if(block){
               block([NSArray array],error);
           }
       }];

}

// 获取推荐品牌列表
+(void)getRecommendBrandsByParamer:(NSDictionary *)parameters andBlocks:(void (^)(NSArray *, NSError *))block{
    
    [[AFAppAPIClient sharedClient] getPath:kWebServiceRecommendBandsPath parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON){
        
        if ([JSON objectForKey:@"data"] == [NSNull null] || [[JSON objectForKey:@"data"]  isEqual: @"404"]) {
            if(block){
                block([NSArray array],nil);
            }
        }else{
            NSArray *bannerFromResponse = [JSON objectForKey:@"data"];
            NSMutableArray *mutableBanner = [NSMutableArray arrayWithCapacity:[bannerFromResponse count]];
            
            for (NSDictionary *attributes in bannerFromResponse) {
                BrandModel *brand = [[BrandModel alloc] initWithAttributes:attributes];
                [mutableBanner addObject:brand];
            }
            
            if(block){
                block([NSArray arrayWithArray:mutableBanner],nil);
            }
        }
        
    }failure:^(AFHTTPRequestOperation *operation,NSError *error){
        if(block){
            block([NSArray array],error);
        }
    }];
}

-(NSURL *)logoUrl{
    
    return [NSURL URLWithString:[kWebMainBaseUrl stringByAppendingString:[_logoStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
}


+(void)getBrandDetailByParamer:(NSDictionary *)parameters andBlocks:(void (^)(NSArray *, NSError *))block{
    
    [[AFAppAPIClient sharedClient] getPath:kWebServiceBandDetailPath parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON){
        NSArray *bannerFromResponse = [JSON objectForKey:@"data"];
        NSMutableArray *mutableBanner = [NSMutableArray arrayWithCapacity:[bannerFromResponse count]];
        
        for (NSDictionary *attributes in bannerFromResponse) {
            BrandModel *brand = [[BrandModel alloc] initWithAttributes:attributes];
            [mutableBanner addObject:brand];
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





@end
