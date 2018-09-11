//
//  MapScrollView.h
//  MSMap
//
//  Created by baobin on 13-4-13.
//  Copyright (c) 2013年 baobin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSAnnotation.h"
#import "MSCallOutView.h"
#import "MSPinAnnotationView.h"

@interface MapScrollView : UIScrollView <UIScrollViewDelegate>{
    
    BOOL isZoomed;
    
    @private
    UIImageView *_imageView;
    NSMutableArray *_pinAnnotations;
    CGSize _originalSize;
    MSCallOutView *_callout;
}

@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) NSMutableArray *pinAnnotations;
@property (nonatomic, retain) MSCallOutView *callout;
@property (nonatomic, assign) CGSize originalSize;

@property (nonatomic, assign) id mapDelegate;

//设置本地地图显示的图片
- (void)displayMapImage:(UIImage *)mapImage;
//添加一个MSAnnotation到MapScrollView上
- (void)addAnnotation:(MSAnnotation *)annotation animated:(BOOL)animate;
//添加多个MSAnnotation到MapScrollView上
- (void)addAnnotations:(NSArray *)annotations animated:(BOOL)animate;


//显示注释
- (void)showCallOutViewWithTag:(NSInteger)tag;

//设置大头针的颜色
- (void)setPinState:(PinImageState)state withTag:(NSInteger)tag;
- (void)setPinState:(PinImageState)state withTags:(NSArray *)tags;


//- (void)

@end
