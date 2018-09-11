//
//  MainView.h
//  旅拍1.0
//
//  Created by 司马帅帅 on 15/7/7.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MainViewDelegate <NSObject>

//设置按钮被点击
- (void)mainViewSetButtonPressed;

//拍照按钮被点击
- (void)mainViewCameraButtonPressed;

//相册按钮被点击
- (void)mainViewLibraryButtonPressed;

//我的旅拍按钮被点击
- (void)mainViewMyListButtonPressed;

//本地草稿按钮被点击
- (void)mainViewLocalDraftButtonPressed;

@end

@interface MainView : UIView

@property (nonatomic, assign) id delegate;

@end





