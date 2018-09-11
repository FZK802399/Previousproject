//
//  MYView.m
//  万汇江分界面
//
//  Created by dzy_PC on 15/11/25.
//  Copyright (c) 2015年 dzy_PC. All rights reserved.
//

#import "MYView.h"
#define WIDTH [UIScreen mainScreen].bounds.size.width
@implementation MYView

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 1);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 4);
    CGPathAddLineToPoint(path, NULL, WIDTH/3, 4);
    CGPathAddLineToPoint(path, NULL, WIDTH/3, 3);
    CGPathAddLineToPoint(path, NULL, WIDTH/6+4, 3);
    CGPathAddLineToPoint(path, NULL, WIDTH/6, 0);
    CGPathAddLineToPoint(path, NULL, WIDTH/6-4, 3);
    CGPathAddLineToPoint(path, NULL, 0, 3);
    CGPathAddLineToPoint(path, NULL, 0, 4);
    [MYRED set];
    CGContextAddPath(ctx, path);
    CGContextFillPath(ctx);
    CGPathRelease(path);
}


@end
