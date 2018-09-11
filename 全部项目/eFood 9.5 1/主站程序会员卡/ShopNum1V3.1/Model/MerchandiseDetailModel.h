//
//  MerchandiseDetailModel.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-20.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MerchandiseDetailModel : NSObject

@property (nonatomic, readonly) NSString *guid;

@property (nonatomic, readonly) NSString *name;

@property (nonatomic, readonly) NSString *originalImageStr;

@property (nonatomic, readonly) NSURL *originalImage;

@property (nonatomic, assign) NSInteger repertoryCount;

@property (nonatomic, readonly) NSString *unitName;

@property (nonatomic, readonly) CGFloat marketPrice;

@property (nonatomic, assign) CGFloat shopPrice;

@property (nonatomic, readonly) NSString *brandName;

@property (nonatomic, readonly) NSArray *imagesList;

@property (nonatomic, copy) NSString *MobileDetail;

@property (nonatomic ,readonly) NSInteger BuyCount;

@property (nonatomic ,readonly) NSInteger IsBest;

@property (nonatomic ,readonly) NSInteger LimitBuyCount;

@property (nonatomic ,assign) NSInteger PresentScore;

@property (nonatomic ,assign) NSInteger PresentRankScore;

@property (nonatomic ,readonly) CGFloat productWeight;

@property (nonatomic ,assign) NSInteger buyNumber;

@property (nonatomic, assign) NSUInteger IDRestrictCount; // 每ID限购数

@property (nonatomic, assign) CGFloat IncomeTax; //税费

@property (nonatomic, readonly) NSString * SmallTitle; //小标题

@property (nonatomic, strong) NSString * LimitTimeBuy; //限时活动说明

@property (nonatomic, strong) NSString * LimitCountBuy; //限量活动说明

@property (nonatomic, strong) NSString * OneYuanGouMemo; //一元购活动说明

@property (nonatomic, strong) NSString * Brief; //商品介绍

@property (nonatomic ,strong)NSDictionary *CouponRule;

@property(nonatomic,assign)NSInteger MemberI;
- (id)initWithAttributes:(NSDictionary *)attributes;

///商品详细
+ (void)getMerchandiseDetailByParamer:(NSDictionary *)parameters andblock:(void(^)(MerchandiseDetailModel *detail,NSError *error))block;

///添加收藏
+ (void)addMerchandiseToCollectByParamer:(NSDictionary *)parameters andblock:(void(^)(NSInteger result,NSError *error))block;

///获取范围内有无货
+ (void)getMerchandiseAreaStockByParamer:(NSDictionary *)parameters andblock:(void(^)(NSInteger result,NSError *error))block;

///添加购物车
+ (void)addMerchandiseToShopCartByParamer:(NSDictionary *)parameters andblock:(void(^)(NSInteger result,NSError *error))block;

// 获取商品评论及晒图


@end
