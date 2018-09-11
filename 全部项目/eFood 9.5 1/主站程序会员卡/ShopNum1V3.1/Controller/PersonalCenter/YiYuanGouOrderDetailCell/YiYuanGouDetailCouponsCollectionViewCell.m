//
//  YiYuanGouDetailCouponsCollectionViewCell.m
//  ShopNum1V3.1
//
//  Created by Mac on 15/12/31.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "YiYuanGouDetailCouponsCollectionViewCell.h"
#import "YiYuanGouModel.h"
#import "CouponInfoModel.h"

NSString *const kYiYuanGouDetailCouponsCellIdentifier = @"YiYuanGouDetailCouponsCollectionViewCell";

@interface YiYuanGouDetailCouponsCollectionViewCell ()

// 抽奖号码
@property (weak, nonatomic) IBOutlet UILabel *luckyNumberLabel;


@end

@implementation YiYuanGouDetailCouponsCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[NSBundle mainBundle] loadNibNamed:kYiYuanGouDetailCouponsCellIdentifier owner:nil options:nil].firstObject;
    }
    return self;
}

- (void)awakeFromNib {
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = LINE_LIGHTGRAY.CGColor;
}

// 有多个抽奖号码时，循环加入label，行高增加25*个数
- (void)updateViewWithModel:(YiYuanGouModel *)model {
    
    CouponInfoModel *couponModel = model.coupons.firstObject;
    self.luckyNumberLabel.attributedText = [self couponsTextWithCouponInfoModel:couponModel index:1];
    if (model.isExtend) {
        self.arrowImageView.image = [UIImage imageNamed:@"arrow_down"];
    } else {
        self.arrowImageView.image = [UIImage imageNamed:@"arrow_up"];
    }
    
    // 多个抽奖券信息
    if (model.coupons.count > 1) {
        for (int i=1; i<model.coupons.count; i++) {
            CouponInfoModel *couponModel = model.coupons[i];
            UILabel *label = (UILabel *)[self viewWithTag:i];
            if (!label) {
                label = [[UILabel alloc] initWithFrame:self.luckyNumberLabel.frame];
                label.tag = i;
                label.frame = CGRectOffset(label.frame, 0, i * CGRectGetHeight(label.frame));
                label.font = [UIFont systemFontOfSize:13.0f];
                label.textColor = [UIColor colorWithWhite:0.205 alpha:1.000];
                label.attributedText = [self couponsTextWithCouponInfoModel:couponModel index:i+1];
                [self addSubview:label];
            }
        }
    }
}


- (NSMutableAttributedString *)couponsTextWithCouponInfoModel:(CouponInfoModel *)model index:(NSInteger)index{
    
    if ([model.Status isEqualToString:@"中奖"]) {
        NSString *winText = [NSString stringWithFormat:@"%@【中奖】", model.TestLuckyCode];
        NSString *showText = [NSString stringWithFormat:@"抽奖号码%d %@", index, winText];
        NSMutableAttributedString *showAttributeStr = [[NSMutableAttributedString alloc] initWithString:showText];
        [showAttributeStr addAttribute:NSForegroundColorAttributeName value:MAIN_ORANGE range:[showText rangeOfString:winText]];
        return showAttributeStr;
    } else {
        NSString *showText = [NSString stringWithFormat:@"抽奖号码%d %@【未中奖】", index, model.TestLuckyCode];
        NSMutableAttributedString *showAttributeStr = [[NSMutableAttributedString alloc] initWithString:showText];
        [showAttributeStr addAttribute:NSForegroundColorAttributeName value:FONT_BLACK range:[showText rangeOfString:showText]];
        return showAttributeStr;
    }
}


//NSString *priceStr = [NSString stringWithFormat:@"抢购价AU$%.2f", model.PanicBuyingPrice.doubleValue];
//NSMutableAttributedString *price = [[NSMutableAttributedString alloc]initWithString:priceStr];
////        priceStr rangeOfString:@"抢购价"
//
//
//[price addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[priceStr rangeOfString:priceStr]];
//[price addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:[priceStr rangeOfString:@"抢购价"]];
//self.priceLabel.attributedText = price;

@end
