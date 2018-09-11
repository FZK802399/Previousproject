//
//  DetailCell.m
//  ShopNum1V3.1
//
//  Created by yons on 16/1/27.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import "DetailCell.h"

@implementation DetailCell

- (void)awakeFromNib {
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
