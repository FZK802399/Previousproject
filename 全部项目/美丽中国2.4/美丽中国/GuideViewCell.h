//
//  GuideViewCell.h
//  美丽中国
//
//  Created by 司马帅帅 on 15/7/20.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//
#import <UIKit/UIKit.h>
@class GuideInfo;

@interface GuideViewCell : UICollectionViewCell

//设置内容视图显示内容
- (void)setContentView:(GuideInfo *)guideInfo;


//显示_msProgressView
- (void)showProgressView;
//隐藏_msProgressView
- (void)hideProgressView;
//刷新进度条
- (void)updateProgressWithValue:(CGFloat)progressValue;

@end
