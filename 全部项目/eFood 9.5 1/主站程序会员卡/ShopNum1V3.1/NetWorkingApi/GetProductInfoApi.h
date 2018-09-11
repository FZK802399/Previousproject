//
//  GetProductInfoApi.h
//  HomePage
//
//  Created by 梁泽 on 15/11/22.
//  Copyright © 2015年 right. All rights reserved.
//

#import "LZBaseRequest.h"
#import "ProductInfoMode.h"
// type 1：新品 2：推荐 3：热卖 4：精品 废弃

//1 新品 2 热销 3 促销 4 推荐商品
typedef NS_ENUM(NSUInteger,CheckProductType) {
    /*
    /// 新品
    CheckProductTypeNew = 1,
    /// 热卖 限时抢购
    CheckProductTypeHot,
    /// 精品
    CheckProductTypeBoutique,
    /// 推荐 商品
    CheckProductTypeRecommend,
     */
    /// 新品
    CheckProductTypeNew = 1,
    /// 推荐 商品
    CheckProductTypeRecommend,
    /// 热卖 限时抢购
    CheckProductTypeHot,
    /// 精品
    CheckProductTypeBoutique,
};

@interface GetProductInfoApi : LZBaseRequest
/// sorts=ModifyTime:时间  isASC=false：降序 默认方式
- (instancetype) initWithType:(CheckProductType)type pageIndex:(NSInteger)pageIndex pageCount:(NSInteger)pageCount;
///
- (instancetype) initWithType:(CheckProductType)type sorts:(NSString*)sorts isASC:(NSString*)isASC pageIndex:(NSInteger)pageIndex pageCount:(NSInteger)pageCount;

/// 调接口 NSArray<ProductInfoMode *> *DATA
- (void) startWtihCallBackSuccess:(void(^)(NSArray *DATA))success failure:(void(^)(NSError *error))failure;
@end
/*
 type 1：新品 2：推荐 3：热卖 4：精品
 sorts ModifyTime:时间   Price：价格  SaleNumber：销售量
 isAsc True：升序  false：降序
 http://fxv811app.groupfly.cn/ api/product2/type/
     ?AppSign=82b514b89232e32e9f6017b0826b26a6        [AppConfig sharedAppConfig].appSign
     &isASC=false
     &pageCount=4
     &pageIndex=1
     &sorts=ModifyTime
     &type=3
 */