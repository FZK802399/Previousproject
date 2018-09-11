//
//  RefundCell2.m
//  ShopNum1V3.1
//
//  Created by yons on 15/11/26.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "RefundCell2.h"

@implementation RefundCell2

- (void)awakeFromNib {
    self.textView.layer.cornerRadius = 3;
    self.textView.layer.borderColor = LINE_LIGHTGRAY.CGColor;
    self.textView.layer.borderWidth = 1;
    self.btn.userInteractionEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
