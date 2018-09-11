//
//  PanoDetailBottomView.h
//  美丽中国
//
//  Created by 司马帅帅 on 15/7/23.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PDBVDelegate <NSObject>

//解说播放按钮_playAudioButton被点击
- (void)pdbvPlayAudioButtonPressed;

//简介按钮_descriptionButton被点击
- (void)pdbvDescriptionButtonPressed;

//评论列表按钮_commentListButton被点击
- (void)pdbvCommentListButtonPressed;

//分享按钮_shareButton被点击
- (void)pdbvShareButtonPressed;

@end

@interface PanoDetailBottomView : UIView

@property (nonatomic, assign) id delegate;
@property (nonatomic, strong) UIImageView *playAudioBaseView;//语音播放的基本视图
@property (nonatomic, strong) UIImageView *playAudioAnimationView;//语音播放的动画视图
@property (nonatomic, strong) UIActivityIndicatorView *playAudioIndicatorView;//语音播放风火轮视图（语音不存在 需要下载 此时的旋转的风火轮视图）


//重置按钮被选中状态
- (void)resetSelectedButton;


@end
