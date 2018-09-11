//
//  CategroyMode.m
//  ShopNum1V3.1
//
//  Created by Right on 15/11/23.
//  Copyright © 2015年 WFS. All rights reserved.
//

#import "CategroyMode.h"

@implementation CategroyMode

- (NSString *) imageName{
    if ([self.BackgroundImage hasPrefix:@"http://fxv811.groupfly.cn.."]) {
        return [self.BackgroundImage stringByReplacingOccurrencesOfString:@"http://fxv811.groupfly.cn.." withString:@"http://fxv811.groupfly.cn"];
    }
    return self.BackgroundImage;
}
@end
