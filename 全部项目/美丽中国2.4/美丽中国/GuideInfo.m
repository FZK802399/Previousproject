//
//  GuideInfo.m
//  美丽中国
//
//  Created by 司马帅帅 on 15/7/20.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import "GuideInfo.h"

@implementation GuideInfo

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.guideId = [dictionary[@"id"] intValue];
        self.configUrl = dictionary[@"config_url"];
        self.dataUrl = dictionary[@"data_url"];
        self.imageUrl = dictionary[@"img_url"];
        self.fileSize = dictionary[@"file_size"];
        self.guideName = dictionary[@"name"];
        self.namePath = dictionary[@"name_path"];
    }
    return self;
}

@end
