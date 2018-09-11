//
//  UIFont+WS.m
//  WorkStation
//
//  Created by 黄露洋 on 13-7-20.
//  Copyright (c) 2013年 黄露洋. All rights reserved.
//

#import "UIFont+WS.h"

@implementation UIFont (WS)

+ (UIFont *)workListDetailFont {
    return [UIFont systemFontOfSize:12];
}

+ (UIFont *)timeDetailFont {
    return [UIFont systemFontOfSize:10];
}

+ (UIFont *)workListTitleFont {
    return [UIFont systemFontOfSize:16];
}

+ (UIFont *)workDetailFont {
    return [UIFont systemFontOfSize:14];
}

+ (UIFont *)textFieldFont {
    return [UIFont systemFontOfSize:15];
}

+ (UIFont *)textViewFont {
    return [UIFont systemFontOfSize:15];
}

+ (UIFont *)loadingIndicateFont {
    return [UIFont systemFontOfSize:11];
}

@end
