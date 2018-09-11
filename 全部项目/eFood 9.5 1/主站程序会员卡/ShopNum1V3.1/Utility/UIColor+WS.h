//
//  UIColor+WS.h
//  Works
//
//  Created by Mac on 14-8-6.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (WS)

+ (UIColor *)colorFromHexRGB:(NSString *)inColorString;
+ (UIColor *)barTitleColor;
+ (UIColor *)buttonTitleColor;
+ (UIColor *)textTitleColor;
+(UIColor *)textTitleBackGroundColor;

@end
