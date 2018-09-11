//
//  MerchandiseCollectModel.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-26.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MerchandiseCollectModel : NSObject

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

+ (void)getCollectListByparameters:(NSDictionary *)parameters andblock:(void(^)(NSArray *CollectList, NSError *error))block;

+ (void)deleteCollectProductByparameters:(NSDictionary *)parameters andblock:(void(^)(NSInteger reslut, NSError *error))block;

@end
