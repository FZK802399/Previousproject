//
//  ProductListCell.m
//  HomePage
//
//  Created by 梁泽 on 15/11/20.
//  Copyright © 2015年 right. All rights reserved.
//

#import "ProductListCell.h"
#import "ProductInfoMode.h"
#import "UIImageView+AFNetworking.h"
NSString *const kProductListCell = @"ProductListCell";
@interface ProductListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *rmbLabel;

@end
@implementation ProductListCell
+ (CGSize) itemSizeForColumn:(NSInteger)column padding:(CGFloat)padding{
    CGFloat width = (LZScreenWidth-(column-1)*padding)/column;
    CGFloat height = width + 40 + 21;
    return CGSizeMake(width, height);
}
- (instancetype) initWithFrame:(CGRect)frame  {
    self = [super initWithFrame:frame];
    self = [[NSBundle mainBundle]loadNibNamed:kProductListCell owner:nil options:nil].firstObject;
    return self;
}
- (void)awakeFromNib {
    // Initialization code
 }

- (void) setMode:(id)mode {
    if ([mode isKindOfClass:[ProductInfoMode class]]) {
        ProductInfoMode *model = mode;
//        [self.icon setImageWithURL:[NSURL URLWithString:[model.OriginalImge stringByReplacingOccurrencesOfString:@"180" withString:@"300"]] placeholderImage:[UIImage imageNamed:@"nopic"]];
         [self.icon setImageWithURL:[NSURL URLWithString:model.OriginalImge] placeholderImage:[UIImage imageNamed:@"nopic"]];
        self.titleLable.text = model.Name;
        self.priceLabel.text = [NSString stringWithFormat:@"AU$%.2f",model.ShopPrice.doubleValue];
        self.rmbLabel.text = [NSString stringWithFormat:@"约¥%.2f",model.MarketPrice.doubleValue];
        
        
    }
}
@end
