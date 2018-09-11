//
//  CommentInfo.m
//  美丽中国
//
//  Created by 司马帅帅 on 15/7/24.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import "CommentInfo.h"
#import "CommentUserInfo.h"
#import "Header.h"

@implementation CommentInfo

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.audioLength = dictionary[@"audioLength"];
        self.commentId = dictionary[@"commentId"];
        self.commentOriginalTime = dictionary[@"commentTime"] ;
        self.commentTime = [self dateDiff:_commentOriginalTime];
        self.commentUserInfo = [[CommentUserInfo alloc] initWithDictionary:dictionary[@"user"]];
    }
    return self;
}

//获取时间
-(NSString *)dateDiff:(NSString *)originalTime {
    
    //取出相应的时间戳 也就是时间间隔timeInterval
    NSTimeInterval timeInterval = [originalTime intValue];
    //用时间间隔生成评论时间commentDate
    NSDate *commentDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    //现在的时间todayDate
    NSDate *todayDate = [NSDate date];
    
    //计算时间间隔
    double ti = [todayDate timeIntervalSinceDate:commentDate];
    NSLog(@"评论的时间间隔 %f",ti);
    ti -= 440;
    
    if(ti < 1) {
        
        return @"刚刚评论";
        
    } else if (ti < 60) {
        
        return @"小于一分钟";
        
    } else if (ti < 3600) {
        
        int diff = round(ti / 60);
        
        return [NSString stringWithFormat:@"%d 分钟以前", diff];
        
    } else if (ti < 86400) {
        
        int diff = round(ti / 60 / 60);
        
        return[NSString stringWithFormat:@"%d 小时以前", diff];
        
    } else {
        //生成时间格式对象newFormatter
        NSDateFormatter  *newFormatter = [[NSDateFormatter alloc] init];
        //设置时区
        NSTimeZone *timeZone = [NSTimeZone localTimeZone];
        [newFormatter setTimeZone:timeZone];
        //设置时间显示格式
        [newFormatter setDateFormat:@"MM-dd HH:mm"];
        //用制定格式将时间声称字符串
        NSString *diff = [newFormatter stringFromDate:commentDate];
        return diff;
    }
}

@end
