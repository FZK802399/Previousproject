//
//  FindCouponView.m
//  ShopNum1V3.1
//
//  Created by Mac on 16/1/4.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import "FindCouponView.h"
#import "RewardModel.h"

@interface FindCouponView ()

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel; // 恭喜...
@property (weak, nonatomic) IBOutlet UILabel *amountLabel; // 金额
@property (weak, nonatomic) IBOutlet UILabel *limitAmountLabel; // 限制使用金额  满100用
@property (weak, nonatomic) IBOutlet UILabel *useDateLabel; // 使用期限

@property (weak, nonatomic) IBOutlet UIButton *gotoLookButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (strong, nonatomic) RewardModel *model;

@end

@implementation FindCouponView

- (void)updateViewWithModel:(id)model {
    // 更新视图
    if ([model isKindOfClass:[RewardModel class]]) {
        self.model = model;
        self.scoreLabel.text = [NSString stringWithFormat:@"恭喜你，获得了%@元优惠券一张！", self.model.FaceValue.stringValue];
        self.amountLabel.text = self.model.FaceValue.stringValue;
        self.limitAmountLabel.text = [NSString stringWithFormat:@"满%@元即可使用", self.model.MinimalCost.stringValue];
        self.useDateLabel.text = [NSString stringWithFormat:@"使用期限:%@ - %@", self.model.StartDate, self.model.EndDate];
    }
}

- (void)drawRect:(CGRect)rect {
    self.gotoLookButton.layer.cornerRadius = 3.0f;
    self.backButton.layer.cornerRadius = 3.0f;
}

- (IBAction)gotoLook:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didSelectGotoLook)]) {
        [self.delegate didSelectGotoLook];
    }
}

- (IBAction)back:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didSelectBack)]) {
        [self.delegate didSelectBack];
    }
}

@end
