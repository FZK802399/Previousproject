//
//  OrderListViewController.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-9-2.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "WFSViewController.h"
#import "OrderIntroModel.h"
#import "OrderList.h"


@interface OrderListViewController : WFSViewController<OrderListDelegate>
@property (strong, nonatomic) IBOutlet UIView *orderView;
@property (strong, nonatomic) IBOutlet UIView *changeTabView;
@property (strong, nonatomic) IBOutlet UIButton *commonOrderBtn;
@property (strong, nonatomic) IBOutlet UIButton *scoreOrderBtn;

@property (strong, nonatomic) OrderList *orderListView;

@property (assign, nonatomic) OrderStatus orderStatue;
///1 积分订单 ?
@property (assign, nonatomic) NSInteger orderType;

@property (assign, nonatomic) NSInteger comFrome;

- (IBAction)changeTabAction:(id)sender;

@end
