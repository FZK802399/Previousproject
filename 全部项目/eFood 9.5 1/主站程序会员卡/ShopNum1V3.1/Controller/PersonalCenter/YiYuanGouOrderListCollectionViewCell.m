//
//  YiYuanGouOrderListCollectionViewCell.m
//  ShopNum1V3.1
//
//  Created by Mac on 15/12/31.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "YiYuanGouOrderListCollectionViewCell.h"
#import "YiYuanGouModel.h"

NSString *const kYiYuanGouOrderListCellIdentifier = @"YiYuanGouOrderListCollectionViewCell";

@interface YiYuanGouOrderListCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel; // 状态
@property (weak, nonatomic) IBOutlet UILabel *isStartLabel; // 是否开奖

@property (weak, nonatomic) IBOutlet UILabel *totalNameLabel;// 总价或开奖号码
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;// 价格或中奖号

@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *productCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UIButton *goBuyButton;

@property (strong, nonatomic) YiYuanGouModel *model;

@end

@implementation YiYuanGouOrderListCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[NSBundle mainBundle]loadNibNamed:kYiYuanGouOrderListCellIdentifier owner:nil options:nil].firstObject;
    }
    return self;
}

- (void)awakeFromNib {
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = LINE_LIGHTGRAY.CGColor;
    
    self.middleView.layer.borderWidth = 0.5;
    self.middleView.layer.borderColor = LINE_LIGHTGRAY.CGColor;
    
    self.goBuyButton.layer.cornerRadius = 3.0f;
}

- (void)updateViewWithModel:(YiYuanGouModel *)model {
    self.model = model;
    self.orderStatusLabel.text = model.OrderStatus;
    [self.imageView setImageWithURL:model.OriginalImgeURL placeholderImage:[UIImage imageNamed:@"nopic"]];
    self.productNameLabel.text = model.Name;
    self.productCountLabel.text = [NSString stringWithFormat:@"x%@", model.BuyNumber.stringValue];
    self.isStartLabel.text = model.RewardStatus;
    
    if ([model.RewardStatus isEqualToString:@"已开奖"]) {
        [self.isStartLabel setTextColor:MAIN_ORANGE];
        self.totalNameLabel.text = @"开奖号码";
        self.totalPriceLabel.text = model.LuckyCode;
    } else {
        [self.isStartLabel setTextColor:FONT_BLACK];
        self.totalNameLabel.text = @"总价";
        self.totalPriceLabel.text = [NSString stringWithFormat:@"AU$%.2f", model.AllMoney.doubleValue];
        if ([model.OrderStatus isEqualToString:@"待付款"]) {
            self.goBuyButton.hidden = NO;
        } else {
            self.goBuyButton.hidden = YES;
        }
    }
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    if ([self.model.OrderStatus isEqualToString:@"待付款"]) {
//        return;
//    }
//}


- (IBAction)didSelectGoBuy:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didSelectGoBuy:)]) {
        [self.delegate didSelectGoBuy:self];
    }
}

@end
