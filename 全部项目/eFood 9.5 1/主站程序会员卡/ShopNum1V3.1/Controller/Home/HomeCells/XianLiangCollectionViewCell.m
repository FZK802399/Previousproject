//
//  XianLiangCollectionViewCell.m
//  ShopNum1V3.1
//
//  Created by Mac on 15/12/28.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "XianLiangCollectionViewCell.h"
#import "SaleProductModel.h"

NSString *const kXianLiangCellIdentifier = @"XianLiangCollectionViewCell";

@interface XianLiangCollectionViewCell ()
// 100
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel_100;
@property (weak, nonatomic) IBOutlet UILabel *secondNameLabel_100;
@property (weak, nonatomic) IBOutlet UILabel *limitCountLabel_100;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_100;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *goBuyLabel;


// 101
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel_101;
@property (weak, nonatomic) IBOutlet UILabel *secondNameLabel_101;
@property (weak, nonatomic) IBOutlet UILabel *limitCountLabel_101;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_101;

// 102
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel_102;
@property (weak, nonatomic) IBOutlet UILabel *secondNameLabel_102;
@property (weak, nonatomic) IBOutlet UILabel *limitCountLabel_102;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_102;


@end

@implementation XianLiangCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame  {
    self = [super initWithFrame:frame];
    self = [[NSBundle mainBundle]loadNibNamed:kXianLiangCellIdentifier owner:nil options:nil].firstObject;
    return self;
}

- (void)awakeFromNib {
    self.goBuyLabel.layer.cornerRadius = 2.0f;
    self.goBuyLabel.clipsToBounds = YES;
    
    self.limitCountLabel_100.layer.borderColor = self.limitCountLabel_100.textColor.CGColor;
    self.limitCountLabel_100.layer.borderWidth = 1.0f;
    self.limitCountLabel_100.layer.cornerRadius = 2.0f;
    
    self.limitCountLabel_101.layer.borderColor = self.limitCountLabel_101.textColor.CGColor;
    self.limitCountLabel_101.layer.borderWidth = 1.0f;
    self.limitCountLabel_101.layer.cornerRadius = 2.0f;
    
    self.limitCountLabel_102.layer.borderColor = self.limitCountLabel_102.textColor.CGColor;
    self.limitCountLabel_102.layer.borderWidth = 1.0f;
    self.limitCountLabel_102.layer.cornerRadius = 2.0f;
    
}

- (void)updateViewWithSaleProductModels:(NSArray *)models {
    if (models && models.count > 0) {
        if (models.count > 0) {
            SaleProductModel *model_100 = models[0];
//            self.firstNameLabel_100.text = model_100.Name;
            self.secondNameLabel_100.text = model_100.Name;
            self.limitCountLabel_100.text = [NSString stringWithFormat:@"限%@件", model_100.RestrictCount.stringValue];
            [self.imageView_100 setImageWithURL:model_100.OriginalImgeURL placeholderImage:[UIImage imageNamed:@"nopic"]];
            self.priceLabel.text = [NSString stringWithFormat:@"AU$%@", model_100.PanicBuyingPrice.stringValue];
        }
        
        if (models.count > 1) {
            SaleProductModel *model_101 = models[1];
//            self.firstNameLabel_101.text = model_101.Name;
            self.secondNameLabel_101.text = model_101.Name;
            [self.imageView_101 setImageWithURL:model_101.OriginalImgeURL placeholderImage:[UIImage imageNamed:@"nopic"]];
            self.limitCountLabel_101.text = [NSString stringWithFormat:@"限%@件", model_101.RestrictCount.stringValue];
        }
        
        if (models.count > 2) {
            SaleProductModel *model_102 = models[2];
//            self.firstNameLabel_102.text = model_102.Name;
            self.secondNameLabel_102.text = model_102.Name;
            [self.imageView_102 setImageWithURL:model_102.OriginalImgeURL placeholderImage:[UIImage imageNamed:@"nopic"]];
            self.limitCountLabel_102.text = [NSString stringWithFormat:@"限%@件", model_102.RestrictCount.stringValue];
        }
        
    }
}

- (IBAction)didSelectItemAtIndex:(UIView *)sender {
    NSInteger tag = sender.tag - 100;
    if ([self.delegate respondsToSelector:@selector(didSelectXianLiangCellAtIndex:)]) {
        [self.delegate didSelectXianLiangCellAtIndex:tag];
    }
}


@end
