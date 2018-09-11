//
//  PinJiaCollectionViewCell.m
//  ShopNum1V3.1
//
//  Created by Mac on 15/11/20.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "PinJiaCollectionViewCell.h"
#import "UIView+ZDX.h"
#import "MerchandisePingJiaModel.h"

NSString *const kPinJiaCellIdentifier = @"PinJiaCollectionViewCell";

@interface PinJiaCollectionViewCell ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *pinJiaDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *pinJiaContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *guiGeCanShuLabel; // 规格参数等
@property (weak, nonatomic) IBOutlet UIView *starView;
@property (weak, nonatomic) IBOutlet UIView *showPicView;


@property (strong, nonatomic) IBOutlet UIScrollView *showPicScrollView;


@end

@implementation PinJiaCollectionViewCell
{
    __weak IBOutlet NSLayoutConstraint *constraint;
    NSArray *imageArray;
    UIPageControl *pageControl;
}



- (void)awakeFromNib {
    self.iconImageView.layer.cornerRadius = CGRectGetWidth(self.iconImageView.frame) / 2.0;
    self.iconImageView.clipsToBounds = YES;
    self.showPicView.clipsToBounds = YES;
}

- (void)updateViewWithMerchandisePingJiaModel:(MerchandisePingJiaModel *)model {
    
//    [UIView_ZDX addStarImageViewWithScore:model.rank toView:self.starView];
    [self.iconImageView setImageWithURL:model.memphotoURL placeholderImage:[UIImage imageNamed:@"userphoto"]];
    self.userNameLabel.text = model.memname;
    self.pinJiaDateLabel.text = model.sendtime;
    self.guiGeCanShuLabel.text = model.attributes;
    self.pinJiaContentLabel.text = model.content;
    for (UIView *view in self.showPicView.subviews) {
        [view removeFromSuperview];
    }
    if (model.baskImageArray) {
        constraint.constant = 60;
        imageArray = model.baskImageArray;
        [self addShowPicContentWithImageArray:model.baskImageArray];
    } else {
        constraint.constant = 0;
    }
}

+ (CGSize)sizeWithMerchandisePingJiaModel:(MerchandisePingJiaModel *)model {
    CGSize itemSize = CGSizeMake(SCREEN_WIDTH, 90);
    if (model.baskImageArray && model.baskImageArray.count > 0) {
        itemSize.height += 60;
    }
    
    CGRect contentRect = [model.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 48, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f]} context:nil];
    if (CGRectGetHeight(contentRect) > 35) {
        itemSize.height += (CGRectGetHeight(contentRect) - 30);
//        NSLog(@"Height : %f", CGRectGetHeight(contentRect));
    }
    return itemSize;
}

- (void)addShowPicContentWithImageArray:(NSArray *)array{
//    constraint.constant = 60;
    for (int i=0; i<array.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * 55, 5, 50, 50)];
        [imageView setImageWithURL:array[i] placeholderImage:[UIImage imageNamed:@"userphoto"]];
//        [imageView setImage:[UIImage imageNamed:@"userphoto"]];
        [self.showPicView addSubview:imageView];
    }
//    [self.showPicScrollView setContentSize:CGSizeMake(array.count * 55, 60)];
}


- (IBAction)didSelectShowPic:(id)sender {
    // 展示图片
    self.showPicScrollView = [[UIScrollView alloc] initWithFrame:self.window.bounds];
    self.showPicScrollView.backgroundColor = [UIColor blackColor];
    self.showPicScrollView.pagingEnabled = YES;
    self.showPicScrollView.delegate = self;
    self.showPicScrollView.showsVerticalScrollIndicator = NO;
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 30, SCREEN_WIDTH, 30)];
    pageControl.numberOfPages = imageArray.count;
    pageControl.currentPageIndicatorTintColor = [UIColor barTitleColor];
    
    for (int i=0; i<imageArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [imageView setImageWithURL:imageArray[i] placeholderImage:[UIImage imageNamed:@"userphoto"]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissShowPicScrollView)];
        [imageView addGestureRecognizer:tap];
        [self.showPicScrollView addSubview:imageView];
    }
    [self.showPicScrollView setContentSize:CGSizeMake(SCREEN_WIDTH * imageArray.count, SCREEN_HEIGHT)];
    [self.window addSubview:self.showPicScrollView];
    [self.window addSubview:pageControl];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.x;
    pageControl.currentPage = offset / SCREEN_WIDTH;
}

- (void)dismissShowPicScrollView {
    [self.showPicScrollView removeFromSuperview];
    [pageControl removeFromSuperview];
}


@end
