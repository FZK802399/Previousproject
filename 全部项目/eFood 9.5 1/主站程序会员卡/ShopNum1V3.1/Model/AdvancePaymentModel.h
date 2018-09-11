//
//  AdvancePaymentModel.h
//  ShopNum1V3.1
//
//  Created by yons on 15/11/13.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdvancePaymentModel : NSObject

@property(nonatomic,strong)NSString * CreateTime;
///创建时间
@property(nonatomic,strong)NSString * CreateUser;
///初始金额
@property(nonatomic,assign)CGFloat CurrentAdvancePayment;
///时间 ?
@property(nonatomic,strong)NSString * Date;

@property(nonatomic,strong)NSString * Guid;

@property(nonatomic,assign)NSInteger IsDeleted;
///最终金额
@property(nonatomic,assign)CGFloat LastOperateMoney;

@property(nonatomic,strong)NSString * MemLoginID;

@property(nonatomic,strong)NSString * Memo;
///操作金额
@property(nonatomic,assign)CGFloat OperateMoney;
///操作类型 1充值 0消费
@property(nonatomic,assign)NSInteger OperateType;

-(instancetype)initWithDict:(NSDictionary *)dict;

///获取交易明细
+(void)getAdvancePaymentModifyLogByParamer:(NSDictionary *)parameters andblock:(void(^)(NSArray *List,NSError *error))block;

@end
//
//CreateTime = "2015/11/13 10:11:03";
//CreateUser = admin;
//CurrentAdvancePayment = 0;
//Date = "2015/11/13 10:11:03";
//Guid = "8e206ff8-5a0a-4388-8ae1-4a81531f85d8";
//IsDeleted = 0;
//LastOperateMoney = 10000;
//MemLoginID = 18702781315;
//Memo = "";
//OperateMoney = 10000;
//OperateType = 1;