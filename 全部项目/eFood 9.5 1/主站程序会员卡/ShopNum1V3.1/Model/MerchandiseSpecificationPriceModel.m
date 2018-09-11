//
//  MerchandiseSpecificationPrice.m
//  Shop
//
//  Created by Ocean Zhang on 4/18/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import "MerchandiseSpecificationPriceModel.h"
#import "AFAppAPIClient.h"

@implementation MerchandiseSpecificationPriceModel

@synthesize ProductGuid = _ProductGuid;
@synthesize SpecDetail = _SpecDetail;
@synthesize SpecTotalId = _SpecTotalId;
@synthesize GoodsPrice = _GoodsPrice;
@synthesize GoodsStock = _GoodsStock;
@synthesize GoodsNumber = _GoodsNumber;
@synthesize ShopID = _ShopID;

- (id)initWithAttributes:(NSDictionary *)attributes{
    self = [super init];
    if(self){
        _ProductGuid = [attributes objectForKey:@"ProductGuid"];
        _SpecDetail = [attributes objectForKey:@"SpecDetail"];
        _SpecTotalId = [attributes objectForKey:@"SpecTotalId"];
        _GoodsPrice = [attributes objectForKey:@"Price"] == [NSNull null] ? 0 :[[attributes objectForKey:@"Price"] floatValue];
        _GoodsStock = [attributes objectForKey:@"RepertoryCount"] == [NSNull null] ? 0 :[[attributes objectForKey:@"RepertoryCount"] intValue];
        _GoodsNumber = [attributes objectForKey:@"GoodsNumber"];
        _ShopID = [attributes objectForKey:@"Detail"];
    }
    return self;
}

+ (void)getPriceWithparameters:(NSDictionary *)parameters andblock:(void (^)(MerchandiseSpecificationPriceModel *, NSError *))block{
    
    [[AFAppAPIClient sharedClient] getPath:kWebProductSpecificationPricePath parameters:parameters success:^(AFHTTPRequestOperation *operation,id JSON){
        NSArray *response = [JSON objectForKey:@"Specification"];
        
        MerchandiseSpecificationPriceModel *result = nil;
        if([response count] > 0){
            result = [[MerchandiseSpecificationPriceModel alloc] initWithAttributes:[response objectAtIndex:0]];
        }
        if(block){
            block(result,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        if(block){
            block(nil,error);
        }
    }];
}

@end
