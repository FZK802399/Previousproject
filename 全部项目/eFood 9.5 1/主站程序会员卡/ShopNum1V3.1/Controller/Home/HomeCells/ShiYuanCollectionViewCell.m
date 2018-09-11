//
//  ShiYuanCollectionViewCell.m
//  ShopNum1V3.1
//
//  Created by Mac on 15/12/23.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "ShiYuanCollectionViewCell.h"
#import "FloorProductModel.h"

NSString *const kShiYuanCollectionViewCell = @"ShiYuanCollectionViewCell";

@interface ShiYuanCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (weak, nonatomic) IBOutlet UILabel *rmbLabel;

@end

@implementation ShiYuanCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame  {
    self = [super initWithFrame:frame];
    self = [[NSBundle mainBundle]loadNibNamed:kShiYuanCollectionViewCell owner:nil options:nil].firstObject;
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

+ (CGSize)shiYuanCellSize {
    CGFloat width = SCREEN_WIDTH / 2.0 - 0.5f;
//    CGFloat height = width * 0.69f;
    CGFloat height = 100.0f;
    return CGSizeMake(width, height);

}

- (void)updateViewWithModel:(FloorProductModel *)model {
    [self.imageView setImageWithURL:model.OriginalImgeURL placeholderImage:[UIImage imageNamed:@"nopic"]];
    self.titleLabel.text = model.Name;
    self.priceLabel.text = [NSString stringWithFormat:@"AU$%@", [model.ShopPrice stringValue]];
    self.discountLabel.text = [NSString stringWithFormat:@"%.1f折", [model.ShopPrice doubleValue] / [model.MarketPrice doubleValue] * 10];
    self.rmbLabel.text = [NSString stringWithFormat:@"约¥%.2f",model.MarketPrice.doubleValue];
}

@end
