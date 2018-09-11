//
//  MSAnnotation.m
//  美丽中国
//
//  Created by 司马帅帅 on 15/7/30.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import "MSAnnotation.h"

@implementation MSAnnotation

+ (id)annotationWithPoint:(CGPoint)point
{
    return [[[self class] alloc] initWithPoint:point];
}

- (id)initWithPoint:(CGPoint)point
{
    self = [super init];
    if (self) {
        self.point = point;
    }
    return self;
}

@end
