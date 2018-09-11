//
//  ProductInfoMode.h
//  HomePage
//
//  Created by 梁泽 on 15/11/22.
//  Copyright © 2015年 right. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductInfoMode : NSObject
/// 商品guid
@property (nonatomic,copy)  NSString *Guid;
/// 商品原图
@property (nonatomic,copy)  NSString *OriginalImge;
/// 商品名字
@property (nonatomic,copy)  NSString *Name;
/// 商品市场价
@property (nonatomic,strong) NSNumber *MarketPrice;
/// 商品店铺价
@property (nonatomic,strong) NSNumber *ShopPrice;

@property (nonatomic,copy)  NSString *Brief;




@end

//{
//    "ActiveImage" : "http://fxv811.groupfly.cn/ImgUpload/20151121182345748.png",
//    "AgentID" : null,
//    "BaskOrderLogCount" : null,
//    "BrandGuid" : "00000000-0000-0000-0000-000000000000",
//    "BrandName" : "",
//    "Brief" : "2012分销商品",
//    "BuyCount" : 0,
//    "ClickCount" : 12,
//    "CollectCount" : 0,
//    "CommentCount" : 0,
//    "Description" : "",
//    "Detail" : "种类：双人床  品牌：臻钻  产地：广东  使用空间：主卧  主材材质：皮艺  风格：简约现代  颜色：黄  定制：不可定制  有无软靠：有  型号：z3031 z3032  属性信息仅供参考，详细情况请向卖家咨询！商品特性时尚现代人体工程学设计舒适感受用料上乘高级家具基本信息商品尺寸: 200 x 180 cm 190x150cm发货重量:80 Kg臻钻家具：皮床系列-轩尼思-皮床，以家具行业高标准，塑造高品质家具。所选用皮料为，进口高品质头层真牛皮，手感细腻，用料上乘。做工精细考究，设计时尚简约。专业的服务，为客户提供优质家具，以高品质回馈顾客。",
//    "Guid" : "07309758-0a2d-46a4-bdfd-ca447cfe44a0",
//    "Images" : null,
//    "IsBest" : 1,
//    "IsHot" : 1,
//    "IsNew" : 0,
//    "IsOnlySaled" : 1,
//    "IsReal" : 1,
//    "IsRecommend" : 1,
//    "IsSaled" : 1,
//    "Keywords" : "",
//    "LimitBuyCount" : 0,
//    "MarketPrice" : 5199,
//    "MobileDetail" : "",
//    "ModifyTime" : "2015/11/21 18:24:49",
//    "Name" : "臻钻 X＆diamond 菲力普斯 真皮床",
//    "OrderID" : 9,
//    "OriginalImge" : "http://fxv811.groupfly.cn/ImgUpload/20120622120557549.jpg_180x180.jpg",
//    "OriginalPrice" : 0,
//    "PresentRankScore" : 0,
//    "PresentScore" : 0,
//    "ProductAttribute" : null,
//    "ProductCategoryID" : 267,
//    "ProductProperty" : null,
//    "ReferCount" : 0,
//    "RepertoryAlertCount" : 1,
//    "RepertoryCount" : 999,
//    "RepertoryNumber" : "2015-09-15",
//    "SaleNumber" : 0,
//    "ShopPrice" : 4691,
//    "SmallImage" : "",
//    "SocreIntegral" : 0,
//    "SocrePrice" : null,
//    "SpecificationProudct" : null,
//    "SupplierLoginID" : "shopnum1",
//    "ThumbImage" : "",
//    "Title" : "",
//    "UnitName" : "套",
//    "Weight" : 1000
//},