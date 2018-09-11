//
//  ListViewInfo.m
//  whxfj
//
//  Created by 司马帅帅 on 14-8-23.
//  Copyright (c) 2014年 baobin. All rights reserved.
//

#import "ListViewInfo.h"

@implementation ListViewInfo

- (id)initWithDictionary:(NSDictionary *)dictionary_
{
    self = [super init];
    if (self) {
        self.webId = [dictionary_ objectForKey:@"id"];
        self.title = [dictionary_ objectForKey:@"title"];
        self.thumbString = [dictionary_ objectForKey:@"thumb"];
        self.miaoshu = [dictionary_ objectForKey:@"description"];
        self.timeString = [NSString stringWithFormat:@"时间：%@", [dictionary_ objectForKey:@"shijian"]];
        self.addressString = [NSString stringWithFormat:@"地点：%@", [dictionary_ objectForKey:@"didian"]];
        self.quName = [dictionary_ objectForKey:@"quname"];
    }
    return self;
}

@end
