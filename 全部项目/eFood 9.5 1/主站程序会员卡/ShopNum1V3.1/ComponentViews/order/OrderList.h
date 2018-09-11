//
//  OrderList.h
//  Shop
//
//  Created by Ocean Zhang on 4/17/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import "EGORefreshView.h"
#import "OrderIntroModel.h"
#import "OrderListTableViewCell.h"
#import "ScoreOrderIntroModel.h"

typedef enum {
    ///全部订单
    OrderAll = 0,
    ///代付款
    OrderWaitPay = 1,
    ///待发货
    OrderWaitShipments = 2,
    ///待收货
    OrderWaitReceiver = 3,
    ///已完成订单
    OrderOver = 4,
    ///买家已经评价
    OrderComment = 5,
    ///买家已经评价
    OrderCommentBuySeller = 6,
    ///退货
    OrderReturn = 7
}OrderStatus;

@protocol OrderListDelegate <NSObject>

- (void)selectedOrder:(id)model;

@optional
- (void)viewWuliuWith:(id)intro;

- (void)confirmReceiver:(id)intro;

- (void)commentProduct:(id)model;

- (void)viewPayWith:(id)intro;

- (void)cancelOrder:(id)intro;

@end

@interface OrderList : EGORefreshView<OrderItemTableViewCellDelegate>

@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger currentRefreshPos;
@property (nonatomic, strong) NSMutableArray *dataSource;

///区分是否是积分订单
@property (nonatomic, assign) NSInteger OrderType;

@property (nonatomic, assign) id<OrderListDelegate> delegate;

///0 全部订单  1待付款 2 待发货 3 待收货  4 已完成订单  5 买家已经评价  6 卖家已经评价  7退货
@property (nonatomic, assign) OrderStatus orderStatusView;

- (void)refreshList;

@end
