//
//  ShopCartMerchandiseModel.h
//  Shop
//
//  Created by Ocean Zhang on 4/13/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import <Foundation/Foundation.h>

/*{
 "Guid": "78d39663-4e00-4cb1-a16d-b81e69797d17",
 "MemLoginID": "jun",
 "ProductGuid": "cad38454-e701-4469-af5b-5f049acfa132",
 "OriginalImge": "http://fxv85.nrqiang.com/ImgUpload/00610ad2b1a44e5d9b7df0734b152d63.jpg_90x90.jpg",
 "Name": "迎客松茶叶 黄山毛峰 新茶 精品超值手工绿茶300g礼盒装直销",
 "RepertoryNumber": "Fx——2012",
 "Attributes": "",
 "ExtensionAttriutes": "M",
 "BuyNumber": 2,
 "MarketPrice": 337.50,
 "BuyPrice": 270.00,
 "IsJoinActivity": 0,
 "IsPresent": 0,
 "CreateTime": "2014/08/11 09:53:03",
 "DetailedSpecifications": "894"
 }
 */

@interface ShopCartMerchandiseModel : NSObject

@property (nonatomic, strong) NSString *guid;

@property (nonatomic, strong) NSString *productGuid;

@property (nonatomic, strong) NSString *originalImageStr;

@property (nonatomic, strong) NSURL *originalImage;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *repertoryNumber;

@property (nonatomic, strong) NSString *Attributes;

//购买数量
@property (nonatomic, assign) NSInteger buyNumber;

@property (nonatomic, assign) NSInteger IsJoinActivity;

//仓库储存量
@property (nonatomic, assign) NSInteger RepertoryCount;

@property (nonatomic, assign) CGFloat buyPrice;

@property (nonatomic, assign) CGFloat MarketPrice;

@property (nonatomic, strong) NSString *createTime;

@property (nonatomic, strong) NSString *specificationName;

@property (nonatomic, strong) NSString *specificationValue;

@property (nonatomic, assign) CGFloat procuctWeight;
//税费
@property (nonatomic, assign) CGFloat IncomeTax;
@property (nonatomic,strong) NSDictionary *CouponRule;


@property (nonatomic, assign) BOOL isEdit; // 是否可以点

///购物车中结算是否选中
@property (nonatomic, assign) Boolean isCheckForShopCart;

- (id)initWithAttributes:(NSDictionary *)attributes;

+ (void)getShopCartMerchandiseListByParamer:(NSDictionary *)parameters andblock:(void(^)(NSArray *shopCartList,NSError *error))block;

///删除购物车商品
+ (void)deleteShopCartMerchandiseByParamer:(NSDictionary *)parameters andblock:(void(^)(NSInteger result,NSError *error))block;



@end
