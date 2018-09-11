//
//  CategroyMode.h
//  ShopNum1V3.1
//
//  Created by Right on 15/11/23.
//  Copyright © 2015年 WFS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategroyMode : NSObject
@property (strong, nonatomic) NSNumber *ID;

@property (copy  , nonatomic) NSString *Name;

@property (copy  , nonatomic) NSString *Keywords;

@property (copy  , nonatomic) NSString *Description;

@property (strong, nonatomic) NSNumber *OrderID;

@property (strong, nonatomic) NSNumber *CategoryLevel;

@property (strong, nonatomic) NSNumber *FatherID;

@property (copy  , nonatomic) NSString *IsLastLevel;

@property (strong, nonatomic) NSNumber *AgentID;

@property (strong, nonatomic) NSString *BackgroundImage;

/// 自定义
@property (copy  , nonatomic) NSString *imageName;
@end
//{
//    "ID": 5,
//    "Name": "服饰内衣",
//    "Keywords": "服饰内衣",
//    "Description": "衣帽手套 内衣文胸 珠宝首饰 服饰配件 ",
//    "OrderID": 5,
//    "CategoryLevel": 1,
//    "FatherID": 0,
//    "IsLastLevel": false,
//    "AgentID": null,
//    "BackgroundImage": "http://fxv811.groupfly.cn../ImgUpload/20140903220157448.png"
//},







