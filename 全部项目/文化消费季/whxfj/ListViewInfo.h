//
//  ListViewInfo.h
//  whxfj
//
//  Created by 司马帅帅 on 14-8-23.
//  Copyright (c) 2014年 baobin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListViewInfo : NSObject

@property (nonatomic, strong) NSString *webId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *thumbString;
@property (nonatomic, strong) NSString *miaoshu;
@property (nonatomic, strong) NSString *timeString;
@property (nonatomic, strong) NSString *addressString;
@property (nonatomic, strong) NSString *quName;

- (id)initWithDictionary:(NSDictionary *)dictionary_;

@end
