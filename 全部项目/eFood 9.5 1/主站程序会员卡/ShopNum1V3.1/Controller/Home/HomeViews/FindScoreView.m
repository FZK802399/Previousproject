//
//  FindScoreView.m
//  ShopNum1V3.1
//
//  Created by Mac on 16/1/4.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import "FindScoreView.h"

@interface FindScoreView ()

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *comfirmButton;

@end

@implementation FindScoreView

- (void)drawRect:(CGRect)rect {
    self.comfirmButton.layer.cornerRadius = 3.0f;
}

- (void)updateViewWithScore:(NSString *)score {
    self.scoreLabel.text = [NSString stringWithFormat:@"恭喜你，获得了%@积分！", score];
}

- (IBAction)comfirm:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didSelectComfirm)]) {
        [self.delegate didSelectComfirm];
    }
}

@end
