//
//  CustomSegementView.m
//  ShopNum1V3.1
//
//  Created by Right on 15/11/24.
//  Copyright © 2015年 WFS. All rights reserved.
//

#import "CustomSegementView.h"
@interface CustomSegementView()
@property (weak, nonatomic) IBOutlet UIButton *oneBtn;
@property (weak, nonatomic) IBOutlet UIButton *twoBtn;
@property (weak, nonatomic) IBOutlet UIButton *threeBtn;
@property (weak, nonatomic) IBOutlet UIButton *fourBtn;
@property (strong, nonatomic) UIButton *currentBtn;
@property (strong, nonatomic) NSArray *btns;
@end
@implementation CustomSegementView
+ (instancetype) createWithFrame:(CGRect)frame{
    CustomSegementView *view = [CustomSegementView create];
    view.frame = frame;
    return view;
}
+ (instancetype) create {
    return [[NSBundle mainBundle]loadNibNamed:@"CustomSegementView" owner:nil options:nil].firstObject;
}
- (void) awakeFromNib{
    self.oneBtn.selected = YES;
    self.currentBtn = self.oneBtn;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)clickBtn:(UIButton *)sender {
    if (sender == self.currentBtn) {//点到相同的按钮
        return;
    }else{
        self.currentBtn.selected = NO;
        sender.selected = YES;
        self.currentBtn = sender;
        if ([self.delegate respondsToSelector:@selector(customSegement:didClickCategroyBtnAtIndex:)]) {
            [self.delegate customSegement:self didClickCategroyBtnAtIndex:sender.tag-100];
        }
    }
}
- (IBAction)clcikLayoutBtn:(UIButton*)sender {
    sender.selected = !sender.isSelected;
    if ([self.delegate respondsToSelector:@selector(customSegement:changeLayoutList:)]) {
        [self.delegate customSegement:self changeLayoutList:sender.selected];
    }
}

@end
