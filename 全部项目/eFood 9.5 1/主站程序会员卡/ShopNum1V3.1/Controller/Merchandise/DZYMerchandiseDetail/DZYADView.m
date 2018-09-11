//
//  DZYADVIew.m
//  ShopNum1V3.1
//
//  Created by yons on 16/1/13.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import "DZYADView.h"
#import "UIImageView+WebCache.h"

@interface DZYADView ()<UIScrollViewDelegate>
@property (nonatomic,weak)UIScrollView * scrollView;
@property (nonatomic,weak)UIPageControl * pageControl;
@end

@implementation DZYADView

-(instancetype)initWithFrame:(CGRect)frame ImageUrlList:(NSArray *)UrlList
{
    self = [super initWithFrame:frame];
    if (self) {
        _UrlList = UrlList;
        [self createScrollViewAndPageControllerWithFrame:frame];
        [self createImageViewListWithSize:frame.size];
        if (UrlList.count > 1) {
            NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(scrollViewTimer) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        }
        else
        {
            self.scrollView.scrollEnabled = NO;
        }
    }
    return self;
}

-(void)createScrollViewAndPageControllerWithFrame:(CGRect )frame
{
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, width, height-20)];
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:scrollView];
    _scrollView = scrollView;
    
    UIPageControl * pageController = [[UIPageControl alloc]initWithFrame:CGRectMake(0, height-20, width, 20)];
    pageController.numberOfPages = _UrlList.count;
    pageController.pageIndicatorTintColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
    pageController.currentPageIndicatorTintColor = [UIColor colorWithRed:239.0/255.0 green:45.0/255.0 blue:48.0/255.0 alpha:1];
    pageController.currentPage = 0;
    [self addSubview:pageController];
    _pageControl = pageController;
}

-(void)createImageViewListWithSize:(CGSize )size
{
    _scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * (_UrlList.count+2), size.height-20);
    [_scrollView setContentOffset:CGPointMake(size.width, 0)];
    for (int i = 0; i<=_UrlList.count+1; i++) {
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*size.width, 0, size.width, size.height)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        if (i == 0) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:_UrlList.lastObject]];
        }
        else if (i == _UrlList.count+1)
        {
            [imageView sd_setImageWithURL:[NSURL URLWithString:_UrlList.firstObject]];
        }
        else
        {
            [imageView sd_setImageWithURL:[NSURL URLWithString:_UrlList[i-1]]];
        }
        [_scrollView addSubview:imageView];
    }
}

-(void)scrollViewTimer
{
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    NSInteger count = _scrollView.contentOffset.x/width;
    [_scrollView scrollRectToVisible:CGRectMake((count+1)*width, 0, width, height) animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    NSInteger count = scrollView.contentOffset.x/width;
    if (scrollView.contentOffset.x == 0) {
        [_scrollView scrollRectToVisible:CGRectMake(_UrlList.count*width, 0, width, height) animated:NO];
        _pageControl.currentPage = _UrlList.count-1;
    }
    else if (scrollView.contentOffset.x == (_UrlList.count+1)*width)
    {
        [_scrollView scrollRectToVisible:CGRectMake(width, 0, width, height) animated:NO];
        _pageControl.currentPage = 0;
    }
    else
    {
        _pageControl.currentPage = count-1;
    }
}

@end
