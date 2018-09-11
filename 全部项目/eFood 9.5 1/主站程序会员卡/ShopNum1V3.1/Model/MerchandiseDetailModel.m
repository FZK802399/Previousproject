//
//  MerchandiseDetailModel.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-20.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "MerchandiseDetailModel.h"

@implementation MerchandiseDetailModel

@synthesize guid = _guid;
@synthesize name = _name;
@synthesize originalImage = _originalImage;
@synthesize originalImageStr = _originalImageStr;
@synthesize repertoryCount = _repertoryCount;
@synthesize unitName = _unitName;
@synthesize marketPrice = _marketPrice;
@synthesize shopPrice = _shopPrice;
@synthesize brandName = _brandName;
@synthesize imagesList = _imagesList;
@synthesize MobileDetail = _MobileDetail;
@synthesize IsBest = _IsBest;
@synthesize MemberI=_MemberI;
- (id)initWithAttributes:(NSDictionary *)attributes{
    self = [super init];
    if(!self){
        return self;
    }
    
    _guid = [attributes objectForKey:@"Guid"];
    _name = [attributes objectForKey:@"Name"];
    _originalImageStr = [attributes objectForKey:@"OriginalImge"];
    _repertoryCount = [attributes objectForKey:@"RepertoryCount"] == [NSNull null] ? 0 : [[attributes objectForKey:@"RepertoryCount"] intValue];
    _unitName = [attributes objectForKey:@"UnitName"];
    _marketPrice = [[attributes objectForKey:@"MarketPrice"] doubleValue];
    _shopPrice = [[attributes objectForKey:@"ShopPrice"] doubleValue];
    _brandName = [attributes objectForKey:@"BrandName"] == [NSNull null] ? @"" :[attributes objectForKey:@"BrandName"];
    _imagesList = [attributes objectForKey:@"Images"];
    _MobileDetail = [attributes objectForKey:@"MobileDetail"] == [NSNull null] ? @"" :[attributes objectForKey:@"MobileDetail"];
    _BuyCount  = [attributes objectForKey:@"SaleNumber"] == [NSNull null] ? 0 :[[attributes objectForKey:@"SaleNumber"] integerValue];
    _IsBest = [attributes objectForKeyedSubscript:@"IsBest"] == [NSNull null] ? 0 : [[attributes objectForKeyedSubscript:@"IsBest"] integerValue];
    _PresentScore = [attributes objectForKeyedSubscript:@"PresentScore"] == [NSNull null] ? 0 : [[attributes objectForKeyedSubscript:@"PresentScore"] integerValue];
    _PresentRankScore = [attributes objectForKeyedSubscript:@"PresentRankScore"] == [NSNull null] ? 0 : [[attributes objectForKeyedSubscript:@"PresentRankScore"] integerValue];
    _productWeight = [attributes objectForKeyedSubscript:@"Weight"] == [NSNull null] ? 0 : [[attributes objectForKeyedSubscript:@"Weight"] floatValue];
    _LimitBuyCount = [attributes objectForKeyedSubscript:@"LimitBuyCount"] == [NSNull null] ? 0 : [[attributes objectForKeyedSubscript:@"LimitBuyCount"] integerValue];
    _IncomeTax = [[attributes objectForKey:@"IncomeTax"] doubleValue];
    _SmallTitle = [attributes objectForKey:@"SmallTitle"] == [NSNull null] ? @"" : [attributes objectForKey:@"SmallTitle"];
    _Brief = [attributes objectForKey:@"Brief"] == [NSNull null] ? @"" : [attributes objectForKey:@"Brief"];
    _CouponRule=[attributes objectForKey:@"CouponRule"] == [NSNull null] ? @"" : [attributes objectForKey:@"CouponRule"];
   _MemberI = [attributes objectForKeyedSubscript:@"Discount"] == [NSNull null] ? 0 : [[attributes objectForKeyedSubscript:@"Discount"] integerValue];
    return self;
}

- (NSURL *)originalImage{
//    _originalImageStr = [_originalImageStr stringByReplacingOccurrencesOfString:@"180" withString:@"300"];
    return [NSURL URLWithString:_originalImageStr];
}

+ (void)getMerchandiseDetailByParamer:(NSDictionary *)parameters andblock:(void (^)(MerchandiseDetailModel *, NSError *))block{
                                             //产品详细
    [[AFAppAPIClient sharedClient] getPath:kWebProductDetailPath parameters:parameters success:^(AFHTTPRequestOperation *operation,id JSON){
        
        NSDictionary *response = [JSON objectForKey:@"ProductInfo"];
        NSLog(@"response==%@",response);
        NSNull *Null = [[NSNull alloc]init];
        MerchandiseDetailModel *detail = nil;
        
        if (![response isEqual:Null]) {
            detail = [[MerchandiseDetailModel alloc] initWithAttributes:response];
            detail.OneYuanGouMemo = [JSON objectForKey:@"OneYuanGouMemo"] == [NSNull null] ? nil : [JSON objectForKey:@"OneYuanGouMemo"];
            detail.LimitTimeBuy = [JSON objectForKey:@"LimitTimeBuy"] == [NSNull null] ? nil : [JSON objectForKey:@"LimitTimeBuy"];
            detail.LimitCountBuy = [JSON objectForKey:@"LimitCountBuy"] == [NSNull null] ? nil : [JSON objectForKey:@"LimitCountBuy"];
        }
        if(block){
            block(detail,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        if(block){
            block(nil,error);
        }
    }];
}


+(void)addMerchandiseToCollectByParamer:(NSDictionary *)parameters andblock:(void (^)(NSInteger, NSError *))block{
                                           //订单列表
    [[AFAppAPIClient sharedClient] getPath:kWebShopCollectAddPath parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON){
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

+(void)getMerchandiseAreaStockByParamer:(NSDictionary *)parameters andblock:(void (^)(NSInteger, NSError *))block{
                                          //库存
    [[AFAppAPIClient sharedClient] getPath:kWebProductStockByAreaPath parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON){
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

+(void)addMerchandiseToShopCartByParamer:(NSDictionary *)parameters andblock:(void (^)(NSInteger, NSError *))block{
    
    NSError *testError;
    NSData *testData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&testError];
    NSString *testStr = [[NSString alloc] initWithBytes:[testData bytes] length:[testData length] encoding:NSUTF8StringEncoding];
    NSLog(@"testStr == =%@",testStr);
    
//    NSString * urlstr = [NSString stringWithFormat:@"%@?AppSign=%@", kWebShopCartAddPath, kWebAppSign];
//    NSLog(@"urlstr== ==%@", urlstr);
    
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/html", nil]];
    //    @"/api/orderpricecaculate/"
    [AFAppAPIClient sharedClient].parameterEncoding = AFJSONParameterEncoding;
                                            //添加购物车
    [[AFAppAPIClient sharedClient] postPath:kWebShopCartAddPath parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON){
        [AFAppAPIClient sharedClient].parameterEncoding = AFFormURLParameterEncoding;
        NSInteger returnFromResponse = [[JSON objectForKey:@"return"] intValue];
        
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
