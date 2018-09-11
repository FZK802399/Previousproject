//
//  YiYuanGouModel.h
//  ShopNum1V3.1
//
//  Created by Mac on 15/12/28.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 一元购
@interface YiYuanGouModel : NSObject
// 商品列表
@property (copy, nonatomic) NSNumber *RowNumber;
@property (copy, nonatomic) NSString *OriginalImge;
@property (copy, nonatomic) NSString *Name;
@property (copy, nonatomic) NSString *Guid;
@property (copy, nonatomic) NSNumber *ResidueNumber;
@property (copy, nonatomic) NSNumber *RestrictCount;
//订单列表
@property (copy, nonatomic) NSString *OrderStatus;
@property (copy, nonatomic) NSString *RewardStatus;
@property (copy, nonatomic) NSNumber *AllMoney;
@property (copy, nonatomic) NSNumber *PanicBuyingPrice;
@property (copy, nonatomic) NSNumber *BuyNumber;
@property (copy, nonatomic) NSString *OrderNumber;
@property (copy, nonatomic) NSString *MemLoginID;
@property (copy, nonatomic) NSString *LuckyCode;
@property (copy, nonatomic) NSString *LuckyMen;
// 订单详情
@property (copy, nonatomic) NSString *NameInfo;
@property (copy, nonatomic) NSString *Address;
@property (copy, nonatomic) NSString *Mobile;
@property (copy, nonatomic) NSString *PayType;
@property (copy, nonatomic) NSString *ConfirmTime;
@property (copy, nonatomic) NSString *PayTime;
@property (copy, nonatomic) NSString *LogisticsCompanyCode;
@property (copy, nonatomic) NSString *ShipmentNumber;

@property (copy, nonatomic) NSArray *OnePurchaseOrderInfosList;

@property (copy, nonatomic) NSArray *coupons; //抽奖信息模型数组

@property (copy, nonatomic) NSURL *OriginalImgeURL;
@property (nonatomic, copy) NSArray *OriginalImgeStrs;
@property (assign, nonatomic) BOOL isExtend;

// 商品列表
//RowNumber: 1,
//OriginalImge: "/ImgUpload/1116546a52772fcbb2035435b7dc41bf.jpg",
//Name: "663D立体眼镜 红蓝眼镜夹片/金属夹片3d眼镜77",
//Guid: "9968e978-8945-41c5-8e19-08471afb9225",
//ResidueNumber: 0,
//RestrictCount: 3

// 订单列表
//RowNumber: 1,
//OrderStatus: "待付款",
//RewardStatus: "已开奖",
//OriginalImge: "/ImgUpload/1116546a52772fcbb2035435b7dc41bf.jpg",
//Guid: "9968e978-8945-41c5-8e19-08471afb9225",
//Name: "663D立体眼镜 红蓝眼镜夹片/金属夹片3d眼镜77",
//PanicBuyingPrice: 1,
//BuyNumber: 1,
//AllMoney: 1,
//OrderNumber: "201512174827962",
//MemLoginID: "Bella"


// 订单详情
//NameInfo: "Bella ",
//Address: "湖北省武汉市武昌区亚贸",
//Mobile: "13971674278",
//OrderStatus: "待付款",
//RewardStatus: "已开奖",
//OriginalImge: "/ImgUpload/1116546a52772fcbb2035435b7dc41bf.jpg",
//Guid: "9968e978-8945-41c5-8e19-08471afb9225",
//Name: "663D立体眼镜 红蓝眼镜夹片/金属夹片3d眼镜77",
//PanicBuyingPrice: 1,
//BuyNumber: 1,
//AllMoney: 1,
//OrderNumber: "201512174827962",
//MemLoginID: "Bella",
//PayType: "货到付款",
//ConfirmTime: "2015/08/18 10:48:08",
//PayTime: "1900/01/01 00:00:00",
//OnePurchaseOrderInfosList: [
//{
//TestLuckyCode: "10000041",
//Status: "中奖"
//}
//                            ]


/// 一元购商品列表接口
+ (void)fetchYiYuanGouListWithParameters:(NSDictionary *)parameters block:(void(^)(NSArray *list, NSError *error))block;


/// 一元购订单表接口：senghongapp.groupfly.cn/api/OnePurchaseOrderList?/AppSign=c29f79822c9b7943dd8755e9406de04b&PageStart=1&PageEnd=10
+ (void)fetchYiYuanGouOrderListWithParameters:(NSDictionary *)parameters block:(void(^)(NSArray *list, NSError *error))block;

/// 一元购订单详情接口：senghongapp.groupfly.cn/api/OnePurchaseOrderInfo?AppSign=c29f79822c9b7943dd8755e9406de04b&OrderNumber=201512174827962
+ (void)fetchYiYuanGouOrderDetailWithParameters:(NSDictionary *)parameters block:(void(^)(YiYuanGouModel *model, NSError *error))block;






@end
