//
//  PromptFooterView.m
//  ShopNum1V3.1
//
//  Created by Right on 15/11/28.
//  Copyright © 2015年 WFS. All rights reserved.
//

#import "PromptFooterView.h"
NSString *const kPromptFooterView = @"PromptFooterView";
@implementation PromptFooterView
- (instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self = [[NSBundle mainBundle]loadNibNamed:kPromptFooterView owner:nil options:nil].firstObject;
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

@end
