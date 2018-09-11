//
//  RefundGoodController.h
//  ShopNum1V3.1
//
//  Created by yons on 15/12/1.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailModel.h"
@interface RefundGoodController : WFSViewController<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
@property (nonatomic,strong)OrderDetailModel * model;
@end
