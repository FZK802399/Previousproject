//
//  RecommendPersonModel.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-11-11.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecommendPersonModel : NSObject

/*
 {
 "Guid": "2182e181-04b8-4e60-8bb9-c713b0cbb6f5",
 "MemLoginID": "elliott",
 "Email": "0",
 "Pwd": "dda62c7884e3dc715d94d8c19e71f170",
 "PayPwd": "dda62c7884e3dc715d94d8c19e71f170",
 "Sex": 0,
 "Age": 0,
 "Birthday": null,
 "CreditMoney": 0.00,
 "Photo": null,
 "RealName": null,
 "Area": null,
 "Vocation": null,
 "Address": null,
 "Postalcode": null,
 "OfficeTel": null,
 "HomeTel": null,
 "Mobile": "0",
 "Fax": null,
 "QQ": null,
 "Msn": null,
 "CardType": null,
 "CardNum": null,
 "WebSite": null,
 "Question": null,
 "Answer": null,
 "RegDate": "2014/11/11 10:01:37",
 "LastLoginDate": null,
 "LastLoginIP": null,
 "LoginTime": 0,
 "AdvancePayment": 0.00,
 "Score": 10,
 "RankScore": 0,
 "LockAdvancePayment": 0.00,
 "LockSocre": 0,
 "CostMoney": 0.00,
 "MemberRankGuid": "6cdea043-b423-459d-8bff-be67306d1dd9",
 "TradeCount": 0,
 "IsForbid": 0,
 "CreateUser": null,
 "CreateTime": "2014/11/11 10:01:37",
 "ModifyUser": null,
 "ModifyTime": "2014/11/11 10:01:37",
 "IsDeleted": 0,
 "AgentID": null,
 "IsAgentID": 0,
 "AgentMemberRankGuid": null,
 "AgentRankScore": 0,
 "AgentValidity": null,
 "PaymentType": 0,
 "CommendPeople": "test1",
 "CommendCondition": 0,
 "AreaCode": null,
 "WW": null,
 "AgentUrl": null,
 "AgentOtherUrl": null,
 "AgentLevel": 0,
 "FromAgent": null,
 "IsRecommendJion": 0,
 "AppKey": null,
 "AppSecret": null,
 "TEmail": null,
 "Tshou": null
 }
 */

@property (nonatomic, strong) NSString *Email;
@property (nonatomic, assign) NSInteger Sex;
@property (nonatomic, strong) NSString *Mobile;
@property (nonatomic, strong) NSString *RealName;
@property (nonatomic, strong) NSString *MemLoginID;
@property (nonatomic, strong) NSString *CommendPeople;

- (id)initWithAttributes:(NSDictionary *)attributes;

///获取推荐会员列表
+ (void)getRecommendPersonListByParameters:(NSDictionary *)parameters andblock:(void(^)(NSArray *List, NSError *error))block;


@end
