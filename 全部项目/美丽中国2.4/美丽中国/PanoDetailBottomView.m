//
//  PanoDetailBottomView.m
//  美丽中国
//
//  Created by 司马帅帅 on 15/7/23.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import "PanoDetailBottomView.h"
#import "UIUtils.h"

@interface PanoDetailBottomView ()
{
    UIButton *_recordButton;//录音按钮
    UIButton *_playAudioButton;//语音播放按钮
    NSMutableArray *_playAudioAnimationArray;//动画视图里的图片数组
    UIButton *_descriptionButton;//简介按钮
    UIButton *_commentListButton;//评论列表按钮
    UIButton *_shareButton;//分享按钮
}
@end

@implementation PanoDetailBottomView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //设置背景颜色
        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"tabBarBackground.png"]]];
        
        //添加内容视图
        [self addContentView];
    }
    return self;
}

//添加内容视图
- (void)addContentView
{
    //录音按钮
    UIImage *recordImageNormal = [UIImage imageNamed:@"pano_detail_record_button_n.png"];
    UIImage *recordImageHighlight = [UIImage imageNamed:@"pano_detail_record_button_h.png"];
    _recordButton = [[UIButton alloc] initWithFrame:CGRectMake(([UIUtils getWindowWidth]-recordImageNormal.size.width/2)/2, 44-recordImageNormal.size.height/2, recordImageNormal.size.width/2,recordImageNormal.size.height/2)];
    [_recordButton setBackgroundImage:recordImageNormal forState:UIControlStateNormal];
    [_recordButton setBackgroundImage:recordImageHighlight forState:UIControlStateHighlighted];
    [self addSubview:_recordButton];
    
    //语音播放按钮
    UIImage *playAudioImageNormal = [UIImage imageNamed:@"pano_detail_audio_button_n.png"];
    _playAudioButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _playAudioButton.frame = CGRectMake((([UIUtils getWindowWidth]-_recordButton.frame.size.width)/2-playAudioImageNormal.size.width/2*2)/3, (44-playAudioImageNormal.size.height/2)/2, playAudioImageNormal.size.width/2, playAudioImageNormal.size.height/2);
    [_playAudioButton addTarget:self action:@selector(playAudioButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_playAudioButton];
    
    //初始化语音播放的基本视图
    _playAudioBaseView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, playAudioImageNormal.size.width/2, playAudioImageNormal.size.height/2)];
    _playAudioBaseView.image = playAudioImageNormal;
    [_playAudioButton addSubview:_playAudioBaseView];
    
    //初始化动画图片数组
    _playAudioAnimationArray = [[NSMutableArray alloc] initWithCapacity:4];
    for (int i=1; i<5; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"pano_detail_audio_button_%d.png", i]];
        [_playAudioAnimationArray addObject:image];
    }
    
    //初始化语音播放的动画视图
    _playAudioAnimationView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, playAudioImageNormal.size.width/2, playAudioImageNormal.size.height/2)];
    _playAudioAnimationView.animationImages = _playAudioAnimationArray;
    _playAudioAnimationView.animationDuration = 1.5;
    _playAudioAnimationView.animationRepeatCount = 0;
    [_playAudioButton addSubview:_playAudioAnimationView];
    
    //初始化语音播放风火轮视图
    _playAudioIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(-8, -8, playAudioImageNormal.size.width/1.5, playAudioImageNormal.size.height/1.5)];
    _playAudioIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    [_playAudioButton addSubview:_playAudioIndicatorView];
    
    //简介按钮
    UIImage *descriptionImageNormal = [UIImage imageNamed:@"pano_detail_description_button_n.png"];
    UIImage *descriptionImageHighlight = [UIImage imageNamed:@"pano_detail_description_button_h.png"];
    _descriptionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _descriptionButton.frame = CGRectMake(CGRectGetMaxX(_playAudioButton.frame)+CGRectGetMinX(_playAudioButton.frame), (44-descriptionImageNormal.size.height/2)/2, descriptionImageNormal.size.width/2, descriptionImageNormal.size.height/2);
    [_descriptionButton setBackgroundImage:descriptionImageNormal forState:UIControlStateNormal];
    [_descriptionButton setBackgroundImage:descriptionImageHighlight forState:UIControlStateHighlighted];
    [_descriptionButton setBackgroundImage:descriptionImageHighlight forState:UIControlStateSelected];
    [_descriptionButton addTarget:self action:@selector(descriptionButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_descriptionButton];
    
    //评论列表按钮
    UIImage *commentImageNormal = [UIImage imageNamed:@"pano_detail_comment_button_n.png"];
    UIImage *commentImageHighlight = [UIImage imageNamed:@"pano_detail_comment_button_h.png"];
    _commentListButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_commentListButton setFrame:CGRectMake(CGRectGetMaxX(_recordButton.frame)+CGRectGetMinX(_playAudioButton.frame), (44-commentImageNormal.size.height/2)/2, commentImageNormal.size.width/2, commentImageNormal.size.height/2)];
    [_commentListButton setBackgroundImage:commentImageNormal forState:UIControlStateNormal];
    [_commentListButton setBackgroundImage:commentImageHighlight forState:UIControlStateHighlighted];
    [_commentListButton setBackgroundImage:commentImageHighlight forState:UIControlStateSelected];
    [_commentListButton addTarget:self action:@selector(commentListButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_commentListButton];
    
    //喜欢列表按钮
    UIImage *shareImageNormal = [UIImage imageNamed:@"pano_detail_share_button_n.png"];
    UIImage *shareImageHighlight = [UIImage imageNamed:@"pano_detail_share_button_h.png"];
    _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shareButton setFrame:CGRectMake(CGRectGetMaxX(_commentListButton.frame)+CGRectGetMinX(_playAudioButton.frame), (44-shareImageNormal.size.height/2)/2+1, shareImageNormal.size.width/2, shareImageNormal.size.height/2)];
    [_shareButton setBackgroundImage:shareImageNormal forState:UIControlStateNormal];
    [_shareButton setBackgroundImage:shareImageHighlight forState:UIControlStateHighlighted];
    [_shareButton setBackgroundImage:shareImageHighlight forState:UIControlStateSelected];
    [_shareButton addTarget:self action:@selector(shareButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_shareButton];

}

//解说播放按钮_playAudioButton被点击
- (void)playAudioButtonPressed
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pdbvPlayAudioButtonPressed)]) {
        [self.delegate pdbvPlayAudioButtonPressed];
    }
}

//简介按钮_descriptionButton被点击
- (void)descriptionButtonPressed
{
    //_descriptionButton设为选中状态
    if (!_descriptionButton.isSelected) {
        [_descriptionButton setSelected:YES];
    } else {
        [_descriptionButton setSelected:NO];
    }
    //_commentListButton设为未选中种状态
    if (_commentListButton.isSelected) {
        [_commentListButton setSelected:NO];
    }
    //_shareButton设为未选中种状态
    if (_shareButton.isSelected) {
        [_shareButton setSelected:NO];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(pdbvDescriptionButtonPressed)]) {
        [self.delegate pdbvDescriptionButtonPressed];
    }
}

//评论列表按钮_commentListButton被点击
- (void)commentListButtonPressed
{
    //_descriptionButton设为未选中状态
    if (_descriptionButton.isSelected) {
        [_descriptionButton setSelected:NO];
    }
    //_commentListButton设为选中种状态
    if (!_commentListButton.isSelected) {
        [_commentListButton setSelected:YES];
    } else {
        [_commentListButton setSelected:NO];
    }
    //_shareButton设为未选中种状态
    if (_shareButton.isSelected) {
        [_shareButton setSelected:NO];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(pdbvCommentListButtonPressed)]) {
        [self.delegate pdbvCommentListButtonPressed];
    }
}

//分享按钮_shareButton被点击
- (void)shareButtonPressed
{
    //_descriptionButton设为未选中状态
    if (_descriptionButton.isSelected) {
        [_descriptionButton setSelected:NO];
    }
    //_commentListButton设为未选中种状态
    if (_commentListButton.isSelected) {
        [_commentListButton setSelected:NO];
    }
    //_shareButton设为选中种状态
    if (!_shareButton.isSelected) {
        [_shareButton setSelected:YES];
    } else {
        [_shareButton setSelected:NO];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(pdbvShareButtonPressed)]) {
        [self.delegate pdbvShareButtonPressed];
    }
}

//重置按钮被选中状态
- (void)resetSelectedButton
{
    [_descriptionButton setSelected:NO];
    [_commentListButton setSelected:NO];
    [_shareButton setSelected:NO];
}

@end
