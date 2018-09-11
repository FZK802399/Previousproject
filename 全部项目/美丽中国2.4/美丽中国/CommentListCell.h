//
//  CommentListCell.h
//  美丽中国
//
//  Created by 司马帅帅 on 15/7/24.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommentInfo;

@protocol CommentListCellDelegate <NSObject>

//评论列表里的语音按钮被点击
- (void)commentListCellAudioButtonPressed:(int)index;

@end

@interface CommentListCell : UITableViewCell

@property (nonatomic, strong) UIButton *audioButton;//语音播放按钮
@property (nonatomic, strong) UIImageView *audioButtonBaseView;//语音播放的基本视图
@property (nonatomic, strong) UIImageView *audioButtonAnimationView;//语音播放的动画视图
@property (nonatomic, strong) UIActivityIndicatorView *audioButtonIndicatorView;//语音播放风火轮视图（语音不存在 需要下载 此时的旋转的风火轮视图）

@property (nonatomic,assign) id delegate;

//设置内容视图中的显示内容
- (void)setContentView:(CommentInfo *)commentInfo;

//获取cell的高度
+ (CGFloat)getCellHeight;

@end
