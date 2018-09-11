//
//  UIView+ZDX.h
//  Smartdre_Student
//
//  Created by Mac on 15/11/13.
//  Copyright (c) 2015年 GroupFly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView_ZDX : UIView

/// 根据评分数，添加star
+ (void)addStarImageViewWithScore:(NSInteger)score toView:(UIView *)subView;

@end
