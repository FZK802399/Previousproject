//
//  OrderSubmitModel.h
//  Shop
//
//  Created by Ocean Zhang on 4/16/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFAppAPIClient.h"

@interface OrderSubmitModel : NSObject

@property (nonatomic, strong) NSString *Address;
@property (nonatomic, assign) CGFloat DispatchPrice;
@property (nonatomic, strong) NSString *Email;
@property (nonatomic, strong) NSString *MemLoginID;
@property (nonatomic, strong) NSString *Mobile;
@property (nonatomic, strong) NSString *Name;
@property (nonatomic, strong) NSString *OrderNumber;
@property (nonatomic, strong) NSString *PaymentGuid;
@property (nonatomic, assign) NSInteger PostType;
@property (nonatomic, strong) NSString *Postalcode;

@property (nonatomic, strong) NSMutableArray *productList;

@property (nonatomic, assign) CGFloat ProductPrice;
@property (nonatomic, assign) NSString *RegionCode;
@property (nonatomic, assign) CGFloat ShouldPayPrice;
@property (nonatomic, strong) NSString *tel;
@property (nonatomic, assign) CGFloat orderPrice;

+ (void)generalOrderNumberWithparameters:(NSDictionary *)parameters andBolock:(void(^)(NSString *orderNumber,NSError *error))block;

///添加订单
+ (void)addOrderModelWithparameters:(NSDictionary *)parameters andblock:(void(^)(NSInteger result,NSError *error))block;

///获取订单邮费
+ (void)getPostPriceWithparameters:(NSDictionary *)parameters andblock:(void(^)(NSDictionary * backOrderModel,NSError *error))block;

///获取积分订单邮费
+ (void)getScoreOrderPostPriceWithparameters:(NSDictionary *)parameters andblock:(void(^)(NSDictionary * backOrderModel,NSError *error))block;

///添加积分订单
+ (void)AddScoreOrderPostPriceWithparameters:(NSDictionary *)parameters andblock:(void(^)(NSInteger result,NSError *error))block;

///扣除用户积分
+ (void)PayScoreOrderWithparameters:(NSDictionary *)parameters andblock:(void(^)(NSInteger result,NSError *error))block;

///获取积分换算金额
+(void)getScorePriceWithparameters:(NSDictionary *)parameters andblock:(void(^)(CGFloat  ScorePrice,NSError *error))block;

@end
