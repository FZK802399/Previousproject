//
//  OrderDetailFootView.h
//  ShopNum1V3.1
//
//  Created by yons on 15/11/25.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailFootView : UIView
@property (weak, nonatomic) IBOutlet UILabel *vipDiscount;
@property (weak, nonatomic) IBOutlet UILabel *preferential;
@property (weak, nonatomic) IBOutlet UILabel *orderNumber;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@property (weak, nonatomic) IBOutlet UILabel *scorePrice;
@property (weak, nonatomic) IBOutlet UILabel *shouldPayPrice;

@property (weak, nonatomic) IBOutlet UIButton *oneBtn;
@property (weak, nonatomic) IBOutlet UIButton *twoBtn;
@property (weak, nonatomic) IBOutlet UIButton *threeBtn;
@property (weak, nonatomic) IBOutlet UIButton *fourBtn;
@end
