//
//  CommentCellOne.m
//  ShopNum1V3.1
//
//  Created by yons on 16/1/14.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import "CommentCellOne.h"
#import "UIImageView+WebCache.h"
@interface CommentCellOne ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *detail;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;

@end

@implementation CommentCellOne

-(void)setModel:(MerchandisePingJiaModel *)model
{
    _model = model;
    [self.iconView sd_setImageWithURL:model.memphotoURL];
    self.name.text = model.memname;
    self.time.text = model.sendtime;
    self.content.text = model.content;
    self.detail.text = model.attributes;
    if (model.attributes.length == 0) {
        self.height.constant = 10;
    }
}

- (void)awakeFromNib {
    self.iconView.layer.cornerRadius = 20;
    self.iconView.layer.masksToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
