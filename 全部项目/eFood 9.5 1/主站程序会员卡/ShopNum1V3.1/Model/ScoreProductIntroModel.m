//
//  ScoreProductIntroModel.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-11-19.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "ScoreProductIntroModel.h"

@implementation ScoreProductIntroModel

- (id)initWithAttributes:(NSDictionary *)attributes{
    self = [super init];
    if(!self){
        return self;
    }
    
    _guid = [attributes objectForKey:@"Guid"];
    _name = [attributes objectForKey:@"Name"];
    _originalImageStr = [attributes objectForKey:@"OriginalImge"];
    _prmo = [attributes valueForKey:@"prmo"] == [NSNull null] ? 0 : [[attributes valueForKey:@"prmo"] floatValue];
    _ExchangeScore = [attributes valueForKey:@"ExchangeScore"] == [NSNull null] ? 0 : [[attributes valueForKey:@"ExchangeScore"] integerValue];
    _SaleNumber = [attributes valueForKey:@"SaleNumber"] == [NSNull null] ? 0 : [[attributes valueForKey:@"SaleNumber"] integerValue];
    return self;
}

- (NSURL *)originalImage{
//    return [NSURL URLWithString:[_originalImageStr stringByReplacingOccurrencesOfString:@"180" withString:@"300"]];
    return [NSURL URLWithString:_originalImageStr];
}

/*
 type 1：新品 2：推荐 3：热卖 4：精品
 sorts ModifyTime:时间   Price：价格  SaleNumber：销售量
 isAsc True：升序  false：降序
 */
+ (void)getScoreMerchandiseIntroForHomeShowByParamer:(NSDictionary *)parameters andBlocks:(void (^)(NSArray *, NSError *))block{
    
    [[AFAppAPIClient sharedClient] getPath:kWebServiceScoreProductListHomeShopsPath parameters:parameters success:^(AFHTTPRequestOperation *operation,id JSON){
        NSArray *merchandiseIntroResponse = [JSON objectForKey:@"DATA"];
        NSMutableArray *mutableMerchandiseIntro = [NSMutableArray arrayWithCapacity:[merchandiseIntroResponse count]];
        
        for (NSDictionary *attribute in merchandiseIntroResponse) {
            ScoreProductIntroModel *intro = [[ScoreProductIntroModel alloc] initWithAttributes:attribute];
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
