//
//  AppConfigModel.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-6.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppSignModel : NSObject

+ (void)getAppSignandBlocks:(void(^)(NSString *appSign,NSError *error))block;

@end
