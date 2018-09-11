//
//  ZDXMoveView.h
//  2016.1.12 修正应用挂起再唤醒时，显示异常bug
//  Created by Mac on 15/10/15.
//  Copyright (c) 2015年 ZDX All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZDXMoveView;
@protocol ZDXMoveViewDelegate <NSObject>

@required
/** 选中某个按钮代理方法 */
- (void)moveView:(ZDXMoveView *)moveView didSelectButtonIndex:(NSInteger)index;

@end

@interface ZDXMoveView : UIView

@property (copy, nonatomic) NSArray *buttonsTitle; // 所有按钮标题

@property (assign, nonatomic) CGFloat buttonTitleNormalFontSize; // default is 13.0
@property (assign, nonatomic) CGFloat moveViewHeight; // default is 2.0f

@property (strong, nonatomic) UIColor *buttonTitleNormalColor;
@property (strong, nonatomic) UIColor *buttonTitleSelectedColor;
@property (strong, nonatomic) UIColor *separationColor;
@property (strong, nonatomic) UIColor *bottomLineColor;
@property (strong, nonatomic) UIColor *topLineColor;

@property (assign, nonatomic) BOOL addSeparation; // default is YES;

@property (weak, nonatomic) id<ZDXMoveViewDelegate> delegate;

// 默认初始化方法
- (instancetype)initWithFrame:(CGRect)frame buttons:(NSArray *)buttonsTitle;


@end
