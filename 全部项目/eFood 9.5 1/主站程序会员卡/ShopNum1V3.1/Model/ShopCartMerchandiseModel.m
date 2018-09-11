//
//  ShopCartMerchandiseModel.m
//  Shop
//
//  Created by Ocean Zhang on 4/13/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import "ShopCartMerchandiseModel.h"

@implementation ShopCartMerchandiseModel

@synthesize guid = _guid;
@synthesize productGuid = _productGuid;
@synthesize originalImage = _originalImage;
@synthesize originalImageStr = _originalImageStr;
@synthesize name = _name;
@synthesize repertoryNumber = _repertoryNumber;
@synthesize Attributes = _Attributes;
@synthesize buyNumber = _buyNumber;
@synthesize RepertoryCount = _RepertoryCount;
@synthesize buyPrice = _buyPrice;
@synthesize MarketPrice = _MarketPrice;
@synthesize createTime = _createTime;
@synthesize specificationName = _specificationName;
@synthesize specificationValue = _specificationValue;
@synthesize isCheckForShopCart = _isCheckForShopCart;
@synthesize IsJoinActivity = _IsJoinActivity;
@synthesize CouponRule=_CouponRule;
- (id)initWithAttributes:(NSDictionary *)attributes{
    self = [super init];
    if(self){
        _CouponRule = [attributes objectForKey:@"CouponRule"];
        _guid = [attributes objectForKey:@"Guid"];
        _productGuid = [attributes objectForKey:@"ProductGuid"];
        _originalImageStr = [attributes objectForKey:@"OriginalImge"];
        _name = [attributes objectForKey:@"Name"];
        _repertoryNumber = [attributes objectForKey:@"RepertoryNumber"];
        _Attributes = [attributes objectForKey:@"Attributes"];
        _buyNumber = [attributes objectForKey:@"BuyNumber"] == [NSNull null] ? 0 :[[attributes objectForKey:@"BuyNumber"] integerValue];
        _RepertoryCount = [attributes objectForKey:@"ExtensionAttriutes"] == [NSNull null] ? 0 : [[attributes objectForKey:@"ExtensionAttriutes"] intValue];
        _buyPrice = [[attributes objectForKey:@"BuyPrice"] doubleValue];
        _MarketPrice = [[attributes objectForKey:@"MarketPrice"] doubleValue];
        _createTime = [attributes objectForKey:@"CreateTime"];
        _specificationName = [attributes objectForKey:@"DetailedSpecifications"];
        _specificationValue = [attributes objectForKey:@"SpecificationValue"];
        _IsJoinActivity = [attributes objectForKey:@"IsJoinActivity"] == [NSNull null] ? 0 : [[attributes objectForKey:@"IsJoinActivity"] integerValue];
        _IncomeTax = [[attributes objectForKey:@"IncomeTax"] doubleValue];
        _isCheckForShopCart = NO;
        _isEdit = YES;
    }
    
    return self;
}

- (NSURL*)originalImage{
    _originalImageStr = [_originalImageStr stringByReplacingOccurrencesOfString:@"90" withString:@"300"];
    return [NSURL URLWithString:_originalImageStr];   
}

+ (void)getShopCartMerchandiseListByParamer:(NSDictionary *)parameters andblock:(void(^)(NSArray *,NSError *))block{
    
    [[AFAppAPIClient sharedClient] getPath:kWebShopCartListPath parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON){
//        if ([[JSON objectForKey:@"Data"]isEqualToString:@"获取购物车列表失败"]) {
//            return ;
//        }
        id response = [JSON objectForKey:@"Data"];
        NSMutableArray *mutableSearch = [NSMutableArray array];
        if ([response isKindOfClass:[NSArray class]]) {
            NSArray *searchFromResponse = response;
            for (NSDictionary *attributes in searchFromResponse) {
                ShopCartMerchandiseModel *shopCart = [[ShopCartMerchandiseModel alloc] initWithAttributes:attributes];
                [mutableSearch addObject:shopCart];
            }
        }
        if(block){
            block(mutableSearch,nil);
        }
        
    }failure:^(AFHTTPRequestOperation *operation,NSError *error){
        if(block){
            block([NSArray array],error);
        }
    }];
}

+(void)deleteShopCartMerchandiseByParamer:(NSDictionary *)parameters andblock:(void (^)(NSInteger, NSError *))block{
    
    [[AFAppAPIClient sharedClient] getPath:kWebShopCartDeletePath parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON){
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
