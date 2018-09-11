//
//  SearchResultCell.m
//  ShopNum1V3.1
//
//  Created by yons on 16/2/1.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import "SearchResultCell.h"
#import "UIImageView+WebCache.h"
@interface SearchResultCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *rmbLabel;

@end

@implementation SearchResultCell

-(void)setModel:(MerchandiseIntroModel *)model
{
    _model = model;
    [self.imgView sd_setImageWithURL:model.originalImage];
    self.title.text = model.name;
    self.price.text = [NSString stringWithFormat:@"AU$ %.2f",model.shopPrice];
    self.rmbLabel.text = [NSString stringWithFormat:@"约¥%.2f",model.marketPrice];
}

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
