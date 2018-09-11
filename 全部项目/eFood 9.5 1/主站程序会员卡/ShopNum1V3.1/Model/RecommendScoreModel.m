//
//  RecommendScoreModel.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-11-11.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "RecommendScoreModel.h"

@implementation RecommendScoreModel

- (id)initWithAttributes:(NSDictionary *)attribute{
    self = [super init];
    if(self){
        _Memo = [attribute objectForKey:@"Memo"] == [NSNull null] ? @"" :[attribute objectForKey:@"Memo"];
        _CurrentScore = [attribute objectForKey:@"CurrentScore"] == [NSNull null] ? 0 :[[attribute objectForKey:@"CurrentScore"] integerValue];
        _OperateScore = [attribute objectForKey:@"OperateScore"] == [NSNull null] ? 0 : [[attribute objectForKey:@"OperateScore"] integerValue];
        _LastOperateScore = [attribute objectForKey:@"LastOperateScore"] == [NSNull null] ? 0 :[[attribute objectForKey:@"LastOperateScore"] integerValue];
        _CreateTime = [attribute objectForKey:@"CreateTime"];
    }
    
    return self;
}


+(void)getRecommendScoreListByParameters:(NSDictionary *)parameters andblock:(void (^)(NSArray *, NSError *))block{
    [[AFAppAPIClient sharedClient] getPath:kWebgetscoremodifylogListPath parameters:parameters success:^(AFHTTPRequestOperation *operation,id JSON){
        //        NSInteger count = [JSON objectForKey:@"count"] == [NSNull null] ? 0 :[[JSON objectForKey:@"count"] integerValue];
        NSArray *response = [JSON objectForKey:@"data"];
        NSMutableArray *commentList = [[NSMutableArray alloc] initWithCapacity:[response count]];
        for (NSDictionary *dict in response) {
            RecommendScoreModel *detail = [[RecommendScoreModel alloc] initWithAttributes:dict];
            [commentList addObject:detail];
        }
        if(block){
            block(commentList,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        if(block){
            block(nil,error);
        }
    }];
}

@end
