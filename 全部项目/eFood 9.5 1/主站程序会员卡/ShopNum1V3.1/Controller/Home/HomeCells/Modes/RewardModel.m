//
//  RewardModel.m
//  ShopNum1V3.1
//
//  Created by Mac on 16/1/8.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import "RewardModel.h"

@implementation RewardModel

+ (void)fetchRewardWithparameters:(NSDictionary *)parameters block:(void(^)(RewardModel *model ,NSError *error))block {
    [[AFAppAPIClient sharedClient] getPath:@"/api/GetReward/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *array = responseObject[@"Data"];
        RewardModel *model = nil;
        if (array && array.count > 0) {
            NSDictionary *dict = array.firstObject;
            model = [RewardModel objectWithKeyValues:dict];
            
        }
        if (block) {
            block(model, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

@end
