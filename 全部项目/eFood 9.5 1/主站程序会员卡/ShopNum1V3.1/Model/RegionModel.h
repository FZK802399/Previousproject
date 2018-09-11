//
//  RegionModel.h
//  Shop
//
//  Created by Ocean Zhang on 4/3/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegionModel : NSObject
//
//[
// {
//     "ID": 1,
//     "Name": "北京市",
//     "FatherID": 0,
//     "Code": "001"
// }
// ]

@property (nonatomic, readonly) NSInteger ownID;

@property (nonatomic, readonly) NSString *name;

@property (nonatomic, readonly) NSInteger fatherID;

@property (nonatomic, readonly) NSString *code;

- (id)initWithAttributes:(NSDictionary *)attributes;

+ (void)getRegionListByParameters:(NSDictionary *)parameters andblock:(void(^)(NSArray *regionList, NSError *error))block;

@end
