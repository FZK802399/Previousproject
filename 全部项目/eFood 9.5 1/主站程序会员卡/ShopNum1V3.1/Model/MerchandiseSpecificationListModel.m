//
//  MerchandiseSpecificationList.m
//  Shop
//
//  Created by Ocean Zhang on 4/1/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import "MerchandiseSpecificationListModel.h"
#import "MerchandiseSpecificationModel.h"

@implementation MerchandiseSpecificationListModel

@synthesize specValueName = _specValueName;
@synthesize specificationDict = _specificationDict;
@synthesize specification = _specification;

- (id)initWithAttributes:(NSDictionary *)attributes{
    self = [super init];
    if(!self){
        return self;
    }
    _specValueName = [attributes objectForKey:@"SpecValueName"];
    _specificationDict = [attributes objectForKey:@"Specification"];
    return self;
}

- (NSArray *)specification{
    NSMutableArray *lsit = [NSMutableArray arrayWithCapacity:[_specificationDict count]];
    
    for (NSDictionary *dict  in _specificationDict) {
        MerchandiseSpecificationModel *detail = [[MerchandiseSpecificationModel alloc] initWithAttributes:dict];
        [lsit addObject:detail];
    }
    
    return [NSArray arrayWithArray:lsit];
}

+ (void)getMerchandiseSpecificationListByParameters:(NSDictionary *)parameters andblock:(void (^)(NSArray *, NSError *))block{
    
    [[AFAppAPIClient sharedClient] getPath:kWebProductSpecificationPath parameters:parameters success:^(AFHTTPRequestOperation *operation,id JSON){
        NSArray *response = [JSON objectForKey:@"SpecificationProudct"];
        NSMutableArray *mutableList = [NSMutableArray arrayWithCapacity:[response count]];
        
        for (NSDictionary *dict in response) {
            MerchandiseSpecificationListModel *list = [[MerchandiseSpecificationListModel alloc] initWithAttributes:dict];
            [mutableList addObject:list];
        }
        
        if(block){
            block(mutableList,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        if(block){
            block([NSArray array], error);
        }
    }];
}

@end
