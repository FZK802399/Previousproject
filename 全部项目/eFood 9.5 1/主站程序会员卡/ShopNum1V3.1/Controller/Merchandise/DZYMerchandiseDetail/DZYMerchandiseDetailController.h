//
//  DZYMerchandiseDetailController.h
//  ShopNum1V3.1
//
//  Created by yons on 16/1/27.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MerchandiseDetailViewController.h"
@interface DZYMerchandiseDetailController : UIViewController
+(instancetype)create;
@property (nonatomic,strong)NSString * Guid;
///首次进入
@property (nonatomic,assign)BOOL firstIn;
@end
