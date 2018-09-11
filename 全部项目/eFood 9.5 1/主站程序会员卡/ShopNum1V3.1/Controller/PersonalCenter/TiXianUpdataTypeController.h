//
//  TiXianUpdataTypeController.h
//  ShopNum1V3.1
//
//  Created by yons on 16/3/9.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BankModel.h"
@interface TiXianUpdataTypeController : UITableViewController
@property (nonatomic,strong)BankModel * model;
+ (instancetype)create;
@end
