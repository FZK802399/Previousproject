//
//  ReturnMerchandiseModel.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-9-5.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReturnMerchandiseModel : NSObject

@property (nonatomic, strong) NSString *OrderGuid;
@property (nonatomic, strong) NSString *ProductGuid;
@property (nonatomic, strong) NSString *ProductName;
@property (nonatomic, assign) NSInteger ReturnCount;
@property (nonatomic, assign) NSInteger buyNumer;
@property (nonatomic, assign) NSInteger OrderType;
@property (nonatomic, assign) CGFloat BuyPrice;
@property (nonatomic, strong) NSString *Attributes;
@property (nonatomic, strong) NSURL *ProductImg;
@property (nonatomic, strong) NSString *ProductImgStr;

@property (nonatomic, assign) BOOL isCheckForReturn;

- (id)initWithAttributes:(NSDictionary *)attributes;


@end
