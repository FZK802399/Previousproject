//
//  YiYuanGouCollectionViewCell.m
//  ShopNum1V3.1
//
//  Created by Mac on 15/12/29.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "YiYuanGouCollectionViewCell.h"
#import "YiYuanGouModel.h"

NSString *const kYiYuanGouCellIdentifier = @"YiYuanGouCollectionViewCell";

@interface YiYuanGouCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *yiShouLabel;
@property (weak, nonatomic) IBOutlet UILabel *allLabel;
@property (weak, nonatomic) IBOutlet UILabel *goBugLabel;


@end

@implementation YiYuanGouCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame  {
    self = [super initWithFrame:frame];
    self = [[NSBundle mainBundle]loadNibNamed:kYiYuanGouCellIdentifier owner:nil options:nil].firstObject;
    return self;
}

- (void)awakeFromNib {
    self.goBugLabel.layer.cornerRadius = 3.0f;
    self.goBugLabel.layer.masksToBounds = YES;
}

- (void)updateViewWithModel:(YiYuanGouModel *)model {
    [self.imageView setImageWithURL:model.OriginalImgeURL placeholderImage:[UIImage imageNamed:@"nopic"]];
    self.nameLabel.text = model.Name;
    self.yiShouLabel.text = [NSString stringWithFormat:@"%d", model.RestrictCount.integerValue - model.ResidueNumber.integerValue];
    self.allLabel.text = model.RestrictCount.stringValue;
}



@end
