//
//  XianShiQiangCell.m
//  HomePage
//
//  Created by 梁泽 on 15/11/20.
//  Copyright © 2015年 right. All rights reserved.
//

#import "XianShiQiangCell.h"
#import "XianShiQiangMode.h"
#import "UIImageView+AFNetworking.h"
NSString *const kXianShiQiangCell = @"XianShiQiangCell";
@interface XianShiQiangCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;


@end
@implementation XianShiQiangCell

- (instancetype) initWithFrame:(CGRect)frame  {
    self = [super initWithFrame:frame];
    self = [[NSBundle mainBundle]loadNibNamed:kXianShiQiangCell owner:nil options:nil].firstObject;
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void) setMode:(id)mode {
    _mode = mode;
    if ([mode isKindOfClass:[XianShiQiangMode class]]) {
        XianShiQiangMode *model = (XianShiQiangMode*)mode;
        [self.imageView setImageWithURL:[NSURL URLWithString:model.OriginalImge] placeholderImage:[UIImage imageNamed:@"nopic"]];
        self.nameLable.text = model.Name;
        NSString *priceStr = [NSString stringWithFormat:@"抢购价AU$%.2f", model.PanicBuyingPrice.doubleValue];
        NSMutableAttributedString *price = [[NSMutableAttributedString alloc]initWithString:priceStr];
//        priceStr rangeOfString:@"抢购价"
        
        
        [price addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[priceStr rangeOfString:priceStr]];
        [price addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:[priceStr rangeOfString:@"抢购价"]];
        self.priceLabel.attributedText = price;
    }
}
@end
