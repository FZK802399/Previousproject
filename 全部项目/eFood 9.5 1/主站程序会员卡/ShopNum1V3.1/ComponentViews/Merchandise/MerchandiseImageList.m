//
//  MerchandiseImageList.m
//  Shop
//
//  Created by Ocean Zhang on 4/1/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import "MerchandiseImageList.h"

//#import "MemberFavoModel.h"

@interface MerchandiseImageList()

@property (nonatomic, strong) MerchandiseDetailModel *currentMerchandise;

@property (nonatomic, strong) UIScrollView *scroll;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) UIPageControl *scrollPage;

@property (nonatomic, strong) UIButton *btnFavo;

@property (nonatomic, strong) UILabel *lbName;

@property (nonatomic, strong) UIImageView *placeHolderImg;


@end

@implementation MerchandiseImageList{
    NSInteger _timeCount;
    NSInteger _bannerCount;
}

BOOL isFavo;

@synthesize currentMerchandise = _currentMerchandise;

@synthesize scroll = _scroll;
@synthesize timer  = _timer;
@synthesize scrollPage = _scrollPage;
@synthesize btnFavo = _btnFavo;
@synthesize lbName = _lbName;
@synthesize placeHolderImg = _placeHolderImg;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)createMerchandiseImageListWith:(MerchandiseDetailModel *)detail{
    
    _currentMerchandise = detail;
    
    if(nil == detail.imagesList || NSNull.null == (id)detail.imagesList || [detail.imagesList count] == 0){
        if(_placeHolderImg == nil){
            _placeHolderImg = [[UIImageView alloc] initWithFrame:self.bounds];
            UIImage *bank = [UIImage imageNamed:@"nopic"];
            [_placeHolderImg setImageWithURL:detail.originalImage placeholderImage:bank];
            [_placeHolderImg setContentMode:UIViewContentModeCenter];
            [self addSubview:_placeHolderImg];
        }
    }else{
        if(_scroll == nil){
            _scroll = [[UIScrollView alloc] initWithFrame:self.bounds];
            _scroll.showsHorizontalScrollIndicator = NO;
            _scroll.pagingEnabled = YES;
            _scroll.delegate = self;
            [self addSubview:_scroll];
        }
        
        CGFloat width = self.bounds.size.width;
        CGFloat height = self.bounds.size.height;
        CGFloat btnHeight = 30;
        CGFloat btnWidth = 70;
        CGFloat nameHeight = 54;
        CGFloat scrollPageHeight = 10;
        
        UIImage *blankImg = [UIImage imageNamed:@"nopic"];
        int i = 0;
        
        for(NSString *imgStr in detail.imagesList){
            UIImageView *bannerView = [[UIImageView alloc] initWithFrame:CGRectMake(i * width, 0, width, height - 10)];
            [bannerView setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:blankImg];
            [bannerView setContentMode:UIViewContentModeScaleAspectFit];
            
            [_scroll addSubview:bannerView];
            
            i ++;
        }
        
        _bannerCount = i;
        _scroll.contentSize = CGSizeMake(width * _bannerCount, height);
        
        _timeCount = 0;
        _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(scrollViewTimer) userInfo:nil repeats:YES];
        
        if(_scrollPage == nil){
            _scrollPage = [[UIPageControl alloc] initWithFrame:CGRectMake(0, height - 10, width, scrollPageHeight)];
            [_scrollPage.layer setCornerRadius:8];
            _scrollPage.hidesForSinglePage = NO;
            _scrollPage.currentPageIndicatorTintColor = MAIN_ORANGE;
            _scrollPage.pageIndicatorTintColor = [UIColor grayColor];
            [self addSubview:_scrollPage];
        }
        
        [_scrollPage setNumberOfPages:_bannerCount];

    }
}
-(void)createMerchandiseImageListWithScoreProductDetialModel:(ScoreProductDetialModel *)detail{
    
    if(_placeHolderImg == nil){
        _placeHolderImg = [[UIImageView alloc] initWithFrame:self.bounds];
        UIImage *bank = [UIImage imageNamed:@"nopic"];
        [_placeHolderImg setImageWithURL:detail.originalImage placeholderImage:bank];
        [_placeHolderImg setContentMode:UIViewContentModeCenter];
        [self addSubview:_placeHolderImg];
    }

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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
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
        
    }
    
    [_scroll scrollRectToVisible:CGRectMake(_timeCount * width, 0, width, height) animated:YES];
}


@end
