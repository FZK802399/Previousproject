//
//  InputTextView.h
//  旅拍1.0
//
//  Created by 司马帅帅 on 15/7/14.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ImageInfo;

@protocol InputTextViewDelegate <NSObject>

- (void)inputTextViewSaveImageInfo:(ImageInfo *)imageInfo;

@end

@interface InputTextView : UIView

@property (nonatomic, assign) id delegate;

//显示InputTextView
- (void)showInView:(UIView *)view withImageInfo:(ImageInfo *)imageInfo;

@end
