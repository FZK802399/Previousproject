//
//  ReturnGoodModel.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-9-19.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReturnGoodModel : NSObject

@property (nonatomic, strong) NSString *Guid;
@property (nonatomic, strong) NSString *ProductGuid;
@property (nonatomic, assign) NSInteger ReturnCount;
@property (nonatomic, assign) CGFloat BuyPrice;
@property (nonatomic, strong) NSString *Attributes;
@property (nonatomic, strong) NSURL *ProductImg;
@property (nonatomic, strong) NSString *ProductImgStr;
@property (nonatomic, strong) NSString *ROrderGuid;


- (id)initWithAttributes:(NSDictionary *)attributes;

@end
