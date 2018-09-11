//
//  LZNavigationController.m
//  LZ10网易
//
//  Created by 梁泽 on 15/5/19.
//  Copyright (c) 2015年 梁泽. All rights reserved.
//
// 判断是否为iOS7
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
#import "YMJNavigationController.h"
#import "UINavigationBar+BackgroundColor.h"
@interface YMJNavigationController ()

@end

@implementation YMJNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

/**
 *  系统在第一次使用这个类的时候调用(1个类只会调用一次)
 */
+ (void)initialize
{
    // 1.设置导航栏主题
    UINavigationBar *navBar = [UINavigationBar appearance];
    // 设置背景图片
//    [navBar setBackgroundImage:[UIImage imageNamed:@"daohanglan"] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    // 设置标题文字颜色 和大小
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor colorWithWhite:0.205 alpha:1.000];
    attrs[NSFontAttributeName] = [UIFont fontWithName:@"Avenir-Heavy" size:20];
    [navBar setTitleTextAttributes:attrs];
    // 在sb 里设置
    
    //2.设置BarButtonItem的主题  这是左右的不是标题
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    // 设置文字颜色
    NSMutableDictionary *itemAttrs = [NSMutableDictionary dictionary];
    itemAttrs[NSForegroundColorAttributeName] = [UIColor colorWithWhite:0.205 alpha:1.000];
    itemAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:18];
    [item setTitleTextAttributes:itemAttrs forState:UIControlStateNormal];
    


//    if (!iOS7) {
//        // 设置按钮背景
//        [item setBackgroundImage:[UIImage imageNamed:@"NavButton"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//        [item setBackgroundImage:[UIImage imageNamed:@"NavButtonPressed"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
//        
//        // 设置返回按钮背景
//        [item setBackButtonBackgroundImage:[UIImage imageNamed:@"NavBackButton"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//        [item setBackButtonBackgroundImage:[UIImage imageNamed:@"NavBackButtonPressed"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
//    }
    // 设置返回按钮
}
-(void) awakeFromNib{
    
}

-(id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    return self;
}
/**
 *  重写这个方法,能拦截所有的push操作
 *
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count>0) {
        [self.navigationBar lz_cleanBackgroundColor];
        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"baisebeijing"] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
        viewController.hidesBottomBarWhenPushed = YES;
    }
   
    [super pushViewController:viewController animated:animated];
}


//- (UIViewController *)popViewControllerAnimated:(BOOL)animated
//{
//    return [super popViewControllerAnimated:YES];
//}
//- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated{
//    return [super popToRootViewControllerAnimated:YES];
//}
@end
