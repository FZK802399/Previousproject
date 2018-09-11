//
//  UIColor+WS.m
//  Works
//
//  Created by Mac on 14-8-6.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "UIColor+WS.h"

@implementation UIColor (WS)

+ (UIColor *)colorFromHexRGB:(NSString *)inColorString
{
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    return result;
}

+(UIColor *)barTitleColor{
    return RGB(56, 172, 181);
}

+(UIColor *)textTitleColor{
    return [UIColor colorWithRed:141/255.0 green:141/255.0 blue:144/255.0 alpha:1];
}

+(UIColor *)textTitleBackGroundColor{
    return [UIColor colorWithRed:255/255.0 green:152/255.0 blue:44/255.0 alpha:1];
}

+(UIColor *)buttonTitleColor{
    return [UIColor colorFromHexRGB:@"007eff"];
}

@end
