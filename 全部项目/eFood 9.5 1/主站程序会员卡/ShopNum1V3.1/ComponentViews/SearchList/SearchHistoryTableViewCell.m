//
//  SearchHistoryTableViewCell.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-9-18.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "SearchHistoryTableViewCell.h"

@implementation SearchHistoryTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setFrame:self.frame];
        // Initialization code
        if (!_menuName) {
            _menuName = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH, CGRectGetHeight(self.frame))];
            _menuName.textColor = FONT_BLACK;
            _menuName.font = [UIFont workDetailFont];
            _menuName.backgroundColor = [UIColor clearColor];
            _menuName.textAlignment = NSTextAlignmentLeft;
            [self.contentView addSubview:_menuName];
        }
        
//        if (!_detailButton) {
//            _detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
//            _detailButton.frame = CGRectMake(width - 26, originY, 20, 20);
//            [_detailButton setImage:[UIImage imageNamed:@"btn_detail_normal.png"] forState:UIControlStateNormal];
//            [_detailButton setImage:[UIImage imageNamed:@"btn_detail_normal.png"] forState:UIControlStateDisabled];
//            [_detailButton setEnabled:NO];
//            [self.contentView addSubview:_detailButton];
//        }
        //        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"segmented_bg.png"]];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
//        CALayer *bottomLayer = [CALayer layer];
//        bottomLayer.frame = CGRectMake(0, height - 1, 320, 1);
//        bottomLayer.backgroundColor = [UIColor colorWithRed:234 /255.0f green:234 /255.0f blue:234 /255.0f alpha:1].CGColor;
//        [self.contentView.layer addSublayer:bottomLayer];
        
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
