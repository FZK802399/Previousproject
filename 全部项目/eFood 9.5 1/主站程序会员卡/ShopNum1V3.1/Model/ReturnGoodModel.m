//
//  ReturnGoodModel.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-9-19.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "ReturnGoodModel.h"

@implementation ReturnGoodModel

- (NSURL *)ProductImg{
    
    NSString * tempStr = [_ProductImgStr hasPrefix:@"http"] ? _ProductImgStr :[kWebMainBaseUrl stringByAppendingString:_ProductImgStr];
    
    return [NSURL URLWithString:tempStr];
}

- (id)initWithAttributes:(NSDictionary *)attributes{
    self = [super init];
    if(self){
        _Guid = [attributes objectForKey:@"guid"];
        _ProductGuid = [attributes objectForKey:@"ProductGuid"];
        _ROrderGuid = [attributes objectForKey:@"ROrderGuid"];
        _ReturnCount = [[attributes objectForKey:@"ReturnCount"] integerValue];
        _BuyPrice = [[attributes objectForKey:@"BuyPrice"] floatValue];
        _Attributes = [attributes objectForKey:@"Attributes"];
        _ProductImgStr = [attributes objectForKey:@"ProductImage"];
        //        _OrderType = [[attributes objectForKey:@"OrderType"] integerValue];
    }
    return self;
}

@end
