//
//  EditViewCell.m
//  旅拍1.0
//
//  Created by 司马帅帅 on 15/7/9.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import "EditViewCell.h"
#import "ImageInfo.h"
#import "UIUtils.h"
#import "Header.h"

#define MARGIN_WIDTH 20

@interface EditViewCell ()
{
    UIImageView *_imageView;//图片视图
    UIImageView *_imageViewOpaqueView;//图片视图的遮盖视图
    UITextView *_textView;//文字视图
    UILabel *_textViewPlaceHolderLabel;//文字视图的占位标签
}
@end

@implementation EditViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //添加内容视图
        [self addContentView];
    }
    return self;
}

//添加内容视图
- (void)addContentView
{
    [self setBackgroundColor:LIGHT_WHITE_COLOR];
    _imageView = [[UIImageView alloc] init];
    _imageView.userInteractionEnabled = YES;
    //给图片添加点击手势
    UITapGestureRecognizer *imageViewTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTap)];
    [_imageView addGestureRecognizer:imageViewTapGesture];
    [self addSubview:_imageView];
    
    //添加imageView的遮盖视图imageViewOpaqueView
    UIImage *opaqueImage = [UIImage imageNamed:@"lp_imageopaque.png"];
    UIImage *stretchImage = [opaqueImage stretchableImageWithLeftCapWidth:60 topCapHeight:0];
    _imageViewOpaqueView = [[UIImageView alloc] initWithImage:stretchImage];
    [_imageView addSubview:_imageViewOpaqueView];
    
    //添加文字视图
    _textView = [[UITextView alloc] init];
    [_textView setBackgroundColor:[UIColor whiteColor]];
    [_textView setFont:[UIFont systemFontOfSize:18]];
    [_textView setScrollEnabled:NO];
    [_textView setEditable:NO];
    [self addSubview:_textView];

    //给文字视图添加点击手势
    UITapGestureRecognizer *textViewTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textViewTap)];
    [_textView addGestureRecognizer:textViewTapGesture];

    //添加文字视图的占位标签
    _textViewPlaceHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 200, 30)];
    [_textViewPlaceHolderLabel setBackgroundColor:[UIColor clearColor]];
    [_textViewPlaceHolderLabel setTextColor:[UIColor lightGrayColor]];
    _textViewPlaceHolderLabel.text = @"点击添加描述...";
    
}

//点击图片
- (void)imageViewTap
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(editViewCellImageViewTapWithIndex:)]) {
        [self.delegate editViewCellImageViewTapWithIndex:(int)self.tag];
    }
}

//点击文字
- (void)textViewTap
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(editViewCellTextViewTapWithIndex:)]) {
        [self.delegate editViewCellTextViewTapWithIndex:(int)self.tag];
    }
}

//设置内容视图中显示的内容
- (void)setContentView:(ImageInfo *)imageInfo
{
    [_imageView setImage:imageInfo.image];
    [_imageView setFrame:CGRectMake(MARGIN_WIDTH, 0, [UIUtils getWindowWidth]-MARGIN_WIDTH*2, imageInfo.imageHeight)];
    
    //设置_imageViewOpaqueView的frame
    [_imageViewOpaqueView setFrame:CGRectMake(0, _imageView.frame.size.height-9, CGRectGetWidth(_imageView.frame), 9)];
    
    //设置_textView的显示内容和frame
    [_textView setText:imageInfo.text];
    [_textView setFrame:CGRectMake(MARGIN_WIDTH, imageInfo.imageHeight, CGRectGetWidth(_imageView.frame), imageInfo.textHeight)];
     
    //根据imageInfo中text内容判断文字视图的占位标签是否显示
    if (imageInfo.text.length == 0) {
        if (!_textViewPlaceHolderLabel.superview) {
            [_textView addSubview:_textViewPlaceHolderLabel];
        }
    } else {
        if (_textViewPlaceHolderLabel.superview) {
            [_textViewPlaceHolderLabel removeFromSuperview];
        }
    }
}

@end


