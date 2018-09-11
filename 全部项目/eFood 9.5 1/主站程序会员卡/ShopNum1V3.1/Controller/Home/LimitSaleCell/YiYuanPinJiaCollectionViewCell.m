//
//  YiYuanPinJiaCollectionViewCell.m
//  ShopNum1V3.1
//
//  Created by Mac on 15/12/29.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "YiYuanPinJiaCollectionViewCell.h"

NSString *const kYiYuanPinJiaCellIdentifier = @"YiYuanPinJiaCollectionViewCell";

@interface YiYuanPinJiaCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *pinJiaCountLabel;

@end

@implementation YiYuanPinJiaCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)updateViewWithPinJiaCount:(NSInteger)count {
    self.pinJiaCountLabel.text = [NSString stringWithFormat:@"(%d)", count];
}

@end
