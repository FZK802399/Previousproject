//
//  CommentUserInfo.h
//  美丽中国
//
//  Created by 司马帅帅 on 15/7/24.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentUserInfo : NSObject

//发表评论的人的userId
@property (nonatomic, strong) NSString *userId;
//发表评论的人的名字
@property (nonatomic, strong) NSString *userName;
//发表评论的人的性别
@property (nonatomic, assign) int userSex;
//发表评论的人的头像
@property (nonatomic, strong) NSString *userThumbImage;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
