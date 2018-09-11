//
//  RefundController.h
//  ShopNum1V3.1
//
//  Created by yons on 15/11/26.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderIntroModel.h"
@interface RefundController : WFSViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)OrderIntroModel * model;
@end
