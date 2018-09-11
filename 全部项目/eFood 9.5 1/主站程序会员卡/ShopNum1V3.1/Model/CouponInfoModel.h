//
//  CouponInfoModel.h
//  ShopNum1V3.1
//
//  Created by Mac on 15/12/31.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface CouponInfoModel : NSObject

@property (copy, nonatomic) NSString *TestLuckyCode; // 抽奖号
@property (copy, nonatomic) NSString *Status;  // "中奖" 和  ""

@end
