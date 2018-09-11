//
//  MyGroupDetailModel.h
//  ShopNum1V3.1
//
//  Created by yons on 16/3/8.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyGroupDetailModel : NSObject
@property (nonatomic,strong)NSString * CreateTime;
@property (nonatomic,strong)NSString * Guid;
@property (nonatomic,strong)NSString * Level;
@property (nonatomic,strong)NSString * MemLoginID;
///订单金额
@property (nonatomic,assign)CGFloat OrderMoney;
@property (nonatomic,strong)NSString * OrderNumber;
@property (nonatomic,strong)NSString * OrderProfit;
@property (nonatomic,strong)NSString * PercentPaid;
///提成金额
@property (nonatomic,assign)CGFloat Profit;
@property (nonatomic,strong)NSString * SourceMember;

-(instancetype)initWithDict:(NSDictionary *)Dict;
+(void)getGroupMemberDetailWithMemLoginID:(NSString *)MemLoginID andBlock:(void(^)(NSArray * arr,NSError * error))block;
@end

//Data =     (
//            {
//                CreateTime = "2016/03/04 12:20:54";
//                Guid = "124ee07c-4b11-400b-95e4-abf9ad2cee4d";
//                Level = 1;
//                MemLoginID = 18616972015;
//                OrderMoney = 21;
//                OrderNumber = 201603041026197642;
//                OrderProfit = 21;
//                PercentPaid = 10;
//                Profit = "2.1";
//                SourceMember = 15553236183;
//            }
//            );