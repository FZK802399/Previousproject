//
//  recommend CollectionViewCell.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-7.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "recommendCollectionViewCell.h"

@implementation recommendCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat height = 206;
        CGFloat width = 152;
        CGFloat originX = 0;
        CGFloat originY = 0;
        if (self.showImage == nil) {
            self.showImage = [[UIImageView alloc] initWithFrame:CGRectMake(originX, originY, width-4, height - 54)];
            [self.showImage setContentMode:UIViewContentModeCenter];
            [self.contentView addSubview:self.showImage];
//            self.showImage.layer.borderWidth = 1;
//            self.showImage.layer.borderColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1].CGColor;
            
        }
        
        if (self.ScoreLabel == nil) {
            self.ScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, self.showImage.frame.size.height - 14, width-4, 14)];
            self.ScoreLabel.textAlignment = NSTextAlignmentCenter;
            self.ScoreLabel.textColor = [UIColor whiteColor];
            self.ScoreLabel.backgroundColor = [UIColor blackColor];
            self.ScoreLabel.alpha = 0.6;
            self.ScoreLabel.font = [UIFont systemFontOfSize:8.5f];
            [self.contentView addSubview:self.ScoreLabel];
            [self.ScoreLabel setHidden:YES];
        }
        
        if (self.priceLabel == nil) {
            self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, height - 54 + 5, width-4, 14)];
            self.priceLabel.textAlignment = NSTextAlignmentCenter;
            self.priceLabel.textColor = [UIColor colorFromHexRGB:@"e32424"];
            self.priceLabel.font = [UIFont workListDetailFont];
            [self.contentView addSubview:self.priceLabel];
            
        }
        if (self.nameLabel == nil) {
            self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, height - 29, width-4, 16)];
            self.nameLabel.textAlignment = NSTextAlignmentCenter;
            self.nameLabel.textColor = [UIColor colorFromHexRGB:@"606366"];
            self.nameLabel.font = [UIFont workListDetailFont];
            [self.contentView addSubview:self.nameLabel];
            
        }
        self.contentView.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

-(void)creatrecommendCollectionViewCellWithMerchandiseIntroModel:(MerchandiseIntroModel *)intro{
    
    UIImage *blankImg = [UIImage imageNamed:@"nopic"];
    [self.showImage setImageWithURL:intro.originalImage placeholderImage:blankImg];
    
    self.priceLabel.text = [NSString stringWithFormat:@"AU$ %.2f", intro.shopPrice];
    
    self.nameLabel.text = intro.name;
    [self.ScoreLabel setHidden:YES];
//    if (intro.scorePrice > 0) {
//       
//        self.ScoreLabel.text = [NSString stringWithFormat:@"可用积分抵AU$ %.2f",intro.scorePrice];
//    }
    
}

-(void)creatrecommendCollectionViewCellWithScoreProductIntroModel:(ScoreProductIntroModel *)intro{
    
    UIImage *blankImg = [UIImage imageNamed:@"nopic"];
    [self.showImage setImageWithURL:intro.originalImage placeholderImage:blankImg];
    
    self.priceLabel.text = [NSString stringWithFormat:@"AU$ %.2f", intro.prmo];
    
    self.nameLabel.text = intro.name;
    
    [self.ScoreLabel setHidden:NO];
    self.ScoreLabel.text = [NSString stringWithFormat:@"可用积分 %d",intro.ExchangeScore];
//    if (intro.scorePrice > 0) {
//        [self.ScoreLabel setHidden:NO];
//        self.ScoreLabel.text = [NSString stringWithFormat:@"可用积分抵AU$ %.2f",intro.scorePrice];
//    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
