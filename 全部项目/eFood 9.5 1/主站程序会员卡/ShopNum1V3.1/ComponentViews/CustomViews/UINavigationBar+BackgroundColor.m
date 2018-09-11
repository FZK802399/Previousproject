//
//  UINavigationBar+BackgroundColor.m
//  HomePage
//
//  Created by Right on 15/11/21.
//  Copyright © 2015年 right. All rights reserved.
//

#import "UINavigationBar+BackgroundColor.h"
#import <objc/runtime.h>
@implementation UINavigationBar(BackgroundColor)

static char overlayKey;

- (UIView *)overlay
{
    return objc_getAssociatedObject(self, &overlayKey);
}

- (void)setOverlay:(UIView *)overlay
{
    objc_setAssociatedObject(self, &overlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)lz_setBackgroundColor:(UIColor *)backgroundColor
{
    if (!self.overlay) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        
        // insert an overlay into the view hierarchy
        self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, self.bounds.size.height + 20)];
        self.overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        [self insertSubview:self.overlay atIndex:0];
        [self sendSubviewToBack:self.overlay];
    }
    self.overlay.backgroundColor = backgroundColor;
}
- (void) lz_cleanBackgroundColor{
    self.overlay.hidden = YES;
}
- (void) lz_showBackgroundColor{
    self.overlay.hidden = NO;
}
@end
