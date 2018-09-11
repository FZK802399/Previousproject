//
//  CommentView.m
//  ShopNum1V3.1
//
//  Created by yons on 15/11/26.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "CommentView.h"

@implementation CommentView

-(void)setArr
{
    self.startArr = [NSMutableArray array];
    [self.startArr addObject:self.one];
    [self.startArr addObject:self.two];
    [self.startArr addObject:self.three];
    [self.startArr addObject:self.four];
    [self.startArr addObject:self.five];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    self.textView.layer.cornerRadius = 3;
    self.textView.layer.borderWidth = 1;
    self.textView.layer.borderColor = LINE_LIGHTGRAY.CGColor;
//    self.startArr = [NSArray arrayWithObjects:self.one,self.two,self.three,self.four,self.five,nil];
}

- (IBAction)startClick:(UIButton *)sender {
    if([self.delegate respondsToSelector:@selector(startClickWithStart:CommentView:)])
    {
        [self.delegate startClickWithStart:sender CommentView:self];
    }
}


@end
