//
//  FloorModel.m
//  ShopNum1V3.1
//
//  Created by Mac on 15/12/23.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "FloorModel.h"
#import "FloorProductModel.h"

@implementation FloorModel

+ (void)fetchFloorListWithParameters:(NSDictionary *)parameters block:(void(^)(NSArray *list,NSError *error))block {
    [[AFAppAPIClient sharedClient] getPath:@"/api/ProductFloor/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *response = [responseObject objectForKey:@"Data"];        
        NSArray *models = [FloorModel objectArrayWithKeyValuesArray:response];
        for (FloorModel *model in models) {
            model.ProductList = [FloorProductModel objectArrayWithKeyValuesArray:model.ProductList];
        }
        if (block) {
            block(models, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
            LZLOG(@"Operation : %@", operation.responseString);
        }
    }];
}

@end


