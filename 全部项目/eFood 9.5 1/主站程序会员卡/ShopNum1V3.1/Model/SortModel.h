//
//  SortModel.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-12.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SortModel : NSObject
/*
 "ID": 1,
 "Name": "数码家电",
 "Keywords": "数码家电",
 "Description": "手机通讯 运营商 3 G 手机 双模手机 手机配件 手机配件 数码 ",
 "OrderID": 1,
 "CategoryLevel": 1,
 "FatherID": 0,
 "IsLastLevel": false,
 "AgentID": null,
 "BackgroundImage": "http://fxv85.nrqiang.com../ImgUpload/20120622135507345.jpg"
 */

@property (nonatomic, strong) NSString *SortID;

@property (nonatomic, strong) NSString *Name;

@property (nonatomic, strong) NSString *Keywords;

@property (nonatomic, strong) NSString *Description;

@property (nonatomic, strong) NSString *OrderID;

@property (nonatomic, strong) NSString *CategoryLevel;

@property (nonatomic, strong) NSString *FatherID;

@property (nonatomic, strong) NSString *IsLastLevel;

@property (nonatomic, strong) NSString *AgentID;

@property (nonatomic, strong) NSString *Imagestr;

@property (nonatomic, strong) NSURL *BackgroundImage;

- (id)initWithAttributes:(NSDictionary *)attributes;

//获取全部分类
+ (void)getAllSortsByParamer:(NSDictionary *)parameters andBlocks:(void(^)(NSArray *sortsList,NSError *error))block;

//获取积分商品分类
+ (void)getScoreSortsByParamer:(NSDictionary *)parameters andBlocks:(void(^)(NSArray *sortsList,NSError *error))block;

//获取二级分类
+ (void)getSecondSortsByParamer:(NSDictionary *)parameters andBlocks:(void(^)(NSArray *sortsList,NSError *error))block;

@end
