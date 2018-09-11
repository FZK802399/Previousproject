//
//  MapInfo.h
//  美丽中国
//
//  Created by 司马帅帅 on 15/7/29.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PointInfo.h"

@interface MapInfo : NSObject

@property (nonatomic, strong) NSString *pinyinName;//名字拼音（用于创建路径）
@property (nonatomic, strong) UIImage *placeHolderImage;//地图的缩略图
@property (nonatomic, assign) int mapWidth;//地图的宽度
@property (nonatomic, assign) int mapHeight;//地图的高度

@property (nonatomic, strong) PointInfo *topRightPointInfo;//右上点
@property (nonatomic, strong) PointInfo *bottomLeftPointInfo;//左下点

@property (nonatomic, assign) float zoomScale;//缩放比例

- (id)initWithDictionary:(NSDictionary *)dictionary andBoundsSize:(CGSize)boundsSize;

@end
