//
//  PostProgressView.m
//  旅拍1.0
//
//  Created by 司马帅帅 on 15/7/15.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import "PostProgressView.h"
#import "Header.h"
#import "MSProgressView.h"

@interface PostProgressView ()
{
    MSProgressView *_progressView;
}
@end

@implementation PostProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addContentView];
    }
    return self;
}

//添加内容视图
- (void)addContentView
{
    _progressView = [[MSProgressView alloc] initWithFrame:CGRectMake(0, 0, 50, 50) backColor:[UIColor whiteColor] progressColor:LIGHT_RED_COLOR lineWidth:14];
    _progressView.alpha = 0.0f;
    _progressView.center = self.center;
    [self addSubview:_progressView];
}

- (void)showInView:(UIView *)view
{
    [view addSubview:self];
    self.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.backgroundColor = LIGHT_OPAQUE_BLACK_COLOR;
                         _progressView.alpha = 1.0f;
                         _progressView.frame = CGRectMake(0, 0, 150, 150);
                         _progressView.center = self.center;
                     } completion:nil];
}

- (void)removeView
{
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.backgroundColor = [UIColor clearColor];
                         _progressView.alpha = 0.0f;
                         _progressView.frame = CGRectMake(0, 0, 50, 50);
                         _progressView.center = self.center;
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

- (void)updateWithValue:(float)progressValue
{
    [_progressView updateWithProgressValue:progressValue];
}

@end






