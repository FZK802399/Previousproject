//
//  DraftInfo.h
//  旅拍1.0
//
//  Created by 司马帅帅 on 15/7/16.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DraftInfo : NSObject

@property (nonatomic, assign) int draftId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray *textArray;
@property (nonatomic, assign) int imageCount;
@property (nonatomic, strong) NSString *dateLine;

@end
