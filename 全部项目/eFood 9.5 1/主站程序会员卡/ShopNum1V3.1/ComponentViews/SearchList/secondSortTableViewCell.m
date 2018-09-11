//
//  secondSortTableViewCell.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-9-17.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "secondSortTableViewCell.h"

@implementation secondSortTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setFrame:self.frame];
        
        CGFloat height = 44;
        CGFloat width = 233;
        CGFloat originX = 0;
        CGFloat originY = 10;
        // Initialization code
        if (!_menuName) {
            _menuName = [[UILabel alloc] initWithFrame:CGRectMake(originX + 12, originY, 65, 20)];
            _menuName.textColor = [UIColor blackColor];
            _menuName.font = [UIFont workDetailFont];
            _menuName.backgroundColor = [UIColor clearColor];
            _menuName.textAlignment = NSTextAlignmentLeft;
            [self.contentView addSubview:_menuName];
        }
        
        if (!_detailButton) {
            _detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _detailButton.frame = CGRectMake(width - 26, originY, 20, 20);
            [_detailButton setImage:[UIImage imageNamed:@"btn_detail_normal.png"] forState:UIControlStateNormal];
            [_detailButton setImage:[UIImage imageNamed:@"btn_detail_normal.png"] forState:UIControlStateDisabled];
            [_detailButton setEnabled:NO];
            [self.contentView addSubview:_detailButton];
        }
        //        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"segmented_bg.png"]];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CALayer *bottomLayer = [CALayer layer];
        bottomLayer.frame = CGRectMake(0, height - 1, 320, 1);
        bottomLayer.backgroundColor = [UIColor colorWithRed:234 /255.0f green:234 /255.0f blue:234 /255.0f alpha:1].CGColor;
        [self.contentView.layer addSublayer:bottomLayer];
        
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

@end
