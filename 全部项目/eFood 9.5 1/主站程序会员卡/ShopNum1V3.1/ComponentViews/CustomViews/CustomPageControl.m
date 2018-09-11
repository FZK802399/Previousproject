//
//  CustomPageControl.m
//  OnlineShop
//
//  Created by m on 15/8/18.
//  Copyright (c) 2015年 m. All rights reserved.
//

#import "CustomPageControl.h"
@implementation CustomPageControl


- (void) setCurrentPage:(NSInteger)page {
    [super setCurrentPage:page];
    [self.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        CGSize size;
        size.height = 11;
        size.width = 11;
        [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y,
                                     size.width,size.height)];
        subview.layer.borderColor = [UIColor whiteColor].CGColor;
        subview.layer.cornerRadius =  size.width*0.5;
        subview.layer.borderWidth = 1;

        subview.clipsToBounds = YES;
//        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 11, 11)];
//        [subview addSubview:imageView];
        if (page == idx) {
            subview.layer.borderColor = [UIColor whiteColor].CGColor;
            subview.layer.cornerRadius =  size.width*0.5;
            subview.layer.borderWidth = 1;
//            imageView.image = [UIImage imageNamed:@"advertisement"];
        }else{
            subview.layer.borderColor = [UIColor whiteColor].CGColor;
            subview.layer.cornerRadius =  size.width*0.5;
            subview.layer.borderWidth = 1;

//            imageView.image = [UIImage imageNamed:@"main_badge"];
        }
    }];
}

@end
