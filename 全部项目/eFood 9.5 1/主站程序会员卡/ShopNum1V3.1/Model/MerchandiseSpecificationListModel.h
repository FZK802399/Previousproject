//
//  MerchandiseSpecificationList.h
//  Shop
//
//  Created by Ocean Zhang on 4/1/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MerchandiseSpecificationModel.h"

@interface MerchandiseSpecificationListModel : NSObject

@property (nonatomic, readonly) NSString *specValueName;

@property (nonatomic, readonly) NSArray *specificationDict;

@property (nonatomic, readonly) NSArray *specification;

- (id)initWithAttributes:(NSDictionary *)attributes;

+ (void)getMerchandiseSpecificationListByParameters:(NSDictionary *)parameters andblock:(void(^)(NSArray *specification, NSError *error))block;

@end
