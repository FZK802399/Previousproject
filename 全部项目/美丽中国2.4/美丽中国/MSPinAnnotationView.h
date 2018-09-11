//
//  MSPinAnnotationView.h
//  美丽中国
//
//  Created by 司马帅帅 on 15/7/30.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MSMapView;
@class MSAnnotation;

@interface MSPinAnnotationView : UIButton

- (id)initWithAnnotation:(MSAnnotation *)annotation onView:(MSMapView *)mapView animated:(BOOL)animate;
- (CGRect)frameForPoint:(CGPoint)point;

@property (nonatomic, strong) MSAnnotation *annotation;

@end
