//
//  OrderDetailTableFootView.m
//  ShopNum1V3.1
//
//  Created by yons on 15/11/25.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "OrderDetailTableFootView.h"

@implementation OrderDetailTableFootView

- (void)drawRect:(CGRect)rect {
    self.msg.layer.cornerRadius = 3;
    self.msg.layer.borderColor = LINE_LIGHTGRAY.CGColor;
    self.msg.layer.borderWidth = 1;
}


@end
