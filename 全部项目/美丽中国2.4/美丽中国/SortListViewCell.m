//
//  SortListViewCell.m
//  美丽中国
//
//  Created by 司马帅帅 on 15/7/25.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import "SortListViewCell.h"
#import "UIUtils.h"
#import "PanoInfo.h"
#import "UIImageView+WebCache.h"

#define Cell_Height 120

@interface SortListViewCell ()
{
    UIImageView *_panoThumbImageView;
    UIImageView *_nameLabelBackgroundView;
    UILabel *_nameLabel;
    UILabel *_loveCountLabel;
    UIImageView *_loveImageView;
}
@end

@implementation SortListViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //添加内容视图
        [self addContentView];
    }
    return self;
}

//添加内容视图
- (void)addContentView
{
    _panoThumbImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIUtils getWindowWidth], Cell_Height)];
    [_panoThumbImageView setBackgroundColor:[UIColor yellowColor]];
    [self addSubview:_panoThumbImageView];
    
    UIImage *loveImage = [UIImage imageNamed:@"like_small.png"];
    _loveImageView = [[UIImageView alloc] initWithFrame:CGRectMake([UIUtils getWindowWidth]-loveImage.size.width/2-5, 5.0f, loveImage.size.width/2, loveImage.size.height/2)];
    _loveImageView.image = loveImage;
    [self addSubview:_loveImageView];
    
    _loveCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_loveImageView.frame)-52, 2.5, 50, 15)];
    _loveCountLabel.textAlignment = NSTextAlignmentRight;
    _loveCountLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0f];
    _loveCountLabel.textColor = [UIColor whiteColor];
    _loveCountLabel.shadowColor = [UIColor grayColor];
    _loveCountLabel.shadowOffset = CGSizeMake(0.5f, 0.5f);
    _loveCountLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_loveCountLabel];
    
    _nameLabelBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, Cell_Height-25, [UIUtils getWindowWidth], 25)];
    _nameLabelBackgroundView.image = [UIImage imageNamed:@"shadow_background_mask.png"];
    [self addSubview:_nameLabelBackgroundView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIUtils getWindowWidth], 25)];
    _nameLabel.font = [UIFont systemFontOfSize:16.0f];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.backgroundColor = [UIColor clearColor];
    [_nameLabelBackgroundView addSubview:_nameLabel];
}

//设置内容视图显示内容
- (void)setContentView:(PanoInfo *)panoInfo
{
    NSURL *url = [NSURL URLWithString:panoInfo.panoThumbImageUrl];
    UIImage *placeHolderImage = [UIImage imageNamed:@"hotlist_holdimage.png"];
    [_panoThumbImageView sd_setImageWithURL:url placeholderImage:placeHolderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        _panoThumbImageView.alpha = 0.5f;
        [UIView animateWithDuration:0.3
                         animations:^{
                             _panoThumbImageView.alpha = 1.0f;
                         }
                         completion:nil];
    }];
    
    [_nameLabel setText:[NSString stringWithFormat:@"%@ %@",panoInfo.province,panoInfo.name]];
    
    [_loveCountLabel setText:panoInfo.loveCount];
}

//获取cell的高度
+(CGFloat)getCellHeight
{
    return Cell_Height;
}

@end
