//
//  FootMarkModel.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-11.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FootMarkModel : NSObject

@property (nonatomic, strong) NSString *ID;

@property (nonatomic, strong) NSString *ProductGuid;

@property (nonatomic, strong) NSString *ProductName;

@property (nonatomic, strong) NSString *ProductOriginalImage;

@property (nonatomic, strong) NSURL *ProductImageURL;

@property (nonatomic, assign) CGFloat ProductMarketPrice;

@property (nonatomic, assign) CGFloat ProductShopPrice;

@property (nonatomic, strong) NSString *MemLoginID;

@property (nonatomic, strong) NSString *CreateTime;

- (id)initWithAttributes:(NSDictionary *)attributes;

+ (void)getFootMarkListByparameters:(NSDictionary *)parameters andblock:(void(^)(NSArray *FootMarklist, NSError *error))block;

+ (void)deleteFootMarkByparameters:(NSDictionary *)parameters andblock:(void(^)(NSInteger reslut, NSError *error))block;

+ (void)addFootMarkByparameters:(NSDictionary *)parameters andblock:(void(^)(NSInteger reslut, NSError *error))block;

@end
