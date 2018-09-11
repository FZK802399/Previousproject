//
//  NameViewController.h
//  Shop
//
//  Created by yons on 15/11/2.
//  Copyright (c) 2015年 ocean. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NameViewController;
@protocol ModifyNameDelegate <NSObject>

- (void)modifNameFromViewController:(NameViewController *)nameViewController;

@end

@interface NameViewController : UIViewController
@property (weak,nonatomic)id<ModifyNameDelegate> delegate;
@end
