//
//  XianShiQiangMode.h
//  ShopNum1V3.1
//
//  Created by Right on 15/11/25.
//  Copyright © 2015年 WFS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XianShiQiangMode : NSObject
@property (strong, nonatomic) NSNumber *ROWNUM;
@property (copy  , nonatomic) NSString *Guid;
@property (copy  , nonatomic) NSString *ProductGuid;
@property (copy  , nonatomic) NSString *StartTime;
@property (copy  , nonatomic) NSString *EndTime;
@property (strong, nonatomic) NSNumber *PanicBuyingPrice;
@property (copy  , nonatomic) NSString *Memo;
@property (strong, nonatomic) NSNumber *RestrictCount;
@property (copy  , nonatomic) NSString *CreateUser;
@property (copy  , nonatomic) NSString *CreateTime;
@property (copy  , nonatomic) NSString *ModifyUser;
@property (copy  , nonatomic) NSString *ModifyTime;
@property (copy  , nonatomic) NSString *Name;
@property (copy  , nonatomic) NSString *OriginalImge;

/// 倒计时 时间
@property (copy  , nonatomic) NSString *timerFire;
@end
//{
//    "ROWNUM": 1,
//    "Guid": "4b22a77b-98d8-4dd0-a786-336b8703c072",
//    "ProductGuid": "6dae7931-f02f-4052-8e9f-83daf1881549",
//    "StartTime": "2015/08/19 10:25:12",
//    "EndTime": "2016/01/14 10:24:50",
//    "PanicBuyingPrice": 5000.00,
//    "Memo": "",
//    "RestrictCount": 100,
//    "CreateUser": "admin",
//    "CreateTime": "2015/08/19 10:25:23",
//    "ModifyUser": "admin",
//    "ModifyTime": "2015/08/19 10:25:23",
//    "Name": "66空调毯抱枕被子 两用靠垫大号毛绒玩具 女七夕情人节生日礼物包邮77",
//    "OriginalImge": "http://fxv811.groupfly.cn/ImgUpload/e9ac815e9cb132ca895025c01124fea5.jpg"
//}