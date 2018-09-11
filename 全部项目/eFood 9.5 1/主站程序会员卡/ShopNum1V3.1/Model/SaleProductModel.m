//
//  SaleProductModel.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-14.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "SaleProductModel.h"

@implementation SaleProductModel


- (NSArray *)OriginalImgeStrs {
    return [_OriginalImge componentsSeparatedByString:@","];
}

-(NSURL *)OriginalImgeURL {
    return [NSURL URLWithString:self.OriginalImgeStrs.firstObject];
//    return [NSURL URLWithString:[self.OriginalImgeStrs.firstObject stringByReplacingOccurrencesOfString:@"180" withString:@"300"]];
}

-(NSTimeInterval)RemainingTime {
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSDate * endTimeDate = [dateFormatter dateFromString:self.EndTime];
    NSTimeInterval timeSinceNow = [endTimeDate timeIntervalSinceNow];
    return timeSinceNow;
}


+ (void)getSaleProductListByParamer:(NSDictionary *)parameters andBlocks:(void(^)(NSArray *SaleProductList,NSError *error))block{
    [[AFAppAPIClient sharedClient] getPath:kWebSaleLimitedproductPath parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON){
        NSInteger  count = [[JSON objectForKey:@"Count"] intValue];
        if (count == 0) {
            if(block){
                block([NSArray array],nil);
            }
        }else {
            NSArray *searchFromResponse = [JSON objectForKey:@"Data"];
            NSArray *mutableSearch = [SaleProductModel objectArrayWithKeyValuesArray:searchFromResponse];
            if(block){
                block(mutableSearch,nil);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        if(block){
            block([NSArray array],error);
        }
    }];
}

+ (void)getXianLiangListByParamer:(NSDictionary *)parameters andBlocks:(void(^)(NSArray *List,NSError *error))block {
    [[AFAppAPIClient sharedClient] getPath:@"/api/QuotaProductList/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON){
        NSInteger  count = [[JSON objectForKey:@"Count"] intValue];
        if (count == 0) {
            if(block){
                block([NSArray array],nil);
            }
        }else {
            NSArray *searchFromResponse = [JSON objectForKey:@"Data"];
            NSArray *mutableSearch = [SaleProductModel objectArrayWithKeyValuesArray:searchFromResponse];
            if(block){
                block(mutableSearch,nil);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        if(block){
            block([NSArray array],error);
        }
    }];
}

@end
