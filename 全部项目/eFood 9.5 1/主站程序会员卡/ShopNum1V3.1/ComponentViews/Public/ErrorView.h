//
//  ErrorView.h
//  Shop
//
//  Created by Ocean Zhang on 4/26/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ErrorView : UIView

+ (ErrorView *)sharedErrorView;

- (void)setErrorFrame:(CGRect)frame;

- (void)startError;

- (void)setErrorInfo:(NSString *)info andtitle:(NSString *)title;

@end
