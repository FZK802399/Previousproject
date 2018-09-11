//
//  MerchandisePingJiaModel.m
//  ShopNum1V3.1
//
//  Created by Mac on 15/11/25.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "MerchandisePingJiaModel.h"

@implementation MerchandisePingJiaModel

// 返回图片url
- (NSArray *)baskImageArray {
    if (_baskiamge && _baskiamge.length > 0) {
        NSArray *images = [_baskiamge componentsSeparatedByString:@"|"];
        NSMutableArray *imagesArray = [NSMutableArray array];
        for (NSString *urlString in images) {
            NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kWebMainBaseUrl, urlString]];
            [imagesArray addObject:imageUrl];
        }
        return imagesArray;
    }
    return nil;
}
// 返回头像url
- (NSURL *)memphotoURL {
    if (_memphoto.length > 0) {
        _memphotoURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kWebMainBaseUrl, _memphoto]];
    }
    return _memphotoURL;
}

// 获取商品评论及晒图
+(void)fetchMerchandisePingJiaListWithParameters:(NSDictionary *)parameters block:(void(^)(NSArray *list,NSError *error))block {
    [[AFAppAPIClient sharedClient] getPath:@"/api/getproductassess/?" parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON){
        
        NSInteger result = [[JSON objectForKey:@"return"] integerValue];
        NSArray *response = [JSON objectForKey:@"Data"];
        NSArray *models = nil;
        if (result == 202) {
            if (response.count > 0) {
                models = [MerchandisePingJiaModel objectArrayWithKeyValuesArray:response];
            }
        }
        if(block){
            block(models,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        if(block){
            block(nil, error);
        }
    }];
}

@end
