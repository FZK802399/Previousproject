//
//  PopView.m
//  DropDownDemo
//
//  Created by m on 15/7/4.
//  Copyright (c) 2015年 童明城. All rights reserved.
//

#import "LZPopView.h"
@interface LZPopView()<UIGestureRecognizerDelegate>
/**
 *  初始化时的原始尺寸
 */
@property (nonatomic,assign) CGRect starFrame;
/**
 *  内容视图
 */
@property (nonatomic,strong) UIView *contentView;
/**
 * 内容视图的原始尺寸
 */
@property (nonatomic,assign) CGRect contentViewStarFrame;
/**
 *  动画将在这消失 或者出现
 */
@property (nonatomic,assign) CGRect contentViewAnimationFrame;
/**
 * 👋🔟
 */
@property (nonatomic,assign) CGPoint  startPoint;
/**
 * 背景色
 */
@property (nonatomic,strong) UIColor *myBackground;
@end
///  从上到下 从下到上 时间设置
static NSTimeInterval kAnimationTypeUPDownAndBottomTop = 0.2;
///  淡入淡出 时间 设置
static NSTimeInterval kAnimationTypeFadeInOut          = 0.4;
/// 视图消失 时间设置
static NSTimeInterval kAnimationDissmiss               = 0.2;
@implementation LZPopView
/**
 *  默认加到topview上 可设置代理
 */
-(instancetype) initWithFrame:(CGRect)frame dataSource:(id<LZPopViewDataSoure>)dataSource  delegate:(id<LZPopViewDelegate>)delegate backGroundColor:(UIColor*)color{
    if (self = [super initWithFrame:frame]) {
        self.dataSoure = dataSource;
        self.delegate = delegate;
        //1...设置背景颜色
        self.backgroundColor = color;
        self.myBackground = color;
        //2...保留原始frame  设置frame；开始是隐藏的：
        self.starFrame = frame;
        //3...激活用户交互
        self.userInteractionEnabled = YES;
        self.canClickBackground     = YES;
        //4...设置数据源视图
        if ([self.dataSoure respondsToSelector:@selector(popViewContentViewForLZPopView:)]) {
            self.contentView = [_dataSoure popViewContentViewForLZPopView:self];
            self.contentViewStarFrame = self.contentView.frame;
            self.contentView.frame = self.contentViewAnimationFrame;
            [self addSubview:self.contentView];
        }
        //5...设置动画效果
        self.animationType = LZAnimationTypeUPAndDown;
    }
    return self;
}
/**
 *  默认加到topview上
 */
-(instancetype) initWithFrame:(CGRect)frame dataSource:(id<LZPopViewDataSoure>)dataSource backGroundColor:(UIColor*)color{
    return [[LZPopView alloc]initWithFrame:frame dataSource:dataSource delegate:nil backGroundColor:color];
}
/**
 *  默认加到topview上 块回调
 */
-(instancetype) initWithFrame:(CGRect)frame dataSource:(id<LZPopViewDataSoure>)dataSource backGroundColor:(UIColor*)color clickBackGround:(LZClickBackgroundView) clickBackgroundView{
    self = [[LZPopView alloc]initWithFrame:frame dataSource:dataSource delegate:nil backGroundColor:color];
    self.clickBackground = clickBackgroundView;
    return self;
}
#pragma mark 用户交互 触摸手势
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.canClickBackground) {
        if (self.clickBackground) {
            self.clickBackground();
        }
        if ([self.delegate respondsToSelector:@selector(popViewDidClickBackgroud:)]) {//设置代理了
            [self.delegate popViewDidClickBackgroud:self];
        }
        [self dismiss];
    }
   
}

//-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
//    CGPoint pt = [[touches anyObject] locationInView:self];
//    CGFloat dx = pt.x - self.startPoint.x;
//    CGFloat dy = pt.y - self.startPoint.y   ;
//    self.center  = CGPointMake(self.center.x + dx,self.center.y + dy);
//}
#pragma mark 动画效果
/**
 *  显示：可以设置动画的方式
 */
-(void) show{
    [self showInView:nil];
}
-(void) showInView:(UIView*)view{
    if (!view) {
        [[self topView] addSubview:self];
    }else{
        [view addSubview:self];
    }
    
    if ([self.dataSoure respondsToSelector:@selector(popViewContentViewForLZPopView:)] && self.isBiJia) {
        self.contentView = [_dataSoure popViewContentViewForLZPopView:self];
        self.contentViewStarFrame = self.contentView.frame;
    }
    
    self.backgroundColor = self.myBackground;
    self.alpha = 0;
    self.frame = self.starFrame;
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        [self setupDateSourceAnimation];
    }];
}
-(void) setupDateSourceAnimation{
    self.contentView.frame = self.contentViewAnimationFrame;
//1...上下切换
    if (self.animationType == LZAnimationTypeUPAndDown || self.animationType == LZAnimationTypeBottomToTop) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:kAnimationTypeUPDownAndBottomTop];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        self.contentView.frame = self.contentViewStarFrame;
        [UIView commitAnimations];
        return ;
    }
//2...淡入淡出
    if (self.animationType == LZAnimationTypeFadeInOut) {
        self.contentView.frame = self.contentViewStarFrame;
        self.contentView.alpha = 0;
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationDuration:0.5];
//        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
//        self.contentView.alpha = 1;
//        [UIView commitAnimations];
        CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        popAnimation.duration = kAnimationTypeFadeInOut;
        popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                                [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                                [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                                [NSValue valueWithCATransform3D:CATransform3DIdentity]];
        popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
        popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                         [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                         [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        self.contentView.alpha = 1;
        [self.contentView.layer addAnimation:popAnimation forKey:nil];
        return ;
    }
//3...从屏幕下方弹出来
    if (self.animationType == LZAnimationTypeBottomToTop) {
        
    }
   
}
/**
 *  让视图消失
 */
-(void) dismiss{
    switch (self.animationType) {
        case LZAnimationTypeUPAndDown:
            [self dismissUsingLZAnimationTypeUPAndDown];
            return;
            break;
        case LZAnimationTypeFadeInOut:
            [self dismissUsingLZAnimationTypeFadeInOut];
            return;
            break;
        case LZAnimationTypeBottomToTop:
            [self dismissUsingLZAnimationTypeUPAndDown];
            return;
            break;
        default:
            [self dismissUsingLZAnimationTypeUPAndDown];
            break;
    }
    
    
    
 
}
-(void) dismissUsingLZAnimationTypeUPAndDown{
    self.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:kAnimationDissmiss animations:^{
        // 最后消失的点
        self.contentView.frame = self.contentViewAnimationFrame;
        //        self.contentView.frame = CGRectZero;   可以设置各种动画
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
-(void) dismissUsingLZAnimationTypeFadeInOut{
     self.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:kAnimationDissmiss animations:^{
        self.contentView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
-(UIView*)topView{
    NSArray *allSubViews = [[UIApplication sharedApplication].keyWindow subviews];
    return allSubViews[0];
}
#pragma mark  设置datasoure动画 用这个即可
-(CGRect)contentViewAnimationFrame{
    if (self.animationType == LZAnimationTypeUPAndDown) {
        CGFloat x = self.contentView.frame.origin.x;
        CGFloat y = self.contentView.frame.origin.y;
        CGFloat w = self.contentView.frame.size.width;
        CGFloat h = 0;
        return CGRectMake(x, y,w, h);
    }
    if (self.animationType == LZAnimationTypeBottomToTop) {
        CGFloat x = self.contentView.frame.origin.x;
        CGFloat y = [UIScreen mainScreen].bounds.size.height;
        CGFloat w = self.contentView.frame.size.width;
        CGFloat h = self.contentView.frame.size.height;
        return CGRectMake(x, y,w, h);
    }
    return CGRectZero;
}
//-(void)test{
//    switch (self.animationType) {
//        LZAnimationTypeFadeInOut:{
//            NSLog(@"DSFSF");
//        }

    
//    }
//}
@end
