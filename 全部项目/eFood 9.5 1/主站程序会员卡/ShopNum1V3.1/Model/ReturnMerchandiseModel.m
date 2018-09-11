//
//  ReturnMerchandiseModel.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-9-5.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "ReturnMerchandiseModel.h"

@implementation ReturnMerchandiseModel

- (NSURL *)ProductImg{
    
    NSString * tempStr = [_ProductImgStr hasPrefix:@"http"] ? _ProductImgStr :[kWebMainBaseUrl stringByAppendingString:_ProductImgStr];
    
    return [NSURL URLWithString:tempStr];
}

- (id)initWithAttributes:(NSDictionary *)attributes{
    self = [super init];
    if(self){
        _OrderGuid = [attributes objectForKey:@"OrderInfoGuid"];
        _ProductGuid = [attributes objectForKey:@"ProductGuid"];
        _ProductName = [attributes objectForKey:@"NAME"];
        _ReturnCount = 1;
        _BuyPrice = [[attributes objectForKey:@"BuyPrice"] floatValue];
        _Attributes = [attributes objectForKey:@"Attributes"];
        _ProductImgStr = [attributes objectForKey:@"OriginalImge"];
        _buyNumer = [[attributes objectForKey:@"BuyNumber"] intValue];
//        _OrderType = [[attributes objectForKey:@"OrderType"] integerValue];
    }
    return self;
}

@end
