//
//  FavourTicketModel.h
//  ShopNum1V3.1
//
//  Created by Mac on 16/1/12.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavourTicketModel : NSObject

@property (copy, nonatomic) NSString *Name;
@property (copy, nonatomic) NSString *StartDate;
@property (copy, nonatomic) NSString *EndDate;
@property (copy, nonatomic) NSNumber *FaceValue;
@property (copy, nonatomic) NSNumber *LimitTimes;
@property (copy, nonatomic) NSNumber *MinimalCost;

//EndDate = "2014/09/15 00:00:00";
//FaceValue = 10;
//LimitTimes = 2;
//MinimalCost = 10;
//Name = "\U6ee110\U51cf10";
//StartDate = "2014/09/14 00:00:00";

+ (void)fetchFavourTicketListWithParameter:(NSDictionary *)parameter block:(void(^)(NSArray *list, NSError *error))block;



@end
