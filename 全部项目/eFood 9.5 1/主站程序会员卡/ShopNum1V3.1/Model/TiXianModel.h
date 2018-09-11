//
//  TiXianModel.h
//  ShopNum1V3.1
//
//  Created by yons on 16/3/8.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TiXianModel : NSObject

@property (nonatomic,strong)NSString * Guid;

@property (nonatomic,strong)NSString * OrderNumber;
///操作类型
@property (nonatomic,assign)NSInteger OperateType;
///当前金额
@property (nonatomic,assign)CGFloat CurrentAdvancePayment;
///操作金额
@property (nonatomic,assign)CGFloat OperateMoney;

@property (nonatomic,strong)NSString * Date;
///操作状态
@property (nonatomic,assign)NSInteger OperateStatus;

@property (nonatomic,strong)NSString * Memo;

@property (nonatomic,strong)NSString * UserMemo;

@property (nonatomic,strong)NSString * MemLoginID;

@property (nonatomic,strong)NSString * PaymentGuid;

@property (nonatomic,strong)NSString * PaymentName;

@property (nonatomic,assign)NSInteger IsDeleted;
///银行名称
@property (nonatomic,strong)NSString * Bank;
///户主
@property (nonatomic,strong)NSString * TrueName;
///银行卡号
@property (nonatomic,strong)NSString * Account;
///操作会员
@property (nonatomic,strong)NSString * OperateMember;

- (instancetype)initWithDict:(NSDictionary *)Dict;

///获取提现记录
+ (void)getHistoryListWithBlock:(void(^)(NSArray * arr,NSError * error))block;

@end


//"Guid": "b9c89d30-07ae-4e37-94ee-52bea7a53366",
//"OrderNumber": "201407254325186",
//"OperateType": "0",/
//"CurrentAdvancePayment": 44269.20,/
//"OperateMoney": 30.00,
//"Date": "2014/07/25 17:43:25",/
//"OperateStatus": 1,/
//"Memo": "11",
//"UserMemo": "",
//"MemLoginID": "jerry",
//"PaymentGuid": "00000000-0000-0000-0000-000000000000",//
//"PaymentName": "",
//"IsDeleted": 0,
//"Bank": "工行",
//"TrueName": "sss",
//"Account": "6222023202039048169",
//"OperateMember": "admin"
