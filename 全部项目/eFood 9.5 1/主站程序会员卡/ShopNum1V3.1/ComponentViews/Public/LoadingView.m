//
//  LoadingView.m
//  Shop
//
//  Created by Ocean Zhang on 4/1/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import "LoadingView.h"

@interface LoadingView()

@property (nonatomic, strong) UIActivityIndicatorView *activity;

@property (nonatomic, strong) UILabel *lbInfo;

@property (nonatomic, strong) UIView *shadeView;

@end

@implementation LoadingView

static LoadingView *sharedLoadingViewInstance = nil;

@synthesize activity = _activity;
@synthesize lbInfo = _lbInfo;
@synthesize shadeView = _shadeView;

+ (LoadingView *)shareLoadingView{
    @synchronized(self){
        if(sharedLoadingViewInstance == nil){
            sharedLoadingViewInstance = [[self alloc] init];
        }
    }
    return sharedLoadingViewInstance;
}

- (id)init{
    self = [super init];
    
    if(self){
        
        if(_activity == nil){
            _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [self addSubview:_activity];
        }
        
        /*
         if(_lbInfo == nil){
         _lbInfo = [[UILabel alloc] initWithFrame:CGRectMake(originX + width, frame.size.height / 2 - height / 2, 130, height)];
         _lbInfo.textColor = [UIColor blackColor];
         _lbInfo.text = @"正在加载,请稍候...";
         _lbInfo.font = [UIFont systemFontOfSize:14.0f];
         [self addSubview:_lbInfo];
         }
         */
        
        if(_shadeView == nil){
            _shadeView = [[UIView alloc] init];
            _shadeView.backgroundColor = [UIColor blackColor];
            _shadeView.alpha = 0.7;
           // _shadeView.userInteractionEnabled = YES;
            
            [self addSubview:_shadeView];
        }
        
        self.backgroundColor = [UIColor clearColor];
        [self setHidden:YES];
    }
    
    return self;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    @synchronized(self){
        if(sharedLoadingViewInstance == nil){
            sharedLoadingViewInstance = [super allocWithZone:zone];
            return sharedLoadingViewInstance;
        }
    }
    
    return nil;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (void)setLoadingFrame:(CGRect)frame {
    CGFloat width = 20;
    CGFloat height = 20;
    
    //CGFloat originX = 80;
    CGFloat originX = 150;
    
    _activity.frame = CGRectMake(originX, frame.size.height / 2 - height / 2, width, height);
    _shadeView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

- (void)startLoading{
    [self setHidden:NO];
    [_activity startAnimating];
    
//    UIView *parentView = self.superview;
//    if(parentView != nil){
//        [parentView bringSubviewToFront:self];
//    }
}

- (void)stopLoading{
    [self setHidden:YES];
    [_activity stopAnimating];
}

@end
