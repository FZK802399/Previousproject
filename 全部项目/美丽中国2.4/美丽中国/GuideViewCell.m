//
//  GuideViewCell.m
//  美丽中国
//
//  Created by 司马帅帅 on 15/7/20.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import "GuideViewCell.h"
#import "UIUtils.h"
#import "GuideInfo.h"
#import "MSProgressView.h"

//宏定义导游存储路径
#define GUIDE_PATH [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"GuideData"];

@interface GuideViewCell ()
{
    UIImageView *_imageView;
    UILabel *_label;
    MSProgressView *_msProgressView;
}
@end

@implementation GuideViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        //添加内容视图
        [self addContentView];
    }
    return self;
}

//添加内容视图
- (void)addContentView
{
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ([UIUtils getWindowWidth]-10*5)/4,([UIUtils getWindowWidth]-10*5)/4)];
    [self addSubview:_imageView];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_imageView.frame), _imageView.frame.size.width, 14)];
    [_label setTextColor:[UIColor whiteColor]];
    [_label setFont:[UIFont systemFontOfSize:12]];
    [_label setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:_label];
    
    UIColor *backColor = [UIColor whiteColor];
    UIColor *progressColor = [UIColor colorWithRed:1.0/255.0 green:151.0/255.0 blue:18.0/255.0 alpha:1.0];
//    if (!_msProgressView) {
        CGRect frame = _imageView.frame;
        frame.size.width = frame.size.width-8;
        frame.size.height = frame.size.height-8;
        _msProgressView = [[MSProgressView alloc] initWithFrame:frame backColor:backColor progressColor:progressColor lineWidth:4];
        _msProgressView.center = _imageView.center;
        [_msProgressView setHidden:YES];
//    }

    [self addSubview:_msProgressView];
}

//设置内容视图显示内容
- (void)setContentView:(GuideInfo *)guideInfo
{
    //导游存放路径
    NSString *guidePath = GUIDE_PATH;
    //获取单个导游的存储路径
    NSString *guideDataPath = [guidePath stringByAppendingPathComponent:guideInfo.namePath];
    //解压后全景的首页tour.html的路径(用这个路径可以判断zip包是否下载完成并且解压完成)
    NSString *tourHtmlPath = [guideDataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/view_fullview/mytour/tour.html",guideInfo.namePath]];
    //判断全景首页tour.html是否存在
    if ([[NSFileManager defaultManager] fileExistsAtPath:tourHtmlPath]) {
        //单个导游 图标的存储路径
        NSString *imagePath = [guideDataPath stringByAppendingPathComponent:@"guideIcon.png"];
        NSData *data = [NSData dataWithContentsOfFile:imagePath];
        [_imageView setImage:[UIImage imageWithData:data]];
    } else {
        [_imageView setImage:[UIImage imageNamed:@"freeguidecellbackground.png"]];
    }
    
    [_label setText:guideInfo.guideName];
}

//显示_msProgressView
- (void)showProgressView
{
    [_msProgressView setHidden:NO];
}

//隐藏_msProgressView
- (void)hideProgressView
{
    [_msProgressView setHidden:YES];
}

//刷新_msProgressView进度条
- (void)updateProgressWithValue:(CGFloat)progressValue
{
    [_msProgressView updateProgressCircleWithProgress:progressValue];
}

@end
