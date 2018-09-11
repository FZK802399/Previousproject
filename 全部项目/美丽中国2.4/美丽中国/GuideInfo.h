//
//  GuideInfo.h
//  美丽中国
//
//  Created by 司马帅帅 on 15/7/20.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GuideInfo : NSObject

@property (nonatomic, assign) int guideId;//导游id
@property (nonatomic, strong) NSString *configUrl;//下载配置文件的url
@property (nonatomic, strong) NSString *dataUrl;//下载数据的url
@property (nonatomic, strong) NSString *imageUrl;//下载图标的url
@property (nonatomic, strong) NSString *fileSize;//数据的大小
@property (nonatomic, strong) NSString *guideName;//导游的名字
@property (nonatomic, strong) NSString *namePath;//名字路径（用来拼接数据的存储路径）

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
