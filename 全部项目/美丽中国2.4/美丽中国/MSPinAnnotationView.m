//
//  MSPinAnnotationView.m
//  美丽中国
//
//  Created by 司马帅帅 on 15/7/30.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import "MSPinAnnotationView.h"
#import "MSMapView.h"
#import "MSAnnotation.h"

#define RED_PIN_IMAGE @"pinRed.png"
#define GREEN_PIN_IMAGE @"pinGreen.png"
#define BLUE_PIN_IMAGE @"pinPurple.png"
#define PIN_WIDTH 32.0//大头针的宽度
#define PIN_HEIGHT 39.0//大头针的高度
#define PIN_POINT_X 8.0
#define PIN_POINT_Y 35.0
#define CALLOUT_OFFSET_X 7.0
#define CALLOUT_OFFSET_Y 5.0

@implementation MSPinAnnotationView

- (id)initWithAnnotation:(MSAnnotation *)annotation onView:(MSMapView *)mapView animated:(BOOL)animate
{
    self = [super init];
    if (self) {
        self.annotation = annotation;
        
        //设置自己的frame
        self.frame = [self frameForPoint:self.annotation.point];
        
        //设置大头针的颜色
        [self setImageState:annotation.pinState];
        
        
        //把自己添加到mapView上
        [mapView addSubview:self];
        
        //大头针下落的动画
        if (animate) {
            CABasicAnimation *pindrop = [CABasicAnimation animationWithKeyPath:@"position.y"];
            pindrop.duration = 0.5f;
            pindrop.fromValue = [NSNumber numberWithFloat:self.center.y-mapView.frame.size.height];
            pindrop.toValue = [NSNumber numberWithFloat:self.center.y];
            pindrop.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            [self.layer addAnimation:pindrop forKey:@"pindrop"];
        }

    }
    return self;
}

//根据给定的坐标点point 算出self的frame
- (CGRect)frameForPoint:(CGPoint)point
{
    float x = point.x - PIN_POINT_X;
    float y = point.y - PIN_POINT_Y;
    return CGRectMake(round(x), round(y), PIN_WIDTH, PIN_HEIGHT);
}

//设置大头针的颜色
- (void)setImageState:(PinImageState)state
{
    if (state == PinState_Red) {
        UIImage *image = [UIImage imageNamed:RED_PIN_IMAGE];
        [self setImage:image forState:UIControlStateNormal];
    } else if (state == PinState_Green) {
        UIImage *image = [UIImage imageNamed:GREEN_PIN_IMAGE];
        [self setImage:image forState:UIControlStateNormal];
    } else if (state == PinState_Blue) {
        UIImage *image = [UIImage imageNamed:BLUE_PIN_IMAGE];
        [self setImage:image forState:UIControlStateNormal];
    }
}

//响应KVO mapView放大缩小后 设定相应的 self的frame值
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqual:@"contentSize"]) {
        MSMapView *mapView = (MSMapView*)object;
        //获取新的x坐标
        float newX = (mapView.contentSize.width/mapView.mapImageViewOriginalSize.width)*self.annotation.point.x;
        //获取新的y坐标
        float newY = (mapView.contentSize.height/mapView.mapImageViewOriginalSize.height)*self.annotation.point.y;
        self.frame = [self frameForPoint:CGPointMake(newX, newY)];
    }
}

@end
