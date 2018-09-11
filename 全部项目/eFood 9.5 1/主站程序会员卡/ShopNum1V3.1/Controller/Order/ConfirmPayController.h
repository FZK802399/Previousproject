//
//  ConfirmPayController.h
//  ShopNum1V3.1
//
//  Created by yons on 15/11/18.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailModel.h"

@interface ConfirmPayController : WFSViewController

@property (nonatomic,strong)OrderDetailModel * model;
///订单号
@property (nonatomic, copy) NSString *orderNumber;


///订单号
@property (nonatomic, copy) NSString *order;
///总金额
@property (nonatomic, assign)CGFloat totalPrice;
///Rmb总金额 
@property (nonatomic, assign)CGFloat rmbPrice;
@property (assign, nonatomic) SaleType saleType;
@end
