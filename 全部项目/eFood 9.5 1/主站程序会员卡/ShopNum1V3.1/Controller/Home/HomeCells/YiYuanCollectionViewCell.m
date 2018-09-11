//
//  YiYuanCollectionViewCell.m
//  ShopNum1V3.1
//
//  Created by Mac on 15/12/22.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "YiYuanCollectionViewCell.h"
#import "YiYuanGouModel.h"

NSString *const kYiYuanCollectionViewCell = @"YiYuanCollectionViewCell";

@interface YiYuanCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *yiShoulabel;
@property (weak, nonatomic) IBOutlet UILabel *allLabel;


@end

@implementation YiYuanCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame  {
    self = [super initWithFrame:frame];
    self = [[NSBundle mainBundle]loadNibNamed:kYiYuanCollectionViewCell owner:nil options:nil].firstObject;
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)updateViewWithModel:(YiYuanGouModel *)model {
    self.nameLabel.text = model.Name;
    self.yiShoulabel.text = [NSString stringWithFormat:@"%d",model.RestrictCount.integerValue - model.ResidueNumber.integerValue];
    self.allLabel.text = model.RestrictCount.stringValue;
    [self.imageView setImageWithURL:model.OriginalImgeURL placeholderImage:[UIImage imageNamed:@"nopic"]];
}

@end
