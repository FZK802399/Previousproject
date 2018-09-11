//
//  FMDBTool.m
//  旅拍1.0
//
//  Created by 司马帅帅 on 15/7/16.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import "FMDBTool.h"

@implementation FMDBTool

//创建数据库
+ (FMDatabase *)createDataBase
{
    //获取数据库存储路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths lastObject];
    NSLog(@"docPath %@",docPath);
    NSString *sqlitePath = [docPath stringByAppendingPathComponent:@"draft.sqlite"];
    //创建数据库
    FMDatabase *db = [FMDatabase databaseWithPath:sqlitePath];
    return db;
}

//创建表
+ (BOOL)createTableOnDB:(FMDatabase *)db withTableName:(NSString *)tableName
{
    NSString *sqlString = [NSString stringWithFormat:@"create table if not exists %@ (id integer primary key autoincrement, title text, imagecount integer, textarray text, dateline text);",tableName];
    BOOL result = [db executeUpdate:sqlString];
    return result;
}


//向数据库的表中添加一条数据
+ (BOOL)insertOnDB:(FMDatabase *)db withTableName:(NSString *)tableName andTitle:(NSString *)title imageCount:(int)imageCount textString:(NSString *)textString dateline:(NSString *)dateline
{
    NSString *sqlString = [NSString stringWithFormat:@"insert into %@ (title, imagecount, textarray, dateline) values ('%@', '%d', '%@', '%@');",tableName,title,imageCount,textString,dateline];
    BOOL result = [db executeUpdate:sqlString];
    return result;
}

@end







