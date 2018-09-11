//
//  LZCycleScrollView.h
//  LZ14无限滚动
//
//  Created by 梁泽 on 15/6/7.
//  Copyright (c) 2015年 梁泽. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LZCycleScrollView;


@protocol LZCycleScrollViewDatasource <NSObject>
@required
- (NSInteger)CycleScrollViewnumberOfPages;
- (UIView*)CycleScrollViewpageAtIndex:(NSInteger)index;
@end

@protocol LZCycleScrollViewDelegate <NSObject>
@optional
- (void)CycleScrollViewdidClickPage:(LZCycleScrollView *)csView atIndex:(NSInteger)index;
@end

@interface LZCycleScrollView : UIView<UIScrollViewDelegate>
@property (nonatomic, assign) CGRect pageCountFrame;
@property (nonatomic,weak,setter = setDataource:) id<LZCycleScrollViewDatasource> datasource;
@property (nonatomic,weak,setter = setDelegate:)  id<LZCycleScrollViewDelegate> delegate;
-(void) beginAutoScroll;
-(void) endAutoScroll;
/// 刷新 和rableview一样
- (void)reloadData;
@end



