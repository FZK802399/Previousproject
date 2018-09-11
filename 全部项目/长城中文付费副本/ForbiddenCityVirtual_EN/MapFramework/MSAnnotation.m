//
//  MSAnnotation.m
//  MSMap
//
//  Created by baobin on 13-4-15.
//  Copyright (c) 2013年 baobin. All rights reserved.
//

#import "MSAnnotation.h"

@implementation MSAnnotation

@synthesize point = _point;
@synthesize title = _title;
@synthesize subtitle = _subtitle;
@synthesize rightCalloutAccessoryView = _rightCalloutAccessoryView;
@synthesize pinState = _pinState;
@synthesize tag = _tag;
@synthesize nameCn = _nameCn;
@synthesize nameEn = _nameEn;


- (void)dealloc
{
    [_title release];
    [_subtitle release];
    [_rightCalloutAccessoryView release];
    [super dealloc];
}

+ (id)annotationWithPoint:(CGPoint)point
{
    return [[[[self class] alloc] initWithPoint:point] autorelease];
}

- (id)initWithPoint:(CGPoint)point
{
    self = [super init];
    if (self != nil) {
        self.point = point;
    }
    return self;
}

@end
