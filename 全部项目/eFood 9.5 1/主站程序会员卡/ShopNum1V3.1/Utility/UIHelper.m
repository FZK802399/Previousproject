//
//  UIHelper.m
//  Shop
//
//  Created by Ocean Zhang on 3/28/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import "UIHelper.h"
#import "AppDelegate.h"

@implementation UIHelper

+ (UITabBarController *)getRootViewController{
    return (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
}

//+ (MemberCenterViewController *)getMemberCenterVc{
//   UITabBarController *tabBar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//    
//    if(tabBar == nil){
//        NSLog(@"Nil");
//    }
//    
//    return nil;
////    UITabBarController *tabBar = (UITabBarController *)[AppDelegate *)]
////    
////    NSLog(@"%d",[tabBar.viewControllers count]);
////    
////    return (MemberCenterViewController *)(tabBar.viewControllers[4]);
//}

+ (void)gotoTabbar:(NSInteger)index{
    [[UIHelper getRootViewController] setSelectedIndex:index];
//    UIViewController *rootVc = [UIApplication sharedApplication].keyWindow.rootViewController;
//    [rootVc.tabBarController setSelectedIndex:index];
//    if([rootVc isKindOfClass:[AppGuideViewController class]]){
//    
//    }else if([rootVc isKindOfClass:[RootViewController class]]){
//        
//    }
}

+(NSInteger)getTabbarIndex{

    return [[UIHelper getRootViewController] selectedIndex];
}

@end
