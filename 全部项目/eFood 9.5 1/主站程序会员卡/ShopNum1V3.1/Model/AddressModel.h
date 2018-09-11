//
//  AddressModel.h
//  Shop
//
//  Created by Ocean Zhang on 4/4/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressModel : NSObject

//Guid: "78e026fc-a970-4c01-8503-e81af3b8adec",
//NAME: "Leo",
//Email: "346688999@qq.com",
//Address: "北京市北京辖区东城区628",
//Postalcode: "430079",
//Tel: "",
//Mobile: "15000009999",
//IsDefault: 0,
//MemLoginID: "jerry",
//CreateUser: "jerry",
//CreateTime: "2015/12/28 10:06:56",
//ModifyUser: "jerry",
//ModifyTime: "2015/12/28 10:06:56",
//Code: "001001001",

//IdCardFront: null,
//IdCardVerso: null
//IDCard

@property (nonatomic, strong) NSString *guid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *address;

@property (nonatomic, strong) NSString *Province;
@property (nonatomic, strong) NSString *City;
@property (nonatomic, strong) NSString *Area;

@property (nonatomic, strong) NSString *postalcode;
@property (nonatomic, strong) NSString *tel;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, assign) Boolean isDefault;
@property (nonatomic, strong) NSString *createTimeStr;
@property (nonatomic, strong) NSData *createTime;
@property (nonatomic, strong) NSString *addressCode;

@property (nonatomic, strong) NSString *IdCardFront;
@property (nonatomic, strong) NSString *IdCardVerso;
@property (nonatomic, strong) NSString *IDCard;
@property(nonatomic,assign)NSInteger MemberI;


- (id)initWithAttributes:(NSDictionary *)attributes;

+ (void)addAddressWithParameters:(NSDictionary*)parameters andlbock:(void(^)(NSInteger result ,NSError *error))block;

+ (void)getLoginUserAddressListByParameters:(NSDictionary*)parameters andblock:(void(^)(NSArray *list,NSError *error))block;

///1 删除 2 设置为默认
+ (void)deleteAddressWithParameters:(NSDictionary*)parameters andblock:(void(^)(NSInteger result,NSError *error))block;

///编辑收货地址
+ (void)editAddressWithParameters:(NSDictionary*)parameters andblock:(void(^)(NSInteger result,NSError *error))block;
@end
