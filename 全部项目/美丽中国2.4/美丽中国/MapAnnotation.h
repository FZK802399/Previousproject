//
//  MapAnnotation.h
//  美丽中国
//
//  Created by 司马帅帅 on 15/7/23.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mapkit/MapKit.h>

//自定义地图标注MapAnnotation
@interface MapAnnotation : NSObject<MKAnnotation>

//显示标注的经纬度
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
//标注的标题
@property (nonatomic, readonly, copy) NSString *title;
//标注的字标题
@property (nonatomic, readonly, copy) NSString *subtitle;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title subtitle:(NSString *)subtitle;

@end
