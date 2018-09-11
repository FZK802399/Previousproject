//
//  TitleHeaderView.m
//  HomePage
//
//  Created by 梁泽 on 15/11/20.
//  Copyright © 2015年 right. All rights reserved.
//

#import "TitleHeaderView.h"
#import "MemberFloorModel.h"
#import "FloorModel.h"


NSString *const kTitleHeaderView = @"TitleHeaderView";
@interface TitleHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end

@implementation TitleHeaderView

- (instancetype) initWithFrame:(CGRect)frame  {
    self = [super initWithFrame:frame];
    self = [[NSBundle mainBundle]loadNibNamed:kTitleHeaderView owner:nil options:nil].firstObject;
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)updateHeaderViewWithModel:(id)model {
    
    if ([model isKindOfClass:[MemberFloorModel class]]) {
        MemberFloorModel *memberModel = (MemberFloorModel *)model;
        [self.iconImageView setImageWithURL:[NSURL URLWithString:memberModel.BackgroundImage] placeholderImage:[UIImage imageNamed:@"nopic"]];
        self.titleLabel.text = memberModel.Name;
        self.detailLabel.text = @"";
    } else if([model isKindOfClass:[FloorModel class]]) {
        FloorModel *floorModel = (FloorModel *)model;
        [self.iconImageView setImageWithURL:[NSURL URLWithString:floorModel.BackgroundImage] placeholderImage:[UIImage imageNamed:@"nopic"]];
        self.titleLabel.text = floorModel.Name;
        self.detailLabel.text = floorModel.Memo;
    } else if ([model isKindOfClass:[NSString class]]) {
        NSString *title = model;
        if ([title isEqualToString:@"限时抢购"]) {
            self.iconImageView.image = [UIImage imageNamed:@"clock"];
            self.detailLabel.text = @"手快有，手慢无";
        } else if ([title isEqualToString:@"限量抢购"]) {
            self.iconImageView.image = [UIImage imageNamed:@"xianliang"];
            self.detailLabel.text = @"数量有限，先到先得";
        } else if ([title isEqualToString:@"一元购"]) {
            self.iconImageView.image = [UIImage imageNamed:@"yiyuangou_home"];
            self.detailLabel.text = @"满额抽奖，机会多多";
        }
        self.titleLabel.text = title;
    }
}

- (void) touchesBegan:(NSSet*/*<UITouch *> **/)touches withEvent:(UIEvent *)event{
    if ([self.delegate respondsToSelector:@selector(titleHeaderViewDidTouch:)]) {
        [self.delegate titleHeaderViewDidTouch:self];
    }
}

@end
