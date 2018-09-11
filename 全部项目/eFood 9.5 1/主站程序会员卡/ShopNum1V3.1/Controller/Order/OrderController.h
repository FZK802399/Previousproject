//
//  OrderController.h
//  OnlineShop
//
//  Created by yons on 15/9/1.
//  Copyright (c) 2015年 m. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OrderEndDelegate <NSObject>

- (void)operationEndWithController:(id )viewController;

@end

///订单列表界面
typedef enum : NSInteger {
    ALL_ORDER,              //全部订单
    WAIT_PAYMONEY,          //等待付款
    WAIT_DELIVERGOODS,      //等待发货
    WAIT_RECEIVEGOODS,      //等待收货
    DONE_ORDER,             //已完成订单
    BUYER_DONE_ASSESS,      //买家已评价
    SELLER_DONE_ASSESS,     //卖家已评价
    REFUNDING,              //退款中
    DONE_ORDER_NOT_ASSESS   //订单完成并且未评价
} OrderType;

@interface OrderController : WFSViewController
///用来判断查看订单的类型
@property(nonatomic,assign)OrderType OrderType;

+ (instancetype) create ;
@end
