//
//  UIUtils.h
//  旅拍1.0
//
//  Created by 司马帅帅 on 15/7/6.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIUtils : NSObject

+ (CGFloat)getWindowWidth;
+ (CGFloat)getWindowHeight;
//判断一个字符串是否为空 或者 只含有空格
+ (BOOL)isBlankString:(NSString *)string;

@end
