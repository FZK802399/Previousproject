//
//  UIUtils.m
//  旅拍1.0
//
//  Created by 司马帅帅 on 15/7/6.
//  Copyright (c) 2015年 fzk. All rights reserved.
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

@end
