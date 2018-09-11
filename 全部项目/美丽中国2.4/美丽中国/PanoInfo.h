//
//  PanoInfo.h
//  美丽中国
//
//  Created by 司马帅帅 on 15/7/21.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface PanoInfo : NSObject

@property (nonatomic, strong) NSString *name;//景区名字
@property (nonatomic, strong) NSString *province;//景区属于省份
@property (nonatomic, strong) NSString *address;//景区地址
@property (nonatomic, strong) NSString *panoDescription;//景区描述
@property (nonatomic, strong) NSString *audioLength;//语音时长
@property (nonatomic, strong) NSString *audioPlayCount;//语音播放次数
@property (nonatomic, strong) NSString *commentCount;//评论次数
@property (nonatomic, assign) BOOL isEnjoy;//你是否喜欢过这个景区
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;//景区坐标
@property (nonatomic, strong) NSString *loveCount;//景区被喜欢的次数
@property (nonatomic, strong) NSString *panoId;//景区全景Id
@property (nonatomic, strong) NSString *publishTime;//景区发布时间
@property (nonatomic, strong) NSString *panoThumbImageUrl;//全景缩略图地址
@property (nonatomic, strong) NSString *audioUrl;//语音解说地址
@property (nonatomic, strong) NSString *panoUrl;//全景缩略图地址

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
