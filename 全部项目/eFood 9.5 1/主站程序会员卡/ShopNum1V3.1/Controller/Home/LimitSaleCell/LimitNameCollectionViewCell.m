//
//  LimitNameCollectionViewCell.m
//  ShopNum1V3.1
//
//  Created by Mac on 15/12/24.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "LimitNameCollectionViewCell.h"
#import "PanicBuyingModel.h"

NSString *const kLimitListCellIdentifier = @"LimitNameCollectionViewCell";

@interface LimitNameCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (strong, nonatomic) PanicBuyingModel *model;

@end

@implementation LimitNameCollectionViewCell

- (void)awakeFromNib {
    self.imageView.layer.cornerRadius = CGRectGetWidth(self.imageView.frame) / 2;
    self.imageView.clipsToBounds = YES;
}

- (void)updateViewWithModel:(id)model {
    if ([model isKindOfClass:[PanicBuyingModel class]]) {
        self.model = model;
        [self.imageView setImageWithURL:self.model.photoURL placeholderImage:[UIImage imageNamed:@"userphoto"]];
        self.nickNameLabel.text = self.model.MemLoginID;
        self.phoneLabel.text = self.model.Message;
        self.dateLabel.text = self.model.ConfirmTime;
    }
}

@end
