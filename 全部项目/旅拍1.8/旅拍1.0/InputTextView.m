//
//  InputTextView.m
//  旅拍1.0
//
//  Created by 司马帅帅 on 15/7/14.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import "InputTextView.h"
#import "Header.h"
#import "UIUtils.h"
#import "ImageInfo.h"

#define KEYBOARD_HEIGHT 216
#define Button_Height 50

@interface InputTextView ()
{
    UIView *_topView;
    UITextView *_textView;
    UIButton *_cancelButton;
    UIButton *_saveButton;
    ImageInfo *_imageInfo;
}
@end

@implementation InputTextView

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
    [self setBackgroundColor:[UIColor clearColor]];
    
    //给自己添加了一个点击手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeInputTextView)];
    [self addGestureRecognizer:tapGesture];
    
    //初始化_topView
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, -([UIUtils getWindowHeight]-KEYBOARD_HEIGHT-60), [UIUtils getWindowWidth], [UIUtils getWindowHeight]-KEYBOARD_HEIGHT-60)];
    [_topView setBackgroundColor:[UIColor whiteColor]];
    //加圆角
    [_topView.layer setCornerRadius:4.0f];
    [_topView.layer setMasksToBounds:YES];
    [self addSubview:_topView];
    
    //初始化_textView
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, [UIUtils getWindowWidth], CGRectGetHeight(_topView.frame)-Button_Height)];
    //加圆角
    [_textView.layer setCornerRadius:4.0f];
    [_textView.layer setMasksToBounds:YES];
    [_textView setFont:[UIFont systemFontOfSize:18]];
    [_textView setBackgroundColor:[UIColor whiteColor]];
    _textView.keyboardAppearance = UIKeyboardAppearanceLight;
    _textView.keyboardType = UIKeyboardTypeNamePhonePad;
    [_topView addSubview:_textView];
    
    //添加取消按钮_cancelButton
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [_cancelButton setFrame:CGRectMake(0, CGRectGetMaxY(_textView.frame), [UIUtils getWindowWidth]/2, Button_Height)];
    [_cancelButton setBackgroundColor:LIGHT_RED_COLOR];
    [_cancelButton.layer setCornerRadius:4.0f];
    [_cancelButton.layer setMasksToBounds:YES];
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    _cancelButton.showsTouchWhenHighlighted = YES;
    [_topView addSubview:_cancelButton];
    
    //添加确定按钮_saveButton
    _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_saveButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [_saveButton setFrame:CGRectMake([UIUtils getWindowWidth]/2, CGRectGetMaxY(_textView.frame), [UIUtils getWindowWidth]/2, Button_Height)];
    [_saveButton setBackgroundColor:LIGHT_GREEN_COLOR];
    [_saveButton.layer setCornerRadius:4.0f];
    [_saveButton.layer setMasksToBounds:YES];
    [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
    _saveButton.showsTouchWhenHighlighted = YES;
    [_topView addSubview:_saveButton];
}

//显示InputTextView
- (void)showInView:(UIView *)view withImageInfo:(ImageInfo *)imageInfo
{
    _imageInfo = imageInfo;
    [_textView setText:imageInfo.text];
    [view addSubview:self];
    [_textView becomeFirstResponder];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         [self setBackgroundColor:LIGHT_BLACK_COLOR];
                         //设置_topView的frame
                         CGRect topViewFrame = _topView.frame;
                         topViewFrame.origin.y = 20;
                         [_topView setFrame:topViewFrame];

                     } completion:nil];
}

//移除InputTextView
- (void)removeInputTextView
{
    [_textView resignFirstResponder];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         [self setBackgroundColor:[UIColor clearColor]];
                         [_topView setFrame:CGRectMake(0, -([UIUtils getWindowHeight]-KEYBOARD_HEIGHT-60), [UIUtils getWindowWidth], [UIUtils getWindowHeight]-KEYBOARD_HEIGHT-60)];
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

//取消按钮被点击
- (void)cancel
{
    //移除InputTextView
    [self removeInputTextView];
}

//保存按钮被点击
- (void)save
{
    //获取新的ImageInfo
    if ([UIUtils isBlankString:_textView.text]) {
        [_textView setText:@""];
    }
    _imageInfo = [[ImageInfo alloc] initWithImage:_imageInfo.image andText:_textView.text];
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputTextViewSaveImageInfo:)]) {
        [self.delegate inputTextViewSaveImageInfo:_imageInfo];
    }
    //移除InputTextView
    [self removeInputTextView];
}

@end







