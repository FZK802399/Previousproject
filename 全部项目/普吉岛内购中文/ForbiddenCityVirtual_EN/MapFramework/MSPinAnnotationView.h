//
//  MSPinAnnotationView.h
//  MSMap
//
//  Created by baobin on 13-4-15.
//  Copyright (c) 2013年 baobin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSAnnotation.h"

@class MapScrollView;

@interface MSPinAnnotationView : UIButton {
    @private
    MSAnnotation *_annotation;
}

- (CGRect)frameForPoint:(CGPoint)point;
- (id)initwithAnnotation:(MSAnnotation *)annotation onView:(MapScrollView *)mapView animated:(BOOL)animate;

@property (nonatomic, retain) MSAnnotation *annotation;

//设置大头针的样式
- (void)setImageStatic:(PinImageState)state;

@end
