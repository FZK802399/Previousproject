//
//  IDCardTableViewCell.m
//  ShopNum1V3.1
//
//  Created by Mac on 16/1/3.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import "IDCardTableViewCell.h"

@implementation IDCardTableViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    NSLog(@"Rect : %@", NSStringFromCGRect(self.frame));
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
