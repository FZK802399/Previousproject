//
//  FavourTicketModel.m
//  ShopNum1V3.1
//
//  Created by Mac on 16/1/12.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import "FavourTicketModel.h"
#import "MJExtension.h"

@implementation FavourTicketModel

+ (void)fetchFavourTicketListWithParameter:(NSDictionary *)parameter block:(void(^)(NSArray *list, NSError *error))block {
    [[AFAppAPIClient sharedClient] getPath:@"/api/GetFavourTicket/?" parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *response = responseObject[@"Data"];
        NSArray *models = nil;;
        if (response.count > 0) {
            models = [FavourTicketModel objectArrayWithKeyValuesArray:response];
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
