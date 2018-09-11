//
//  RewardModel.h
//  ShopNum1V3.1
//
//  Created by Mac on 16/1/8.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

// 首页抽奖模型
@interface RewardModel : NSObject

@property (copy, nonatomic) NSString *ChestsType;
@property (copy, nonatomic) NSString *Score;
@property (copy, nonatomic) NSNumber *MinimalCost; // 满100减
@property (copy, nonatomic) NSNumber *FaceValue; // 面额
@property (copy, nonatomic) NSString *StartDate;
@property (copy, nonatomic) NSString *EndDate;

// 获取抽奖
+ (void)fetchRewardWithparameters:(NSDictionary *)parameters block:(void(^)(RewardModel *model ,NSError *error))block;

@end
