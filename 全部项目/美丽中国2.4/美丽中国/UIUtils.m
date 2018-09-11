//
//  UIUtils.m
//  美丽中国
//
//  Created by 司马帅帅 on 15/7/19.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import "UIUtils.h"

@implementation UIUtils

+ (CGFloat)getWindowWidth
{
    UIWindow *mainWindow = [UIApplication sharedApplication].windows[0];
    return mainWindow.frame.size.width;
}

+ (CGFloat)getWindowHeight
{
    UIWindow *mainWindow = [UIApplication sharedApplication].windows[0];
    return mainWindow.frame.size.height;
}

//判断一个字符串是否为空 或者 只含有空格
+ (BOOL)isBlankString:(NSString *)string
{
    if (string == nil) {
        return YES;
    }
    if (string == NULL) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        return YES;
    }
    return NO;
}

//根据文本的font获取单行文本的size
+ (CGSize)getTextSize:(NSString *)text withFont:(UIFont*)font
{
    CGSize textSize;
    if ([text respondsToSelector:@selector(sizeWithFont:)]) {
        textSize = [text sizeWithFont:font];
    } else {
        NSDictionary *dictionary = @{NSFontAttributeName:font};
        textSize = [text sizeWithAttributes:dictionary];
    }
    return textSize;
}

@end
