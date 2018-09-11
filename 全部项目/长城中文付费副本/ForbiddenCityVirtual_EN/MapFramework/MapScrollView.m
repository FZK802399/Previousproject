//
//  MapScrollView.m
//  MSMap
//
//  Created by baobin on 13-4-13.
//  Copyright (c) 2013年 baobin. All rights reserved.
//

#import "MapScrollView.h"


@implementation MapScrollView

@synthesize imageView = _imageView;
@synthesize pinAnnotations = _pinAnnotations;
@synthesize callout = _callout;
@synthesize originalSize = _originalSize;
@synthesize mapDelegate = _mapDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor redColor];
        self.delegate = self;
        self.bouncesZoom = NO;
        self.bounces = NO;
        self.contentMode = UIViewContentModeCenter;
        self.maximumZoomScale = 2.5;
        self.minimumZoomScale = 1.0;
        self.decelerationRate = .85;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
    }
    return self;
}

//设置本地地图显示的图片
- (void)displayMapImage:(UIImage *)mapImage
{
    if (!self.imageView) {
        UIImageView *aImageView = [[UIImageView alloc] initWithImage:mapImage];
        [aImageView setFrame:CGRectMake(0, 0, (mapImage.size.width / mapImage.size.height) * self.frame.size.height, self.frame.size.height)];
        aImageView.userInteractionEnabled = YES;
        self.imageView = aImageView;
        [aImageView release];
    } else {
        self.imageView.image = mapImage;
    }
    [self addSubview:self.imageView];
    self.originalSize = self.imageView.frame.size;
    
    self.contentSize = self.imageView.frame.size;
    self.contentOffset=CGPointMake((self.imageView.frame.size.width-self.frame.size.width)/2, 0);
}

//添加一个MSAnnotation到MapScrollView上
- (void)addAnnotation:(MSAnnotation *)annotation animated:(BOOL)animate
{
    MSPinAnnotationView *pinAnnotation = [[MSPinAnnotationView alloc] initwithAnnotation:annotation onView:self animated:animate];
    
    pinAnnotation.tag = annotation.tag;
    
    if (!_pinAnnotations) {
        _pinAnnotations = [[NSMutableArray alloc] init];
    }
    
    [self.pinAnnotations addObject:pinAnnotation];
    //注册KVO self的contentSize属性发生变化 
    [self addObserver:pinAnnotation forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    [pinAnnotation release];
}


//添加多个MSAnnotation到MapScrollView上
- (void)addAnnotations:(NSArray *)annotations animated:(BOOL)animate
{
    for (MSAnnotation *annotation in annotations) {
        [self addAnnotation:annotation animated:animate];
    }
}


//展示弹出气泡
- (void)showCallOut:(id)sender {
    for (MSPinAnnotationView *pin in self.pinAnnotations) {
        if (pin == sender) {
            if (!self.callout) {
                MSCallOutView *calloutView = [[MSCallOutView alloc] initWithAnnotation:pin.annotation onMap:self];
                self.callout = calloutView;
                [calloutView release];
                //注册KVO self的contentSize属性发生变化
                [self addObserver:self.callout forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
                [self addSubview:self.callout];
            } else {
                [self hideCallOut];
                [self.callout displayAnnotation:pin.annotation];
            }
            
            [self centreOnPoint:pin.annotation.point animated:YES];
            break;
        }
    }
}

- (void)changeScence:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSLog(@"msmsmsm %d", button.tag);
    
    //调用代理
    [self.mapDelegate performSelector:@selector(loadSceenWithTag:) withObject:[NSNumber numberWithInt:button.tag]];
    
}

//隐藏弹出气泡
- (void)hideCallOut {
    self.callout.hidden = YES;
}

- (void)centreOnPoint:(CGPoint)point animated:(BOOL)animate {
    float x = (point.x * self.zoomScale) - (self.frame.size.width / 2.0f);
    float y = (point.y * self.zoomScale) - (self.frame.size.height / 2.0f);
//     NSLog(@"x=%f y=%f",x,y);
    
    if (x<0) {
        x=0;
    }
    
    if (y<0) {
        y=0;
    }
    
    if (x>(self.contentSize.width-self.frame.size.width)) {
        x=self.contentSize.width-self.frame.size.width;
    }
    
    if (y>(self.contentSize.height-self.frame.size.height)) {
        y=self.contentSize.height-self.frame.size.height;
    }
    [self setContentOffset:CGPointMake(x, y) animated:animate];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    if (touch.tapCount == 2) {
        if (isZoomed) {
            isZoomed = NO;
            [self setZoomScale:self.minimumZoomScale animated:YES];
        } else {
            isZoomed = YES;
            CGPoint touchCenter = [touch locationInView:self];
            CGSize zoomRectSize = CGSizeMake(self.frame.size.width/self.maximumZoomScale, self.frame.size.height/self.maximumZoomScale);
            CGRect zoomRect = CGRectMake(touchCenter.x-zoomRectSize.width*0.5, touchCenter.y-zoomRectSize.height*0.5, zoomRectSize.width, zoomRectSize.height);
            [self zoomToRect:zoomRect animated:YES];

        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"点击结束");
}

#pragma mark UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	return self.imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    if (self.zoomScale == self.minimumZoomScale) {
        isZoomed = NO;
    } else {
        isZoomed = YES;
    }
}

#pragma mark -
#pragma mark show call out view
//显示注释
- (void)showCallOutViewWithTag:(NSInteger)tag
{
    NSInteger count = 0;
    while (1)
    {        
        int atag = [[_pinAnnotations objectAtIndex:count++] tag];
        if (tag == atag)
        {
            break;
        }
    }
//    NSLog(@"count = %d", count);
    [self showCallOut:[self.pinAnnotations objectAtIndex:(count - 1)]];
}

//设置大头针的颜色
- (void)setPinState:(PinImageState)state withTag:(NSInteger)tag
{
    MSPinAnnotationView *pin = [self.pinAnnotations objectAtIndex:tag];
    [pin setImageStatic:state];
}
- (void)setPinState:(PinImageState)state withTags:(NSArray *)tags
{
    for (NSNumber *num in tags)
    {
        [self setPinState:state withTag:[num intValue]];
    }
}

- (void)displayPins
{
    
    for (int i = 0; i < self.pinAnnotations.count; i++)
    {
        
        for (int j = i; j < self.pinAnnotations.count ; j++)
        {
            MSPinAnnotationView *pin1 = [self.pinAnnotations objectAtIndex:i];
            MSPinAnnotationView *pin2 = [self.pinAnnotations objectAtIndex:j];
            if (pin1.frame.origin.y < pin2.frame.origin.y)
            {
                [self.pinAnnotations exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
    
    
}



@end
