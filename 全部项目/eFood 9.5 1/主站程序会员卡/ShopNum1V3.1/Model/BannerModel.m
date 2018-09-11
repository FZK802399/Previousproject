//
//  Banner.m
//  Shop
//
//  Created by Ocean Zhang on 3/23/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import "BannerModel.h"
#import "AFAppAPIClient.h"

@implementation BannerModel



- (id)initWithAttributes:(NSDictionary *)attributes{
    self = [super init];
    if(!self){
        return nil;
    }
    
    _ID = [[attributes valueForKey:@"ID"] integerValue];
    _ShopID = [[attributes valueForKey:@"ShopID"] integerValue];
    _ImageUrl = [attributes valueForKey:@"Value"];
    _Url = [attributes valueForKey:@"Url"];
    _ConfigType = [[attributes valueForKey:@"ConfigType"] integerValue];
    return self;
}


+ (void)getBannersWithParamer:(NSDictionary *)parameters andBlocks:(void (^)(NSArray *, NSError *))block{
    [[AFAppAPIClient sharedClient] getPath:kWebServiceBannersPath parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON){
        NSArray *bannerFromResponse = [JSON objectForKey:@"ImageList"];
        NSMutableArray *mutableBanner = [NSMutableArray arrayWithCapacity:[bannerFromResponse count]];
        
        for (NSDictionary *attributes in bannerFromResponse) {
            BannerModel *banner = [[BannerModel alloc] initWithAttributes:attributes];
            [mutableBanner addObject:banner];
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
