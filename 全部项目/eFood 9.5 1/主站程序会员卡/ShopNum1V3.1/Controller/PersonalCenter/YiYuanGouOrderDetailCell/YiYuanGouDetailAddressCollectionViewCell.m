//
//  YiYuanGouDetailAddressCollectionViewCell.m
//  ShopNum1V3.1
//
//  Created by Mac on 15/12/31.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "YiYuanGouDetailAddressCollectionViewCell.h"
#import "YiYuanGouModel.h"

NSString *const kYiYuanGouDetailAddressCellIdentifier = @"YiYuanGouDetailAddressCollectionViewCell";

@interface YiYuanGouDetailAddressCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameAndPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation YiYuanGouDetailAddressCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[NSBundle mainBundle] loadNibNamed:kYiYuanGouDetailAddressCellIdentifier owner:nil options:nil].firstObject;
    }
    return self;
}

- (void)awakeFromNib {
    self.layer.borderColor = LINE_LIGHTGRAY.CGColor;
    self.layer.borderWidth = 0.5f;
}

- (void)updateViewWithModel:(YiYuanGouModel *)model {
    self.nameAndPhoneLabel.text = [NSString stringWithFormat:@"%@  %@", model.NameInfo, model.Mobile];
    self.addressLabel.text = model.Address;
}

@end
