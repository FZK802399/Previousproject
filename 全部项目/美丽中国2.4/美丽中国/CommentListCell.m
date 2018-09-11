//
//  CommentListCell.m
//  美丽中国
//
//  Created by 司马帅帅 on 15/7/24.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import "CommentListCell.h"
#import "UIUtils.h"
#import "CommentInfo.h"
#import "CommentUserInfo.h"
#import "UIImageView+WebCache.h"

#define CommentCellHeight 50.0

@interface CommentListCell ()
{
    UIImageView *_headerImageView;//头像视图
    UILabel *_nameLabel;//名字标签
    UILabel *_secondLabel;//秒数标签
    UIImageView *_clockImageView;//时钟视图
    UILabel *_timeLabel;//时间标签
    NSMutableArray *_audioAnimationImageArray;//动画图片数组
}
@end

@implementation CommentListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //添加内容视图
        [self addContentView];
    }
    return self;
}

//添加内容视图
- (void)addContentView
{
    //初始化头像视图
    _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f, (CommentCellHeight-35)/2, 35, 35)];
    [self addSubview:_headerImageView];
    
    //初始化姓名标签
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 100, CommentCellHeight)];
    _nameLabel.font = [UIFont systemFontOfSize:14.0f];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.numberOfLines = 1;
    [self addSubview:_nameLabel];
    
    //初始化播放语音按钮
    UIImage *audioButtonImage = [UIImage imageNamed:@"play_button_large.png"];
    _audioButton = [[UIButton alloc] initWithFrame:CGRectMake(130.0f, (CommentCellHeight-audioButtonImage.size.height/2)/2, audioButtonImage.size.width/2, audioButtonImage.size.height/2)];
    [_audioButton addTarget:self action:@selector(audioButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_audioButton setBackgroundImage:audioButtonImage forState:UIControlStateNormal];
    [_audioButton setBackgroundImage:audioButtonImage forState:UIControlStateHighlighted];
    [_audioButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_audioButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    _audioButton.titleLabel.font = [UIFont boldSystemFontOfSize:11.0f];
    [_audioButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:_audioButton];
    
    //初始化语音长度标签
    _secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, _audioButton.bounds.size.height, _audioButton.bounds.size.height)];
    [_secondLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [_secondLabel setBackgroundColor:[UIColor clearColor]];
    [_audioButton addSubview:_secondLabel];
    
    //初始化播放语音按钮上的基础视图
    _audioButtonBaseView = [[UIImageView alloc] initWithFrame:CGRectMake(56, 18, 29/2, 27/2)];
    _audioButtonBaseView.image = [UIImage imageNamed:@"recorder_icon4.png"];
    [_audioButton addSubview:_audioButtonBaseView];
    
    //初始化动画图片数组
    if (!_audioAnimationImageArray) {
        _audioAnimationImageArray = [[NSMutableArray alloc] init];
        for (int i=1; i<5; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"recorder_icon%d.png", i]];
            [_audioAnimationImageArray addObject:image];
        }
    }
    
    //初始化语音播放的动画视图
    _audioButtonAnimationView = [[UIImageView alloc] initWithFrame:CGRectMake(56, 18, 29/2, 27/2)];
    _audioButtonAnimationView.animationImages = _audioAnimationImageArray;
    _audioButtonAnimationView.animationDuration = 1.5;
    _audioButtonAnimationView.animationRepeatCount = 0;
    [_audioButton addSubview:_audioButtonAnimationView];
    
    //初始化语音播放的风火轮
    _audioButtonIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(58, 21, 29/3, 27/3)];
    _audioButtonIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [_audioButton addSubview:_audioButtonIndicatorView];
    
    //初始化时间标签
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIUtils getWindowWidth]-70, 35, 70, 10)];
    [_timeLabel setTextAlignment:NSTextAlignmentCenter];
    [_timeLabel setTextColor:[UIColor darkGrayColor]];
    [_timeLabel setFont:[UIFont systemFontOfSize:11.0f]];
    [self addSubview:_timeLabel];
    
    //初始化钟表图标
    UIImage *clockImage = [UIImage imageNamed:@"clock_image_normal.png"];
    _clockImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_timeLabel.frame)-clockImage.size.width/2-4, 35, clockImage.size.width/2, clockImage.size.height/2)];
    _clockImageView.image = clockImage;
    [self addSubview:_clockImageView];
}

//设置内容视图中的显示内容
- (void)setContentView:(CommentInfo *)commentInfo
{
    //设置_headerImageView显示的内容
    NSURL *headerImageUrl = [NSURL URLWithString:commentInfo.commentUserInfo.userThumbImage];
    UIImage *placeholderImage = [UIImage imageNamed:@"user_headerImage_default.png"];
    [_headerImageView sd_setImageWithURL:headerImageUrl
                        placeholderImage:placeholderImage
                               completed:nil];
    
    //设置_nameLabel显示的内容
    if ([UIUtils isBlankString:commentInfo.commentUserInfo.userName]) {
        [_nameLabel setText:@"游客:"];
    } else {
        [_nameLabel setText:[NSString stringWithFormat:@"%@:",commentInfo.commentUserInfo.userName]];
    }
    //获取_nameLabel.text的size
    CGSize textSize = [UIUtils getTextSize:_nameLabel.text withFont:_nameLabel.font];
    //设置_nameLabel的frame
    CGRect nameLabelFrame = _nameLabel.frame;
    if (textSize.width>([UIUtils getWindowWidth]-CGRectGetMinX(_nameLabel.frame)-_timeLabel.frame.size.width-_audioButton.frame.size.width)+10) {
        nameLabelFrame.size.width = ([UIUtils getWindowWidth]-CGRectGetMinX(_nameLabel.frame)-_timeLabel.frame.size.width-_audioButton.frame.size.width)+10;
    } else {
        nameLabelFrame.size.width = textSize.width;
    }
    [_nameLabel setFrame:nameLabelFrame];
    
    //设置_audioButton的frame
    CGRect audioButtonFrame = _audioButton.frame;
    audioButtonFrame.origin.x = CGRectGetMaxX(_nameLabel.frame)-10;
    [_audioButton setFrame:audioButtonFrame];
    
    //设置_secondLabel中显示的内容
    [_secondLabel setText:[NSString stringWithFormat:@"%@“",commentInfo.audioLength]];
    
    //设置_timeLabel显示的内容
    [_timeLabel setText:commentInfo.commentTime];
}

//获取cell的高度
+ (CGFloat)getCellHeight
{
    return CommentCellHeight;
}

//语音播放按钮被点击
- (void)audioButtonPressed:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(commentListCellAudioButtonPressed:)]) {
        [self.delegate commentListCellAudioButtonPressed:button.tag];
    }
}

@end
