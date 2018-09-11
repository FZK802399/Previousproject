//
//  MerchandisePingJiaModel.h
//  ShopNum1V3.1
//
//  Created by Mac on 15/11/25.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface MerchandisePingJiaModel : NSObject

//rank: 5,
//memphoto: "",
//memname: "Mike分站1",
//attributes: "颜色4:绿色4;尺码(鞋):36",
//content: "非常给力啊，有木有屌的一B",
//sendtime: "2015/11/12 16:27:18",
//baskiamge: ""

@property (nonatomic, assign) NSInteger rank;
@property (nonatomic, copy) NSString *memphoto; // 头像
@property (nonatomic, copy) NSString *memname; // 名称
@property (nonatomic, copy) NSString *attributes; // 商品信息
@property (nonatomic, copy) NSString *content; // 评价内容
@property (nonatomic, copy) NSString *sendtime; // 时间
@property (nonatomic, copy) NSString *baskiamge; // 晒图

@property (nonatomic, copy) NSArray *baskImageArray; // 图片地址
@property (nonatomic, copy) NSURL *memphotoURL; // 头像URL


/// 获取商品评论及晒图
+(void)fetchMerchandisePingJiaListWithParameters:(NSDictionary *)parameters block:(void(^)(NSArray *list,NSError *error))block;




@end
