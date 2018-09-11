//
//  FXModel.h
//  ShopNum1V3.1
//
//  Created by yons on 15/11/28.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FXModel : NSObject
@property (nonatomic,strong)NSString * MemLoginID;
///推荐人
@property (nonatomic,strong)NSString * CommendPeople;
///等级
@property (nonatomic,assign)NSInteger lvl;
///盈利
@property (nonatomic,assign)CGFloat Profit;
///相片
@property (nonatomic,strong)NSString * Photo;

-(instancetype)initWithDict:(NSDictionary *)dict;
///获取分销列表
+(void)getFXListWithBlock:(void(^)(NSArray *,CGFloat ,CGFloat ,NSError *))block;
@end
//"MemLoginID": "great1",
//"CommendPeople": "jerry",
//"lvl": 1