//
//  MapInfo.m
//  美丽中国
//
//  Created by 司马帅帅 on 15/7/29.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import "MapInfo.h"
#import "Header.h"

@implementation MapInfo

- (id)initWithDictionary:(NSDictionary *)dictionary andBoundsSize:(CGSize)boundsSize
{
    self = [super init];
    if (self) {
        self.mapWidth = [[dictionary objectForKey:@"map_width"] intValue];
        self.mapHeight = [[dictionary objectForKey:@"map_height"] intValue];
        self.pinyinName = dictionary[@"map_pinyin"];
        
        //获得地图缩略图
        NSString *guidePath = GUIDE_PATH;
        NSString *imagePath = [guidePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@/view_map/map_thumb.png",_pinyinName,_pinyinName]];
        self.placeHolderImage = [UIImage imageWithContentsOfFile:imagePath];
        
        //获取最大的比例为缩放比例
        CGFloat xScale = boundsSize.width/self.mapWidth;
        CGFloat yScale = boundsSize.height/self.mapHeight;
        self.zoomScale = MAX(xScale, yScale);
        NSLog(@"zoomScale %f",_zoomScale);
        
        self.topRightPointInfo = [[PointInfo alloc] init];
        _topRightPointInfo.latitude = [[dictionary objectForKey:@"map_topRightLat"] floatValue];
        _topRightPointInfo.longitude = [[dictionary objectForKey:@"map_topRightLon"] floatValue];
        _topRightPointInfo.x = [[dictionary objectForKey:@"map_width"] integerValue]*_zoomScale;
        _topRightPointInfo.y = 0*_zoomScale;
        
        self.bottomLeftPointInfo = [[PointInfo alloc] init];
        _bottomLeftPointInfo.latitude = [[dictionary objectForKey:@"map_bottomLeftLat"] floatValue];
        _bottomLeftPointInfo.longitude = [[dictionary objectForKey:@"map_bottomLeftLon"] floatValue];
        _bottomLeftPointInfo.x = 0*_zoomScale;
        _bottomLeftPointInfo.y = [[dictionary objectForKey:@"map_height"] integerValue]*_zoomScale;
    }
    return self;
}

@end
