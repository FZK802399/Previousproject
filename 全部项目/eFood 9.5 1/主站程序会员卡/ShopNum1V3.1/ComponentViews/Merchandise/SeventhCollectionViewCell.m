//
//  SeventhCollectionViewCell.m
//  Shop
//
//  Created by Mac on 15/10/23.
//  Copyright (c) 2015年 ocean. All rights reserved.
//

#import "SeventhCollectionViewCell.h"
#import "MerchandiseIntroModel.h"
#import "ScoreProductIntroModel.h"

@implementation SeventhCollectionViewCell

- (void)awakeFromNib {
//    [self.contentView.layer setBorderColor:SeparateLine_Color.CGColor];
//    [self.contentView.layer setBorderWidth:0.5];
}

-(void)creatSearchTableViewCellWithMerchandiseIntroModel:(MerchandiseIntroModel *)intro{
    UIImage *blankImg = [UIImage imageNamed:@"nopic"];
    [self.picImageView setImageWithURL:intro.originalImage placeholderImage:blankImg];
    [self.titleLabel setText:[intro.name stringByReplacingOccurrencesOfString:@" " withString:@""]];
    [self.priceLabel setText:[NSString stringWithFormat:@"AU$ %.2f", intro.shopPrice]];
    self.rmbLabel.text = [NSString stringWithFormat:@"约¥%.2f",intro.marketPrice];
//    NSString * tempStr = [NSString stringWithFormat:@"AU$ %.2f", intro.marketPrice];
//    NSMutableAttributedString * MarketPriceStr = [[NSMutableAttributedString alloc] initWithString:tempStr];
//    NSRange range = {0 , tempStr.length};
//    [MarketPriceStr addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:range];
//    [self.MarketPriceLabel setAttributedText:MarketPriceStr];
    
    //    [self.saleNumLabel setText:[NSString stringWithFormat:@"最近售出：%d",intro.buyCount]];
}

-(void)creatSearchTableViewCellWithScoreProductIntroModel:(ScoreProductIntroModel *)intro{
    UIImage *blankImg = [UIImage imageNamed:@"nopic"];
    [self.picImageView setImageWithURL:intro.originalImage placeholderImage:blankImg];
    [self.titleLabel setText:[intro.name stringByReplacingOccurrencesOfString:@" " withString:@""]];
    [self.priceLabel setText:[NSString stringWithFormat:@"AU$ %.2f", intro.prmo]];
//    self.MarketPriceLabel.text = [NSString stringWithFormat:@"%d积分", intro.ExchangeScore];
    
    //    [self.saleNumLabel setText:[NSString stringWithFormat:@"最近售出：%d",intro.buyCount]];
}

@end
