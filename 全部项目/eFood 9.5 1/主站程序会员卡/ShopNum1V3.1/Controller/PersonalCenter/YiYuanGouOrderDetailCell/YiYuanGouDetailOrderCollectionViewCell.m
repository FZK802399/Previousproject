//
//  YiYuanGouDetailOrderCollectionViewCell.m
//  ShopNum1V3.1
//
//  Created by Mac on 15/12/31.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "YiYuanGouDetailOrderCollectionViewCell.h"
#import "YiYuanGouModel.h"

NSString *const kYiYuanGouDetailOrderCellIdentifier = @"YiYuanGouDetailOrderCollectionViewCell";

@interface YiYuanGouDetailOrderCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel; // 状态
@property (weak, nonatomic) IBOutlet UILabel *isStartLabel; // 是否开奖
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;// 价格

@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *productCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *lookWuLiuButton;


@property (weak, nonatomic) IBOutlet UIView *middleView;

@end

@implementation YiYuanGouDetailOrderCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[NSBundle mainBundle] loadNibNamed:kYiYuanGouDetailOrderCellIdentifier owner:nil options:nil].firstObject;
    }
    return self;
}

- (void)awakeFromNib {
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = LINE_LIGHTGRAY.CGColor;
    
    self.middleView.layer.borderWidth = 0.5;
    self.middleView.layer.borderColor = LINE_LIGHTGRAY.CGColor;
    
    self.lookWuLiuButton.layer.cornerRadius = 3.0f;
}

- (void)updateViewWithModel:(YiYuanGouModel *)model {
    
    self.orderStatusLabel.text = model.OrderStatus;
    [self.imageView setImageWithURL:model.OriginalImgeURL placeholderImage:[UIImage imageNamed:@"nopic"]];
    self.productNameLabel.text = model.Name;
    self.productCountLabel.text = [NSString stringWithFormat:@"x%@", model.BuyNumber.stringValue];
    self.isStartLabel.text = model.RewardStatus;
    self.totalPriceLabel.text = [NSString stringWithFormat:@"AU$%.2f", model.AllMoney.doubleValue];
    
    if ([model.RewardStatus isEqualToString:@"已开奖"]) {
        [self.isStartLabel setTextColor:MAIN_ORANGE];
        // TODO: 开奖号码
        
    } else if ([model.RewardStatus isEqualToString:@"未开奖"]) {
        [self.isStartLabel setTextColor:FONT_BLACK];
    }
    if ([model.OrderStatus isEqualToString:@"待付款"]) {
        self.lookWuLiuButton.hidden = NO;
    } else {
        self.lookWuLiuButton.hidden = YES;
    }
}

- (IBAction)checkLogistics:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didSelectCheckLogistics)]) {
        [self.delegate didSelectCheckLogistics];
    }
}


@end
