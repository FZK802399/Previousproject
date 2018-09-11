//
//  CouponsModel.h
//  ShopNum1V3.1
//
//  Created by 森泓投资 on 16/8/15.
//  Copyright © 2016年 WFS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouponsModel : NSObject

@property (nonatomic,copy)UIImageView *backImage;
@property (nonatomic,copy)NSString *money;
@property (nonatomic,copy)NSString *moneyMake;
@property (nonatomic,copy)NSString *coupons;
@property (nonatomic,copy)NSString *time;
@property (nonatomic,assign)NSInteger isUse;

@property (nonatomic,copy)NSString *cardCode;
@property (nonatomic,copy)NSString *date;
@property(nonatomic,copy)NSString *CPtype;//优惠券类型1=金额折扣，2=百分比折扣
@property(nonatomic,copy)NSString *RTtype;//范围类别1=全场，2=指定商品，3=指定类别
@property(nonatomic,copy)NSString *UseMoney;//优惠券的金额
@property (nonatomic ,copy) NSString *appointType;
@property (nonatomic ,copy) NSString *canUseCon;//此优惠券可以不可以用

@end
