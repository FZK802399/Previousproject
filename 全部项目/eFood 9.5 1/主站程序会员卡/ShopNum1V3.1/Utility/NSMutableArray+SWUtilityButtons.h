//
//  NSMutableArray+SWUtilityButtons.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-9-17.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (SWUtilityButtons)

- (void)addUtilityButtonWithColor:(UIColor *)color icon:(UIImage *)icon andLightImage:(UIImage *)lightImage;
- (void)addUtilityButtonWithColor:(UIColor *)color title:(NSString *)title;
@end
