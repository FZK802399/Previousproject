//
//  BankModel.h
//  ShopNum1V3.1
//
//  Created by yons on 16/3/8.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BankModel : NSObject
///户主
@property (nonatomic,strong)NSString * BankAccountName;
///银行卡号
@property (nonatomic,strong)NSString * BankAccountNumber;
///银行姓名
@property (nonatomic,strong)NSString * BankName;
@property (nonatomic,strong)NSString * CreateTime;
@property (nonatomic,strong)NSString * CreateUser;
@property (nonatomic,strong)NSString * Guid;
@property (nonatomic,assign)NSInteger IsDeleted;
@property (nonatomic,strong)NSString * MemLoginID;
@property (nonatomic,strong)NSString * Mobile;
@property (nonatomic,strong)NSString * ModifyTime;
@property (nonatomic,strong)NSString * ModifyUser;
///是否选中
@property (nonatomic,assign)BOOL isSelected;

- (instancetype)initWithDict:(NSDictionary *)Dict;

///获取银行列表 
+ (void)getBankListWithBlock:(void(^)(NSArray * arr,NSError * error))block;

@end

//BankAccountName = "\U6de1\U6de1\U7684";
//BankAccountNumber = 123456;
//BankName = "\U62db\U884c";
//CreateTime = "2016/03/08 17:00:50";
//CreateUser = jerry;
//Guid = "942a4347-6f02-4e75-868f-84b09548c48a";
//IsDeleted = 0;
//MemLoginID = jerry;
//Mobile = 13971634264;
//ModifyTime = "2016/03/08 17:00:50";
//ModifyUser = jerry;