//
//  VirtualTour.h
//  BeiJing360
//
//  Created by lin yuxin on 12-2-10.
//  Copyright (c) 2012年 __ChuangYiFengTong__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VirtualTour : UIViewController <UIWebViewDelegate>{
    NSInteger whichView;
    UILabel *vtLabel;
    
    UIWebView *webView;
    UIActivityIndicatorView *activityIndicator;
    UIView *opaqueView;
}
@property (nonatomic) NSInteger whichView;
@property (nonatomic, retain) IBOutlet UILabel *vtLabel;

@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) UIView *opaqueView;

@end
