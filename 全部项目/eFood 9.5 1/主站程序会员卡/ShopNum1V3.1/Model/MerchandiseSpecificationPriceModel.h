//
//  MerchandiseSpecificationPrice.h
//  Shop
//
//  Created by Ocean Zhang on 4/18/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MerchandiseSpecificationPriceModel : NSObject

@property (nonatomic, strong) NSString *ProductGuid;
@property (nonatomic, strong) NSString *SpecDetail;
@property (nonatomic, strong) NSString *SpecTotalId;
@property (nonatomic, assign) CGFloat GoodsPrice;
///库存量
@property (nonatomic, assign) NSInteger GoodsStock;
@property (nonatomic, strong) NSString *GoodsNumber;
@property (nonatomic, strong) NSString *ShopID;

- (id)initWithAttributes:(NSDictionary *)attributes;

+ (void)getPriceWithparameters:(NSDictionary *)parameters andblock:(void(^)(MerchandiseSpecificationPriceModel *price, NSError *error))block;

@end
