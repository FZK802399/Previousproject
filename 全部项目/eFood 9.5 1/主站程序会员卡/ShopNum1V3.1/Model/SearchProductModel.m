//
//  SearchProductModel.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-13.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "SearchProductModel.h"

@implementation SearchProductModel

- (id)initWithAttributes:(NSDictionary *)attributes{
    self = [super init];
    if(!self){
        return nil;
    }
    
    self.GuID = [attributes valueForKey:@"Guid"];
    self.Name = [attributes valueForKey:@"Name"];
    self.OriginalImge = [NSURL URLWithString:[attributes valueForKey:@"OriginalImge"] == [NSNull null] ? @"" : [attributes valueForKey:@"OriginalImge"]];
    self.RepertoryNumber = [attributes valueForKey:@"RepertoryNumber"];
    self.RepertoryCount = [attributes valueForKey:@"RepertoryCount"];
    self.RepertoryAlertCount = [attributes valueForKey:@"RepertoryAlertCount"];
    self.UnitName = [attributes valueForKey:@"UnitName"];
    self.PresentScore = [attributes valueForKey:@"PresentScore"];
    self.PresentRankScore = [attributes valueForKey:@"PresentRankScore"];
    self.MarketPrice = [attributes valueForKey:@"MarketPrice"] == [NSNull null] ? 0 : [[attributes valueForKey:@"MarketPrice"] floatValue];
    self.ShopPrice = [attributes valueForKey:@"ShopPrice"] == [NSNull null] ? 0 : [[attributes valueForKey:@"ShopPrice"] floatValue];
    self.Brief = [attributes valueForKey:@"Brief"];
    self.ClickCount = [attributes valueForKey:@"ClickCount"] == [NSNull null] ? 0 : [[attributes valueForKey:@"ClickCount"] intValue];
    self.CollectCount = [attributes valueForKey:@"CollectCount"] == [NSNull null] ? 0 : [[attributes valueForKey:@"CollectCount"] intValue];
    self.BuyCount = [attributes valueForKey:@"BuyCount"] == [NSNull null] ? 0 : [[attributes valueForKey:@"BuyCount"] intValue];
    self.CommentCount = [attributes valueForKey:@"CommentCount"] == [NSNull null] ? 0 : [[attributes valueForKey:@"CommentCount"] intValue];
    self.SaleNumber = [attributes valueForKey:@"SaleNumber"] == [NSNull null] ? 0 : [[attributes valueForKey:@"SaleNumber"] intValue];
    
    return self;
    
}

+ (void)getSearchProductListByParamer:(NSDictionary *)parameters andBlocks:(void(^)(NSArray *searchList,NSError *error))block{
    [[AFAppAPIClient sharedClient] getPath:kWebSearchProductPath parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON){
        NSInteger  count = [[JSON objectForKey:@"Count"] intValue];
        if (count == 0) {
            if(block){
                block([NSArray array],nil);
            }
        }else{
            NSArray *searchFromResponse = [JSON objectForKey:@"Data"];
            NSMutableArray *mutableSearch = [NSMutableArray arrayWithCapacity:[searchFromResponse count]];
            for (NSDictionary *attributes in searchFromResponse) {
                SearchProductModel *Search = [[SearchProductModel alloc] initWithAttributes:attributes];
                [mutableSearch addObject:Search];
            }
            
            if(block){
                block([NSArray arrayWithArray:mutableSearch],nil);
            }

        
        }
           }failure:^(AFHTTPRequestOperation *operation,NSError *error){
        if(block){
            block([NSArray array],error);
        }
    }];

}


@end
