//
//  MSProgressView.h
//  旅拍1.0
//
//  Created by 司马帅帅 on 15/7/15.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSProgressView : UIView

- (id)initWithFrame:(CGRect)frame
          backColor:(UIColor *)backColor
      progressColor:(UIColor *)progressColor
          lineWidth:(CGFloat)lineWidth;

//跟新进度
- (void)updateWithProgressValue:(float)value;

@end
