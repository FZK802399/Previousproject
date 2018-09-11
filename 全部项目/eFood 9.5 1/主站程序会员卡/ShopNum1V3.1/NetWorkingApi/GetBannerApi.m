//
//  GetBannerApi.m
//  ShopNum1V3.1
//
//  Created by Right on 15/11/25.
//  Copyright © 2015年 WFS. All rights reserved.
//

#import "GetBannerApi.h"
@interface GetBannerApi()
@property (assign, nonatomic) NSInteger bannerIndex;

@end
@implementation GetBannerApi
- (instancetype) initWithBannerIndex:(NSInteger)index{
    if (self = [super init]) {
        self.bannerIndex = index;
    }
    return self;
}

- (NSString*) requestPath {
    return @"/api/Get_DefaultAd/";
}
- (NSDictionary*) requestParameters{
    return @{
             @"AppSign" : self.appsign,
             @"ShopID"  : self.shopID,
             @"W_Type"  : @(0),
             @"BanerPostion" : @(self.bannerIndex)
             };
}
// senghongapp.groupfly.cn/api/Get_DefaultAd
- (void) startWtihCallBackSuccess:(void(^)(NSArray *DATA))success failure:(void(^)(NSError *error))failure{
    [[AFAppAPIClient sharedClient] getPath:self.requestPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success && responseObject) {
            success([BannerModel objectArrayWithKeyValuesArray:responseObject[@"Data"]]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
@end
//http://fxv811app.groupfly.cn/api/GetDefaultAd?ShopID=shopnum1_administrators&BanerPostion=1&W_Type=0