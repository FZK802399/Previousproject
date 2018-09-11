//
//  NoticeModel.m
//  ShopNum1V3.1
//
//  Created by Mac on 15/12/1.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "NoticeModel.h"

@implementation NoticeModel

+(void)fetchNoticeListWithParameters:(NSDictionary *)parameters block:(void(^)(NSArray *list,CGFloat IOSversion,NSError *error))block {
    [[AFAppAPIClient sharedClient] getPath:@"/api/GetAnnouncementList/?" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *responseArray = [responseObject objectForKey:@"Data"];
        NSArray *notices = nil;
        if (responseArray.count > 0) {
            notices = [NoticeModel objectArrayWithKeyValuesArray:responseArray];
        }
        NSDictionary * dict = responseArray.firstObject;
        CGFloat IOSversion = [[dict objectForKey:@"IOSversion"] doubleValue];
        if (block) {
            block(notices,IOSversion, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil,-1, error);
        }
    }];
}

@end
