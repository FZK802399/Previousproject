//
//  MSCallOutView.h
//  MSMap
//
//  Created by baobin on 13-4-17.
//  Copyright (c) 2013年 baobin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MSAnnotation;
@class MapScrollView;

@interface MSCallOutView : UIView {
    @private
    MSAnnotation *_annotation;
    MapScrollView *_mapView;
}

@property (nonatomic, retain) MSAnnotation *annotation;
@property (nonatomic, retain) MapScrollView *mapView;

- (id)initWithAnnotation:(MSAnnotation *)annotation onMap:(MapScrollView *)mapView;
- (void)displayAnnotation:(MSAnnotation *)annotation;

@end
