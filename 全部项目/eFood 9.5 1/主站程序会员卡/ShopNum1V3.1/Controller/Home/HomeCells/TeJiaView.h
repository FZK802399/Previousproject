//
//  TeJiaView.h
//  ShopNum1V3.1
//
//  Created by Mac on 15/12/23.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FloorProductModel;

@interface TeJiaView : UIView

+ (instancetype)teJiaView;
+ (instancetype)teJiaViewWithFrame:(CGRect)frame;

- (void)updateViewWithModel:(FloorProductModel *)model;

@end
