//
//  NSString+GF.h
//  ShopNum1V3.1
//
//  Created by Mac on 16/1/4.
//  Copyright (c) 2016年 WFS. All rights reserved.
//


@interface NSString (GF)

+ (BOOL)isMobileNumber:(NSString *)mobileNum;
+ (BOOL)isTelNumber:(NSString *)tel;
+ (BOOL)NSStringIsValidEmail:(NSString *)checkString;
+ (BOOL) isIDCard: (NSString *)cardNo;
+ (NSString *)htmlStringReplaceWithString:(NSString *)str;

@end
