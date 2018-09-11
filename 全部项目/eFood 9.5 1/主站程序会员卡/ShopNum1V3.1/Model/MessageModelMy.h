//
//  MessageModelMyMy.h
//  Shop
//
//  Created by Ocean Zhang on 4/17/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModelMy : NSObject

@property (nonatomic, strong) NSString *Guid;
@property (nonatomic, strong) NSString *Title;
@property (nonatomic, assign) NSInteger Type;
@property (nonatomic, strong) NSString *Content;
@property (nonatomic, strong) NSString *SendTime;

//"Guid": "c4ce220e-0019-4b74-a3fc-55e36619fcf8",
//"Title": "liuxing",
//"Type": "1",
//"Content": "dsafsdfsdafds",
//"SendTime": "2013/08/10 09:59:04"

- (id)initWithAttributes:(NSDictionary *)attributes;

+ (void)getMessageListWithParameters:(NSDictionary*)parameters andblock:(void(^)(NSArray *list,NSError *error))block;

+ (void)deleteMessageWithParameters:(NSDictionary*)parameters andblock:(void(^)(NSInteger result, NSError *error))block;

+ (void)setReadMessageWithParameters:(NSDictionary*)parameters andblock:(void(^)(NSInteger result, NSError *error))block;

@end
