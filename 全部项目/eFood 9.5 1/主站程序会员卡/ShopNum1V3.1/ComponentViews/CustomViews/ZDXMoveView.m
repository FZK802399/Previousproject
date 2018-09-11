//
//  ZDXMoveView.m
//  
//  Created by Mac on 15/10/15.
//  Copyright (c) 2015年 ZDX All rights reserved.
//

#import "ZDXMoveView.h"

@interface ZDXMoveView ()

@property (strong, nonatomic) UIView *moveView; // 滑块View
@property (strong, nonatomic) UIView *bottomLineView; // 底线
@property (strong, nonatomic) UIView *topLineView; // 顶线
@property (assign, nonatomic) CGFloat buttonWidth; // 按钮宽度
@property (assign, nonatomic) CGFloat buttonHeight; // 按钮高度
@property (strong, nonatomic) NSMutableArray *buttons; // 所有按钮

@end

@implementation ZDXMoveView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self setupMoveView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame buttons:(NSArray *)buttonsTitle {
    _buttonsTitle = buttonsTitle;
    return [self initWithFrame:frame];
}

#pragma mark - GETTER

- (CGFloat)buttonTitleNormalFontSize {
    if (_buttonTitleNormalFontSize == 0) {
        _buttonTitleNormalFontSize = 13.0f;
    }
    return _buttonTitleNormalFontSize;
}

- (CGFloat)moveViewHeight {
    if (_moveViewHeight == 0) {
        _moveViewHeight = 2.0f;
    }
    return _moveViewHeight;
}

- (CGFloat)buttonHeight {
    _buttonHeight = CGRectGetHeight(self.frame) - self.moveViewHeight - 0.5;
    return _buttonHeight;
}

- (UIColor *)buttonTitleNormalColor {
    if (!_buttonTitleNormalColor) {
        _buttonTitleNormalColor = [UIColor grayColor];
    }
    return _buttonTitleNormalColor;
}

- (UIColor *)buttonTitleSelectedColor {
    if (!_buttonTitleSelectedColor) {
        _buttonTitleSelectedColor = [UIColor colorWithRed:0.165 green:0.504 blue:0.843 alpha:1.000];
    }
    return _buttonTitleSelectedColor;
}

- (UIColor *)bottomLineColor {
    if (!_bottomLineColor) {
        _bottomLineColor = [UIColor colorWithWhite:0.878 alpha:1.000];
    }
    return _bottomLineColor;
}

- (UIColor *)topLineColor {
    if (!_topLineColor) {
        _topLineColor = [UIColor colorWithWhite:0.878 alpha:1.000];
    }
    return _topLineColor;
}

- (NSMutableArray *)buttons {
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (UIColor *)separationColor {
    if (!_separationColor) {
        _separationColor = [UIColor colorWithWhite:0.878 alpha:1.000];
    }
    return _separationColor;
}

#pragma SETTER
- (void)setButtonsTitle:(NSArray *)buttonsTitle {
    _buttonsTitle = buttonsTitle;
    [self setupMoveView];
}

// 配置界面
- (void)setupMoveView {
    self.addSeparation = YES;
    if (self.buttonsTitle && self.buttonsTitle.count >= 2) {
        if (self.buttons.count == 0) {
            //            NSLog(@"View Frame : %@", NSStringFromCGRect(self.frame));
            self.buttonWidth = CGRectGetWidth(self.frame) / self.buttonsTitle.count;
            for (NSInteger index = 0; index < self.buttonsTitle.count; index ++) {
                UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(index * self.buttonWidth, 0, self.buttonWidth, self.buttonHeight)];
                // 设置按钮文字和颜色
                [button setTitle:_buttonsTitle[index] forState:UIControlStateNormal];
                [button setTitleColor:self.buttonTitleNormalColor forState:UIControlStateNormal];
                [button setTitleColor:self.buttonTitleSelectedColor forState:UIControlStateSelected];
                button.titleLabel.font = [UIFont systemFontOfSize:self.buttonTitleNormalFontSize];
                
                button.tag = index;
                [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
                if (index == 0) {
                    // 第一个按钮被选中
                    button.selected = YES;
                }
                [self addSubview:button];
                [self.buttons addObject:button]; //将按钮添加到所有按钮数组中
                // 添加分隔线
                if (index != 0) {
                    
                    // 分隔线高度-根据文字大小字体计算高度
                    CGFloat separationHeight = CGRectGetHeight([_buttonsTitle[index] boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:button.titleLabel.font} context:nil]) - 2 ;
                    UIView *separationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.5f, separationHeight)];
                    // 分隔线中心位置
                    separationView.center = CGPointMake(ceil(CGRectGetMinX(button.frame)), CGRectGetHeight(self.frame) / 2);
                    separationView.tag = 1000 + index;
                    [separationView setBackgroundColor:self.separationColor];
                    [self addSubview:separationView];
                }
            }
            // 添加滑块
            self.moveView = [[UIView alloc] initWithFrame:CGRectMake(0, self.buttonHeight, self.buttonWidth, self.moveViewHeight)];
            [self.moveView setBackgroundColor:self.buttonTitleSelectedColor];
            [self addSubview:self.moveView];
            
            // 顶线
            self.topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 0.5)];
            [self.topLineView setBackgroundColor:self.topLineColor];
            [self addSubview:self.topLineView];
            
            // 底线
            self.bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 0.5, CGRectGetWidth(self.frame), 0.5)];
            [self.bottomLineView setBackgroundColor:self.bottomLineColor];
            [self addSubview:self.bottomLineView];
        }
    }
}


#pragma mark - 按钮点击
- (void)clickButton:(UIButton *)sender {
    UIButton *selectButton = sender;
    for (UIButton *button in _buttons) {
        button.selected = NO;
    }
    selectButton.selected = YES;
    [_moveView.layer addAnimation:[self moveX:0.3 X:[NSNumber numberWithFloat:selectButton.tag * _buttonWidth]] forKey:nil];
    if ([self.delegate respondsToSelector:@selector(moveView:didSelectButtonIndex:)]) {
        [self.delegate moveView:self didSelectButtonIndex:selectButton.tag];
    }
}

// 移动滑块视图，time为时间，X为移动位置
-(CABasicAnimation *)moveX:(float)time X:(NSNumber *)x {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];// .y的话就向下移动
    animation.toValue = x;
    animation.duration = time;
    animation.removedOnCompletion = NO;//yes的话，又返回原位置了。
    animation.fillMode = kCAFillModeForwards;
    return animation;
}

// 重写父类方法
- (void)drawRect:(CGRect)rect {
    self.frame = rect;
    for (int i = 0; i < self.buttons.count; i++) {
        // 设置按钮文字和颜色
        UIButton *btn = self.buttons[i];
        [btn setTitleColor:self.buttonTitleNormalColor forState:UIControlStateNormal];
        [btn setTitleColor:self.buttonTitleSelectedColor forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:self.buttonTitleNormalFontSize];
        if (self.addSeparation) {
            if (i != 0) {
                UIView *sepView = [self viewWithTag:(1000 + i)];
                sepView.backgroundColor = self.separationColor;
            }
        } else {
            UIView *sepView = [self viewWithTag:(1000 + i)];
            if (sepView) {
                [sepView removeFromSuperview];
            }
        }
    }
//    self.moveView.frame = CGRectMake(0, self.buttonHeight, self.buttonWidth, self.moveViewHeight);
    [self.moveView setBackgroundColor:self.buttonTitleSelectedColor];
    [self.topLineView setBackgroundColor:self.topLineColor];
    [self.bottomLineView setBackgroundColor:self.bottomLineColor];
}

@end
