//
//  ChaiDanModel.m
//  ShopNum1V3.1
//
//  Created by yons on 16/3/1.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import "ChaiDanModel.h"
//PostageMoney = 5;           邮费
//SplitPostageMoney = 50;     达不到该金额则有邮费
//SplitSingleMoney = 100;     拆单金额
@implementation ChaiDanModel
+ (void)getRateWithBlock:(void(^)(CGFloat rate,CGFloat PostageMoney,CGFloat SplitPostageMoney))block
{
    [[AFAppAPIClient sharedClient2]getPath:@"/api/mobileCommonAPI.ashx?opreateType=SplitSingleMoney" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            NSDictionary * dict = [responseObject firstObject];
            CGFloat rate = [[dict objectForKey:@"SplitSingleMoney"] doubleValue];
            CGFloat PostageMoney = [[dict objectForKey:@"PostageMoney"] doubleValue];
            CGFloat SplitPostageMoney = [[dict objectForKey:@"SplitPostageMoney"] doubleValue];
            if (block) {
                block(rate,PostageMoney,SplitPostageMoney);
            }
        }
        else
        {
            if (block) {
                block(-1,-1,-1);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(-1,-1,-1);
        }
    }];
}
@end
