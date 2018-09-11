//
//  CommentUserInfo.m
//  美丽中国
//
//  Created by 司马帅帅 on 15/7/24.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import "CommentUserInfo.h"
#import "Header.h"

@implementation CommentUserInfo

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.userId = dictionary[@"userId"];
        self.userName = dictionary[@"userName"];
        self.userSex = [dictionary[@"userSex"] intValue];
        self.userThumbImage = [NSString stringWithFormat:@"%@/%@",LOCAL_HOST_SECONDE, dictionary[@"userThumbImage"]];
        NSLog(@"userThumbImage %@",_userThumbImage);
    }
    return self;
}

@end
