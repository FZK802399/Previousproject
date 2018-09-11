//
//  MSAnnotation.h
//  美丽中国
//
//  Created by 司马帅帅 on 15/7/30.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PinState_Red,
    PinState_Blue,
    PinState_Green
} PinImageState;

@interface MSAnnotation : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) UIButton *rightCalloutAccessoryButton;
@property (nonatomic, strong) NSString *sceneName;
@property (nonatomic, assign) CGPoint point;
@property (nonatomic, assign) PinImageState pinState;
@property (nonatomic, assign) int tag;

+ (id)annotationWithPoint:(CGPoint)point;
- (id)initWithPoint:(CGPoint)point;

@end
