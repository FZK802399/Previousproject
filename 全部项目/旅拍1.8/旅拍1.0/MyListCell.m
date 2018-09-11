//
//  MyListCell.m
//  旅拍1.0
//
//  Created by 司马帅帅 on 15/7/15.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import "MyListCell.h"
#import "UIUtils.h"
#import "WebInfo.h"
#import "Header.h"
#import "UIImageView+WebCache.h"

@interface MyListCell ()
{
    UILabel *_dayLabel;
    UILabel *_monthLabel;
    UILabel *_yearLabel;
    UILabel *_titleLabel;
    UIImageView *_imageView;
    UILabel *_viewCountLabel;
}
@end

@implementation MyListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addContentView];
    }
    return self;
}

- (void)addContentView
{
    //添加天标签
    _dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 1, 30, 30)];
    [_dayLabel setTextAlignment:NSTextAlignmentCenter];
    [_dayLabel setFont:[UIFont systemFontOfSize:26]];
    [self addSubview:_dayLabel];
    
    //添加月标签
    _monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_dayLabel.frame), 9, 50, 20)];
    [_monthLabel setTextAlignment:NSTextAlignmentCenter];
    [_monthLabel setFont:[UIFont systemFontOfSize:17]];
    [self addSubview:_monthLabel];
    
    //添加年标签
    _yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_monthLabel.frame), 16, 30, 10)];
    [_yearLabel setTextAlignment:NSTextAlignmentCenter];
    [_yearLabel setFont:[UIFont systemFontOfSize:12]];
    [self addSubview:_yearLabel];
    
    //添加图片视图
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(_dayLabel.frame)+5, 75, 75)];
    [self addSubview:_imageView];
    
    //添加标题视图
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imageView.frame)+5, CGRectGetMinY(_imageView.frame), [UIUtils getWindowWidth]-(CGRectGetMaxX(_imageView.frame)+5)-5, 20)];
    [_titleLabel setFont:[UIFont systemFontOfSize:17]];
    [self addSubview:_titleLabel];
    
    //浏览次数标签
    _viewCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imageView.frame)+5, CGRectGetMaxY(_imageView.frame)-20, [UIUtils getWindowWidth]-(CGRectGetMaxX(_imageView.frame)+5)-5, 20)];
    [_viewCountLabel setTextAlignment:NSTextAlignmentRight];
    [_viewCountLabel setTextColor:LIGHT_BLACK_COLOR];
    [_viewCountLabel setFont:[UIFont systemFontOfSize:13]];
    [self addSubview:_viewCountLabel];
}

//设置内容视图显示内容
- (void)setContentView:(WebInfo *)webInfo
{
    [_dayLabel setText:webInfo.dayString];
    [_monthLabel setText:[NSString stringWithFormat:@"%@月",webInfo.monthString]];
    [_yearLabel setText:webInfo.yearString];
    [_titleLabel setText:webInfo.title];
    [_viewCountLabel setText:[NSString stringWithFormat:@"浏览(%@)次",webInfo.viewCount]];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:webInfo.imageUrl] placeholderImage:[UIImage imageNamed:@"lp_headPlaceHolder.png"]];
}

+ (CGFloat)getCellHeight
{
    return 120.0f;
}

@end
