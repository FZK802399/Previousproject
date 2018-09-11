//
//  WaterFlowViewCell.m
//  美丽中国
//
//  Created by 司马帅帅 on 15/7/20.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import "WaterFlowViewCell.h"
#import "CityInfo.h"
#import "UIUtils.h"

@interface WaterFlowViewCell ()
{
    UIImageView *_imageView;
    UIImageView *_backImageView;
    UIImageView *_iconImageView;
    UILabel *_nameLabel;
    UILabel *_countLabel;
}
@end

@implementation WaterFlowViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //添加内容视图
        [self addContentView];
    }
    return self;
}

//添加内容视图
- (void)addContentView
{
    _imageView = [[UIImageView alloc] init];
    [self addSubview:_imageView];
    
    _backImageView = [[UIImageView alloc] init];
    [_backImageView setImage:[UIImage imageNamed:@"waterBackground.png"]];
    [self addSubview:_backImageView];
    
    _iconImageView = [[UIImageView alloc] init];
    [_iconImageView setImage:[UIImage imageNamed:@"waterIcon.png"]];
    [_backImageView addSubview:_iconImageView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 105, 25)];
    [_nameLabel setBackgroundColor:[UIColor clearColor]];
    [_nameLabel setFont:[UIFont systemFontOfSize:20]];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.textAlignment = NSTextAlignmentRight;
    [_backImageView addSubview:_nameLabel];
    
    _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, 105, 43-25)];
    [_countLabel setBackgroundColor:[UIColor clearColor]];
    [_countLabel setFont:[UIFont systemFontOfSize:12]];
    _countLabel.textColor = [UIColor whiteColor];
    _countLabel.textAlignment = NSTextAlignmentRight;
    [_backImageView addSubview:_countLabel];
}


//设置显示内容
- (void)setContentView:(CityInfo*)cityInfo
{
    //设置_imageView的image和frame
    [_imageView setFrame:CGRectMake(0, 0, cityInfo.width, cityInfo.height)];
    [_imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_1.jpg", cityInfo.cityName]]];
    _imageView.alpha = 0.5f;
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _imageView.alpha = 1.0f;
                     }
                     completion:nil];
    
    //获取文本cityInfo.cityName的size
    CGSize textSize = [UIUtils getTextSize:cityInfo.cityName withFont:[UIFont systemFontOfSize:20]];
    [_backImageView setFrame:CGRectMake(cityInfo.width-114, cityInfo.height-60, 114, 43)];
    [_iconImageView setFrame:CGRectMake(114 - textSize.width - 17 - 10, 0, 17, 25)];
    [_nameLabel setText:[NSString stringWithFormat:@"%@", cityInfo.cityName]];
    [_countLabel setText:[NSString stringWithFormat:@"%@人浏览过", cityInfo.scanCount]];
}

@end
