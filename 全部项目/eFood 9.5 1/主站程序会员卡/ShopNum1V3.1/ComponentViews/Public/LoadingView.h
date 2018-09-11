//
//  LoadingView.h
//  Shop
//
//  Created by Ocean Zhang on 4/1/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView

+ (LoadingView *)shareLoadingView;

- (void)setLoadingFrame:(CGRect)frame;

- (void)startLoading;

- (void)stopLoading;


@end
