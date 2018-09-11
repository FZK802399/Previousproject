//
//  VirtualTourismViewController.h
//  BeiJing360
//
//  Created by baobin on 11-5-23.
//  Copyright 2011 __ChuangYiFengTong__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VirtualTourismViewController : UIViewController <UIWebViewDelegate> {
	
	UIWebView				*webview01;
	UIActivityIndicatorView *activityIndiator01;
	UIView					*opaqueView01;
	
}

@property (nonatomic, retain) UIWebView					*webview01;
@property (nonatomic, retain) UIActivityIndicatorView	*activityIndiator01;
@property (nonatomic, retain) UIView					*opaqueView01;

@end
