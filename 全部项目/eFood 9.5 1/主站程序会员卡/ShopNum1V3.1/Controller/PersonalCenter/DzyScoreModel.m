//
//  ScoreModel.m
//  ShopNum1V3.1
//
//  Created by yons on 15/11/25.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "DzyScoreModel.h"
#import "AppConfig.h"
@implementation DzyScoreModel
//@property (nonatomic,strong)NSString * Guid;
//
//@property (nonatomic,assign)NSInteger OperateType;
//
//@property (nonatomic,assign)CGFloat CurrentScore;
//
//@property (nonatomic,assign)CGFloat OperateScore;
//
//@property (nonatomic,assign)CGFloat LastOperateScore;
//
//@property (nonatomic,strong)NSString * Date;
//
//@property (nonatomic,strong)NSString * Memo;
//
//@property (nonatomic,strong)NSString * MemLoginID;
//
//@property (nonatomic,strong)NSString * CreateUser;
//
//@property (nonatomic,strong)NSString * CreateTime;
//
//@property (nonatomic,assign)NSInteger IsDeleted;
-(instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        _Guid = [dict objectForKey:@"Guid"];
        _OperateType = [[dict objectForKey:@"OperateType"] integerValue];
        _CurrentScore = [[dict objectForKey:@"CurrentScore"] floatValue];
        _OperateScore = [[dict objectForKey:@"OperateScore"] floatValue];
        _LastOperateScore = [[dict objectForKey:@"LastOperateScore"] floatValue];
        NSString * data = [dict objectForKey:@"Date"];
        _Date = [[data componentsSeparatedByString:@" "] firstObject];
        _Memo = [dict objectForKey:@"Memo"];
        _MemLoginID = [dict objectForKey:@"MemLoginID"];
        _CreateUser = [dict objectForKey:@"CreateUser"];
        _CreateTime = [dict objectForKey:@"CreateTime"];
        _IsDeleted = [[dict objectForKey:@"IsDeleted"] integerValue];
    }
    return self;
}

+(void)getScoreListWithBlock:(void(^)(NSArray * list,NSError * error))block
{
    AppConfig * config = [AppConfig sharedAppConfig];
    [config loadConfig];
    NSDictionary * dict = @{
                            @"MemLoginID":config.loginName,
                            @"AppSign":config.appSign
                            };
    [[AFAppAPIClient sharedClient]getPath:@"api/getscoremodifylog/" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray * arr = [responseObject objectForKey:@"Data"] == [NSNull null]?[NSArray array]:[responseObject objectForKey:@"Data"];
        NSMutableArray * list = [NSMutableArray arrayWithCapacity:arr.count];
        for (NSDictionary * dict in arr) {
            DzyScoreModel * model = [[DzyScoreModel alloc]initWithDict:dict];
            [list addObject:model];
        }
        if (block) {
            block([NSArray arrayWithArray:list],nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil,error);
        }
    }];
}
@end
