//
//  ChaiDan.h
//  拆单
//
//  Created by yons on 16/1/20.
//  Copyright (c) 2016年 dzy_PC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ChaiDanModel.h"
//#import "GoodsModel.h"
#import "OrderMerchandiseSubmitModel.h"
///拆单最大金额
#define GoodsModel OrderMerchandiseSubmitModel
@interface ChaiDan : NSObject
///初始商品列表
@property (nonatomic,strong)NSMutableArray * firstArr;
@property (nonatomic,assign)CGFloat rate;
+(NSMutableArray *)ChanDanWithArr:(NSMutableArray *)firstArr Rate:(CGFloat )rate;
@end
