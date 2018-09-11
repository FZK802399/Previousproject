//
//  OrderMerchandiseSubmitModel.m
//  Shop
//
//  Created by Ocean Zhang on 4/16/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import "OrderMerchandiseSubmitModel.h"

@implementation OrderMerchandiseSubmitModel

@synthesize Attributes = _Attributes;
@synthesize BuyNumber = _BuyNumber;
@synthesize BuyPrice = _BuyPrice;
@synthesize CreateTime = _CreateTime;
@synthesize CreateTimeStr = _CreateTimeStr;
@synthesize Guid = _Guid;
@synthesize MarketPrice = _MarketPrice;
@synthesize MemLoginID = _MemLoginID;
@synthesize Name = _Name;
@synthesize OriginalImge = _OriginalImge;
@synthesize ProductGuid = _ProductGuid;
@synthesize ShopID = _ShopID;
@synthesize ShopName = _ShopName;
@synthesize SpecificationName = _SpecificationName;
@synthesize SpecificationValue = _SpecificationValue;
@synthesize CouponRule=_CouponRule;
@synthesize MemberI=_MemberI;
- (NSString *)CreateTimeStr{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh-mm-ss"];
    return [dateFormatter stringFromDate:_CreateTime];
}

@end
