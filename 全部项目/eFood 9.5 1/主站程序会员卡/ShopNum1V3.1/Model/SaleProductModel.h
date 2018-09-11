//
//  SaleProductModel.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-14.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

typedef NS_ENUM(NSInteger, ActivityType){
    ActivityTypeBegining = 0,       // 进行中
    ActivityTypeNotStarted,         // 未开始
    ActivityTypeRobEmpty,           // 已抢完
    ActivityTypeHasEnded,           // 已结束
};

@interface SaleProductModel : NSObject


//ROWNUM: 4,
//Guid: "8f96139e-b89d-448b-a65c-8b475619eb71",
//ProductGuid: "a145e6e6-cadf-4a72-bedc-c5f03799ecac",
//StartTime: "2014/08/30 18:11:44",
//EndTime: "2018/12/06 18:11:46",
//PanicBuyingPrice: 100,
//Memo: "1232456",
//RestrictCount: 50,
//CreateUser: "admin",
//CreateTime: "2014/08/18 18:11:51",
//ModifyUser: "admin",
//ModifyTime: "2014/10/25 16:49:10",
//SnapType: "1",
//IDRestrictCount: null,
//LuckyCode: null,
//Lottery: null,
//Name: "66GOOD LUCK精美男孩女孩调味罐 骨瓷调味罐 套装77",
//OriginalImge: "http://senghong.groupfly.cn/ImgUpload/20140905175358565.jpg,http://senghong.groupfly.cn/ImgUpload/cgqcsfoh8cgagzyzaan-ij1ca0431200_450x450.jpg,http://senghong.groupfly.cn/ImgUpload/7528e9278db075f8bbac232200bc2b54.jpg",
//MarketPrice: 153,
//SaleNumber: 2


@property (copy, nonatomic) NSNumber *ROWNUM;
@property (copy, nonatomic) NSString *Guid;
@property (copy, nonatomic) NSString *ProductGuid;
@property (copy, nonatomic) NSString *StartTime;
@property (copy, nonatomic) NSString *EndTime;
///现价
@property (copy, nonatomic) NSNumber *PanicBuyingPrice;
@property (copy, nonatomic) NSString *Memo;
@property (copy, nonatomic) NSNumber *RestrictCount;
@property (copy, nonatomic) NSString *CreateUser;
@property (copy, nonatomic) NSString *CreateTime;
@property (copy, nonatomic) NSString *ModifyUser;
@property (copy, nonatomic) NSString *ModifyTime;
@property (copy, nonatomic) NSString *SnapType;
@property (copy, nonatomic) NSNumber *IDRestrictCount;
@property (copy, nonatomic) NSString *LuckyCode;
@property (copy, nonatomic) NSString *Lottery;
@property (copy, nonatomic) NSString *Name;
@property (copy, nonatomic) NSString *OriginalImge;
@property (copy, nonatomic) NSNumber *MarketPrice;
///原价
@property (copy, nonatomic) NSNumber *ShopPrice;
@property (copy, nonatomic) NSNumber *SaleNumber;


@property (nonatomic, copy) NSURL *OriginalImgeURL;
@property (nonatomic, copy) NSArray *OriginalImgeStrs;
@property (nonatomic, assign) NSTimeInterval RemainingTime;

@property (assign, nonatomic) ActivityType activityType;


//获取限时抢商品
+ (void)getSaleProductListByParamer:(NSDictionary *)parameters andBlocks:(void(^)(NSArray *SaleProductList,NSError *error))block;

//获取限量抢商品
+ (void)getXianLiangListByParamer:(NSDictionary *)parameters andBlocks:(void(^)(NSArray *List,NSError *error))block;


@end
