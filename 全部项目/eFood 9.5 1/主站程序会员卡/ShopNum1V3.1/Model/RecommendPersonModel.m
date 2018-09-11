//
//  RecommendPersonModel.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-11-11.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "RecommendPersonModel.h"

@implementation RecommendPersonModel

- (id)initWithAttributes:(NSDictionary *)attribute{
    self = [super init];
    if(self){
        _Email = [attribute objectForKey:@"Email"] == [NSNull null] ? @"" : [attribute objectForKey:@"Email"];
        _RealName = [attribute objectForKey:@"RealName"] == [NSNull null] ? @"" : [attribute objectForKey:@"RealName"];
        _Mobile = [attribute objectForKey:@"Mobile"] == [NSNull null] ? @"" :[attribute objectForKey:@"Mobile"];
        _MemLoginID = [attribute objectForKey:@"MemLoginID"];
        _Sex = [attribute objectForKey:@"Sex"] == [NSNull null] ? 0 :[[attribute objectForKey:@"Sex"] integerValue];
        _CommendPeople = [attribute objectForKey:@"CommendPeople"] == [NSNull null] ? @"" :[attribute objectForKey:@"CommendPeople"];
    }
    
    return self;
}


+(void)getRecommendPersonListByParameters:(NSDictionary *)parameters andblock:(void (^)(NSArray *, NSError *))block{
    [[AFAppAPIClient sharedClient] getPath:kWebgetmemberlistPath parameters:parameters success:^(AFHTTPRequestOperation *operation,id JSON){
//        NSInteger count = [JSON objectForKey:@"count"] == [NSNull null] ? 0 :[[JSON objectForKey:@"count"] integerValue];
        NSArray *response = [JSON objectForKey:@"data"];
        if (response != nil) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"获取信息失败"
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
            [alertView show];
            return ;
        }
        
        NSMutableArray *commentList = [[NSMutableArray alloc] initWithCapacity:[response count]];
        for (NSDictionary *dict in response) {
            RecommendPersonModel *detail = [[RecommendPersonModel alloc] initWithAttributes:dict];
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
