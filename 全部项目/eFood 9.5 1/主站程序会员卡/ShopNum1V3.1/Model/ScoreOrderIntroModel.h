//
//  ScoreOrderIntroModel.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-11-27.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScoreOrderIntroModel : NSObject

@property (nonatomic, readonly) NSString *Guid;
@property (nonatomic, readonly) NSString *OrderNumber;
///订单状态0.(等待买家付款)1.等待卖家发货(买家已付款) 2.等待买家确认收货3.交易成功   4.订单关闭 5.卖家关闭订单 6.买家关闭订单
@property (nonatomic, assign) NSInteger OrderStatus;
@property (nonatomic, readonly) NSString *Name;
@property (nonatomic, readonly) CGFloat PaymentPrice;
@property (nonatomic, readonly) CGFloat TotaltPrice;
@property (nonatomic, readonly) CGFloat InsurePrice;

@property (nonatomic, readonly) CGFloat prmo;

@property (nonatomic, readonly) CGFloat DispatchPrice;
@property (nonatomic, readonly) NSInteger CostTotalScore;

@property (nonatomic, readonly) NSString *CreateTime;
@property (nonatomic, readonly) NSString *PayTime;
@property (nonatomic, strong) NSMutableArray *ScoreProductList;

///物流状态0，未发货(卖家)；1，已发货(卖家)；2，已收货(买家)；,3退货(买家)
@property (nonatomic, assign) NSInteger ShipmentStatus;
@property (nonatomic, readonly) NSString *LogisticsCompanyCode;
@property (nonatomic, readonly) NSString *ShipmentNumber;
@property (nonatomic, strong) NSString *OrderStatusStr;

//等于null   :申请退货/退款
//等于0	:正在进行
//等于2	:失败
@property (nonatomic, readonly) NSInteger RefundStatus;
@property (nonatomic, strong) NSString *RefundStatusStr;

@property (nonatomic, readonly) NSInteger PaymentStatus;

@property (nonatomic, strong) NSString *PaymentGuid;

@property (nonatomic, strong) NSString *PaymentName;

- (id)initWithAttributes:(NSDictionary *)attributes;

//0 全部订单  1待付款 2 待发货 3 待收货  4 已完成订单  5 买家已经评价  6 卖家已经评价  7退货
//8 订单完成并且未评价
+ (void)getScoreOrderListWithParameters:(NSDictionary *)parameters andblock:(void(^)(NSArray *list,NSError *error))block;

///确认收货
+ (void)UpdateScoreOrderStatueWithParameters:(NSDictionary *)parameters andblock:(void(^)(NSInteger result,NSError *error))block;

///取消订单
+ (void)CancelScoreOrderStatueWithParameters:(NSDictionary *)parameters andblock:(void(^)(NSInteger result,NSError *error))block;



@end
