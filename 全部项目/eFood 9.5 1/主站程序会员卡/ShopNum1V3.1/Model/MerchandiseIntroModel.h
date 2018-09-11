//
//  MerchandiseIntro.h
//  Shop
//
//  Created by Ocean Zhang on 3/23/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

/*
 {
     "Guid": "b3c43d38-842e-4b76-8796-0d9a50cc1dd8",
     "Name": "testA",
     "OriginalImage": "http://wap.nrqiang.com/ImgUpload/noImage.gif_100X100.jpg",
     "MarketPrice": 100.00,
     "ShopPrice": 50.00
 }
 */

#import <Foundation/Foundation.h>

@interface MerchandiseIntroModel : NSObject

@property (readonly, nonatomic) NSString *guid;

@property (readonly, nonatomic) NSString *name;

@property (readonly, nonatomic) NSString *originalImageStr;

@property (readonly, nonatomic) NSURL *originalImage;

@property (readonly, nonatomic) CGFloat marketPrice;

@property (assign, nonatomic) CGFloat shopPrice;

@property (assign, nonatomic) CGFloat scorePrice;

@property (readonly, nonatomic) NSInteger buyCount;

//@property (readonly, nonatomic) NSArray *imagesList;
//
////货号
//@property (readonly, nonatomic) NSString *productNum;
//
////品牌
//@property (readonly, nonatomic) NSString *brandName;
//
////库存
//@property (readonly, nonatomic) NSInteger repertoryCount;
//
//@property (readonly, nonatomic) NSString *unitName;

- (id)initWithAttributes:(NSDictionary *)attributes;

//首页展示商品
+ (void)getMerchandiseIntroForHomeShowByParamer:(NSDictionary *)parameters andBlocks:(void(^)(NSArray *merchandiseList,NSError *error))block;

//获取积分兑换商品
+(void)getGetScoreProductListByParamer:(NSDictionary *)parameters andBlocks:(void (^)(NSArray *ScoreProductList, NSError *error))block;

//获取搜索商品
+ (void)getSearchProductListByParamer:(NSDictionary *)parameters andBlocks:(void(^)(NSArray *searchList,NSError *error))block;

//--------------------------------------------------------------------------------------
///搜索
+ (void)searchMerchandiseIntroSorts:(NSString *)sort isAsc:(Boolean)isAsc pageIndex:(NSInteger)pageIndex pageCount:(NSInteger)pageCount name:(NSString *)name city:(NSString *)cityUrl andBlocks:(void(^)(NSArray *merchandiseList,NSError *error))block;

//店铺分类
+ (void)getMerchandiseByCategory:(NSString *)categoryCode Sorts:(NSString *)sort isAsc:(Boolean)isAsc pageIndex:(NSInteger)pageIndex pageCount:(NSInteger)count City:(NSString *)cityName andBlocks:(void(^)(NSArray *merchandiseList,NSError *error))block;

///店铺新品，推荐，热门，精品
+ (void)getShopMerchandiseByType:(NSInteger)type Sorts:(NSString *)sort isAsc:(Boolean)isAsc pageIndex:(NSInteger)pageIndex pageCount:(NSInteger)pageCount shopID:(NSString *)shopID andBlocks:(void(^)(NSArray *merchandiseList,NSError *error))block;

///店铺产品列表+搜索
+ (void)getShopMerchandiseByCategory:(NSInteger)categoryID Sorts:(NSString *)sort isAsc:(Boolean)isAsc pageIndex:(NSInteger)pageIndex pageCount:(NSInteger)pageCount shopID:(NSInteger)shopID name:(NSString *)name andBlocks:(void(^)(NSArray *merchandiseList,NSError *error))block;

///筛选
+ (void)getMerchandiseListByFilterParamer:(NSDictionary *)parameters CategoryID:(NSString *)CategoryID andBlocks:(void(^)(NSArray *merchandiseList,NSError *error))block;

@end
