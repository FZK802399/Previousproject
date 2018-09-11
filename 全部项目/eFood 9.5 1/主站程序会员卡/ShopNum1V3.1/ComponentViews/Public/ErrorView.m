//
//  ErrorView.m
//  Shop
//
//  Created by Ocean Zhang on 4/26/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import "ErrorView.h"
#import <QuartzCore/QuartzCore.h>

@interface ErrorView()

@property (nonatomic, strong) UILabel *lbInfo;

@property (nonatomic, strong) UILabel *lbTitle;

@property (nonatomic, strong) UIView *shadeView;

@property (nonatomic, strong) UIView *containterView;
@property (nonatomic, strong) UIButton *btnHide;

@end

@implementation ErrorView

static ErrorView *sharedErrorViewInstance = nil;
@synthesize lbInfo = _lbInfo;
@synthesize shadeView = _shadeView;
@synthesize containterView = _containterView;
@synthesize lbTitle = _lbTitle;
@synthesize btnHide = _btnHide;

+ (ErrorView *)sharedErrorView{
    @synchronized(self){
        if(sharedErrorViewInstance == nil){
            sharedErrorViewInstance = [[self alloc] init];
        }
    }
    
    return sharedErrorViewInstance;
}

- (id)init{
    self = [super init];
    
    if(self){
        if(_shadeView == nil){
            _shadeView = [[UIView alloc] init];
            _shadeView.backgroundColor = [UIColor blackColor];
            _shadeView.alpha = 0.7;
            [self addSubview:_shadeView];
        }
        
        if(_containterView == nil){
            _containterView = [[UIView alloc] init];
//            _containterView.layer.cornerRadius = 15;
//            _containterView.layer.borderWidth = 1;
//            _containterView.layer.borderColor = [UIColor colorWithRed:245 /255.0f green:245 /255.0f blue:245 /255.0f alpha:1].CGColor;
            _containterView.backgroundColor = [UIColor colorWithRed:232 /255.0f green:76 /255.0f blue:60 /255.0f alpha:1];
            [self addSubview:_containterView];
        }
        
        if(_lbTitle == nil){
            _lbTitle = [[UILabel alloc] init];
            _lbTitle.textColor = [UIColor whiteColor];
            _lbTitle.backgroundColor = [UIColor clearColor];
            _lbTitle.font = [UIFont systemFontOfSize:14.0f];
            _lbTitle.textAlignment = NSTextAlignmentCenter;
            [_containterView addSubview:_lbTitle];
        }
        
        if(_lbInfo == nil){
            _lbInfo = [[UILabel alloc] init];
            _lbInfo.textColor = [UIColor whiteColor];
            _lbInfo.backgroundColor = [UIColor clearColor];
            _lbInfo.font = [UIFont systemFontOfSize:14.0f];
            _lbInfo.lineBreakMode = NSLineBreakByCharWrapping;
            _lbInfo.numberOfLines = 1;
            _lbInfo.textAlignment = NSTextAlignmentCenter;
            [_containterView addSubview:_lbInfo];
        }
        
        if(_btnHide == nil){
            _btnHide = [UIButton buttonWithType:UIButtonTypeCustom];
            _btnHide.backgroundColor = [UIColor clearColor];
            [_btnHide addTarget:self action:@selector(btnHidenTouch:) forControlEvents:UIControlEventTouchUpInside];
            [_containterView addSubview:_btnHide];
        }
        
        self.backgroundColor = [UIColor clearColor];
        [self setHidden:YES];
    }
    
    return self;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    @synchronized(self){
        if(sharedErrorViewInstance == nil){
            sharedErrorViewInstance = [super allocWithZone:zone];
            return sharedErrorViewInstance;
        }
    }
    
    return nil;
}

- (id)copyWithZone:(NSZone *)zone{
    return self;
}

- (IBAction)btnHidenTouch:(id)sender{
    [self stopError];
}

- (void)setErrorFrame:(CGRect)frame{
    CGFloat width = 320;
    CGFloat height = 100;
    CGFloat originX = 0;
    
    _shadeView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    _containterView.frame = CGRectMake(originX, (frame.size.height - height) / 2, width, height);
    _lbTitle.frame = CGRectMake(originX, 30, width, 20);
    _lbInfo.frame = CGRectMake(0, 50, width, 20);
    _btnHide.frame = _containterView.bounds;
    
}

- (void)startError{
    [self setHidden:NO];
    [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(stopError) userInfo:nil repeats:NO];
}

- (void)setErrorInfo:(NSString *)info andtitle:(NSString *)title{
    _lbTitle.text = title;
    _lbInfo.text = info;
}

- (void)stopError{
    [self setHidden:YES];
}
@end
