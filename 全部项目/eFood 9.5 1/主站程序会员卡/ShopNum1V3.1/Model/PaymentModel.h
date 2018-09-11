//
//  PaymentForAlipay.h
//  Shop
//
//  Created by Ocean Zhang on 5/6/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaymentModel : NSObject

@property (nonatomic, strong) NSString *Guid;
@property (nonatomic, strong) NSString *PaymentType;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *MerchantCode;
@property (nonatomic, assign) NSInteger IsCOD;
@property (nonatomic, strong) NSString *ForAdvancePayment;
@property (nonatomic, assign) NSInteger OrderID;
@property (nonatomic, assign) NSInteger IsPercent;
@property (nonatomic, assign) CGFloat Charge;
@property (nonatomic, strong) NSString *SecondKey;
@property (nonatomic, strong) NSString *Email;
@property (nonatomic, strong) NSString *paytype;
@property (nonatomic, strong) NSString *Public_Key;
@property (nonatomic, strong) NSString *Private_Key;

- (id)initWithAttribute:(NSDictionary *)attribute;

+ (void)getPaymentwithParameters:(NSDictionary *)parameters andbolock:(void(^)(NSArray *list,NSError *error))block;

+ (void)payWithAdvanceWithParameters:(NSDictionary *)parameters andblock:(void(^)(BOOL result,NSError *error))block;

+ (void)returnGoodsWithOrderGuid:(NSString *)guid andblock:(void(^)(BOOL result, NSError *error))block;

+ (void)postReturnGood:(NSMutableDictionary *)postData andblock:(void(^)(BOOL result,NSError *error))block;

+ (void)postProductComment:(NSMutableDictionary *)postData andblock:(void(^)(NSInteger result,NSError *error))block;

@end
