//
//  RegionModel.m
//  Shop
//
//  Created by Ocean Zhang on 4/3/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import "RegionModel.h"
#import "AFAppAPIClient.h"

@implementation RegionModel

@synthesize ownID = _ownID;
@synthesize name = _name;
@synthesize fatherID = _fatherID;
@synthesize code = _code;

- (id)initWithAttributes:(NSDictionary *)attributes{
    self = [super init];
    if(!self){
        return self;
    }
    
    _ownID = [[attributes objectForKey:@"ID"] intValue];
    _name = [attributes objectForKey:@"Name"];
    _fatherID = [[attributes objectForKey:@"FatherID"] intValue];
    _code = [attributes objectForKey:@"Code"];
    
    return self;
}

+ (void)getRegionListByParameters:(NSDictionary *)parameters andblock:(void (^)(NSArray *, NSError *))block{

    [[AFAppAPIClient sharedClient] getPath:kWebRegionlistPath parameters:parameters success:^(AFHTTPRequestOperation *operation,id JSON){
        NSArray *response = [JSON objectForKey:@"Data"];
        NSMutableArray *regionList = [NSMutableArray arrayWithCapacity:[response count]];
        
        for (NSDictionary *dict in response) {
            RegionModel *region = [[RegionModel alloc] initWithAttributes:dict];
            [regionList addObject:region];
        }
        
        if(regionList.count != 0){
            block(regionList,nil);
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"没有数据请稍等"
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
            [alertView show];
            return ;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        if(block){
            block(nil,error);
        }
    }];
}

@end
