//
//  MSProgressView.m
//  QuanJingKe
//
//  Created by baobin on 13-7-30.
//  Copyright (c) 2013年 司马帅帅. All rights reserved.
//

#import "MSProgressView.h"

@interface MSProgressView ()
@property (strong, nonatomic) UIColor *backColor;
@property (strong, nonatomic) UIColor *progressColor;
@property (assign, nonatomic) CGFloat lineWidth;
@property (assign, nonatomic) float progress;

@end

@implementation MSProgressView

- (id)initWithFrame:(CGRect)frame
          backColor:(UIColor *)backColor
      progressColor:(UIColor *)progressColor
          lineWidth:(CGFloat)lineWidth
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        _backColor = [backColor retain];
        _progressColor = [progressColor retain];
        _lineWidth = lineWidth;
        
        UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guidecelldownloadbackground.png"]];
        [backgroundView setFrame:CGRectMake(4, 4, self.bounds.size.width-4*2, self.bounds.size.height-4*2)];
        backgroundView.alpha=0.5;
        [self addSubview:backgroundView];
        _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.bounds.size.width-50)/2, (self.bounds.size.height-20)/2, 50, 20)];
        [_progressLabel setTextAlignment:NSTextAlignmentCenter];
        [_progressLabel setFont:[UIFont boldSystemFontOfSize:15]];
        _progressLabel.adjustsFontSizeToFitWidth=YES;
        [_progressLabel setBackgroundColor:[UIColor clearColor]];
        [_progressLabel setTextColor:[UIColor whiteColor]];
        [_progressLabel setText:@"等待"];
        [self addSubview:_progressLabel];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    //draw background circle
    UIBezierPath *backCircle = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width / 2,self.bounds.size.height / 2) radius:self.bounds.size.width / 2 - self.lineWidth / 2 startAngle:(CGFloat) -M_PI_2 endAngle:(CGFloat)(1.5 * M_PI) clockwise:YES];
    [self.backColor setStroke];
    backCircle.lineWidth = self.lineWidth;
    [backCircle stroke];
    
    if (self.progress != 0) {
        //draw progress circle
        UIBezierPath *progressCircle = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width / 2,self.bounds.size.height / 2) radius:self.bounds.size.width / 2 - self.lineWidth / 2 startAngle:(CGFloat) -M_PI_2 endAngle:(CGFloat)(-M_PI_2 + self.progress * 2 * M_PI) clockwise:YES];
        [self.progressColor setStroke];
        progressCircle.lineWidth = self.lineWidth;
        [progressCircle stroke];
    }
}

- (void)updateProgressCircleWithProgress:(float)progress_
{
    self.progress = progress_;
    [_progressLabel setText:[NSString stringWithFormat:@"%.1f%%",progress_*100]];
    [self setNeedsDisplay];
}

@end
