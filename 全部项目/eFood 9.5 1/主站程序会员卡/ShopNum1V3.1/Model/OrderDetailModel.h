//
//  OrderDetailModel.h
//  Shop
//
//  Created by Ocean Zhang on 5/2/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderMerchandiseIntroModel.h"
#import "PaymentModel.h"
#import "PostageModel.h"
#import "ReturnMerchandiseModel.h"

@interface OrderDetailModel : NSObject

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
@property (nonatomic, readonly) PostageModel * PostModel;

///快递公司编码
@property (nonatomic, readonly) NSString *LogisticsCompanyCode;
@property (nonatomic, readonly) NSString *ShipmentNumber;

@property (nonatomic, strong) PaymentModel *paymentModel;

@property (nonatomic, readonly) CGFloat ProductPrice;
@property (nonatomic, readonly) CGFloat ShouldPayPrice;
@property (nonatomic, readonly) CGFloat AlreadPayPrice;
@property (nonatomic, readonly) CGFloat SurplusPrice;
@property (nonatomic, readonly) CGFloat ScorePrice;
@property (nonatomic, readonly) NSString *CreateTime;
@property (nonatomic, readonly) NSString *PayTime;
@property (nonatomic, strong) NSMutableArray *ProductList;
@property (nonatomic, strong) NSMutableArray *ReturnProductList;

@property (nonatomic, readonly) NSString *ShopName;

@property (nonatomic, readonly) NSString *ShopID;
@property (nonatomic, assign) NSInteger PostType;
@property (nonatomic, strong) NSString *PostTypeStr;
@property (nonatomic, strong) NSString *ClientToSellerMsg;

@property (nonatomic, strong) NSString *ShopID2;

@property (nonatomic, assign) CGFloat DispatchPrice;

@property (nonatomic, assign) CGFloat InsurePrice;

///发票相关
@property (nonatomic,assign)NSInteger InvoiceType;
@property (nonatomic,strong)NSString * InvoiceTitle;
@property (nonatomic,strong)NSString * InvoiceContent;

//等于null   :申请退货/退款
//等于0	:正在进行
//等于2	:失败
@property (nonatomic, readonly) NSInteger RefundStatus;
@property (nonatomic, strong) NSString *RefundStatusStr;

- (id)initWithAttributes:(NSDictionary *)attributes;

///获取订单详情
+ (void)getOrderDetailWithparameters:(NSDictionary *)parameters andblock:(void(^)(OrderDetailModel *model ,NSError *error))block;

///取消订单
+ (void)cancelOrderWithparameters:(NSDictionary *)parameters andblock:(void(^)(NSInteger result, NSError *error))block;

///确认收货
+ (void)confirmReceiptWithGuid:(NSString *)orderGuid orderNum:(NSString *)orderNum andblock:(void(^)(BOOL result, NSError *error))block;

+ (void)AddReturnOrderWithParameters:(NSDictionary *)parameters andblock:(void(^)(NSInteger result, NSError *error))block;


@end
