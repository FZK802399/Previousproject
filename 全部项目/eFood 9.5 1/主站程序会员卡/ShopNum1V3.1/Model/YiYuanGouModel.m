//
//  YiYuanGouModel.m
//  ShopNum1V3.1
//
//  Created by Mac on 15/12/28.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "YiYuanGouModel.h"
#import "CouponInfoModel.h"
#import "MJExtension.h"

@implementation YiYuanGouModel

- (NSArray *)OriginalImgeStrs {
    NSMutableArray *originals = [NSMutableArray array];
    NSArray *array = [_OriginalImge componentsSeparatedByString:@","];
    for (NSString *imgStr in array) {
        NSString *imgString;
        if (![imgStr hasPrefix:@"http://"]) {
            imgString = [NSString stringWithFormat:@"%@%@", kWebMainBaseUrl, imgStr];
        } else {
            imgString = imgStr;
        }
        [originals addObject:imgString];
    }
    return originals;
}

- (NSURL *)OriginalImgeURL {
    NSString *urlString;
    if (_OriginalImge && _OriginalImge.length > 0) {
        _OriginalImge = [_OriginalImge componentsSeparatedByString:@","].firstObject;
        if ([_OriginalImge hasPrefix:@"http://"]) {
            urlString = _OriginalImge;
        } else {
            urlString = [NSString stringWithFormat:@"%@%@", kWebMainBaseUrl, _OriginalImge];
        }
    }
    return [NSURL URLWithString:urlString];
}
// AppSign=d67c9b6fde3563cbc256ab19a6abda8d&PageStart=1&PageEnd=5
+ (void)fetchYiYuanGouListWithParameters:(NSDictionary *)parameters block:(void(^)(NSArray *list, NSError *error))block {
    [[AFAppAPIClient sharedClient] getPath:@"/api/OnePurchaseList/?" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *response = responseObject[@"Data"];
        NSArray *models = nil;
        if (response.count > 0) {
            models = [YiYuanGouModel objectArrayWithKeyValuesArray:response];
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

// 订单列表
+ (void)fetchYiYuanGouOrderListWithParameters:(NSDictionary *)parameters block:(void(^)(NSArray *list, NSError *error))block {
    [[AFAppAPIClient sharedClient] getPath:@"/api/OnePurchaseOrderList/?" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *response = responseObject[@"Data"];
        NSArray *models = nil;;
        if (response.count > 0) {
            models = [YiYuanGouModel objectArrayWithKeyValuesArray:response];
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
// 订单详情
+ (void)fetchYiYuanGouOrderDetailWithParameters:(NSDictionary *)parameters block:(void(^)(YiYuanGouModel *model, NSError *error))block {
    [[AFAppAPIClient sharedClient] getPath:@"/api/OnePurchaseOrderInfo/?" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *response = responseObject[@"Data"];
        YiYuanGouModel *model = nil;
        if (response.count > 0) {
            model = [YiYuanGouModel objectArrayWithKeyValuesArray:response].firstObject;
            model.coupons = [CouponInfoModel objectArrayWithKeyValuesArray:model.OnePurchaseOrderInfosList];
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
