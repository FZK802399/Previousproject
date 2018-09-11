//
//  MSProgressView.h
//  QuanJingKe
//
//  Created by baobin on 13-7-30.
//  Copyright (c) 2013年 司马帅帅. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface MSProgressView : UIView

@property (strong, nonatomic) UILabel *progressLabel;

- (id)initWithFrame:(CGRect)frame
          backColor:(UIColor *)backColor
      progressColor:(UIColor *)progressColor
          lineWidth:(CGFloat)lineWidth;
- (void)updateProgressCircleWithProgress:(float)progress_;
@end
