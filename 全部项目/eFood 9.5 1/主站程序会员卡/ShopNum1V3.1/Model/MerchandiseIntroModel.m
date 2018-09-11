//
//  MerchandiseIntro.m
//  Shop
//
//  Created by Ocean Zhang on 3/23/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import "MerchandiseIntroModel.h"
#import "AFAppAPIClient.h"

@implementation MerchandiseIntroModel

@synthesize guid = _guid;
@synthesize name = _name;
@synthesize originalImageStr = _originalImageStr;
@synthesize originalImage = _originalImage;
@synthesize marketPrice = _marketPrice;
@synthesize shopPrice = _shopPrice;
@synthesize buyCount = _buyCount;
//@synthesize imagesList = _imagesList;
//@synthesize productNum = _productNum;
//@synthesize brandName = _brandName;
//@synthesize repertoryCount = _repertoryCount;
//@synthesize unitName = _unitName;

- (id)initWithAttributes:(NSDictionary *)attributes{
    self = [super init];
    if(!self){
        return self;
    }
    
    _guid = [attributes objectForKey:@"Guid"];
    _name = [attributes objectForKey:@"Name"];
    _originalImageStr = [attributes objectForKey:@"OriginalImge"];
    _marketPrice = [attributes valueForKey:@"MarketPrice"] == [NSNull null] ? 0 : [[attributes valueForKey:@"MarketPrice"] floatValue];
    _shopPrice = [attributes valueForKey:@"ShopPrice"] == [NSNull null] ? 0 : [[attributes valueForKey:@"ShopPrice"] floatValue];
    _buyCount = [attributes valueForKey:@"SaleNumber"] == [NSNull null] ? 0 : [[attributes valueForKey:@"SaleNumber"] integerValue];
    _scorePrice = [attributes valueForKey:@"SocrePrice"] == [NSNull null] ? 0 : [[attributes valueForKey:@"SocrePrice"] floatValue];
//    _imagesList = [attributes objectForKey:@"ImagesList"];
//    _productNum = [attributes objectForKey:@"ProductNum"];
//    _brandName = [attributes objectForKey:@"BrandName"];
//    _repertoryCount = [[attributes objectForKey:@"RepertoryCount"] intValue];
//    _unitName = [attributes objectForKey:@"UnitName"];
    return self;
}

- (NSURL *)originalImage{
    return [NSURL URLWithString:_originalImageStr];
}

/*
    type 1：新品 2：推荐 3：热卖 4：精品
    sorts ModifyTime:时间   Price：价格  SaleNumber：销售量
    isAsc True：升序  false：降序
*/
+ (void)getMerchandiseIntroForHomeShowByParamer:(NSDictionary *)parameters andBlocks:(void (^)(NSArray *, NSError *))block{
    
    [[AFAppAPIClient sharedClient] getPath:kWebServiceHomeShopsPath parameters:parameters success:^(AFHTTPRequestOperation *operation,id JSON){
        NSArray *merchandiseIntroResponse = [JSON objectForKey:@"Data"];
        NSMutableArray *mutableMerchandiseIntro = [NSMutableArray arrayWithCapacity:[merchandiseIntroResponse count]];
        
        for (NSDictionary *attribute in merchandiseIntroResponse) {
            MerchandiseIntroModel *intro = [[MerchandiseIntroModel alloc] initWithAttributes:attribute];
            [mutableMerchandiseIntro addObject:intro];
        }
        
        if(block){
            block([NSArray arrayWithArray:mutableMerchandiseIntro],nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        if(block){
            block([NSArray array],error);
        }
    }];
}

+(void)getGetScoreProductListByParamer:(NSDictionary *)parameters andBlocks:(void (^)(NSArray *ScoreProductList, NSError *error))block{
    [[AFAppAPIClient sharedClient] getPath:kWebGetScoreProductPath parameters:parameters success:^(AFHTTPRequestOperation *operation,id JSON){
        NSArray *merchandiseIntroResponse = [JSON objectForKey:@"data"];
        NSMutableArray *mutableMerchandiseIntro = [NSMutableArray arrayWithCapacity:[merchandiseIntroResponse count]];
        
        for (NSDictionary *attribute in merchandiseIntroResponse) {
            MerchandiseIntroModel *intro = [[MerchandiseIntroModel alloc] initWithAttributes:attribute];
            [mutableMerchandiseIntro addObject:intro];
        }
        
        if(block){
            block([NSArray arrayWithArray:mutableMerchandiseIntro],nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        if(block){
            block([NSArray array],error);
        }
    }];

}

+ (void)getSearchProductListByParamer:(NSDictionary *)parameters andBlocks:(void(^)(NSArray *searchList,NSError *error))block{
    [[AFAppAPIClient sharedClient] getPath:kWebSearchProductPath parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON){
        NSInteger  count = [[JSON objectForKey:@"Count"] intValue];
        if (count == 0) {
            if(block){
                block([NSArray array],nil);
            }
        }else{
            NSArray *searchFromResponse = [JSON objectForKey:@"Data"];
            NSMutableArray *mutableSearch = [NSMutableArray arrayWithCapacity:[searchFromResponse count]];
            for (NSDictionary *attributes in searchFromResponse) {
                MerchandiseIntroModel *Search = [[MerchandiseIntroModel alloc] initWithAttributes:attributes];
                [mutableSearch addObject:Search];
            }
            
            if(block){
                block([NSArray arrayWithArray:mutableSearch],nil);
            }
            
            
        }
    }failure:^(AFHTTPRequestOperation *operation,NSError *error){
        if(block){
            block([NSArray array],error);
        }
    }];
    
}

//----------------------------------------------------------------------------------------
+ (void)searchMerchandiseIntroSorts:(NSString *)sort isAsc:(Boolean)isAsc pageIndex:(NSInteger)pageIndex pageCount:(NSInteger)pageCount name:(NSString *)name city:(NSString *)cityUrl andBlocks:(void (^)(NSArray *, NSError *))block{
    NSString *asc = @"false";
    if(isAsc)
        asc = @"true";
    
    NSString *url = [NSString stringWithFormat:@"/api/product/search/-1?sorts=%@&isASC=%@&pageIndex=%d&pageCount=%d&name=%@&CityDomainName=%@",sort,asc,pageIndex,pageCount,name,cityUrl];
    NSString *utfUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[AFAppAPIClient sharedClient] getPath:utfUrl parameters:nil success:^(AFHTTPRequestOperation *operation,id JSON){
        NSArray *merchandiseIntroResponse = [JSON objectForKey:@"Data"];
        NSMutableArray *mutableMerchandiseIntro = [NSMutableArray arrayWithCapacity:[merchandiseIntroResponse count]];
        
        for (NSDictionary *attribute in merchandiseIntroResponse) {
            MerchandiseIntroModel *intro = [[MerchandiseIntroModel alloc] initWithAttributes:attribute];
            [mutableMerchandiseIntro addObject:intro];
        }
        
        if(block){
            block([NSArray arrayWithArray:mutableMerchandiseIntro],nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        if(block){
            block([NSArray array],error);
        }
    }];
}

+ (void)getMerchandiseByCategory:(NSString *)categoryCode Sorts:(NSString *)sort isAsc:(Boolean)isAsc pageIndex:(NSInteger)pageIndex pageCount:(NSInteger)count City:(NSString *)cityName andBlocks:(void (^)(NSArray *, NSError *))block{
    NSString *asc = @"false";
    if(isAsc)
        asc = @"true";
    
    NSString *url = [NSString stringWithFormat:@"api/product/list/%@?sorts=%@&isASC=%@&pageIndex=%d&pageCount=%d&CityDomainName=%@",categoryCode, sort,asc,pageIndex,count,cityName];
    NSString *utfUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[AFAppAPIClient sharedClient2] getPath:utfUrl parameters:nil success:^(AFHTTPRequestOperation *operation,id JSON){
        NSArray *merchandiseIntroResponse = [JSON objectForKey:@"Data"];
        NSMutableArray *mutableMerchandiseIntro = [NSMutableArray arrayWithCapacity:[merchandiseIntroResponse count]];
        
        for (NSDictionary *attribute in merchandiseIntroResponse) {
            MerchandiseIntroModel *intro = [[MerchandiseIntroModel alloc] initWithAttributes:attribute];
            [mutableMerchandiseIntro addObject:intro];
        }
        
        if(block){
            block([NSArray arrayWithArray:mutableMerchandiseIntro],nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        if(block){
            block([NSArray array],error);
        }
    }];

}


+ (void)getShopMerchandiseByType:(NSInteger)type Sorts:(NSString *)sort isAsc:(Boolean)isAsc pageIndex:(NSInteger)pageIndex pageCount:(NSInteger)pageCount shopID:(NSString *)shopID andBlocks:(void (^)(NSArray *, NSError *))block{
    NSString *asc = @"false";
    if(isAsc)
        asc = @"true";
    
    NSString *url = [NSString stringWithFormat:@"api/product1/type/?type=%d&sorts=%@&isASC=%@&pageIndex=%d&pageCount=%d&shopid=%@",type,sort, asc,pageIndex,pageCount,shopID];
    NSString *utfUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[AFAppAPIClient sharedClient] getPath:utfUrl parameters:nil success:^(AFHTTPRequestOperation *operation,id JSON){
        NSArray *merchandiseIntroResponse = [JSON objectForKey:@"Data"];
        NSMutableArray *mutableMerchandiseIntro = [NSMutableArray arrayWithCapacity:[merchandiseIntroResponse count]];
        
        for (NSDictionary *attribute in merchandiseIntroResponse) {
            MerchandiseIntroModel *intro = [[MerchandiseIntroModel alloc] initWithAttributes:attribute];
            [mutableMerchandiseIntro addObject:intro];
        }
        
        if(block){
            block([NSArray arrayWithArray:mutableMerchandiseIntro],nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        if(block){
            block([NSArray array],error);
        }
    }];
}

+ (void)getShopMerchandiseByCategory:(NSInteger)categoryID Sorts:(NSString *)sort isAsc:(Boolean)isAsc pageIndex:(NSInteger)pageIndex pageCount:(NSInteger)pageCount shopID:(NSInteger)shopID name:(NSString *)name andBlocks:(void (^)(NSArray *, NSError *))block{
    NSString *asc = @"false";
    if(isAsc)
        asc = @"true";
    
    if(allTrim(name).length == 0){
        name = @"";
    }
    
    NSString *url = [NSString stringWithFormat:@"api/product/list/%d?sorts=%@&isASC=%@&pageIndex=%d&pageCount=%d&shopid=%d&name=%@",categoryID,sort,asc,pageIndex,pageCount,shopID,name];
    NSString *utfUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[AFAppAPIClient sharedClient] getPath:utfUrl parameters:nil success:^(AFHTTPRequestOperation *operation,id JSON){
        NSArray *merchandiseIntroResponse = [JSON objectForKey:@"Data"];
        NSMutableArray *mutableMerchandiseIntro = [NSMutableArray arrayWithCapacity:[merchandiseIntroResponse count]];
        
        for (NSDictionary *attribute in merchandiseIntroResponse) {
            MerchandiseIntroModel *intro = [[MerchandiseIntroModel alloc] initWithAttributes:attribute];
            [mutableMerchandiseIntro addObject:intro];
        }
        
        if(block){
            block([NSArray arrayWithArray:mutableMerchandiseIntro],nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        if(block){
            block([NSArray array],error);
        }
    }];

}

///筛选
+ (void)getMerchandiseListByFilterParamer:(NSDictionary *)parameters CategoryID:(NSString *)CategoryID andBlocks:(void(^)(NSArray *merchandiseList,NSError *error))block {
    [[AFAppAPIClient sharedClient] getPath:[NSString stringWithFormat:@"/api/product/filterr/%@/?", CategoryID] parameters:parameters success:^(AFHTTPRequestOperation *operation,id JSON){
        NSArray *merchandiseIntroResponse = [JSON objectForKey:@"Data"];
        NSMutableArray *mutableMerchandiseIntro = [NSMutableArray arrayWithCapacity:[merchandiseIntroResponse count]];
        
        for (NSDictionary *attribute in merchandiseIntroResponse) {
            MerchandiseIntroModel *intro = [[MerchandiseIntroModel alloc] initWithAttributes:attribute];
            [mutableMerchandiseIntro addObject:intro];
        }
        
        if(block){
            block([NSArray arrayWithArray:mutableMerchandiseIntro],nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        if(block){
            block([NSArray array],error);
        }
    }];

}
@end
