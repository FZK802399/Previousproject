//
//  MemberFloorModel.m
//  ShopNum1V3.1
//
//  Created by Mac on 15/12/24.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "MemberFloorModel.h"
#import "MemberFloorProductModel.h"

@implementation MemberFloorModel

+ (void)fetchMemberFloorListWithParameters:(NSDictionary *)parameters block:(void(^)(NSArray *list,NSError *error))block {
    [[AFAppAPIClient sharedClient] getPath:@"/api/MemberFloor/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *response = [responseObject objectForKey:@"Data"];
        NSArray *models = [MemberFloorModel objectArrayWithKeyValuesArray:response];
        for (MemberFloorModel *model in models) {
            model.MemberFloorsList = [MemberFloorProductModel objectArrayWithKeyValuesArray:model.MemberFloorsList];
        }
        if (block) {
            block(models, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

@end
