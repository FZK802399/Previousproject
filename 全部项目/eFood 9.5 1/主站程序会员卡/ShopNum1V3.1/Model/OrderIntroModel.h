//
//  OrderIntroModel.h
//  Shop
//
//  Created by Ocean Zhang on 4/17/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderMerchandiseIntroModel.h"

#import "MJExtension.h"

@interface OrderIntroModel : NSObject

@property (nonatomic, readonly) NSString *Guid;
@property (nonatomic, readonly) NSString *OrderNumber;
///订单状态0.(等待买家付款)1.等待卖家发货(买家已付款) 2.等待买家确认收货3.交易成功   4.订单关闭 5.卖家关闭订单 6.买家关闭订单
@property (nonatomic, assign) NSInteger OrderStatus;
///订单状态 中文
@property (nonatomic,strong) NSString * StatusName;
@property (nonatomic, readonly) NSString *Name;
@property (nonatomic, readonly) CGFloat ProductPrice;
@property (nonatomic, readonly) CGFloat ShouldPayPrice;
@property (nonatomic, readonly) CGFloat InsurePrice;
//vip 减免价格
@property(nonatomic,readonly)CGFloat Vipdiscount;
///已付款
@property (nonatomic, readonly) CGFloat AlreadPayPrice;
///剩余款项
@property (nonatomic, readonly) CGFloat SurplusPrice;

@property (nonatomic, readonly) CGFloat DispatchPrice;
@property (nonatomic, readonly) CGFloat ScorePrice;

@property (nonatomic, readonly) NSString *CreateTime;
@property (nonatomic, readonly) NSString *PayTime;
@property (nonatomic, strong) NSMutableArray *ProductList;
@property (nonatomic, readonly) NSString *ShopName;
///物流状态0，未发货(卖家)；1，已发货(卖家)；2，已收货(买家)；,3退货(买家)
@property (nonatomic, assign) NSInteger ShipmentStatus;
@property (nonatomic, readonly) NSString *LogisticsCompanyCode;
@property (nonatomic, readonly) NSString *ShipmentNumber;
@property (nonatomic, strong) NSString *OrderStatusStr;
//0未评论 1已评论
@property (nonatomic, assign) BOOL IsBuyComment;
@property (nonatomic, readonly) NSInteger PayType;
//等于null   :申请退货/退款
//等于0	:正在进行
//等于2	:失败
@property (nonatomic, readonly) NSInteger RefundStatus;
@property (nonatomic, strong) NSString *RefundStatusStr;

@property (nonatomic, readonly) NSInteger PaymentStatus;

@property (nonatomic, strong) NSString *PaymentGuid;
///支付方式 （线上 线上 货到付款）
@property (nonatomic, strong) NSString * PayTypeName;

///分销新加的 订单状态
@property (nonatomic, strong) NSString *ReturnOrderStatus;

- (id)initWithAttributes:(NSDictionary *)attributes;

//0 全部订单  1待付款 2 待发货 3 待收货  4 已完成订单  5 买家已经评价  6 卖家已经评价  7退货
//8 订单完成并且未评价
+ (void)getOrderListWithParameters:(NSDictionary *)parameters andblock:(void(^)(NSArray *list,NSError *error))block;

+ (void)UpdateOrderStatueWithParameters:(NSDictionary *)parameters andblock:(void(^)(NSInteger result,NSError *error))block;

@end
