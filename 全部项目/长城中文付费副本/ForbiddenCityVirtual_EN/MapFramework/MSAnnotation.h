//
//  MSAnnotation.h
//  MSMap
//
//  Created by baobin on 13-4-15.
//  Copyright (c) 2013年 baobin. All rights reserved.
//

#import <Foundation/Foundation.h>

enum PinImageState {
    PinRed,
    PinBlue,
    PinGreen
};
typedef NSInteger PinImageState;

@interface MSAnnotation : NSObject {
    CGPoint _point;
    NSString *_title;
    NSString *_subtitle;
    UIButton *_rightCalloutAccessoryView;
    
    PinImageState _pinState;
}

@property (nonatomic, assign) CGPoint point;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, retain) UIButton *rightCalloutAccessoryView;
@property (nonatomic, assign) PinImageState pinState;
@property (nonatomic, assign) NSInteger tag;

@property (nonatomic, copy) NSString *nameCn;
@property (nonatomic, copy) NSString *nameEn;

+ (id)annotationWithPoint:(CGPoint)point;
- (id)initWithPoint:(CGPoint)point;

@end
