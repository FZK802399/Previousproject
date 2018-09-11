//
//  FMDBTool.h
//  旅拍1.0
//
//  Created by 司马帅帅 on 15/7/16.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface FMDBTool : NSObject

//创建数据库
+ (FMDatabase *)createDataBase;
//创建表
+ (BOOL)createTableOnDB:(FMDatabase *)db withTableName:(NSString *)tableName;
//向数据库的表中添加一条数据
+ (BOOL)insertOnDB:(FMDatabase *)db withTableName:(NSString *)tableName andTitle:(NSString *)title imageCount:(int)imageCount textString:(NSString *)textString dateline:(NSString *)dateline;

@end




