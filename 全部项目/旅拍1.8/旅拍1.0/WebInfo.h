//
//  WebInfo.h
//  旅拍1.0
//
//  Created by 司马帅帅 on 15/7/15.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebInfo : NSObject

@property (nonatomic, strong) NSString *webUrl;
@property (nonatomic, strong) NSString *dateLine;
@property (nonatomic, strong) NSString *yearString;
@property (nonatomic, strong) NSString *monthString;
@property (nonatomic, strong) NSString *dayString;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *viewCount;
@property (nonatomic, assign) int lpCount;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
