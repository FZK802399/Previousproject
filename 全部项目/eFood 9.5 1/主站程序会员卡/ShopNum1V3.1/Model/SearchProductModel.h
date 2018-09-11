//
//  SearchProductModel.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-13.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import <Foundation/Foundation.h>

/*{
 "Guid": "2e1ba8fe-c9c5-4345-99da-001ca040c5f9",
 "Name": "诺基亚 N97",
 "OriginalImge": "http://fxv85.nrqiang.com/ImgUpload/20120622105153735.jpg_180x180.jpg",
 "ThumbImage": null,
 "SmallImage": null,
 "RepertoryNumber": "Fx——2012",
 "Weight": 1000.00,
 "RepertoryCount": 1,
 "RepertoryAlertCount": 1,
 "UnitName": "包",
 "PresentScore": 0,
 "PresentRankScore": 0,
 "SocreIntegral": 0,
 "LimitBuyCount": 0,
 "MarketPrice": 2180.00,
 "ShopPrice": 1423.00,
 "Brief": "2012分销商品",
 "Detail": null,
 "ClickCount": 2,
 "CollectCount": 0,
 "BuyCount": 0,
 "CommentCount": 0,
 "ReferCount": 0,
 "SaleNumber": 0,
 "ModifyTime": "2012/06/22 10:56:26",
 "IsSaled": 1,
 "IsBest": 0,
 "IsNew": 0,
 "IsHot": 0,
 "IsReal": 1,
 "IsRecommend": 0,
 "IsOnlySaled": 1,
 "Title": null,
 "Description": null,
 "Keywords": null,
 "OrderID": 1,
 "BrandName": "诺基亚",
 "ProductCategoryID": 2,
 "ActiveImage": null,
 "SupplierLoginID": "shopnum1m",
 "BaskOrderLogCount": null,
 "SpecificationProudct": null,
 "ProductProperty": null,
 "ProductAttribute": null,
 "Images": null,
 "MobileDetail": null,
 "AgentID": null,
 "BrandGuid": "9cb6168c-6099-4c4b-95f0-310b9560458c",
 "SocrePrice": null
 }
 */

//搜索出来的商品的数据模型
@interface SearchProductModel : NSObject

@property (nonatomic, strong) NSString *GuID;

@property (nonatomic, strong) NSString *Name;

@property (nonatomic, strong) NSURL *OriginalImge;

@property (nonatomic, strong) NSString *RepertoryNumber;

@property (nonatomic, strong) NSString *RepertoryCount;

@property (nonatomic, strong) NSString *RepertoryAlertCount;

@property (nonatomic, strong) NSString *UnitName;

@property (nonatomic, strong) NSString *PresentScore;

@property (nonatomic, strong) NSString *PresentRankScore;

@property (nonatomic, assign) CGFloat MarketPrice;

@property (nonatomic, assign) CGFloat ShopPrice;

@property (nonatomic, strong) NSString *Brief;

@property (nonatomic, assign) NSInteger ClickCount;

@property (nonatomic, assign) NSInteger CollectCount;

@property (nonatomic, assign) NSInteger BuyCount;

@property (nonatomic, assign) NSInteger CommentCount;

@property (nonatomic, assign) NSInteger SaleNumber;

- (id)initWithAttributes:(NSDictionary *)attributes;

//获取搜索商品
+ (void)getSearchProductListByParamer:(NSDictionary *)parameters andBlocks:(void(^)(NSArray *searchList,NSError *error))block;



@end
