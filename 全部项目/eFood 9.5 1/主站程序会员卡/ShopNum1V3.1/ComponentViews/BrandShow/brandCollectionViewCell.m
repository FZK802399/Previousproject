//
//  brandCollectionViewCell.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-9.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "brandCollectionViewCell.h"

@implementation brandCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGFloat width = (SCREEN_WIDTH - 9) / 4.0f;
        CGFloat height = width * 1.2;
        
        if (self.showImage == nil) {
            self.showImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, width - 10, height - 30)];
            [self.showImage setContentMode:UIViewContentModeScaleAspectFit];
            [self.contentView addSubview:self.showImage];
            
        }
        if (self.nameLabel == nil) {
            self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.showImage.frame), CGRectGetMaxY(self.showImage.frame) + 5, width - 10, 20)];
            self.nameLabel.textAlignment = NSTextAlignmentCenter;
            self.nameLabel.textColor = FONT_DARKGRAY;
            self.nameLabel.font = [UIFont workListDetailFont];
            self.nameLabel.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:self.nameLabel];
        }
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)creatbrandCollectionViewCellWithMerchandiseIntroModel:(BrandModel *)intro{
    [self.showImage setImageWithURL:[NSURL URLWithString:intro.logoStr] placeholderImage:[UIImage imageNamed:@"nopic"]];
    self.nameLabel.text = intro.name;
}

- (void)creatSortCollectionViewCellWithMerchandiseIntroModel:(SortModel *) intro{
    [self.showImage setImageWithURL:intro.BackgroundImage placeholderImage:[UIImage imageNamed:@"nopic"]];
    self.nameLabel.text = intro.Name;
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
