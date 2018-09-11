//
//  DZYSubmitOrderController.h
//  ShopNum1V3.1
//
//  Created by yons on 16/1/20.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZYSubmitOrderController : UIViewController

@property (nonatomic,strong)NSArray * productArr;
///邮费
@property (nonatomic,assign)CGFloat PostageMoney;
///需要邮费的临界点
@property (nonatomic,assign)CGFloat SplitPostageMoney;
+(instancetype)create;
@end
