//
//  NavTitleView.h
//  ShopNum1V3.1
//
//  Created by 梁泽 on 15/11/24.
//  Copyright © 2015年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NavTitleView;
@protocol NavTitleViewDelegate <NSObject>
@optional
- (void) navTitleViewDidClickLeftBtn:(NavTitleView*)view;

- (void) navTitleViewDidClickRightBtn:(NavTitleView*)view;

- (void) navTitleView:(NavTitleView*)view searchText:(NSString*)text;
@end

@interface NavTitleView : UIView
@property (nonatomic,weak)  id<NavTitleViewDelegate> delegate;
//+ (instancetype) getInstance;

+ (void) showBlurEffectOnView:(UIView*)view;
+ (void) dismissBlure;
+ (instancetype) create;
@end
