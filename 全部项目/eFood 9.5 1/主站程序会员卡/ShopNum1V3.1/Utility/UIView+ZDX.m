//
//  UIView+ZDX.m
//  Smartdre_Student
//
//  Created by Mac on 15/11/13.
//  Copyright (c) 2015年 GroupFly. All rights reserved.
//

#import "UIView+ZDX.h"

@implementation UIView_ZDX

+ (void)addStarImageViewWithScore:(NSInteger)score toView:(UIView *)subView {
    CGFloat starViewWidth = CGRectGetWidth(subView.bounds) / 5.0;
    // 一共有5分
    for (int i=0; i<5; i++) {        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*starViewWidth, 0, starViewWidth, starViewWidth)];
        imageView.contentMode = UIViewContentModeCenter;
        if (i < score) {
            imageView.image = [UIImage imageNamed:@"comment_sstar"];
        } else {
            imageView.image = [UIImage imageNamed:@"comment_sstar_gray"];
        }
        [subView addSubview:imageView];
    }
}

@end
