//
//  ImageInfo.h
//  旅拍1.0
//
//  Created by 司马帅帅 on 15/7/8.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageInfo : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) CGFloat imageHeight;
@property (nonatomic, assign) CGFloat textHeight;
@property (nonatomic, assign) CGFloat imageAndTextHeight;


- (id)initWithImage:(UIImage *)image andText:(NSString *)text;

@end
