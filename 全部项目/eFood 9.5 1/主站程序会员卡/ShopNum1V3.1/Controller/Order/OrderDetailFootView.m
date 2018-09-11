//
//  OrderDetailFootView.m
//  ShopNum1V3.1
//
//  Created by yons on 15/11/25.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "OrderDetailFootView.h"

@implementation OrderDetailFootView


- (void)drawRect:(CGRect)rect {
    self.oneBtn.backgroundColor = LINE_DARKGRAY;
    self.oneBtn.layer.cornerRadius = 3;
    
    self.twoBtn.backgroundColor = LINE_DARKGRAY;
    self.twoBtn.layer.cornerRadius = 3;
    
    self.threeBtn.backgroundColor = MYRED;
    self.threeBtn.layer.cornerRadius = 3;
    
    self.fourBtn.backgroundColor = MYRED;
    self.fourBtn.layer.cornerRadius = 3;
}


@end
