//
//  MemberCollectionViewCell.m
//  ShopNum1V3.1
//
//  Created by Mac on 15/12/23.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "MemberCollectionViewCell.h"
#import "MemberFloorProductModel.h"

NSString *const kMemberCollectionViewCell = @"MemberCollectionViewCell";

@interface MemberCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation MemberCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame  {
    self = [super initWithFrame:frame];
    self = [[NSBundle mainBundle]loadNibNamed:kMemberCollectionViewCell owner:nil options:nil].firstObject;
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

+ (CGSize)memberCellSize {
    CGFloat width = (SCREEN_WIDTH - 1.5f) / 3.0f;
    CGFloat height = width * 0.84f;
    return CGSizeMake(width, height);
}

- (void)updateViewWithModel:(MemberFloorProductModel *)model {
    [self.imageView setImageWithURL:[NSURL URLWithString:model.BackgroundImage] placeholderImage:[UIImage imageNamed:@"nopic"]];
    self.titleLabel.text = model.Name;
}

@end
