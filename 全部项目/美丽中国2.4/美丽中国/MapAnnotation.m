//
//  MapAnnotation.m
//  美丽中国
//
//  Created by 司马帅帅 on 15/7/23.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import "MapAnnotation.h"

@implementation MapAnnotation

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title subtitle:(NSString *)subtitle
{
    self = [super init];
    if (self) {
        _coordinate = coordinate;
        _title = title;
        _subtitle = subtitle;
    }
    return self;
}

@end
