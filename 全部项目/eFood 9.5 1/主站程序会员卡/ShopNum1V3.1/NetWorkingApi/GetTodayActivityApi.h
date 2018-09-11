//
//  SearchProductsApi.h
//  ShopNum1V3.1
//
//  Created by Right on 15/11/24.
//  Copyright © 2015年 WFS. All rights reserved.
//

#import "LZBaseRequest.h"
#import "ProductInfoMode.h"
@interface GetTodayActivityApi : LZBaseRequest



/// 返回装有ProductInfoMode 的数组
- (void) startWithCallBack:(void(^)(NSArray* DATA))success failuer:(void(^)(NSError *error))failure;
@end
