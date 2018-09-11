//
//  UIViewController+leftBarItem.m
//  HomePage
//
//  Created by 梁泽 on 15/11/22.
//  Copyright © 2015年 right. All rights reserved.
//

#import "UIViewController+leftBarItem.h"

@implementation UIViewController(leftBarItem)

- (void) setLeftBarItem {
     UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithTitle:@"xx" style:UIBarButtonItemStylePlain target:self action:@selector(click)];
    self.navigationItem.leftBarButtonItem = left;
}
- (void) click{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
