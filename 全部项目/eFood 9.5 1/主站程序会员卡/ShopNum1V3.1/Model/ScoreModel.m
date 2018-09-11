//
//  ScoreModel.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-9-3.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "ScoreModel.h"

@implementation ScoreModel

- (id)initWithAttributes:(NSDictionary *)attributes{
    self = [super init];
    if(!self){
        return nil;
    }
    
    _Guid = [attributes valueForKey:@"Guid"];
    _OperateType = [attributes valueForKey:@"OperateType"] == [NSNull null] ? 0 : [[attributes valueForKey:@"OperateType"] integerValue];
    _CurrentScore = [attributes valueForKey:@"CurrentScore"] == [NSNull null] ? 0 : [[attributes valueForKey:@"CurrentScore"] integerValue];
    _OperateScore = [attributes valueForKey:@"OperateScore"] == [NSNull null] ? 0 : [[attributes valueForKey:@"OperateScore"] integerValue];
    _LastOperateScore = [attributes valueForKey:@"LastOperateScore"] == [NSNull null] ? 0 : [[attributes valueForKey:@"LastOperateScore"] integerValue];
    _Memo = [attributes valueForKey:@"Memo"] ;
    _MemLoginID = [attributes valueForKey:@"MemLoginID"];
    _CreateTime = [attributes valueForKey:@"CreateTime"];
    
    return self;
}

+(void)getScoreDetailByparameters:(NSDictionary *)parameters andblock:(void (^)(NSArray *, NSError *))block{
    [[AFAppAPIClient sharedClient] getPath:kWebGetScoreDetailPath parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON){
        NSArray *bannerFromResponse = [JSON objectForKey:@"data"];
        if ([bannerFromResponse isEqual:[NSNull null]]) {
            if(block){
                block([NSArray array],nil);
            }
        }else{
            NSMutableArray *mutableBanner = [NSMutableArray arrayWithCapacity:[bannerFromResponse count]];
            
            for (NSDictionary *attributes in bannerFromResponse) {
                ScoreModel *score = [[ScoreModel alloc] initWithAttributes:attributes];
                [mutableBanner addObject:score];
            }
            
            if(block){
                block([NSArray arrayWithArray:mutableBanner],nil);
            }
        }
        
    }failure:^(AFHTTPRequestOperation *operation,NSError *error){
        if(block){
            block([NSArray array],error);
        }
    }];
}

@end
