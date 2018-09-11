//
//  PostageModel.m
//  Shop
//
//  Created by Ocean Zhang on 4/29/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import "PostageModel.h"
#import "AFAppAPIClient.h"

@implementation PostageModel


- (id)initWithAttribute:(NSDictionary *)attribute{
    self = [super self];
    if(self){
        _Guid = [attribute objectForKey:@"Guid"];
        _IsPayArrived = [attribute objectForKey:@"IsPayArrived"] == [NSNull null] ? 0 :[[attribute objectForKey:@"IsPayArrived"] integerValue];
        _name = [attribute objectForKey:@"Name"];
        _SafeCost = [attribute objectForKey:@"SafeCost"] == [NSNull null] ? 0 :[[attribute objectForKey:@"SafeCost"] floatValue];
        _Remark = [attribute objectForKey:@"Remark"];
        _peipr = [attribute objectForKey:@"peipr"] == [NSNull null] ? 0 :[[attribute objectForKey:@"peipr"] floatValue];
        _baopr = [attribute objectForKey:@"SafeCost"] ==[NSNull null] ? 0 :[[attribute objectForKey:@"SafeCost"] floatValue];
        
        _name2 = [attribute objectForKey:@"NAME"];
  
    }
    
    return self;
}

+ (void)getPostagePrice:(NSDictionary *)paramer andblock:(void (^)(NSArray *, NSError *))block{
//    修改回去 记得
    [[AFAppAPIClient sharedClient] getPath:kWebdispatchmodelistbycodePath parameters:paramer success:^(AFHTTPRequestOperation *operation,id JSON){
        NSArray *response = [JSON objectForKey:@"Data"];
        NSMutableArray *list = [[NSMutableArray alloc] initWithCapacity:[response count]];
        for (NSDictionary *dict in response) {
            PostageModel *payType = [[PostageModel alloc] initWithAttribute:dict];
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
