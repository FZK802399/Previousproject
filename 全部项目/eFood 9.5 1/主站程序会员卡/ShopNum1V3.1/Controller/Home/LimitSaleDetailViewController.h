//
//  LimitSaleDetailViewController.h
//  ShopNum1V3.1
//
//  Created by Mac on 15/12/24.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "WFSViewController.h"
@class SaleProductModel;

@interface LimitSaleDetailViewController : WFSViewController

@property (strong, nonatomic) SaleProductModel *model;
@property (assign, nonatomic) SaleType saleType;

@end
