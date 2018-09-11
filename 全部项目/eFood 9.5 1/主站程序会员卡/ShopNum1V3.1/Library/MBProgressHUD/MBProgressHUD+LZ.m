//
//  MBProgressHUD+LZ.m
//
//  Created by LZ on 13-4-18.
//  
//

#import "MBProgressHUD+LZ.h"

@implementation MBProgressHUD (LZ)
#pragma mark 显示 文字 和图片  图片在文字上方
+ (void)show:(NSString *)text icon:(UIImage *)icon hideAfterTime:(NSTimeInterval)timer forView:(UIView*)view{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:icon];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    hud.margin = 10.f;
    hud.cornerRadius = 8;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hide:YES afterDelay:timer];

}
+(void) show:(NSString *)text icon:(UIImage *)icon hideAfterTime:(NSTimeInterval)timer{
    [self show:text icon:icon hideAfterTime:timer forView:nil];
}
///  只显示 文字
+ (void)show:(NSString *)text hideAfterTime:(NSTimeInterval)timer{
    [self show:text icon:nil hideAfterTime:timer forView:nil];
}
#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]];
    //时间设置在这里
    [self show:text icon:image hideAfterTime:2 forView:view];
}

#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"error.png" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"success.png" view:view];
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = YES;
    return hud;
}

+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}

+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil];
}

+ (void)hideHUDForView:(UIView *)view
{
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD
{
    [self hideHUDForView:nil];
}
#pragma mark 显示一条信息
/// 只显示文本
+(void) showMessage:(NSString*) message hideAfterTime:(NSTimeInterval)timer{
    [self showMessage:message hideAfterTime:timer toView:nil];
}
/// 只显示文本到指定视图
+(void) showMessage:(NSString*) message hideAfterTime:(NSTimeInterval)timer toView:(UIView*)view{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = NO;
    hud.margin = 10.f;
    
    // 几秒之后再消失
    [hud hide:YES afterDelay:timer];
}
@end
