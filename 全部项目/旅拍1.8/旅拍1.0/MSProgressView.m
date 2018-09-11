//
//  MSProgressView.m
//  旅拍1.0
//
//  Created by 司马帅帅 on 15/7/15.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import "MSProgressView.h"

@interface MSProgressView ()
{
    UILabel *_progressLabel;
    UIColor *_backColor;
    UIColor *_progressColor;
    CGFloat _lineWidth;
    CGFloat _progress;
}
@end

@implementation MSProgressView

- (id)initWithFrame:(CGRect)frame
          backColor:(UIColor *)backColor
      progressColor:(UIColor *)progressColor
          lineWidth:(CGFloat)lineWidth
{
    self = [super initWithFrame:frame];
    if (self) {
        _backColor = backColor;
        _progressColor = progressColor;
        _lineWidth = lineWidth;
        
        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"lp_progressBackImage.png"]]];
        if (!_progressLabel) {
            _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
            _progressLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:_progressLabel];
        }

    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *backCircle = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) radius:self.bounds.size.width/2-_lineWidth/2 startAngle:(CGFloat)-M_PI_2 endAngle:(CGFloat)(1.5 * M_PI) clockwise:YES];
    [_backColor setStroke];
    backCircle.lineWidth = _lineWidth;
    [backCircle stroke];
    
    if (_progress != 0) {
        UIBezierPath *progressCircle = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) radius:self.bounds.size.width/2-_lineWidth/2 startAngle:(CGFloat)-M_PI_2 endAngle:(CGFloat)(-M_PI_2+_progress*2*M_PI) clockwise:YES];
        [_progressColor setStroke];
        progressCircle.lineWidth = _lineWidth;
        [progressCircle stroke];
    }
}

//跟新进度
- (void)updateWithProgressValue:(float)value
{
    _progress = value;
    [_progressLabel setText:[NSString stringWithFormat:@"%.f%%",value*100]];
    [self setNeedsDisplay];
}

@end





