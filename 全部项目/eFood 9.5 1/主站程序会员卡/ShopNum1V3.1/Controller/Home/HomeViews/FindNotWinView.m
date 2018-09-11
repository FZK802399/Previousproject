//
//  FindNotWinView.m
//  ShopNum1V3.1
//
//  Created by Mac on 16/1/9.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import "FindNotWinView.h"

@interface FindNotWinView ()

@property (weak, nonatomic) IBOutlet UIButton *comfirmButton;

@end

@implementation FindNotWinView

- (void)drawRect:(CGRect)rect {
    self.comfirmButton.layer.cornerRadius = 3.0f;
}

- (IBAction)comfirm:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didSelectComfirm)]) {
        [self.delegate didSelectComfirm];
    }
}

@end
