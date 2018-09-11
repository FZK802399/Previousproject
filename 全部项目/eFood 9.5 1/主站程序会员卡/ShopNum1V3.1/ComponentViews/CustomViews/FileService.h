//
//  FileService.h
//  ShopNum1V3.1
//
//  Created by yons on 15/12/30.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileService : NSObject

+(float)fileSizeAtPath:(NSString *)path;
+(float)folderSizeAtPath:(NSString *)path;
+(void)clearCache:(NSString *)path;
@end
