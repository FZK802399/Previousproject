//
//  RefundOrderModel.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-9-5.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReturnGoodModel.h"

@interface RefundOrderModel : NSObject

@property (nonatomic, strong) NSString *Guid;

@property (nonatomic, assign) NSInteger returnOrderStatue;

@property (nonatomic, strong) NSMutableArray *returnProductList;

- (id)initWithAttributes:(NSDictionary *)attributes;

///获取退货订单详情
+ (void)getReturnOrderDetailWithparameters:(NSDictionary *)parameters andblock:(void(^)(RefundOrderModel *model ,NSError *error))block;

///更新退货订单详情
+ (void)updateReturnOrderDetailWithparameters:(NSDictionary *)parameters andblock:(void(^)(NSInteger result ,NSError *error))block;

@end
