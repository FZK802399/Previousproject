//
//  ScoreModel.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-9-3.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScoreModel : NSObject

//"Guid": "eee22490-1526-4e66-8886-2f51bda3f228",
//"OperateType": 2,
//"CurrentScore": 20,
//"OperateScore": 10,
//"LastOperateScore": 30,
//"Date": "2014/09/03 15:26:16",
//"Memo": "签到奖励积分",
//"MemLoginID": "elliott",
//"CreateUser": "admin",
//"CreateTime": "2014/09/03 15:26:16",
//"IsDeleted": 0


@property (nonatomic, strong) NSString *Guid;

@property (nonatomic, assign) NSInteger OperateType;

@property (nonatomic, assign) NSInteger CurrentScore;

@property (nonatomic, assign) NSInteger OperateScore;

@property (nonatomic, assign) NSInteger LastOperateScore;

@property (nonatomic, strong) NSString *Memo;

@property (nonatomic, strong) NSString *CreateTime;

@property (nonatomic, strong) NSString *MemLoginID;

- (id)initWithAttributes:(NSDictionary *)attributes;

+ (void)getScoreDetailByparameters:(NSDictionary *)parameters andblock:(void(^)(NSArray *List, NSError *error))block;



@end
