//
//  CityInfo.m
//  美丽中国
//
//  Created by 司马帅帅 on 15/7/20.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import "CityInfo.h"
#import "UIUtils.h"

@implementation CityInfo

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.cityId = [dictionary[@"circleId"] intValue];
        self.cityName = dictionary[@"circleName"];
        self.panoCount = dictionary[@"panoCount"];
        self.scanCount = dictionary[@"total"];
        self.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_1.jpg",_cityName]];
        self.width = ([UIUtils getWindowWidth]-10*3)/2;
        self.height = _image.size.height/_image.size.width*_width;
    }
    return self;
}

@end
