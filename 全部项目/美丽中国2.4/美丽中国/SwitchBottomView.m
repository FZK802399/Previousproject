//
//  SwitchBottomView.m
//  美丽中国
//
//  Created by 司马帅帅 on 15/7/19.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import "SwitchBottomView.h"
#import "UIUtils.h"

@interface SwitchBottomView ()
{
    UIButton *_waterFlowButton;
    UIButton *_guideButton;
    UIButton *_categoryButton;
}
@end

@implementation SwitchBottomView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabBarBackground.png"]];
        
        //添加内容视图
        [self addContentView];
    }
    return self;
}

//添加内容视图
- (void)addContentView
{
    //按钮的图片
    UIImage *guideButtonImageNormal = [UIImage imageNamed:@"guide_button_normal.png"];
    UIImage *guideButtonImageSelected = [UIImage imageNamed:@"guide_button_selected.png"];
    UIImage *cityButtonImageNormal = [UIImage imageNamed:@"city_button_normal.png"];
    UIImage *cityButtonImageSelected = [UIImage imageNamed:@"city_button_selected.png"];
    UIImage *categoryButtonImageNormal = [UIImage imageNamed:@"category_button_normal.png"];
    UIImage *categoryButtonImageSelected = [UIImage imageNamed:@"category_button_selected.png"];
    
    //按钮调用的方法
    SEL guideActions = @selector(guideButtonPress);
    SEL categoryActions = @selector(categoryButtonPress);
    SEL waterFlowActions = @selector(waterFlowButtonPress);
    
    //按钮的frame
    CGRect guideButtonRect=CGRectMake(([UIUtils getWindowWidth]-guideButtonImageNormal.size.width/2)/2, 44-guideButtonImageNormal.size.height/2, guideButtonImageNormal.size.width/2, guideButtonImageNormal.size.height/2);
    CGRect waterFlowButtonRect=CGRectMake((CGRectGetMinX(guideButtonRect)-cityButtonImageNormal.size.width/2)/2, (44-cityButtonImageNormal.size.height/2)/2, cityButtonImageNormal.size.width/2, cityButtonImageNormal.size.height/2);
    CGRect categoryButtonRect=CGRectMake(CGRectGetMaxX(guideButtonRect)+(CGRectGetMinX(guideButtonRect)-cityButtonImageNormal.size.width/2)/2, (44-categoryButtonImageNormal.size.height/2)/2, categoryButtonImageNormal.size.width/2, categoryButtonImageNormal.size.height/2);
    
    _waterFlowButton = [self buttonInitWithFrame:waterFlowButtonRect imageNormal:cityButtonImageNormal imageSelected:cityButtonImageSelected isSelected:YES callBackActions:waterFlowActions];
    [self addSubview:_waterFlowButton];
    
    _guideButton = [self buttonInitWithFrame:guideButtonRect imageNormal:guideButtonImageNormal imageSelected:guideButtonImageSelected isSelected:NO callBackActions:guideActions];
    [self addSubview:_guideButton];
    
    _categoryButton = [self buttonInitWithFrame:categoryButtonRect imageNormal:categoryButtonImageNormal imageSelected:categoryButtonImageSelected isSelected:NO callBackActions:categoryActions];
    [self addSubview:_categoryButton];
}

//生成按钮的方法
- (UIButton *)buttonInitWithFrame:(CGRect)frame imageNormal:(UIImage *)imageNormal imageSelected:(UIImage *)imageSelected isSelected:(BOOL)isSelected callBackActions:(SEL)actions
{
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setBackgroundImage:imageNormal forState:UIControlStateNormal];
    [button setBackgroundImage:imageSelected forState:UIControlStateSelected];
    [button addTarget:self action:actions forControlEvents:UIControlEventTouchUpInside];
//    button.adjustsImageWhenHighlighted = NO;
    button.selected = isSelected;
    return button;
}

#pragma mark 按钮的点击方法
- (void)guideButtonPress
{
    _guideButton.selected = YES;
    _categoryButton.selected = NO;
    _waterFlowButton.selected = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(sbvGuideButtonPress)]) {
        [self.delegate sbvGuideButtonPress];
    }
}

- (void)categoryButtonPress
{
    _guideButton.selected = NO;
    _categoryButton.selected = YES;
    _waterFlowButton.selected = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(sbvCategoryButtonPress)]) {
        [self.delegate sbvCategoryButtonPress];
    }
}

- (void)waterFlowButtonPress
{
    _guideButton.selected = NO;
    _categoryButton.selected = NO;
    _waterFlowButton.selected = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(sbvWaterFlowButtonPress)]) {
        [self.delegate sbvWaterFlowButtonPress];
    }
}

@end
