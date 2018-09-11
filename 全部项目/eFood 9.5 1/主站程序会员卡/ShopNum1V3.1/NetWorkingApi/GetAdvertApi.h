//
//  GetAdvertApi.h
//  ShopNum1V3.1
//
//  Created by Right on 15/11/23.
//  Copyright © 2015年 WFS. All rights reserved.
//

#import "LZBaseRequest.h"
#import "BannerModel.h"
typedef NS_ENUM(NSUInteger, CheckType) {
    /// 首页广告类型
    CheckTypeAdvert = 0,
    CheckTypeXXX,
    CheckTypeXXXX,
};
@interface GetAdvertApi : LZBaseRequest
/// 传1 获取首页广告
- (instancetype) initWithDataType:(CheckType)Type;


/// 返回BannerModel的数组
- (void) startWtihCallBackSuccess:(void(^)(NSArray *DATA))success failure:(void(^)(NSError *error))failure;

@end
/*
 {
 "ImageList": [
 {
 "ID": 1,
 "ShopID": 0,
 "Value": "http://mall.nrqiang.com/ImgUpload/shopImage/2012/shop10001//img_201401171004512.jpg",
 "Url": "www",
 "ConfigType": 10
 }
 ]
 }
 */
