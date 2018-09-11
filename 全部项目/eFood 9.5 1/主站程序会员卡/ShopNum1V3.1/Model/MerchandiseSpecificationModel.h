//
//  MerchandiseSpecification.h
//  Shop
//
//  Created by Ocean Zhang on 4/2/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import <Foundation/Foundation.h>
//"Guid": 0,
//"Detail": null,
//"Specid": 1,
//"SpecValueid": 49,
//"SpecValueName": "花色",
//"SpecName": "颜色"
@interface MerchandiseSpecificationModel : NSObject

@property (nonatomic, readonly) NSString *guid;

@property (nonatomic, readonly) NSString *detail;

@property (nonatomic, readonly) NSInteger specid;

@property (nonatomic, readonly) NSInteger specValueid;

@property (nonatomic, readonly) NSString *specValueName;

@property (nonatomic, readonly) NSString *specName;

- (id)initWithAttributes:(NSDictionary *)attributes;

@end
