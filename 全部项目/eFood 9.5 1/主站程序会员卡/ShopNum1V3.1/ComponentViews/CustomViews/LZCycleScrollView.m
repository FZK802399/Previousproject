//
//  LZCycleScrollView.m
//  LZ14无限滚动
//
//  Created by 梁泽 on 15/6/7.
//  Copyright (c) 2015年 梁泽. All rights reserved.
//

#import "LZCycleScrollView.h"
#import "CustomPageControl.h"
@interface LZCycleScrollView () <UIGestureRecognizerDelegate>
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,readonly) UIScrollView *scrollView;
@property (nonatomic,readonly) UIPageControl *pageControl;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign) NSInteger curPage;
@property (nonatomic,assign) NSInteger totalPages;
@property (nonatomic,strong)  NSMutableArray *curViews;
@end

@implementation LZCycleScrollView
#pragma mark - 初始化方法
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(self.bounds.size.width * 3, 0);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
        _scrollView.pagingEnabled = YES;
        [self addSubview:_scrollView];
        
        CGFloat widht = 80;
        CGFloat height = 37;
        CGFloat x = self.frame.size.width - widht;
        CGFloat y = self.frame.size.height - height;
        
        _pageControl = [[CustomPageControl alloc] initWithFrame:CGRectMake(x, y, widht, height)];
        _pageControl.center = CGPointMake(self.center.x,_pageControl.center.y);
        _pageControl.userInteractionEnabled = NO;
        _pageControl.currentPageIndicatorTintColor = [UIColor barTitleColor];
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        _pageControl.backgroundColor = [UIColor clearColor];
        
        [self addSubview:_pageControl];
    
        _curPage = 0;
    }
    return self;
}
-(void) setPageCountFrame:(CGRect)pageCountFrame{
    self.pageControl.frame = pageCountFrame;
}
#pragma mark 数据源方法:
- (void)setDataource:(id<LZCycleScrollViewDatasource>)datasource
{
    _datasource = datasource;
    [self reloadData];
}

- (void)reloadData
{
    _totalPages = [_datasource CycleScrollViewnumberOfPages];
    if (_totalPages == 0) {
        return;
    }
    
    if (_totalPages == 1)
        _pageControl.hidden = YES;
    else
        _pageControl.hidden = NO;
    
    _pageControl.numberOfPages = _totalPages;
    [self loadData];
    if (_totalPages<=1)
        _scrollView.scrollEnabled = NO;
    else
        _scrollView.scrollEnabled = YES;
}

- (void)loadData
{
    
    _pageControl.currentPage = _curPage;
    
    //从scrollView上移除所有的subview
    NSArray *subViews = [_scrollView subviews];
    if([subViews count] != 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    [self getDisplayImagesWithCurpage:_curPage];
    
    for (int i = 0; i < 3; i++) {
        UIView *v = [_curViews objectAtIndex:i];
        v.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(handleTap:)];
        singleTap.delegate = self;
        [v addGestureRecognizer:singleTap];
        //        [singleTap release];
        v.frame = CGRectOffset(v.frame, v.frame.size.width * i, 0);
        [_scrollView addSubview:v];
    }
    
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
}
- (void)getDisplayImagesWithCurpage:(NSInteger)page {
    
    NSInteger pre = [self validPageValue:_curPage-1];
    NSInteger last = [self validPageValue:_curPage+1];
    
    if (!_curViews) {
        _curViews = [[NSMutableArray alloc] init];
    }
    
    [_curViews removeAllObjects];
    
    [_curViews addObject:[_datasource CycleScrollViewpageAtIndex:pre]];
    [_curViews addObject:[_datasource CycleScrollViewpageAtIndex:_curPage]];
    [_curViews addObject:[_datasource CycleScrollViewpageAtIndex:last]];
    

}
#pragma mark -定制视图样式 的事例：
-(UIView*) addCustomView{
    CGRect frame = self.frame;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:view.bounds];
    [view addSubview:imageView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-39.f,frame.size.width, 39.f)];
    bottomView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(9, 5, 302, 21)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [UIColor whiteColor];
    [bottomView addSubview:label];
    [view addSubview:bottomView];
    
    return view;
}

- (NSInteger)validPageValue:(NSInteger)value {
    
    if(value == -1) value = _totalPages - 1;
    if(value == _totalPages) value = 0;
    
    return value;
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]])
        return NO;
    else
        return YES;
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
    
    if ([_delegate respondsToSelector:@selector(CycleScrollViewdidClickPage:atIndex:)]) {
        [_delegate CycleScrollViewdidClickPage:self atIndex:_curPage];
    }
    
}

- (void)setViewContent:(UIView *)view atIndex:(NSInteger)index
{
    if (index == _curPage) {
        [_curViews replaceObjectAtIndex:1 withObject:view];
        for (int i = 0; i < 3; i++) {
            UIView *v = [_curViews objectAtIndex:i];
            v.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(handleTap:)];
            [v addGestureRecognizer:singleTap];
            //            [singleTap release];
            v.frame = CGRectOffset(v.frame, v.frame.size.width * i, 0);
            [_scrollView addSubview:v];
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    if ([self.datasource  CycleScrollViewnumberOfPages] == 0) return;
    
    int x = aScrollView.contentOffset.x;
    
    
    //往下翻一张
    if(x >= (2*self.frame.size.width)) {
        _curPage = [self validPageValue:_curPage+1];
        [self loadData];
    }
    
    //往上翻
    if(x <= 0) {
        _curPage = [self validPageValue:_curPage-1];
        [self loadData];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView {
    
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0) animated:YES];
    
}

/**开始图拽时 */
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //停止 定时器
    [self endAutoScroll];
}
/**停止图拽时 */
-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //开始计时器 计时
   [self beginAutoScroll];
 
}
#pragma mark 添加定时器
-(void)beginAutoScroll
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.5  target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
/** 三除定时器*/
-(void)endAutoScroll
{
    [self.timer invalidate];
    self.timer = nil;
}
#pragma mark 循环图片
-(void)nextPage
{
    CGPoint offset = self.scrollView.contentOffset;
    offset.x += self.scrollView.frame.size.width;
    [self.scrollView setContentOffset:offset animated:YES];
}

@end
