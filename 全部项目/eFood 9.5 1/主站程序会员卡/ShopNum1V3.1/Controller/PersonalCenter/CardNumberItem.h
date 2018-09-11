//
//  CardNumberItem.h
//  ShopNum1V3.1
//
//  Created by 森泓投资 on 16/7/10.
//  Copyright © 2016年 WFS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardNumberItem : NSObject

//CardNumber 卡号
@property (nonatomic,copy)NSString *cardNumber;
//面值
@property (nonatomic,copy)NSString *faceValue;
//可使用次数
@property (nonatomic,copy)NSString *canTimes;
//有效时间
@property (nonatomic,copy)NSString *buyCardTime;

//卡密
@property (nonatomic,copy)NSString *cardPass;

//cardNum	生成的卡数量
@property (nonatomic ,assign) NSInteger cardNum;
//amount	卡金额
@property (nonatomic ,assign) NSInteger amount;
//startTime	卡的开始使用时间
@property (nonatomic ,copy) NSString *startTime;
//endTime	卡的最晚使用时间
@property (nonatomic ,copy) NSString *endTime;
//head	卡的前缀
@property (nonatomic ,copy) NSString *head;
//number	不含前缀卡的位数（纯数字）
@property (nonatomic ,assign) NSInteger number;
//cardType	卡类型 1实体卡 2虚拟卡
@property (nonatomic ,assign) NSInteger cardType;
//当前时间
@property (nonatomic ,copy) NSString *time;
//加密验证
@property (nonatomic ,copy) NSString *validation;
//获得虚拟卡
@property (nonatomic ,copy) NSString *numbers;
//根据code查询卡的信息
@property (nonatomic ,copy) NSString *cardCode;
//绑定用户
@property (nonatomic ,copy) NSString *userld;


- (id)initWithAttributes:(NSDictionary *)attributes;

@end
