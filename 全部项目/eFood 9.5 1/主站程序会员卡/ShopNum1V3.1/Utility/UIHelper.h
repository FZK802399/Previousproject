//
//  UIHelper.h
//  Shop
//
//  Created by Ocean Zhang on 3/28/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIHelper : NSObject

+ (UITabBarController *)getRootViewController;

//+ (MemberCenterViewController *)getMemberCenterVc;

+ (void)gotoTabbar:(NSInteger)index;

+ (NSInteger)getTabbarIndex;

@end
