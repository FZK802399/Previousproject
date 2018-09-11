
//
//  Banner.m
//  Shop
//
//  Created by Ocean Zhang on 3/23/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import "BannerComponent.h"
#import "UIImageView+AFNetworking.h"
#import "TSMessage.h"
#import <QuartzCore/QuartzCore.h>

@implementation BannerComponent{
    NSInteger _timeCount;
    NSInteger _bannerCount;
}

@synthesize scroll = _scroll;
@synthesize scrollPage = _scrollPage;
@synthesize placeholderImg = _placeholderImg;
@synthesize timer = _timer;
@synthesize scrollPagePositionOffset = _scrollPagePositionOffset;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if(_placeholderImg == nil){
            _placeholderImg = [[UIImageView alloc] initWithFrame:self.bounds];
            _placeholderImg.image = [UIImage imageNamed:@"nopic"];
            [self addSubview:_placeholderImg];
            
        _timeCount = 0;
        _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(scrollViewTimer) userInfo:nil repeats:YES];
        }
    }
    return self;
}

#pragma mark - Load Banner
- (void)createBanner:(NSDictionary *)CityStr withType:(BannerType)type{
    [BannerModel getBannersWithParamer:CityStr andBlocks:^(NSArray *bannerArr,NSError *error){
        if(error){
            [TSMessage showNotificationWithTitle:NSLocalizedString(@"获取图片失败，点击屏幕重新加载", nil)
                                        subtitle:NSLocalizedString(@"网络连接失败，请检查网络设置", nil)
                                            type:TSMessageNotificationTypeError];
        }else{
            
            if ([bannerArr count] == 0) {
                
                [self addSubview:_placeholderImg];
            }
            
            if([bannerArr count] > 0){
                if(_placeholderImg != nil){
                    [_placeholderImg removeFromSuperview];
                }
                
                _bannerCount = [bannerArr count];
                
                if(_scroll == nil){
                    _scroll = [[UIScrollView alloc] initWithFrame:self.bounds];
                    _scroll.showsHorizontalScrollIndicator = NO;
                    _scroll.pagingEnabled = YES;
                    _scroll.delegate = self;
                    [self addSubview:_scroll];
                }else{
                    for (UIView *sub in _scroll.subviews) {
                        [sub removeFromSuperview];
                    }
                }
                
                CGFloat width = self.bounds.size.width;
                CGFloat height = self.bounds.size.height - 15;
                
                UIImage *blankImg = [UIImage imageNamed:@"nopic"];
                int i = 0;
                for (BannerModel *banner in bannerArr) {
                    UIImageView *bannerView = [[UIImageView alloc] initWithFrame:CGRectMake(i * width, 0, width, height)];
                    [bannerView setImageWithURL:banner.Value placeholderImage:blankImg];
                    [bannerView setContentMode:UIViewContentModeScaleAspectFit];
                    [_scroll addSubview:bannerView];
                    i ++;
                }
                _scroll.contentSize = CGSizeMake(width * _bannerCount, height);
                
//                _timeCount = 0;
//                _timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(scrollViewTimer) userInfo:nil repeats:YES];
                
                if(_scrollPage == nil){
                    CGFloat scrollPageHeight = 10;
                    CGFloat scrillPageWidth = _bannerCount * 20;
                    
                    CGFloat scrollPageOriginY = height - scrollPageHeight;
                    
                    if(_scrollPagePositionOffset > 0){
                        scrollPageOriginY -= _scrollPagePositionOffset;
                    }
                    
                    _scrollPage = [[UIPageControl alloc] initWithFrame:CGRectMake((width - scrillPageWidth) / 2, height+2, scrillPageWidth, scrollPageHeight)];
//                    _scrollPage.backgroundColor = [UIColor colorWithRed:0 /255.0f green:0 /255.0f blue:0 /255.0f alpha:0.3];
//                    [_scrollPage.layer setCornerRadius:8];
                    _scrollPage.hidesForSinglePage = NO;
                    _scrollPage.currentPageIndicatorTintColor = [UIColor barTitleColor];
                    _scrollPage.pageIndicatorTintColor = [UIColor grayColor];
                    [self addSubview:_scrollPage];
                }
                
                [_scrollPage setNumberOfPages:_bannerCount];
            }
        }
    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
    _scrollPage.currentPage = index;
    _timeCount = index;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
    _scrollPage.currentPage = index;
    _timeCount = index;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if(_timer != nil){
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(scrollViewTimer) userInfo:nil repeats:YES];
}

- (void)scrollViewTimer{
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    _timeCount ++;
    if(_timeCount == _bannerCount){
        _timeCount = 0;
        [_scroll scrollRectToVisible:CGRectMake(_timeCount * width, 0, width, height) animated:NO];

    }else{
        [_scroll scrollRectToVisible:CGRectMake(_timeCount * width, 0, width, height) animated:YES];
    
    }
    
    
}

@end
