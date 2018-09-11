//
//  MySegment.h
//  ForbiddenCityVirtual_EN
//
//  Created by Heramerom on 13-7-23.
//  Copyright (c) 2013年 Duke Douglas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MySegment : UIView
{
    UIButton *_chineseButton;
    UIButton *_englishButton;
}

@property (nonatomic, assign) NSInteger value;

- (id)initWithTag:(id)object andSelect:(SEL)select andEvent:(UIControlEvents)event;

- (void)setButtonImageWithTag:(NSInteger)tag;

@end
