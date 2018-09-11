//
//  CityListCell.m
//  美丽中国
//
//  Created by 司马帅帅 on 15/7/21.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import "CityListCell.h"
#import "UIUtils.h"
#import "PanoInfo.h" 
#import "UIImageView+WebCache.h"

//全景缩略图的frame
#define PANO_THUMB_IMAGE_FRAME CGRectMake(0.0f, 0.0f, 360.0f, 90.0f)
//文字颜色
#define TEXT_COLOR [UIColor colorWithPatternImage:[UIImage imageNamed:@"dot.png"]]


@interface CityListCell ()
{
    UIImageView *_panoThumbView;//全景缩略图视图
    UIScrollView *_scrollView;//滚动视图
    UILabel *_titleLabel;
    UILabel *_playCountLabel;
    UILabel *_commentCountLabel;
    UILabel *_loveCountLabel;
    UIImageView *_maskImageView;//黑色遮盖视图
    UILabel *_rankLabel;//排名label
}
@end

@implementation CityListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //设置背景颜色
        [self.contentView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundImage.png"]]];
        
        //添加内容视图
        [self addContentView];
    }
    return self;
}

//添加内容视图
- (void)addContentView
{
    //添加_scrollView
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(60.0f, 25.0f, [UIUtils getWindowWidth]-60-20, 90.0f)];
    _scrollView.contentSize = PANO_THUMB_IMAGE_FRAME.size;
    [_scrollView setBackgroundColor:[UIColor yellowColor]];
    _scrollView.userInteractionEnabled = NO;
    [self addSubview:_scrollView];
    
    //添加placeHolder视图
    UIImageView *placeHolderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame))];
    [placeHolderImageView setImage:[UIImage imageNamed:@"hotlist_holdimage.png"]];
    [_scrollView addSubview:placeHolderImageView];
    
    //添加_panoThumbView
    _panoThumbView = [[UIImageView alloc] initWithFrame:PANO_THUMB_IMAGE_FRAME];
    [_panoThumbView setBackgroundColor:[UIColor clearColor]];
    _panoThumbView.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_panoThumbView];
    
    //添加遮盖视图_maskImageView
    _maskImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"snapshot_mask_image.png"]];
    _maskImageView.frame = CGRectMake(55.0f, 20.0f, [UIUtils getWindowWidth]-55, _maskImageView.image.size.height/2);
    [self addSubview:_maskImageView];
    
    //添加_titleLabel
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(53.0f, 5.0f, [UIUtils getWindowWidth], 18.0f)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont systemFontOfSize:13.0f];
    _titleLabel.textColor = TEXT_COLOR;
    [self addSubview:_titleLabel];

    //添加橘黄色竖线
    UIImage *centerImage = [UIImage imageNamed:@"timeline_center.png"];
    UIImageView *centerImageView = [[UIImageView alloc] initWithImage:centerImage];
    [centerImageView setFrame:CGRectMake(46.5f, 0.0f, centerImage.size.width/2, 125.0f)];
    [self addSubview:centerImageView];
    
    //添加竖线上的圆点
    UIImage *dotImage = [UIImage imageNamed:@"timeline_dot.png"];
    UIImageView *dotImageView = [[UIImageView alloc] initWithImage:dotImage];
    [dotImageView setFrame:CGRectMake(0.0f, 0.0f, dotImage.size.width/2, dotImage.size.height/2)];
    dotImageView.center = CGPointMake(47.5f, 62.5f);
    [self addSubview:dotImageView];
}

//设置内容视图里显示的内容
- (void)setContentView:(PanoInfo *)panoInfo
{
    //设置缩略图显示
    NSURL *url = [NSURL URLWithString:panoInfo.panoThumbImageUrl];
    [_panoThumbView sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        _panoThumbView.alpha = 0.5f;
        [UIView animateWithDuration:0.3
                         animations:^{
                             _panoThumbView.alpha = 1.0f;
                         }
                         completion:nil];
    }];
    
    
    NSString *titleString = [NSString stringWithFormat:@"%@%@",panoInfo.province,panoInfo.name];
    [_titleLabel setText:titleString];
}

+ (CGFloat)getHeight
{
    return 125.0f;
}

@end
