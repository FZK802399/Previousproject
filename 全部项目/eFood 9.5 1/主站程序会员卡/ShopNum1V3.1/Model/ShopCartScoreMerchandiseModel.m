//
//  ShopCartScoreMerchandiseModel.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-11-27.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "ShopCartScoreMerchandiseModel.h"

@implementation ShopCartScoreMerchandiseModel

- (id)initWithAttributes:(NSDictionary *)attributes{
    self = [super init];
    if(self){
        _guid = [attributes objectForKey:@"Guid"];
        _productGuid = [attributes objectForKey:@"ProductGuid"];
        _originalImageStr = [attributes objectForKey:@"OriginalImge"];
        _name = [attributes objectForKey:@"Name"];
        _Attributes = [attributes objectForKey:@"Attributes"];
        _buyNumber = [attributes objectForKey:@"BuyNumber"] == [NSNull null] ? 0 :[[attributes objectForKey:@"BuyNumber"] integerValue];
        _RepertoryCount = [attributes objectForKey:@"RepertoryNumber"] == [NSNull null] ? 0 : [[attributes objectForKey:@"RepertoryNumber"] intValue];
        _prmo = [[attributes objectForKey:@"prmo"] floatValue];
        _buyScore = [[attributes objectForKey:@"BuyScore"] integerValue];
        _createTime = [attributes objectForKey:@"CreateTime"];
        _IsJoinActivity = [attributes objectForKey:@"IsJoinActivity"] == [NSNull null] ? 0 : [[attributes objectForKey:@"IsJoinActivity"] integerValue];
        _isCheckForShopCart = NO;
        _CouponRule = [attributes objectForKey:@"CouponRule"];
        _MemberI=[[attributes objectForKey:@"Discount"] integerValue];
    }
    
    return self;
}

- (NSURL*)originalImage{

    _originalImageStr = [_originalImageStr hasPrefix:@"http"] ? _originalImageStr : [kWebMainBaseUrl stringByAppendingString:_originalImageStr];
    return [NSURL URLWithString:_originalImageStr];
}

+ (void)getScoreShopCartMerchandiseListByParamer:(NSDictionary *)parameters andblock:(void (^)(NSArray *, NSError *))block{
    
    [[AFAppAPIClient sharedClient] getPath:kWebServiceGetScoreShopCartPath parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON){
        
        NSArray *searchFromResponse = [JSON objectForKey:@"DATA"];
        NSMutableArray *mutableSearch = [NSMutableArray arrayWithCapacity:[searchFromResponse count]];
        for (NSDictionary *attributes in searchFromResponse) {
            ShopCartScoreMerchandiseModel *shopCart = [[ShopCartScoreMerchandiseModel alloc] initWithAttributes:attributes];
            [mutableSearch addObject:shopCart];
        }
        
        if(block){
            block([NSArray arrayWithArray:mutableSearch],nil);
        }
        
    }failure:^(AFHTTPRequestOperation *operation,NSError *error){
        if(block){
            block([NSArray array],error);
        }
    }];
}

+(void)deleteScoreShopCartMerchandiseByParamer:(NSDictionary *)parameters andblock:(void (^)(NSInteger, NSError *))block{
    
    [[AFAppAPIClient sharedClient] getPath:kWebServiceDeleteScoreShopCartPath parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON){
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
