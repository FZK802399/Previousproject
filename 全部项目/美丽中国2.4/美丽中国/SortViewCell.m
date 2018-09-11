//
//  SortViewCell.m
//  美丽中国
//
//  Created by 司马帅帅 on 15/7/20.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import "SortViewCell.h"
#import "CategoryInfo.h"
#import "UIUtils.h"

@interface SortViewCell ()
{
    UIImageView *_imageView;
}
@end

@implementation SortViewCell

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
    _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [_imageView setFrame:CGRectMake(0, 0, ([UIUtils getWindowWidth]-10*4)/3, ([UIUtils getWindowWidth]-10*4)/3)];
    
    [self addSubview:_imageView];
}

//设置内容视图显示内容
- (void)setContentView:(CategoryInfo *)categoryInfo
{
    [_imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",categoryInfo.categoryName]]];
    
    _imageView.alpha = 0.5f;
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _imageView.alpha = 1.0f;
                     }
                     completion:nil];
}

@end
