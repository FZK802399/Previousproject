//
//  PanoInfo.m
//  美丽中国
//
//  Created by 司马帅帅 on 15/7/21.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import "PanoInfo.h"
#import "Header.h"

@implementation PanoInfo

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.name = dictionary[@"title"];
        self.province = dictionary[@"province"];
        self.address = dictionary[@"address"];
        self.panoDescription = dictionary[@"description"];
        self.audioLength = dictionary[@"audioLength"];
        self.audioPlayCount = dictionary[@"audioPlayCount"];
        self.commentCount = dictionary[@"commentCount"];
        self.isEnjoy = [dictionary[@"isenjoy"] boolValue];
        //全景的坐标
        self.coordinate = [self getCoordinate:dictionary];
        self.loveCount = dictionary[@"loveCount"];
        self.panoId = dictionary[@"publishPanoId"];
        self.publishTime = dictionary[@"publishTime"];
        self.panoThumbImageUrl = [NSString stringWithFormat:@"%@/uploadfile/720/%d/%@.jpg",LOCAL_HOST_SECONDE,[_panoId intValue]/1000,_panoId];
        self.audioUrl = [NSString stringWithFormat:@"%@/uploadfile/720audio/%d/%@.mp3",LOCAL_HOST_SECONDE,[_panoId intValue]/1000,_panoId];
        NSLog(@"audioUrl %@",_audioUrl);
        self.panoUrl = [NSString stringWithFormat:@"%@%@",PANO_REQUEST,_panoId];
    }
    return self;
}

//获取全景坐标
- (CLLocationCoordinate2D)getCoordinate:(NSDictionary *)dictionary
{
    //纬度
    NSString *latitude = dictionary[@"lat"];
    //经度
    NSString *longitude = dictionary[@"lng"];
    //用经度纬度生成坐标
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([latitude floatValue], [longitude floatValue]);
    return coordinate;
}

@end
