//
//  ScoreProductDetialModel.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-11-19.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "ScoreProductDetialModel.h"

@implementation ScoreProductDetialModel

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
    _RepertoryAlertCount = [attributes valueForKey:@"RepertoryAlertCount"] == [NSNull null] ? 0 : [[attributes valueForKey:@"RepertoryAlertCount"] integerValue];
    _RepertoryCount = [attributes valueForKey:@"RepertoryCount"] == [NSNull null] ? 0 : [[attributes valueForKey:@"RepertoryCount"] integerValue];
    _Description = [attributes objectForKey:@"Description"];
    _Detail = [attributes objectForKey:@"Detail"];
    _Memo = [attributes objectForKey:@"Memo"];
    _Title = [attributes objectForKey:@"Title"];
    _Keywords = [attributes objectForKey:@"Keywords"];
    _ClickCount = [attributes valueForKey:@"ClickCount"] == [NSNull null] ? 0 : [[attributes valueForKey:@"ClickCount"] integerValue];
    _CommentCount = [attributes valueForKey:@"CommentCount"] == [NSNull null] ? 0 : [[attributes valueForKey:@"CommentCount"] integerValue];
    _IsReal = [attributes valueForKey:@"IsReal"] == [NSNull null] ? 0 : [[attributes valueForKey:@"IsReal"] integerValue];
    
    return self;
}

- (NSURL *)originalImage{
//    return [NSURL URLWithString:[_originalImageStr stringByReplacingOccurrencesOfString:@"180" withString:@"300"]];
    return [NSURL URLWithString:_originalImageStr];
}

+ (void)getScoreMerchandiseDetailWithParamer:(NSDictionary *)parameters andBlocks:(void (^)(ScoreProductDetialModel *, NSError *))block{
    
    [[AFAppAPIClient sharedClient] getPath:kWebServiceScoreProductDetailPath parameters:parameters success:^(AFHTTPRequestOperation *operation,id JSON){
        NSArray *merchandiseIntroResponse = [JSON objectForKey:@"DATA"];
        ScoreProductDetialModel *intro = [[ScoreProductDetialModel alloc] initWithAttributes:[merchandiseIntroResponse objectAtIndex:0]];
        
        if(block){
            block(intro, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        if(block){
            block(nil, error);
        }
    }];
}

+(void)addScoreMerchandiseToShopCartByParamer:(NSDictionary *)parameters andblock:(void (^)(NSInteger, NSError *))block {
    
//    NSError *testError;
//    NSData *testData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&testError];
//    NSString *testStr = [[NSString alloc] initWithBytes:[testData bytes] length:[testData length] encoding:NSUTF8StringEncoding];
//    NSLog(@"testStr == =%@",testStr);
    
    NSString * urlstr = [NSString stringWithFormat:@"%@?AppSign=%@", kWebServiceScoreProductAddShopCartPath, [parameters objectForKey:@"AppSign"]];
//    NSLog(@"urlstr====%@", urlstr);
    
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/html", nil]];
    [AFAppAPIClient sharedClient].parameterEncoding = AFJSONParameterEncoding;
    [[AFAppAPIClient sharedClient] postPath:urlstr parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON){
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
