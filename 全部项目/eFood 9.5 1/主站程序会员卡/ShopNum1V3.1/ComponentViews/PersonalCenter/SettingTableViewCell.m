//
//  SettingTableViewCell.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-21.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "SettingTableViewCell.h"

@implementation SettingTableViewCell{
    // 背景view
    UIImageView *_bgView;
    UIImageView *_selectedBgView;
}


- (void)setFrame:(CGRect)frame
{
    CGFloat margin = 15;
    if (kCurrentSystemVersion >= 7.0) {
        margin = 0;
    }
    
    frame.origin.x = -margin;
    frame.size.width += 2 * margin;
    
    [super setFrame:frame];
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setFrame:self.frame];
        // 1.设置背景view
        _bgView = [[UIImageView alloc] init];
        self.backgroundView = _bgView;
        _selectedBgView =[[UIImageView alloc] init];
        self.selectedBackgroundView = _selectedBgView;
        
        CGFloat height = 44;
        CGFloat width = 320;
        CGFloat originX = 0;
        CGFloat originY = 10;
        // Initialization code
        if (!_menuName) {
            _menuName = [[UILabel alloc] initWithFrame:CGRectMake(originX + 12, originY, 80, 20)];
            _menuName.textColor = [UIColor blackColor];
            _menuName.font = [UIFont workDetailFont];
            _menuName.backgroundColor = [UIColor clearColor];
            _menuName.textAlignment = NSTextAlignmentLeft;
            [self.contentView addSubview:_menuName];
        }
        
        if (!_tipNum) {
            _tipNum = [[UILabel alloc] initWithFrame:CGRectMake(originX + _menuName.frame.size.width + 10, originY + 3, 25, 15)];
            _tipNum.textColor = [UIColor whiteColor];
            _tipNum.font = [UIFont timeDetailFont];
            _tipNum.backgroundColor = [UIColor barTitleColor];
            _tipNum.textAlignment = NSTextAlignmentCenter;
            [_tipNum.layer setMasksToBounds:YES];
            _tipNum.layer.cornerRadius = 8;
            [self.contentView addSubview:_tipNum];
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

    }
    return self;
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    
    // 1.算出文件名
    NSString *centerName = nil;
    NSInteger rowsCount = [_myTableView numberOfRowsInSection:indexPath.section];
    if (rowsCount == 1) {
        centerName = @"";
    } else if (indexPath.row == 0) { // 顶部
        centerName = @"_top";
    } else if (indexPath.row == rowsCount - 1) { // 底部
        centerName = @"_bottom";
    } else { // 中间
        centerName = @"_middle";
    }
    
    // 2.设置图片
    _bgView.image = [UIImage resizeImage:[NSString stringWithFormat:@"common_card%@_background.png", centerName]];
    _selectedBgView.image = [UIImage resizeImage:[NSString stringWithFormat:@"common_card%@_background_highlighted.png", centerName]];
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

-(void)creatSettingTableViewCellWithSettingModel:(SettingModel *)intro{

    if (intro.Tipnum > 0) {
        [_tipNum setHidden:NO];
        _tipNum.text = [NSString stringWithFormat:@"%ld", (long)intro.Tipnum];
    }else{
        [_tipNum setHidden:YES];
    }
    _menuName.text = intro.MenuName;
}

@end
