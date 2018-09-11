//
//  LZButton.m
//  ShopNum1V3.1
//
//  Created by 森泓投资 on 16/7/8.
//  Copyright © 2016年 WFS. All rights reserved.
//

#import "LZButton.h"

@implementation LZButton


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithRed:61/255.0 green:163/255.0 blue:171/255.0 alpha:1] forState:UIControlStateSelected];
    }
    return self;
}
@end