//
//  PostageModel.h
//  Shop
//
//  Created by Ocean Zhang on 4/29/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import <Foundation/Foundation.h>

///价格都为0的时候，显示免邮
@interface PostageModel : NSObject

/*
"Guid": "edc55d73-f69f-4e65-9c4f-14926f2f73b2",
"NAME": "顺丰快递",
"IsPayArrived": 1,
"SafeCost": 20.00,
"Formula": "B+((W-A)*D)/C",
"OrderID": 3,
"DispatchType": 1,
"Remark": "顺丰快递",
"peipr": 10.00,
"baopr": 20.00
*/

//Guid": "02bc374c-060e-42e8-84af-ae6980274288",
//"NAME": "圆通快递",
//"IsPayArrived": 0,
//"SafeCost": 1.00,
//"Formula": "B+((W-A)*D)/C",
//"OrderID": 3,
//"DispatchType": 0,
//"Remark": "圆通快递:A为起重，B为起重价格，C为续重，D为续重的单价，W指实际物重,Q重量超过该值使用公式计算,未超过用起重价格计算,P不使用公式计算时的配送费用,即在W<=Q的时候配送费用为P\r\n配送价格=起重价格+((物品实际重量-起重)*续重的单价)/续重"
//},

///快递
@property (nonatomic, strong) NSString *Guid;
@property (nonatomic, strong) NSString *name;
///快递名称
@property (nonatomic, strong) NSString *name2;
@property (nonatomic, assign) NSInteger IsPayArrived;
@property (nonatomic, assign) CGFloat SafeCost;
@property (nonatomic, strong) NSString *Remark;
@property (nonatomic, assign) CGFloat peipr;
@property (nonatomic, assign) CGFloat baopr;


- (id)initWithAttribute:(NSDictionary *)attribute;

+ (void)getPostagePrice:(NSDictionary *)paramer andblock:(void(^)(NSArray *list, NSError *error))block;

@end
