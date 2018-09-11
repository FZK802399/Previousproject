//
//  SortModel.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-12.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "SortModel.h"

@implementation SortModel

@synthesize SortID = _SortID, Name = _Name, Keywords = _Keywords, Description = _Description, OrderID = _OrderID, CategoryLevel = _CategoryLevel, FatherID = _FatherID, IsLastLevel = _IsLastLevel, AgentID = _AgentID, BackgroundImage = _BackgroundImage, Imagestr = _Imagestr;

- (id)initWithAttributes:(NSDictionary *)attributes{
    self = [super init];
    if(!self){
        return nil;
    }
    
    _SortID = [[attributes valueForKey:@"ID"] stringValue];
    _Name = [attributes valueForKey:@"Name"];
    _Keywords = [attributes valueForKey:@"Keywords"];
    _Description = [attributes valueForKey:@"Description"];
    _OrderID = [attributes valueForKey:@"OrderID"];
    _CategoryLevel = [attributes valueForKey:@"CategoryLevel"];
    _FatherID = [attributes valueForKey:@"FatherID"];
    _IsLastLevel = [attributes valueForKey:@"IsLastLevel"];
    _AgentID = [attributes valueForKey:@"AgentID"];
    
    _Imagestr = [attributes valueForKey:@"BackgroundImage"] == [NSNull null] ? @"" : [attributes valueForKey:@"BackgroundImage"];
    
    return self;
}

-(NSURL *)BackgroundImage {
    NSString * urlStr = [_Imagestr hasPrefix:@"http"] ? _Imagestr : [kWebMainBaseUrl stringByAppendingString:_Imagestr];
    return [NSURL URLWithString:urlStr];
}

+ (void)getAllSortsByParamer:(NSDictionary *)parameters andBlocks:(void(^)(NSArray *sortsList,NSError *error))block{
    [[AFAppAPIClient sharedClient] getPath:kWebAllSortsPath parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON){
        NSArray *bannerFromResponse = [JSON objectForKey:@"Data"];
        NSMutableArray *mutableBanner = [NSMutableArray arrayWithCapacity:[bannerFromResponse count]];
        for (NSDictionary *attributes in bannerFromResponse) {
            SortModel *brand = [[SortModel alloc] initWithAttributes:attributes];
            [mutableBanner addObject:brand];
        }
        
        if(block){
            block([NSArray arrayWithArray:mutableBanner],nil);
        }
    }failure:^(AFHTTPRequestOperation *operation,NSError *error){
        if(block){
            block([NSArray array],error);
        }
    }];
}

+ (void)getScoreSortsByParamer:(NSDictionary *)parameters andBlocks:(void (^)(NSArray *, NSError *))block{
    [[AFAppAPIClient sharedClient] getPath:kWebServiceGetScoreProductCategoryListPath parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON){
        NSArray *bannerFromResponse = [JSON objectForKey:@"DATA"];
        NSMutableArray *mutableBanner = [NSMutableArray arrayWithCapacity:[bannerFromResponse count]];
        for (NSDictionary *attributes in bannerFromResponse) {
            SortModel *brand = [[SortModel alloc] initWithAttributes:attributes];
            [mutableBanner addObject:brand];
        }
        
        if(block){
            block([NSArray arrayWithArray:mutableBanner],nil);
        }
    }failure:^(AFHTTPRequestOperation *operation,NSError *error){
        if(block){
            block([NSArray array],error);
        }
    }];
}

+ (void)getSecondSortsByParamer:(NSDictionary *)parameters andBlocks:(void(^)(NSArray *sortsList,NSError *error))block{
    [[AFAppAPIClient sharedClient] getPath:kWebAllSortsPath parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON){
        NSArray *bannerFromResponse = [JSON objectForKey:@"Data"];
        NSMutableArray *mutableBanner = [NSMutableArray arrayWithCapacity:[bannerFromResponse count]];
        
        for (NSDictionary *attributes in bannerFromResponse) {
            SortModel *brand = [[SortModel alloc] initWithAttributes:attributes];
            [mutableBanner addObject:brand];
        }
        
        if(block){
            block([NSArray arrayWithArray:mutableBanner],nil);
        }
    }failure:^(AFHTTPRequestOperation *operation,NSError *error){
        if(block){
            block([NSArray array],error);
        }
    }];
}

@end
