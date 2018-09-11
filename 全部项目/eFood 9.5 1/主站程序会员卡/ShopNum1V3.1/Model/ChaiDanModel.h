//
//  ChaiDanModel.h
//  ShopNum1V3.1
//
//  Created by yons on 16/3/1.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChaiDanModel : NSObject
//PostageMoney = 5;           邮费
//SplitPostageMoney = 50;     达不到该金额则有邮费
//SplitSingleMoney = 100;     拆单金额
+ (void)getRateWithBlock:(void(^)(CGFloat rate,CGFloat PostageMoney,CGFloat SplitPostageMoney))block;
@end
