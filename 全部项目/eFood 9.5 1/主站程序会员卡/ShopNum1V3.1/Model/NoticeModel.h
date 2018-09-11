//
//  NoticeModel.h
//  ShopNum1V3.1
//
//  Created by Mac on 15/12/1.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface NoticeModel : NSObject

@property (copy, nonatomic) NSString *Guid;
@property (copy, nonatomic) NSString *Title;
@property (copy, nonatomic) NSString *Remark;

// 获取公告列表
+(void)fetchNoticeListWithParameters:(NSDictionary *)parameters block:(void(^)(NSArray *list,CGFloat IOSversion,NSError *error))block;

@end
