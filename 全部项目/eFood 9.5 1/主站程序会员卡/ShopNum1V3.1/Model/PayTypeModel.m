//
//  PayTypeModel.m
//  Shop
//
//  Created by Ocean Zhang on 4/16/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import "PayTypeModel.h"
#import "AFAppAPIClient.h"

@implementation PayTypeModel

@synthesize guid = _guid;
@synthesize paymentType = _paymentType;
@synthesize name = _name;

- (id)initWithAttributes:(NSDictionary *)attributes{
    self = [super init];
    if(self){
        _guid = [attributes objectForKey:@"Guid"];
        _paymentType = [attributes objectForKey:@"PaymentType"];
        _name = [attributes objectForKey:@"NAME"];
    }
    return self;
}

+ (void)getPayTypeWithParameters:(NSDictionary *)parameters andblock:(void (^)(NSArray *, NSError *))block{

    [[AFAppAPIClient sharedClient] getPath:kWebGetPaymentListPath parameters:parameters success:^(AFHTTPRequestOperation *operation,id JSON){
        NSArray *response = [JSON objectForKey:@"data"];
        NSMutableArray *list = [[NSMutableArray alloc] initWithCapacity:[response count]];
        for (NSDictionary *dict in response) {
            PayTypeModel *payType = [[PayTypeModel alloc] initWithAttributes:dict];
            [list addObject:payType];
        }
        
        if(block){
            block(list,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        if(block){
            block(nil,error);
        }
    }];

}

@end
