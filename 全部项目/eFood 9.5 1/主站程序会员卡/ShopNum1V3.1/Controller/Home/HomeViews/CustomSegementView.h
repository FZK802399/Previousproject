//
//  CustomSegementView.h
//  ShopNum1V3.1
//
//  Created by Right on 15/11/24.
//  Copyright © 2015年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomSegementView;
@protocol CustomSegementViewDelegate <NSObject>
@optional
- (void) customSegement:(CustomSegementView*)view didClickCategroyBtnAtIndex:(NSInteger)index;
- (void) customSegement:(CustomSegementView *)view changeLayoutList:(BOOL)changeList;

@end
@interface CustomSegementView : UIView
@property (weak  , nonatomic) id<CustomSegementViewDelegate> delegate;

+ (instancetype) create;
+ (instancetype) createWithFrame:(CGRect)frame;
@end
