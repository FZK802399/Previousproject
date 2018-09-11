//
//  MemberFloorModel.h
//  ShopNum1V3.1
//
//  Created by Mac on 15/12/24.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface MemberFloorModel : NSObject

@property (copy, nonatomic) NSString *BackgroundImage;
@property (copy, nonatomic) NSString *Name;
@property (copy, nonatomic) NSNumber *ID;
@property (copy, nonatomic) NSNumber *Acount;
@property (copy, nonatomic) NSArray *MemberFloorsList;

+ (void)fetchMemberFloorListWithParameters:(NSDictionary *)parameters block:(void(^)(NSArray *list,NSError *error))block;

@end
