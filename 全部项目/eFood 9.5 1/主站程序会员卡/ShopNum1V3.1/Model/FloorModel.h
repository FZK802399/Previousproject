//
//  FloorModel.h
//  ShopNum1V3.1
//
//  Created by Mac on 15/12/23.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface FloorModel : NSObject

@property (copy, nonatomic) NSString *BackgroundImage;
@property (copy, nonatomic) NSString *Name;
@property (copy, nonatomic) NSString *Memo;
@property (copy, nonatomic) NSNumber *ProductID;
@property (copy, nonatomic) NSNumber *Floor; // 楼层
@property (copy, nonatomic) NSString *Acount;
@property (copy, nonatomic) NSArray *ProductList;

+ (void)fetchFloorListWithParameters:(NSDictionary *)parameters block:(void(^)(NSArray *list,NSError *error))block;

@end

