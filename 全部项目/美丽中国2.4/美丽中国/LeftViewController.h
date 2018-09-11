//
//  LeftViewController.h
//  美丽中国
//
//  Created by 司马帅帅 on 15/7/19.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SideBarMenuViewController;

@interface LeftViewController : UIViewController

@property (nonatomic, assign) SideBarMenuViewController *sideBarMenuVC;

//展示相应的controller
- (void)showViewControllerWithIndex:(int)index;

@end
