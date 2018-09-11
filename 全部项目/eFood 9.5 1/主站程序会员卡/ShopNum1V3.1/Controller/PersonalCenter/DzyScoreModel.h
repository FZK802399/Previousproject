//
//  ScoreModel.h
//  ShopNum1V3.1
//
//  Created by yons on 15/11/25.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DzyScoreModel : NSObject
@property (nonatomic,strong)NSString * Guid;

@property (nonatomic,assign)NSInteger OperateType;

@property (nonatomic,assign)CGFloat CurrentScore;

@property (nonatomic,assign)CGFloat OperateScore;

@property (nonatomic,assign)CGFloat LastOperateScore;

@property (nonatomic,strong)NSString * Date;

@property (nonatomic,strong)NSString * Memo;

@property (nonatomic,strong)NSString * MemLoginID;

@property (nonatomic,strong)NSString * CreateUser;

@property (nonatomic,strong)NSString * CreateTime;

@property (nonatomic,assign)NSInteger IsDeleted;

-(instancetype)initWithDict:(NSDictionary *)dict;

+(void)getScoreListWithBlock:(void(^)(NSArray * list,NSError * error))block;
@end

//"Guid": "163d2aac-6a10-4476-b1cf-1fc68a3d5f6d",
//"OperateType": 0,
//"CurrentScore": 11019982,
//"OperateScore": 1,
//"LastOperateScore": 11019981,
//"Date": "2015/11/13 14:47:03",
//"Memo": "换购积分商品",
//"MemLoginID": "jerry",
//"CreateUser": "admin",
//"CreateTime": "2015/11/13 14:47:03",
//"IsDeleted": 0