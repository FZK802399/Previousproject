//
//  ScoreOrderDetailModel.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-11-27.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScoreOrderDetailModel : NSObject

@property (nonatomic, readonly) NSString *Guid;
@property (nonatomic, readonly) NSString *OrderNumber;
@property (nonatomic, assign) NSInteger OrderStatus;
@property (nonatomic, strong) NSString *OrderStatusStr;
@property (nonatomic, assign) NSInteger ShipmentStatus;
@property (nonatomic, strong) NSString *ShipmentStatusStr;
@property (nonatomic, assign) NSInteger PaymentStatus;
@property (nonatomic, strong) NSString *PaymentStatusStr;
@property (nonatomic, readonly) NSString *Name;
@property (nonatomic, readonly) NSString *Email;
@property (nonatomic, readonly) NSString *Address;
@property (nonatomic, readonly) NSString *PostalCode;
@property (nonatomic, readonly) NSString *Tel;
@property (nonatomic, readonly) NSString *Mobile;
@property (nonatomic, readonly) NSString *PaymentName;
@property (nonatomic, readonly) NSString *PayTypeName;
@property (nonatomic, readonly) NSString *PaymentGuid;
//@property (nonatomic, readonly) PostageModel * PostModel;

///快递公司编码
@property (nonatomic, readonly) NSString *LogisticsCompanyCode;
@property (nonatomic, readonly) NSString *ShipmentNumber;

//@property (nonatomic, strong) PaymentModel *paymentModel;

@property (nonatomic, readonly) NSInteger CostTotalScore;
@property (nonatomic, readonly) CGFloat PaymentPrice;
@property (nonatomic, readonly) CGFloat TotaltPrice;
@property (nonatomic, readonly) CGFloat prmo;
@property (nonatomic, readonly) NSString *CreateTime;
@property (nonatomic, readonly) NSString *PayTime;
@property (nonatomic, strong) NSMutableArray *ScoreProductList;

@property (nonatomic, readonly) NSString *DispatchModeName;

@property (nonatomic, readonly) NSString *SellerToClientMsg;

@property (nonatomic, strong) NSString *ClientToSellerMsg;

@property (nonatomic, assign) CGFloat DispatchPrice;

@property (nonatomic, assign) CGFloat InsurePrice;

//等于null   :申请退货/退款
//等于0	:正在进行
//等于2	:失败
@property (nonatomic, readonly) NSInteger RefundStatus;
@property (nonatomic, strong) NSString *RefundStatusStr;

- (id)initWithAttributes:(NSDictionary *)attributes;

///获取订单详情
+ (void)getScoreOrderDetailWithparameters:(NSDictionary *)parameters andblock:(void(^)(ScoreOrderDetailModel *model ,NSError *error))block;

@end
