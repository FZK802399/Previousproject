//
//  MBProgressHUD+LZ.h
//
//  Created by LZ on 13-4-18.
//
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (LZ)
///  只显示 文字
+ (void)show:(NSString *)text hideAfterTime:(NSTimeInterval)timer;
/// 显示 文字 和图片  图片在文字上方
+ (void)show:(NSString *)text icon:(UIImage *)icon hideAfterTime:(NSTimeInterval)timer;
/// 显示成功 对勾
+ (void)showSuccess:(NSString *)success;
/// 显示 失败 叉
+ (void)showError:(NSString *)error;
/// 显示文本 和菊花
+(void) showMessage:(NSString*) message hideAfterTime:(NSTimeInterval)timer;
/// 显示文本句话 到指定视图
+(void) showMessage:(NSString*) message hideAfterTime:(NSTimeInterval)timer toView:(UIView*)view;
///  显示文本到指定视图 需要掉hideHUD
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;
///  显示文本到topview 需要掉hideHUD
+ (MBProgressHUD *)showMessage:(NSString *)message;

+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;


+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;


@end
