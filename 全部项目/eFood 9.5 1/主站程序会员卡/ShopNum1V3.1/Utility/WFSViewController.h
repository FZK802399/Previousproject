//
//  WFSViewController.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-6.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppConfig.h"
#import "AppDelegate.h"
#import "ShortCutPopView.h"

typedef NS_ENUM(NSInteger, SaleType){
    SaleTypeYiYuanGou = 1 << 5,
    SaleTypeXianShiGou = 1 << 3,
    SaleTypeXianLiangGou = 1 << 1
};

@interface WFSViewController : UIViewController <ShortCutPopViewDelegate>

@property (nonatomic, strong, readonly) AppConfig *appConfig;
@property (nonatomic, strong, readonly) AppDelegate *appDelegate;
@property (nonatomic, strong) ShortCutPopView * shortcutView;

//显示警告框
- (void)showAlertWithMessage:(NSString *)message;

//返回按钮
-(void)loadLeftBackBtn;

///快捷按钮
-(void)loadRightShortCutBtn;

-(UIColor *)getMatchTopColor;

//适配ios6、7
-(CGFloat)MatchIOS7:(CGFloat)originY;

//保存收藏商品的
- (void)SaveArrayToPlist:(NSArray *)Array;

-(NSMutableArray *)getSearchArray;

///写入数据文件
-(BOOL)writeApplicationData:(NSDictionary *)data  writeFileName:(NSString *)fileName;
///读取数据文件
-(id)readApplicationData:(NSString *)fileName;

/// 显示在window上的成功信息
- (void)showSuccessMesaageInWindow:(NSString *)message;
/// 成功提示
- (void)showSuccessMessage:(NSString *)message;
/// 错误信息
- (void)showErrorMessage:(NSString *)message;
/// 一般信息
- (void)showMessage:(NSString *)message;

/// 加载视图
- (void)showLoadView;
/// 带字的加载视图
- (void)showLoadViewWithMessage:(NSString *)message;
/// 隐藏加载
- (void)hideLoadView;

@end
