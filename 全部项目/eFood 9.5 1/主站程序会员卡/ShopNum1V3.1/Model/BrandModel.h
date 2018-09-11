//
//  BrandModel.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-9.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
{
    "Guid": "807e2628-67af-49c2-911d-005cb1f34878",
    "Name": "ochirly",
    "Logo": "/ImgUpload/20131106174421790.jpg",
    "WebSite": "http://www.shopnum1.com",
    "OrderID": 20,
    "Keywords": "ochirly",
    "IsShow": 1,
    "Remark": "ochirly-优雅摩登无尽灵感",
    "Description": "ochirly-优雅摩登无尽灵感",
    "CreateUser": "admin",
    "CreateTime": "2013/11/06 17:53:09",
    "ModifyUser": "admin",
    "ModifyTime": "2013/11/06 17:53:09",
    "IsDeleted": 0,
    "IsDownLoad": 0,
    "IsRecommend": 1
}
*/
@interface BrandModel : NSObject

@property (readonly, nonatomic) NSString *guid;

@property (copy, nonatomic) NSString *name;

@property (readonly, nonatomic) NSString *logoStr;

@property (readonly, nonatomic) NSURL *logoUrl;

@property (readonly, nonatomic) NSString *webSiteUrl;

@property (readonly, nonatomic) NSString *keyWords;

@property (readonly, nonatomic) NSString *remark;

@property (readonly, nonatomic) NSString *description;

@property (readonly, nonatomic) NSString *createUser;


- (id)initWithAttributes:(NSDictionary *)attributes;

//获取全部品牌
+ (void)getAllBrandsByParamer:(NSDictionary *)parameters andBlocks:(void (^)(NSArray *brandList,NSError *error))block;

//获取推荐品牌
+ (void)getRecommendBrandsByParamer:(NSDictionary *)parameters andBlocks:(void(^)(NSArray *brandList,NSError *error))block;

//获取品牌详细
+ (void)getBrandDetailByParamer:(NSDictionary *)parameters andBlocks:(void(^)(NSArray *merchandiseList,NSError *error))block;

// 获取分类下的品牌列表 api/product/brandlist/
+ (void)getBrandListByParamer:(NSDictionary *)parameters andBlocks:(void (^)(NSArray *brandList,NSError *error))block;

@end
