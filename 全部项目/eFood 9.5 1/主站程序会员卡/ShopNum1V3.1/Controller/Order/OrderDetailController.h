//
//  OrderDetailController.h
//  ShopNum1V3.1
//
//  Created by yons on 15/11/24.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailModel.h"
#import "OrderIntroModel.h"
@interface OrderDetailController : UITableViewController
@property (nonatomic,strong)NSString * orderNum;
@property (nonatomic,strong)OrderIntroModel * listModel;
@end
