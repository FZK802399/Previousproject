//
//  MSMapView.m
//  美丽中国
//
//  Created by 司马帅帅 on 15/7/29.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import "MSMapView.h"
#import "MapInfo.h"
#import "TilingView.h"
#import "MSPinAnnotationView.h"

@interface MSMapView ()<UIScrollViewDelegate>
{
    UIImageView *_mapImageView;
    MapInfo *_mapInfo;
    BOOL isZoomed;
    TilingView *_tilingView;
}
@end

@implementation MSMapView

- (id)initWithFrame:(CGRect)frame andMapInfo:(MapInfo*)mapInfo
{
    self = [super initWithFrame:frame];
    if (self) {
        _mapInfo = mapInfo;
        
        self.delegate = self;
        self.backgroundColor = [UIColor whiteColor];
        //放大缩小时边界没有反弹效果
        self.bouncesZoom = NO;
        //设置边界没有反弹效果
        self.bounces = NO;
        //设置最小缩放比例
        self.minimumZoomScale = _mapInfo.zoomScale;
        //设置最大缩放比例
        self.maximumZoomScale = 1.0f;
        
        //添加内容视图
        [self addContentView];
    }
    return self;
}

//添加内容视图
- (void)addContentView
{
    //添加_mapImageView
    _mapImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _mapInfo.mapWidth, _mapInfo.mapHeight)];
    [_mapImageView setImage:_mapInfo.placeHolderImage];
    [self addSubview:_mapImageView];
    self.contentSize = _mapImageView.frame.size;
    
    //初始化TilingView
    _tilingView = [[TilingView alloc] initWithFrame:_mapImageView.frame andPinyinName:_mapInfo.pinyinName];
    [_mapImageView addSubview:_tilingView];
    
    //把当前的缩放比例为最小
    self.zoomScale = self.minimumZoomScale;
    //初始状态下没有放大 isZoomed为NO
    isZoomed = NO;
    
    //mapScrollView的size
    CGSize mapScrollViewSize = self.bounds.size;
    //mapImageView的size
    CGSize mapImageViewSize = _mapImageView.frame.size;
    
    //给_mapImageViewOriginalSize负值
    _mapImageViewOriginalSize = mapImageViewSize;

    //当mapImageView的宽度大于mapScrollView的宽度时 设置self.contentOffset使mapImageView横向居中
    if (mapImageViewSize.width>mapScrollViewSize.width) {
        self.contentOffset = CGPointMake((mapImageViewSize.width-mapScrollViewSize.width)/2, 0);
        NSLog(@"contentOffset %f %f",self.contentOffset.x,self.contentOffset.y);
    }
    
    //当mapImageView的高度大于mapScrollView的高度时 设置self.contentOffset使mapImageView纵向居中
    if (mapImageViewSize.height>mapScrollViewSize.height) {
        self.contentOffset = CGPointMake(0, (mapImageViewSize.height-mapScrollViewSize.height)/2);
    }
}

//根据centerPoint进行放大缩小
- (void)zoomAtPoint:(CGPoint)centerPoint
{
    if (isZoomed) {
        isZoomed = NO;
        //缩小到最小
        [self setZoomScale:self.minimumZoomScale animated:YES];
    } else {
        isZoomed = YES;
        //放大区域
        CGRect zoomRect;
        zoomRect.size.height = self.frame.size.height;
        zoomRect.size.width = self.frame.size.width;
        zoomRect.origin.x = centerPoint.x-(zoomRect.size.width/2.0);
        zoomRect.origin.y = centerPoint.y-(zoomRect.size.height/2.0);
        //进行放大
        [self zoomToRect:zoomRect animated:YES];
    }
}

//双击事件
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch.tapCount == 2) {
        CGPoint point = [[touches anyObject] locationInView:_mapImageView];
        //根据point进行放大缩小
        [self zoomAtPoint:point];
        
    }
}

//添加一个MSAnnotation到MapScrollView上
- (void)addAnnotation:(MSAnnotation *)msAnnotation animated:(BOOL)animate
{
    MSPinAnnotationView *pinAnnotationView = [[MSPinAnnotationView alloc] initWithAnnotation:msAnnotation onView:self animated:YES];
    //注册KVO self的contentSize属性发生变化
    [self addObserver:pinAnnotationView forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - UIScrollViewDelegate
//缩放ScrollView上的_mapImageView视图
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _mapImageView;
}

@end
