//
//  TeJiaView.m
//  ShopNum1V3.1
//
//  Created by Mac on 15/12/23.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "TeJiaView.h"
#import "FloorProductModel.h"

@interface TeJiaView ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *firstTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (weak, nonatomic) IBOutlet UILabel *salePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *originalPriceLabel;


@end

@implementation TeJiaView

+ (instancetype)teJiaViewWithFrame:(CGRect)frame {
    TeJiaView *view = [TeJiaView teJiaView];
    view.frame = frame;
    return view;
}

+ (instancetype)teJiaView {
    return [[NSBundle mainBundle]loadNibNamed:@"TeJiaView" owner:nil options:nil].firstObject;
}

- (void)updateViewWithModel:(FloorProductModel *)model {
    [self.imageView setImageWithURL:model.OriginalImgeURL placeholderImage:[UIImage imageNamed:@"nopic"]];
    self.firstTitleLabel.text = model.Name;
    self.titleLabel.text = model.Name;
    self.salePriceLabel.text = [NSString stringWithFormat:@"特价:AU$%.2f", model.ShopPrice.doubleValue];
    self.originalPriceLabel.text = [NSString stringWithFormat:@"AU$%.2f", model.MarketPrice.doubleValue];
    self.discountLabel.text = [NSString stringWithFormat:@"%.1f折", [model.ShopPrice doubleValue] / [model.MarketPrice doubleValue] * 10];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
