//
//  HomeCycleView.m
//  HomePage
//
//  Created by 梁泽 on 15/11/20.
//  Copyright © 2015年 right. All rights reserved.
//

#import "HomeCycleView.h"
#import "LZCycleScrollView.h"

#import "BannerModel.h"
#import "UIImageView+AFNetworking.h"
NSString *const kHomeCycleView = @"HomeCycleView";
@interface HomeCycleView ()<LZCycleScrollViewDatasource,LZCycleScrollViewDelegate>
@property (nonatomic,strong) LZCycleScrollView *cycleView;
@end
@implementation HomeCycleView
/// 创建一个cycelView
- (LZCycleScrollView *) createCycleView {
    LZCycleScrollView *cycle = [[LZCycleScrollView alloc]initWithFrame:self.bounds];
    cycle.datasource = self;
    cycle.delegate = self;
    return cycle;
}
- (instancetype) initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.cycleView = [self createCycleView];
    }
    return self;
}

- (void) beginScorll {
    [self.cycleView endAutoScroll];
    [self.cycleView beginAutoScroll];
}
- (void) endScorll {
    [self.cycleView endAutoScroll];
}

- (void) setImages:(NSArray *)images {
    _images = images;
    [self.cycleView removeFromSuperview];
    self.cycleView = [self createCycleView];
    [self addSubview:self.cycleView];
    [self.cycleView reloadData];
}
#pragma mark - cycleview代理
- (NSInteger) CycleScrollViewnumberOfPages{
    return self.images.count;
}
- (UIView*) CycleScrollViewpageAtIndex:(NSInteger)index{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.bounds];
    id mode = self.images[index%self.images.count];
    if ([mode isKindOfClass:[NSString class]]) {
        imageView.image = [UIImage imageNamed:(NSString*)mode];
    }else if([mode isKindOfClass:[BannerModel class]]){
        BannerModel *model = (BannerModel*)mode;
        [imageView setImageWithURL:[NSURL URLWithString:model.Value] placeholderImage:[UIImage imageNamed:@"nopic"]];
    }
    return imageView;
}
- (void) CycleScrollViewdidClickPage:(LZCycleScrollView *)csView atIndex:(NSInteger)index{
    if ([self.delegate respondsToSelector:@selector(HomeCycleViewDidClickIndex:)]) {
        [self.delegate HomeCycleViewDidClickIndex:index];
    }
}

@end
