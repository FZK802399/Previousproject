//
//  PopView.h
//  DropDownDemo
//
//  Created by m on 15/7/4.
//  Copyright (c) 2015年 童明城. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM (NSInteger , LZAnimationType) {
    //以下是枚举成员
    /// 上下切换
    LZAnimationTypeUPAndDown = 0,
    /// 淡入淡出
    LZAnimationTypeFadeInOut = 1,
    /// 从下面出来
    LZAnimationTypeBottomToTop = 2,
    Test1D = 3
};

typedef void (^LZClickBackgroundView)();

@class LZPopView;

@protocol LZPopViewDataSoure <NSObject>
@optional
-(UIView*)popViewContentViewForLZPopView:(LZPopView*)popView;

@end

@protocol LZPopViewDelegate <NSObject>

@optional
//根据情况判断 是否委托出去  如果只需要消失 而不做其他事 则不用设置代理
/**
 *  点击背景
 */
-(void)popViewDidClickBackgroud:(LZPopView*)popView;

@end


@interface LZPopView : UIImageView
/**
 * 控制器拥有popview  popview拥有块  块里是强引用 拥有控制器 不用__weak的话 就会出现保留环
 */
@property (nonatomic,copy)  void (^clickBackground)() ;

@property (nonatomic,weak) id<LZPopViewDataSoure> dataSoure;
@property (nonatomic,weak) id<LZPopViewDelegate> delegate;
// 默认是上下切换视图
@property (nonatomic,assign) LZAnimationType animationType;
/// 背景是否能点  默认为YES
@property (nonatomic,assign) BOOL canClickBackground;
@property (nonatomic, assign) BOOL isBiJia;
/**
 *  默认加到topview上 可设置代理
 */
-(instancetype) initWithFrame:(CGRect)frame dataSource:(id<LZPopViewDataSoure>)dataSource  delegate:(id<LZPopViewDelegate>)delegate backGroundColor:(UIColor*)color;
/**
 *  默认加到topview上
 */
-(instancetype) initWithFrame:(CGRect)frame dataSource:(id<LZPopViewDataSoure>)dataSource backGroundColor:(UIColor*)color;
/**
 *  默认加到topview上 块回调
 */
-(instancetype) initWithFrame:(CGRect)frame dataSource:(id<LZPopViewDataSoure>)dataSource backGroundColor:(UIColor*)color clickBackGround:(LZClickBackgroundView) clickBackgroundView;
/**
 *  出现和消失
 */
-(void) showInView:(UIView*)view;
-(void) show;
-(void) dismiss;
@end
