//
//  DzyPopView.m
//  Shop
//
//  Created by yons on 15/11/3.
//  Copyright (c) 2015年 ocean. All rights reserved.
//

#import "DzyPopView.h"
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
@interface DzyPopView ()
@property (nonatomic,assign)CGRect sourceFrame;
@property (nonatomic,strong)UITextField * passWord;
@end

@implementation DzyPopView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self dataSource];
    }
    return self;
}

-(void)show
{
    [[[[UIApplication sharedApplication].keyWindow subviews] firstObject] addSubview:self];
}

-(void)dismiss
{
    [self endEditing:YES];
    [self removeFromSuperview];
}

-(void)dataSource
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(30, ScreenHeight/4, ScreenWidth-60, 100)];
    view.backgroundColor = BACKGROUND_GRAY;
    self.sourceFrame = view.frame;
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, ScreenWidth-60, 30)];
    label.text = @"请输入支付密码";
    label.textColor = FONT_BLACK;
    [view addSubview:label];
    
    UITextField * password = [[UITextField alloc]initWithFrame:CGRectMake(10, 45, ScreenWidth-60-70/*按钮50空位20*/, 40)];
    password.borderStyle = UITextBorderStyleNone;
    password.backgroundColor = [UIColor whiteColor];
    password.secureTextEntry = YES;
    [view addSubview:password];
    self.passWord = password;
    
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(password.frame)+5, 45, 50, 40)];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:MYRED];
    [view addSubview:btn];
    [btn addTarget:self action:@selector(payNow) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:view];
}

-(void)payNow
{
//    [self.passWord resignFirstResponder];
    if ([self.delegate respondsToSelector:@selector(payMoneyWithView:str:section:)]) {
        [self.delegate payMoneyWithView:self str:self.passWord.text section:_section];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point=[[touches anyObject] locationInView:self.superview];
    ///判断是否包含
    if(CGRectContainsPoint(self.sourceFrame,point))
    {
        return;
    }
    else
    {
        [self dismiss];
    }
}
@end
