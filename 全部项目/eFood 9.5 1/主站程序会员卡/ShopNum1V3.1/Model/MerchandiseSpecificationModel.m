//
//  MerchandiseSpecification.m
//  Shop
//
//  Created by Ocean Zhang on 4/2/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import "MerchandiseSpecificationModel.h"
//"Guid": 0,
//"Detail": null,
//"Specid": 1,
//"SpecValueid": 49,
//"SpecValueName": "花色",
//"SpecName": "颜色"
@implementation MerchandiseSpecificationModel

@synthesize guid = _guid;
@synthesize detail = _detail;
@synthesize specid = _specid;
@synthesize specValueid = _specValueid;
@synthesize specValueName = _specValueName;
@synthesize specName = _specName;

- (id)initWithAttributes:(NSDictionary *)attributes{
    self = [super init];
    if(!self){
        return self;
    }
    _guid = [attributes objectForKey:@"Guid"];
    _detail = [attributes objectForKey:@"Detail"];
    _specid = [attributes objectForKey:@"Specid"] == [NSNull null] ? 0 :[[attributes objectForKey:@"Specid"] intValue];
    _specValueid = [attributes objectForKey:@"SpecValueid"] == [NSNull null] ? 0 : [[attributes objectForKey:@"SpecValueid"] intValue];
    _specValueName = [attributes objectForKey:@"SpecValueName"];
    _specName = [attributes objectForKey:@"SpecName"];
    
    return self;
}

@end
