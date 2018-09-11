//
//  GetBannerApi.h
//  ShopNum1V3.1
//
//  Created by Right on 15/11/25.
//  Copyright © 2015年 WFS. All rights reserved.
//

#import "LZBaseRequest.h"
#import "BannerModel.h"
@interface GetBannerApi : LZBaseRequest

- (instancetype) initWithBannerIndex:(NSInteger)index;

- (void) startWtihCallBackSuccess:(void(^)(NSArray *DATA))success failure:(void(^)(NSError *error))failure;

@end
