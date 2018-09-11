//
//  FIrstCollectionViewCell.m
//  ShopNum1V3.1
//
//  Created by Mac on 15/12/23.
//  Copyright (c) 2015年 WFS. All rights reserved.
//


#import "FIrstCollectionViewCell.h"
NSString *const kFirstContentCollectionViewCell = @"FIrstCollectionViewCell";

@implementation FIrstCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame  {
    self = [super initWithFrame:frame];
    self = [[NSBundle mainBundle]loadNibNamed:kFirstContentCollectionViewCell owner:nil options:nil].firstObject;
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (IBAction)clickBtns:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(firstCollectionViewCell:clickAtIndex:)]) {
        [self.delegate firstCollectionViewCell:self clickAtIndex:sender.tag - 100];
    }
}


@end