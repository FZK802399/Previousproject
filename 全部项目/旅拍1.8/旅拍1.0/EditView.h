//
//  EditView.h
//  旅拍1.0
//
//  Created by 司马帅帅 on 15/7/7.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
@class ImageInfo;

@protocol EditViewDelegate <NSObject>

- (void)editViewBackButtonPressed;

- (void)editViewUploadButtonPressed;

- (void)editViewCameraButtonPressed;

- (void)editViewLibraryButtonPressed;

- (void)editViewActionSheetCameraButtonPressed:(int)index;

- (void)editViewActionSheetLibraryButtonPressed:(int)index;

//删除一个ImageInfo对象
- (void)editViewDeleteImageInfoAtIndex:(int)index;

- (void)editViewInputTextViewSaveButtonPressedWithImageInfo:(ImageInfo *)imageInfo andIndex:(int)index;

@end

@interface EditView : UIView

@property (nonatomic, strong) UITextView *titleView;
@property (nonatomic, assign) id delegate;

//用array刷新EditView显示的内容
- (void)reloadEditViewWithArray:(NSArray *)array andUpdateType:(UpdateType)updateType;
//点击_titleView
- (void)tapTitleView;

@end




