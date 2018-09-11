//
//  TeJiaCollectionViewCell.m
//  ShopNum1V3.1
//
//  Created by Mac on 15/12/23.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "TeJiaCollectionViewCell.h"
#import "TeJiaView.h"

NSString *const kTeJiaCollectionViewCell = @"TeJiaCollectionViewCell";

@interface TeJiaCollectionViewCell ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;

@end

@implementation TeJiaCollectionViewCell
{
    NSInteger currentPage;
    NSInteger countPage;
}

- (instancetype)initWithFrame:(CGRect)frame  {
    self = [super initWithFrame:frame];
    self = [[NSBundle mainBundle]loadNibNamed:kTeJiaCollectionViewCell owner:nil options:nil].firstObject;
    return self;
}

- (void)awakeFromNib {
    
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        CGRect frame = self.bounds;
        frame.origin.x = 30;
        frame.size.width = SCREEN_WIDTH - 60;
        _scrollView = [[UIScrollView alloc] initWithFrame:frame];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (IBAction)leftButton:(id)sender {
    [self fetchCurrentPage];
    
    if (currentPage == 0) {
        return;
    } else {
        CGFloat x = (currentPage - 1) * CGRectGetWidth(self.scrollView.bounds);
        NSLog(@"X:%f",x);
        [self.scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
    }
}


- (IBAction)rightButton:(id)sender {
    [self fetchCurrentPage];
    
    if (currentPage == countPage - 1 || currentPage == countPage) {
        return;
    } else {
        CGFloat x = (currentPage + 1) * CGRectGetWidth(self.scrollView.bounds);
//        NSLog(@"X:%f",x);
        [self.scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
    }
}

- (void)updateViewWithModels:(NSArray *)models {

    countPage = models.count;
    if (countPage > 0) {
        for (int i = 0; i < models.count; i++) {
            TeJiaView *view = [TeJiaView teJiaViewWithFrame:self.scrollView.bounds];
            [view updateViewWithModel:models[i]];
            view.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
            [view addGestureRecognizer:singleTap];
            view.frame = CGRectOffset(view.frame, view.frame.size.width * i, 0);
            [self.scrollView addSubview:view];
        }
        [self.scrollView setContentSize:CGSizeMake(CGRectGetWidth(self.scrollView.bounds) * models.count, CGRectGetHeight(self.scrollView.bounds))];
    }
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
    [self fetchCurrentPage];
    if ([self.delegate respondsToSelector:@selector(teJiaCellDidSelectAtIndex:)]) {
        [self.delegate teJiaCellDidSelectAtIndex:currentPage];
    }
}

- (void)fetchCurrentPage {
    CGFloat offsetX = self.scrollView.contentOffset.x;
    double pageDouble = offsetX / self.scrollView.frame.size.width;
    currentPage = (int)(pageDouble + 0.5);
}

#pragma mark - UIScrollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    // 1.取出水平方向上滚动的距离
//    CGFloat offsetX = scrollView.contentOffset.x;
//    // 2.求出页码
//    double pageDouble = offsetX / scrollView.frame.size.width;
//    currentPage = (int)(pageDouble + 0.5);
//    NSLog(@"")
//}

@end
