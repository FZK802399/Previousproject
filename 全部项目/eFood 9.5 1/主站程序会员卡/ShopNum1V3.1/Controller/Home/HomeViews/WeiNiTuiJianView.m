//
//  WeiNiTuiJianView.m
//  HomePage
//
//  Created by 梁泽 on 15/11/20.
//  Copyright © 2015年 right. All rights reserved.
//

#import "WeiNiTuiJianView.h"
NSString *const kWeiNiTuiJianView = @"WeiNiTuiJianView";

@implementation WeiNiTuiJianView
- (instancetype) initWithFrame:(CGRect)frame  {
    self = [super initWithFrame:frame];
    self = [[NSBundle mainBundle]loadNibNamed:kWeiNiTuiJianView owner:nil options:nil].firstObject;
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

@end
