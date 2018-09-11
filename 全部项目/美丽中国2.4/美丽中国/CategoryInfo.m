//
//  CategoryInfo.m
//  美丽中国
//
//  Created by 司马帅帅 on 15/7/20.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import "CategoryInfo.h"

@implementation CategoryInfo

- (id)initWithDictionay:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.categoryName = dictionary[@"classifyName"];
        self.categoryId = dictionary[@"id"];
    }
    return self;
}

@end
