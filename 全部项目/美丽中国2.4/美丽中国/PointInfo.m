//
//  PointInfo.m
//  美丽中国
//
//  Created by 司马帅帅 on 15/7/29.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import "PointInfo.h"
#import "UIUtils.h"

@implementation PointInfo

- (id)initWithDictionary:(NSDictionary *)dictionary andZoomScale:(float)zoomScale
{
    self = [super init];
    if (self) {
        self.x = [[dictionary objectForKey:@"point_x"] integerValue]*zoomScale;
        self.y = [[dictionary objectForKey:@"point_y"] integerValue]*zoomScale;
        self.longitude = [[dictionary objectForKey:@"point_longitude"] floatValue];
        self.latitude = [[dictionary objectForKey:@"point_latitude"] floatValue];
        self.pointName = [dictionary objectForKey:@"point_name"];
        self.pointScene = [dictionary objectForKey:@"point_scene"];
        self.hasNotPano = [UIUtils isBlankString:[dictionary objectForKey:@"point_fullview"]];
    }
    return self;
}

@end
