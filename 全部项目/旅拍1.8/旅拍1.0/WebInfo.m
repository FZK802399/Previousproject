//
//  WebInfo.m
//  旅拍1.0
//
//  Created by 司马帅帅 on 15/7/15.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import "WebInfo.h"

@implementation WebInfo

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.webUrl = dictionary[@"url"];
        self.dateLine = dictionary[@"dateline"];
        
        self.dayString = [self getTimeWithFormat:@"dd"];
        self.monthString = [self getTimeWithFormat:@"MM"];
        self.yearString = [self getTimeWithFormat:@"YYYY"];
        
        self.imageUrl = dictionary[@"imgUrl"];
        self.lpCount = [dictionary[@"lpCount"] intValue];
        self.title = dictionary[@"title"];
        self.viewCount = dictionary[@"viewCount"];
    }
    return self;
}

//获取年月日
- (NSString *)getTimeWithFormat:(NSString *)format
{
    NSString *originalTimeInterval = self.dateLine;
    
    //获取时间戳的日期
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[originalTimeInterval intValue]];
    
    //设置时间格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *zone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:zone];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:date];
}

@end
