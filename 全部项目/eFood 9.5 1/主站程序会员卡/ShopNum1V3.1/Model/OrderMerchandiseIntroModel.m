//
//  OrderMerchandiseIntroModel.m
//  Shop
//
//  Created by Ocean Zhang on 4/17/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import "OrderMerchandiseIntroModel.h"

@implementation OrderMerchandiseIntroModel

@synthesize Guid = _Guid;
@synthesize ProductGuid = _ProductGuid;
@synthesize ProductName = _ProductName;
@synthesize BuyNumber = _BuyNumber;
@synthesize BuyPrice = _BuyPrice;
@synthesize SpecificationName = _SpecificationName;
@synthesize ProductImg = _ProductImg;
@synthesize ProductImgStr = _ProductImgStr;

@synthesize orderNum = _orderNum;

- (NSURL *)ProductImg{
    
    NSString * tempStr = [_ProductImgStr hasPrefix:@"http"] ? _ProductImgStr :[kWebMainBaseUrl stringByAppendingString:_ProductImgStr];
    
//    return [NSURL URLWithString:[tempStr stringByReplacingOccurrencesOfString:@"180" withString:@"300"]];
     return [NSURL URLWithString:tempStr];
}

- (id)initWithAttributes:(NSDictionary *)attributes andOrderNum:(NSString *)orderNum{
    self = [super init];
    if(self){
        _Guid = [attributes objectForKey:@"Guid"];
        _ProductGuid = [attributes objectForKey:@"ProductGuid"];
        _ProductName = [attributes objectForKey:@"NAME"];
        _BuyNumber = [[attributes objectForKey:@"BuyNumber"] intValue];
        _refundNum = _BuyNumber;
        _BuyPrice = [[attributes objectForKey:@"BuyPrice"] floatValue];
        ///规格
        _SpecificationName = [attributes objectForKey:@"Attributes"];
        _ProductImgStr = [attributes objectForKey:@"OriginalImge"];
        _Name = [attributes objectForKey:@"Name"];
        _BuyScore = [[attributes objectForKey:@"BuyScore"] intValue];
        _prmo = [[attributes objectForKey:@"prmo"] floatValue];
        _isSelect = NO;
        _orderNum = orderNum;
        _Rank = 0;
    }
    return self;
}

@end
