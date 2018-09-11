//
//  RecommendScoreModel.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-11-11.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import <Foundation/Foundation.h>

//{
//    "Guid": "9ed835b3-f919-46d7-93ec-dc04a70462d8",
//    "OperateType": 9,
//    "CurrentScore": 10,
//    "OperateScore": 3000,
//    "LastOperateScore": 3010,
//    "Date": "2014/11/10 20:06:35",
//    "Memo": "会员第一次购买记录，赠送消费积分！",
//    "MemLoginID": "test1",
//    "CreateUser": "admin",
//    "CreateTime": "2014/11/10 20:06:35",
//    "IsDeleted": 0
//}

@interface RecommendScoreModel : NSObject

@property (nonatomic, strong) NSString *Memo;
@property (nonatomic, assign) NSInteger CurrentScore;
@property (nonatomic, assign) NSInteger OperateScore;
@property (nonatomic, assign) NSInteger LastOperateScore;
@property (nonatomic, strong) NSString *CreateTime;


- (id)initWithAttributes:(NSDictionary *)attributes;

///获取推荐返利列表
+ (void)getRecommendScoreListByParameters:(NSDictionary *)parameters andblock:(void(^)(NSArray *List, NSError *error))block;

@end
