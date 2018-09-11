//
//  PanicBuyingModel.m
//  ShopNum1V3.1
//
//  Created by Mac on 16/1/8.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import "PanicBuyingModel.h"
#import "MJExtension.h"

@implementation PanicBuyingModel

- (NSURL *)photoURL {
    if (_Photo) {
        return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kWebMainBaseUrl, _Photo]];
    }
    return nil;
}

+ (void)fetchPanicBuyingListWithParameter:(NSDictionary *)parameter block:(void(^)(NSArray *list, NSError *error))block {
    
    [[AFAppAPIClient sharedClient] getPath:@"/api/PanicBuying/" parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *array = responseObject[@"Data"];
        NSArray *list = nil;
        if (array && array.count > 0) {
            list = [PanicBuyingModel objectArrayWithKeyValuesArray:array];
        }
        if (block) {
            block(list, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

@end
