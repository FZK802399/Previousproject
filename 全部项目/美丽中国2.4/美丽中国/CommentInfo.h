//
//  CommentInfo.h
//  美丽中国
//
//  Created by 司马帅帅 on 15/7/24.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CommentUserInfo;

@interface CommentInfo : NSObject

@property (nonatomic, strong) NSString *audioLength;
@property (nonatomic, strong) NSString *commentId;
@property (nonatomic, strong) NSString *commentOriginalTime;//时间戳
@property (nonatomic, strong) NSString *commentTime;//有时间格式的时间
@property (nonatomic, strong) CommentUserInfo *commentUserInfo;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
