//
//  ShareViewController.h
//  MSSideBarMenu
//
//  Created by baobin on 14-3-4.
//  Copyright (c) 2014年 baobin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShareViewControllerDelegate <NSObject>

@optional
- (void)shareViewDismiss;

@end

@interface ShareViewController : UIViewController

@property (nonatomic, strong) NSString *webUrlString;
@property (nonatomic, strong) NSString *titleString;
@property (nonatomic, assign) id delegate;

- (void)showShareViewInView:(UIView *)view_;//展示shareView

@end
