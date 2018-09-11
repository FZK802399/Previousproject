//
//  BanJiaCollectionViewCell.m
//  ShopNum1V3.1
//
//  Created by Mac on 15/12/23.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "BanJiaCollectionViewCell.h"
#import "FloorProductModel.h"

NSString *const kBanJiaCollectionViewCell = @"BanJiaCollectionViewCell";

@interface BanJiaCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (weak, nonatomic) IBOutlet UILabel *rmbLabel;

@end

@implementation BanJiaCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame  {
    self = [super initWithFrame:frame];
    self = [[NSBundle mainBundle]loadNibNamed:kBanJiaCollectionViewCell owner:nil options:nil].firstObject;
    return self;
}

- (void)awakeFromNib {
    self.buyButton.layer.cornerRadius = 3.0f;
}

+ (CGSize)banJiaCellsize {
    CGFloat width = (SCREEN_WIDTH - 1.5f) / 3.0f;
//    CGFloat height = width * 1.69f;
    CGFloat height = width + 100;
    return CGSizeMake(width, height);
}

- (void)updateViewWithModel:(FloorProductModel *)model {
    [self.imageView setImageWithURL:model.OriginalImgeURL placeholderImage:[UIImage imageNamed:@"nopic"]];
    self.titleLabel.text = model.Name;
    self.priceLabel.text = [NSString stringWithFormat:@"AU$%.2f", model.ShopPrice.doubleValue];
    self.discountLabel.text = [NSString stringWithFormat:@"%.1f折", model.ShopPrice.doubleValue / model.MarketPrice.doubleValue * 10];
    self.rmbLabel.text = [NSString stringWithFormat:@"约¥%.2f",model.MarketPrice.doubleValue];
}

@end
