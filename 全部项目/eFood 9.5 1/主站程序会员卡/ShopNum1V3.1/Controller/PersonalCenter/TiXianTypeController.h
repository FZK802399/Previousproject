//
//  TiXianTypeController.h
//  ShopNum1V3.1
//
//  Created by yons on 16/3/8.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BankModel.h"
@class TiXianTypeController;
@protocol TiXianTypeDelegate <NSObject>

- (void)TiXianTypeController:(TiXianTypeController *)vc withModel:(BankModel *)Model;

@end

// 提现方式
@interface TiXianTypeController : UIViewController
@property (nonatomic,weak)id<TiXianTypeDelegate>delegate;
@property (nonatomic,strong)NSString * Guid;
+ (instancetype)create;
@end
