//
//  FloorProductModel.h
//  ShopNum1V3.1
//
//  Created by Mac on 15/12/23.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface FloorProductModel : NSObject

@property (copy, nonatomic) NSString *Name;
@property (copy, nonatomic) NSString *OriginalImge;
@property (copy, nonatomic) NSNumber *CostPrice;
@property (copy, nonatomic) NSNumber *MarketPrice;
@property (copy, nonatomic) NSNumber *ShopPrice;
@property (copy, nonatomic) NSString *Guid;
@property (assign, nonatomic) NSInteger ProductCategoryID;
@property (assign, nonatomic) NSInteger TwoProductID;
@property (assign, nonatomic) NSInteger OneProductID;

@property (copy, nonatomic) NSURL *OriginalImgeURL;

//"Name": "66创意苹果台灯 插电床头灯 卧室灯看书灯办公灯 学习工作学生灯77",
//"OriginalImge": "/ImgUpload/bf95e42afdfad3876869e6984eaf3736.jpg",
//"CostPrice": "135.00",
//"MarketPrice": "52.50",
//"ShopPrice": "42.00",
//"Guid": "47e46e32-b86d-473b-b053-86c31e0a4db4",
//"ProductCategoryID": "375",
//"TwoProductID": "351",
//"OneProductID": "87"

@end
