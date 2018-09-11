//
//  SecondHeaderView.m
//  HomePage
//
//  Created by 梁泽 on 15/11/20.
//  Copyright © 2015年 right. All rights reserved.
//

#import "SecondHeaderView.h"
 NSString *const kSecondHeaderView = @"SecondHeaderView";
@implementation SecondHeaderView

- (instancetype) initWithFrame:(CGRect)frame  {
    self = [super initWithFrame:frame];
    self = [[NSBundle mainBundle]loadNibNamed:kSecondHeaderView owner:nil options:nil].firstObject;
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}
- (void) refershWithNotice:(NSString*)notice{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromTop;
    self.titleLabel.text = notice;
    [self.titleLabel.layer addAnimation:transition forKey:nil];

}
@end
