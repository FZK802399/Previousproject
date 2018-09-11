//
//  MerchandiseCollectModel.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-26.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "MerchandiseCollectModel.h"

@implementation MerchandiseCollectModel

@synthesize ID = _ID, ProductGuid = _ProductGuid, ProductName = _ProductName, ProductOriginalImage = _ProductOriginalImage, ProductImageURL = _ProductImageURL, ProductMarketPrice = _ProductMarketPrice, ProductShopPrice = _ProductShopPrice, MemLoginID = _MemLoginID, CreateTime = _CreateTime;

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if(!self){
        return nil;
    }
    
    _ID = [attributes valueForKey:@"Guid"];
    _ProductGuid = [attributes valueForKey:@"ProductGuid"];
    _ProductName = [attributes valueForKey:@"Name"];
    _ProductOriginalImage = [attributes valueForKey:@"OriginalImge"] == [NSNull null] ? @"" : [attributes valueForKey:@"OriginalImge"];
    _ProductMarketPrice = [attributes valueForKey:@"MarketPrice"] == [NSNull null] ? 0 : [[attributes valueForKey:@"MarketPrice"] floatValue];
    _ProductShopPrice = [attributes valueForKey:@"ShopPrice"] == [NSNull null] ? 0 : [[attributes valueForKey:@"ShopPrice"] floatValue];
    _MemLoginID = [attributes valueForKey:@"MemLoginID"];
    _CreateTime = [attributes valueForKey:@"CollectTime"];
    
    return self;
}

-(NSURL *)ProductImageURL {
    return [NSURL URLWithString:_ProductOriginalImage];
}


+(void)getCollectListByparameters:(NSDictionary *)parameters andblock:(void (^)(NSArray *, NSError *))block {
    [[AFAppAPIClient sharedClient] getPath:kWebShopCollectListPath parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON){
        NSArray *bannerFromResponse = [JSON objectForKey:@"Data"];
        NSMutableArray *mutableBanner = [NSMutableArray arrayWithCapacity:[bannerFromResponse count]];
        
        for (NSDictionary *attributes in bannerFromResponse) {
            MerchandiseCollectModel *collect = [[MerchandiseCollectModel alloc] initWithAttributes:attributes];
            [mutableBanner addObject:collect];
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

+(void)deleteCollectProductByparameters:(NSDictionary *)parameters andblock:(void (^)(NSInteger, NSError *))block {
    [[AFAppAPIClient sharedClient] getPath:kWebShopCollectDeletePath parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON){
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

@end
