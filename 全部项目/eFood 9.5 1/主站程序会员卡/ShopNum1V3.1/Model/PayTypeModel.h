//
//  PayTypeModel.h
//  Shop
//
//  Created by Ocean Zhang on 4/16/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayTypeModel : NSObject

@property (nonatomic, strong) NSString *guid;

@property (nonatomic, strong) NSString *paymentType;

@property (nonatomic, strong) NSString *name;


- (id)initWithAttributes:(NSDictionary *)attributes;

+ (void)getPayTypeWithParameters:(NSDictionary*)parameters andblock:(void(^)(NSArray *list, NSError *error))block;

@end
