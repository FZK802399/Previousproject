//
//  CityInfo.h
//  美丽中国
//
//  Created by 司马帅帅 on 15/7/20.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CityInfo : NSObject

@property (nonatomic, assign) int cityId;//城市Id
@property (nonatomic, strong) NSString *cityName;//城市名字
@property (nonatomic, strong) NSString *scanCount;//浏览次数
@property (nonatomic, strong) NSString *panoCount;//全景个数
@property (nonatomic, strong) UIImage *image;//城市图片
@property (nonatomic, assign) CGFloat width;//宽
@property (nonatomic, assign) CGFloat height;//高

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
