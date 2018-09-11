//
//  OrderDetailTableFootView.h
//  ShopNum1V3.1
//
//  Created by yons on 15/11/25.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface OrderDetailTableFootView : UIView
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *fpTitle;
@property (weak, nonatomic) IBOutlet UILabel *fpType;
@property (weak, nonatomic) IBOutlet UILabel *fpContent;
@property (weak, nonatomic) IBOutlet UILabel *msg;

@property (weak, nonatomic) IBOutlet UILabel *orderNum;
@property (weak, nonatomic) IBOutlet UILabel *orderTime;
@end
