//
//  GetXiangshiQiang.h
//  ShopNum1V3.1
//
//  Created by Right on 15/11/25.
//  Copyright © 2015年 WFS. All rights reserved.
//

#import "LZBaseRequest.h"
#import "XianShiQiangMode.h"
@interface GetXiangshiQiang : LZBaseRequest
- (instancetype) initWithPageIndex:(NSInteger)index count:(NSInteger)count;

/// 返回XianShiQiangMode
- (void) startWtihCallBackSuccess:(void(^)(NSArray *DATA))success failure:(void(^)(NSError *error))failure;
@end
