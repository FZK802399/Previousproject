//
//  GetCatgroyApi.h
//  ShopNum1V3.1
//
//  Created by Right on 15/11/23.
//  Copyright © 2015年 WFS. All rights reserved.
//

#import "LZBaseRequest.h"
#import "CategroyMode.h"
/// 获取分类API
@interface GetCatgroyApi : LZBaseRequest
/// 查分类 第一级传0 下级传上级CategroyMode的ID
- (instancetype) initWith:(NSNumber*)code;
/// 返回装有CategoryMode的数组
- (void) startWithCallBack:(void(^)(NSArray* DATA))success failuer:(void(^)(NSError *error))failure;
@end
