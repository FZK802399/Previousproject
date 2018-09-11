//
//  PointInfo.h
//  美丽中国
//
//  Created by 司马帅帅 on 15/7/29.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PointInfo : NSObject

@property (nonatomic, assign) int x;
@property (nonatomic, assign) int y;
@property (nonatomic, assign) float longitude;
@property (nonatomic, assign) float latitude;
@property (nonatomic, retain) NSString *pointName;
@property (nonatomic, retain) NSString *pointScene;
@property (nonatomic, assign) BOOL hasNotPano;

- (id)initWithDictionary:(NSDictionary *)dictionary andZoomScale:(float)zoomScale;

@end
