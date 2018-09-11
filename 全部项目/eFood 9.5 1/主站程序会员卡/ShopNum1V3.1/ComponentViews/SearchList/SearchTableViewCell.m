//
//  SearchTableViewCell.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-13.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "SearchTableViewCell.h"

@implementation SearchTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat height = 105;
        CGFloat width = SCREEN_WIDTH;
        CGFloat originX = 5;
        CGFloat originY = 5;
        
        if(_showImage == nil){
            _showImage = [[UIImageView alloc] initWithFrame:CGRectMake(originX, originY, height - 10, 95)];
            
            [self.contentView addSubview:_showImage];
        }
        
//        UIColor *darkColor = [UIColor colorWithRed:124 /255.0f green:124 /255.0f blue:124 /255.0f alpha:1];
        UIFont *fontSize = [UIFont systemFontOfSize:14.0f];
        originX = originX + _showImage.frame.size.width;
        
        if(_nameLabel == nil){
            _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX + 10, originY + 5, SCREEN_WIDTH - CGRectGetWidth(_showImage.frame) - 20, 35)];
            _nameLabel.textColor = [UIColor colorFromHexRGB:@"606366"];
            _nameLabel.numberOfLines = 3;
            _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping;
            _nameLabel.font = fontSize;
            _nameLabel.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:_nameLabel];
        }
        
        if(_ShopPriceLabel == nil){
            _ShopPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX + 10, CGRectGetMaxY(_showImage.frame) - 30 , 85, 20)];
            _ShopPriceLabel.textColor = [UIColor colorFromHexRGB:@"e32424"];
            _ShopPriceLabel.font = [UIFont systemFontOfSize:16.0f];
            _ShopPriceLabel.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:_ShopPriceLabel];
        }
        
        if(_MarketPriceLabel == nil){
            _MarketPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX + 90, originY + 40, 95, 15)];
            _MarketPriceLabel.textColor = [UIColor colorWithRed:187 /255.0f green:187 /255.0f blue:175 /255.0f alpha:1];
            _MarketPriceLabel.font = fontSize;
            _MarketPriceLabel.lineBreakMode = NSLineBreakByCharWrapping;
            _MarketPriceLabel.backgroundColor = [UIColor clearColor];
//            [self.contentView addSubview:_MarketPriceLabel];
        }
        
        if(_saleNumLabel == nil){
            _saleNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX + 5, CGRectGetMaxY(_ShopPriceLabel.frame), 100, 15)];
            _saleNumLabel.textColor = [UIColor colorWithRed:187 /255.0f green:187 /255.0f blue:175 /255.0f alpha:1];
            _saleNumLabel.font = fontSize;
            _saleNumLabel.lineBreakMode = NSLineBreakByCharWrapping;
            _saleNumLabel.backgroundColor = [UIColor clearColor];
//            [self.contentView addSubview:_saleNumLabel];
        }
        
        if (!_detailButton) {
            _detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _detailButton.frame = CGRectMake(width - 26, 42, 20, 20);
            [_detailButton setImage:[UIImage imageNamed:@"btn_detail_normal.png"] forState:UIControlStateNormal];
            [_detailButton setImage:[UIImage imageNamed:@"btn_detail_normal.png"] forState:UIControlStateDisabled];
            [_detailButton setEnabled:NO];
//            [self.contentView addSubview:_detailButton];
        }
        
//        [self.contentView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_patterns.png"]]];
        
        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.borderColor = [UIColor colorWithWhite:0.892 alpha:1.000].CGColor;
        bottomBorder.frame = CGRectMake(0, height - 0.5, SCREEN_WIDTH, 0.5);
        bottomBorder.borderWidth = 0.5;
        [self.contentView.layer addSublayer:bottomBorder];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)creatSearchTableViewCellWithMerchandiseIntroModel:(MerchandiseIntroModel *)intro{
    UIImage *blankImg = [UIImage imageNamed:@"nopic"];
    [self.showImage setImageWithURL:intro.originalImage placeholderImage:blankImg];
    [self.nameLabel setText:[intro.name stringByReplacingOccurrencesOfString:@" " withString:@""]];
    [self.ShopPriceLabel setText:[NSString stringWithFormat:@"AU$ %.2f", intro.shopPrice]];
    [self.saleNumLabel setText:[NSString stringWithFormat:@"最近售出:%d", intro.buyCount]];
    NSString * tempStr = [NSString stringWithFormat:@"AU$ %.2f", intro.marketPrice];
    NSMutableAttributedString * MarketPriceStr = [[NSMutableAttributedString alloc] initWithString:tempStr];
    NSRange range = {0 , tempStr.length};
    [MarketPriceStr addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:range];
    [self.MarketPriceLabel setAttributedText:MarketPriceStr];
    
//    [self.saleNumLabel setText:[NSString stringWithFormat:@"最近售出：%d",intro.buyCount]];
}

-(void)creatSearchTableViewCellWithScoreProductIntroModel:(ScoreProductIntroModel *)intro{
    UIImage *blankImg = [UIImage imageNamed:@"nopic"];
    [self.showImage setImageWithURL:intro.originalImage placeholderImage:blankImg];
    [self.nameLabel setText:[intro.name stringByReplacingOccurrencesOfString:@" " withString:@""]];
    [self.ShopPriceLabel setText:[NSString stringWithFormat:@"AU$ %.2f", intro.prmo]];

    self.MarketPriceLabel.text = [NSString stringWithFormat:@"%d积分", intro.ExchangeScore];
    
    //    [self.saleNumLabel setText:[NSString stringWithFormat:@"最近售出：%d",intro.buyCount]];
}

@end
