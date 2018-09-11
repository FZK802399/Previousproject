//
//  MSPinAnnotationView.m
//  MSMap
//
//  Created by baobin on 13-4-15.
//  Copyright (c) 2013年 baobin. All rights reserved.
//

#import "MSPinAnnotationView.h"
#import "MSAnnotation.h"
#import "MapScrollView.h"
#import <QuartzCore/QuartzCore.h>

#define RED_PIN @"pinRed.png"
#define GREEN_PIN @"pinGreen.png"
#define BLUE_PIN @"pinPurple.png"
#define PIN_WIDTH 32.0
#define PIN_HEIGHT 39.0
#define PIN_POINT_X 8.0
#define PIN_POINT_Y 35.0
#define CALLOUT_OFFSET_X 7.0
#define CALLOUT_OFFSET_Y 5.0

@implementation MSPinAnnotationView

@synthesize annotation = _annotation;

- (void)dealloc
{
    [_annotation release];
    [super dealloc];
}

- (id)initwithAnnotation:(MSAnnotation *)annotation onView:(MapScrollView *)mapView animated:(BOOL)animate
{
    CGRect frame = CGRectMake(0, 0, 0, 0);
    self = [super initWithFrame:frame];
    if (self) {
        self.annotation = annotation;
        self.frame = [self frameForPoint:self.annotation.point];
        
//        [self setImage:[UIImage imageNamed:RED_PIN] forState:UIControlStateNormal];
        [self setImageStatic:annotation.pinState];
        [self addTarget:mapView action:@selector(showCallOut:) forControlEvents:UIControlEventTouchDown];
        [self.annotation.rightCalloutAccessoryView addTarget:mapView action:@selector(changeScence:) forControlEvents:UIControlEventTouchDown];
        
        if (!self.annotation.title) {
            [self setImage:[UIImage imageNamed:RED_PIN] forState:UIControlStateDisabled];
            self.enabled = self.annotation.title?YES:NO;
        }
        
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

//响应KVO mapView放大缩小后 设定相应的 self的frame值
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqual:@"contentSize"]) {
        MapScrollView *mapView = (MapScrollView *)object;
        float width = (mapView.contentSize.width / mapView.originalSize.width) * self.annotation.point.x;
        float height = (mapView.contentSize.height / mapView.originalSize.height) * self.annotation.point.y;
        self.frame = [self frameForPoint:CGPointMake(width, height)];
    }
}

//设置大头针的颜色
- (void)setImageStatic:(PinImageState)state
{
    if (state == PinRed)
    {
        UIImage *image = [UIImage imageNamed:RED_PIN];
        [self setImage:image forState:UIControlStateNormal];
    }
    else if(state == PinGreen)
    {
        UIImage *image = [UIImage imageNamed:GREEN_PIN];
        [self setImage:image forState:UIControlStateNormal];
    }
    else
    {
        UIImage *image = [UIImage imageNamed:BLUE_PIN];
        [self setImage:image forState:UIControlStateNormal];
    }
}
@end
