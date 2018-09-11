//
//  DZYSelectView.m
//  selectView
//
//  Created by yons on 15/12/14.
//  Copyright (c) 2015年 ShopNum1. All rights reserved.
//
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define WIDTH [UIScreen mainScreen].bounds.size.width
#import "DZYSelectView.h"

@interface DZYSelectView ()

@property (nonatomic,strong)UIView * redLine;
@property (nonatomic,strong)NSMutableArray * lineWidth;
@property (nonatomic,assign)NSInteger fontNum;
@end

@implementation DZYSelectView

-(NSMutableArray *)btnArr
{
    if (_btnArr == nil) {
        _btnArr = [NSMutableArray array];
    }
    return _btnArr;
}

-(NSMutableArray *)lineWidth
{
    if (_lineWidth == nil) {
        _lineWidth = [NSMutableArray array];
        for (NSString * str in self.dataSource) {
            CGFloat width = [self getSizeWithString:str FontNum:_fontNum].width;
            [_lineWidth addObject:[NSNumber numberWithFloat:width]];
        }
    }
    return _lineWidth;
}

-(void)setFirstClick:(NSInteger)firstClick
{
    _firstClick = firstClick;
    NSInteger i = 0;
    if (firstClick == 8) {
        i = 4;
    }
    else
    {
        i = firstClick;
    }
    [self.btnArr[i] sendActionsForControlEvents:UIControlEventTouchUpInside];
}

-(instancetype)initWithFrame:(CGRect)frame dataSource:(NSMutableArray *)dataSource delegate:(id<SelectDelegate>)delegate normalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectColor lineColor:(UIColor *)lineColor fontNum:(NSInteger)fontNum
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = delegate;
        _dataSource = dataSource;
        _fontNum = fontNum;
        [self createBtnWithFrame:frame normalColor:normalColor selectedColor:selectColor];
        [self createRedLineWithFrame:frame color:lineColor];
//        [self.btnArr[0] sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)createBtnWithFrame:(CGRect)frame normalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectColor
{
    CGFloat w = frame.size.width/self.dataSource.count;
    for (NSString * str in self.dataSource) {
        NSInteger i = [self.dataSource indexOfObject:str];
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*w, 0, w, frame.size.height);
        btn.tag = i;
        [btn setTitle:str forState:UIControlStateNormal];
        [btn setTitleColor:normalColor forState:UIControlStateNormal];
        [btn setTitleColor:selectColor forState:UIControlStateSelected|UIControlStateHighlighted];
        [btn setTitleColor:selectColor forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:_fontNum];
        [btn addTarget:self action:@selector(headClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [self.btnArr addObject:btn];
    }
}

-(void)createRedLineWithFrame:(CGRect )frame color:(UIColor *)color
{
    self.redLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [self.lineWidth[0] floatValue], 2)];
    UIButton * btn = self.btnArr[0];
    self.redLine.center = CGPointMake(btn.center.x, frame.size.height-1);
    self.redLine.backgroundColor = color;
    [self addSubview:self.redLine];
}

#pragma mark - 点击事件
-(void)headClick:(UIButton *)btn
{
    if(btn.isSelected){return;}
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    for (UIButton * Rbtn in self.btnArr) {
        if ([Rbtn isEqual:btn]) {
            Rbtn.selected = !Rbtn.selected;
            continue;
        }
        Rbtn.selected = NO;
        Rbtn.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    CGPoint center = btn.center;
    center.y = self.frame.size.height - 1;
   
    CGFloat width = [self.lineWidth[btn.tag] floatValue];
    CGRect bounds = self.redLine.layer.bounds;
    bounds.size.width = width;
    [UIView animateWithDuration:0.3 animations:^{
        self.redLine.layer.bounds= bounds;
    }];
    
    CABasicAnimation * ani = [[CABasicAnimation alloc]init];
    ani.keyPath = @"position";
    ani.toValue = [NSValue valueWithCGPoint:center];
    ani.duration = 0.5;
    ani.removedOnCompletion = NO;
    ani.fillMode = kCAFillModeForwards;
    [self.redLine.layer addAnimation:ani forKey:nil];
    
    if ([self.delegate respondsToSelector:@selector(selectWithSelectView:btn:)]) {
        [self.delegate selectWithSelectView:self btn:btn];
    }
}

-(CGSize )getSizeWithString:(NSString *)str FontNum:(CGFloat )num
{
    return [str boundingRectWithSize:CGSizeMake(WIDTH, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:num]} context:nil].size;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
