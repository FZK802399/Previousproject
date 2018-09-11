//
//  MainView.m
//  旅拍1.0
//
//  Created by 司马帅帅 on 15/7/7.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import "MainView.h"
#import "UIUtils.h"

@interface MainView ()
{
    UIImageView *_backgroundImageView;//背景视图
    UIButton *_setButton;//设置按钮
    UIButton *_cameraButton;//拍照按钮
    UIButton *_libraryButton;//相册按钮
    UIButton *_myListButton;//我的旅拍按钮
    UIButton *_localDraftButton;//本地草稿按钮
}
@end

@implementation MainView

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
    //添加背景视图
    [self addBackgroundImageView];

    //添加设置按钮
    [self addSetButton];

    //添加拍照和相册按钮
    [self addCameraAndLibraryButton];

    //添加我的旅拍和本地草稿按钮
    [self addMyListAndLocalDraftButton];
}

#pragma mark 添加UI视图
//添加背景视图
- (void)addBackgroundImageView
{
    //添加背景视图
    _backgroundImageView = [[UIImageView alloc] initWithFrame:self.frame];
    _backgroundImageView.userInteractionEnabled = YES;
    [_backgroundImageView setImage:[UIImage imageNamed:@"lp_main_background.png"]];
    [self addSubview:_backgroundImageView];
    
    //添加icon视图
    UIImage *iconImage = [UIImage imageNamed:@"lp_main_icon.png"];
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(([UIUtils getWindowWidth]-iconImage.size.width)/2, 60, iconImage.size.width, iconImage.size.height)];
    [iconImageView setImage:iconImage];
    [_backgroundImageView addSubview:iconImageView];
}

//添加设置按钮
- (void)addSetButton
{
    UIImage *setButtonImage = [UIImage imageNamed:@"lp_set_button.png"];
    _setButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_setButton addTarget:self action:@selector(setButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_setButton setFrame:CGRectMake([UIUtils getWindowWidth]-setButtonImage.size.width-10, 30, setButtonImage.size.width, setButtonImage.size.height)];
    [_setButton setBackgroundImage:setButtonImage forState:UIControlStateNormal];
    [_backgroundImageView addSubview:_setButton];
}

//添加拍照和相册按钮
- (void)addCameraAndLibraryButton
{
    //添加拍照按钮
    UIImage *cameraButtonImage = [UIImage imageNamed:@"lp_bigCameraButtonImage_normal.png"];
    _cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cameraButton addTarget:self action:@selector(cameraButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_cameraButton setFrame:CGRectMake(([UIUtils getWindowWidth]-cameraButtonImage.size.width*2)/3, ([UIUtils getWindowHeight]-cameraButtonImage.size.height)/2, cameraButtonImage.size.width, cameraButtonImage.size.height)];
    [_cameraButton setBackgroundImage:cameraButtonImage forState:UIControlStateNormal];
    [_backgroundImageView addSubview:_cameraButton];
    
    //添加相册按钮
    UIImage *libraryButtonImage = [UIImage imageNamed:@"lp_bigLibraryButtonImage_normal.png"];
    _libraryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_libraryButton addTarget:self action:@selector(libraryButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_libraryButton setFrame:CGRectMake(CGRectGetMaxX(_cameraButton.frame)+([UIUtils getWindowWidth]-cameraButtonImage.size.width*2)/3, ([UIUtils getWindowHeight]-libraryButtonImage.size.height)/2, libraryButtonImage.size.width, libraryButtonImage.size.height)];
    [_libraryButton setBackgroundImage:libraryButtonImage forState:UIControlStateNormal];
    [_backgroundImageView addSubview:_libraryButton];
}

//添加我的旅拍和本地草稿按钮
- (void)addMyListAndLocalDraftButton
{
    //添加我的旅拍按钮
    UIImage *myListButtonImageNormal = [UIImage imageNamed:@"lp_mylist_button_normal.png"];
    UIImage *myListButtonImageHighlight = [UIImage imageNamed:@"lp_mylist_button_highlight.png"];
    _myListButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_myListButton addTarget:self action:@selector(myListButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_myListButton setFrame:CGRectMake(0, [UIUtils getWindowHeight]-myListButtonImageNormal.size.height/myListButtonImageNormal.size.width*[UIUtils getWindowWidth]/2, [UIUtils getWindowWidth]/2, myListButtonImageNormal.size.height/myListButtonImageNormal.size.width*[UIUtils getWindowWidth]/2)];
    [_myListButton setBackgroundImage:myListButtonImageNormal forState:UIControlStateNormal];
    [_myListButton setBackgroundImage:myListButtonImageHighlight forState:UIControlStateHighlighted];
    [_backgroundImageView addSubview:_myListButton];
    
    //添加本地草稿按钮
    UIImage *localDraftButtonImageNormal = [UIImage imageNamed:@"lp_draft_button_normal.png"];
    UIImage *localDraftButtonImageHighlight = [UIImage imageNamed:@"lp_draft_button_highlight.png"];
    _localDraftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_localDraftButton addTarget:self action:@selector(localDraftButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_localDraftButton setFrame:CGRectMake(CGRectGetMaxX(_myListButton.frame), CGRectGetMinY(_myListButton.frame), CGRectGetWidth(_myListButton.frame), CGRectGetHeight(_myListButton.frame))];
    [_localDraftButton setBackgroundImage:localDraftButtonImageNormal forState:UIControlStateNormal];
    [_localDraftButton setBackgroundImage:localDraftButtonImageHighlight forState:UIControlStateHighlighted];
    [_backgroundImageView addSubview:_localDraftButton];
}

#pragma mark 按钮的点击方法
//设置按钮被点击
- (void)setButtonPressed
{
    NSLog(@"setButtonPressed");
    if (self.delegate && [self.delegate respondsToSelector:@selector(mainViewSetButtonPressed)]) {
        [self.delegate mainViewSetButtonPressed];
    }
}

//拍照按钮被点击
- (void)cameraButtonPressed
{
    NSLog(@"cameraButtonPressed");
    if (self.delegate && [self.delegate respondsToSelector:@selector(mainViewCameraButtonPressed)]) {
        [self.delegate mainViewCameraButtonPressed];
    }
}

//相册按钮被点击
- (void)libraryButtonPressed
{
    NSLog(@"libraryButtonPressed");
    if (self.delegate && [self.delegate respondsToSelector:@selector(mainViewLibraryButtonPressed)]) {
        [self.delegate mainViewLibraryButtonPressed];
    }
}

//我的旅拍按钮被点击
- (void)myListButtonPressed
{
    NSLog(@"myListButtonPressed");
    if (self.delegate && [self.delegate respondsToSelector:@selector(mainViewMyListButtonPressed)]) {
        [self.delegate mainViewMyListButtonPressed];
    }
}

//本地草稿按钮被点击
- (void)localDraftButtonPressed
{
    NSLog(@"localDraftButtonPressed");
    if (self.delegate && [self.delegate respondsToSelector:@selector(mainViewLocalDraftButtonPressed)]) {
        [self.delegate mainViewLocalDraftButtonPressed];
    }
}

@end









