//
//  ProductCategoryTableViewCell.m
//  Shop
//
//  Created by Ocean Zhang on 4/1/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import "ProductCategoryTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@interface ProductCategoryTableViewCell()

@property (nonatomic, strong) UILabel *lbName;

@property (nonatomic, strong) UILabel *lbDesc;

@property (nonatomic, strong) UIImageView *imgArrow;

@property (nonatomic, strong) CALayer *bottomLayer;

@end

@implementation ProductCategoryTableViewCell

@synthesize lbName = _lbName;
@synthesize lbDesc = _lbDesc;
@synthesize imgArrow = _imgArrow;
@synthesize bottomLayer = _bottomLayer;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        if(_lbName == nil){
            _lbName = [[UILabel alloc] initWithFrame:CGRectMake(20, 12, 260, 20)];
            _lbName.font = [UIFont boldSystemFontOfSize:15.0f];
            _lbName.textColor = [UIColor colorWithRed:127 /255.0f green:127 /255.0f blue:127 /255.0f alpha:1];
            _lbName.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:_lbName];
        }
        
//        if(_lbDesc == nil){
//            _lbDesc = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 280, 40)];
//            _lbDesc.font = [UIFont systemFontOfSize:12.0f];
//            _lbDesc.textColor = [UIColor colorWithRed:187 /255.0f green:187 /255.0f blue:187 /255.0f alpha:1];
//            _lbDesc.lineBreakMode = UILineBreakModeWordWrap;
//            _lbDesc.numberOfLines = 2;
//            [self.contentView addSubview:_lbDesc];
//        }
        
        if(_imgArrow == nil){
            _imgArrow = [[UIImageView alloc] initWithFrame:CGRectMake(290, 10, 24, 24)];
            _imgArrow.image = [UIImage imageNamed:@"btn_godetail_normal.png"];
            [self.contentView addSubview:_imgArrow];
        }
        
        if(_bottomLayer == nil){
            _bottomLayer = [CALayer layer];
            _bottomLayer.frame = CGRectMake(0, 43,self.contentView.frame.size.width, 1.0f);
            // _bottomLayer.frame = CGRectMake(0, 57,self.contentView.frame.size.width, 1.0f);
            _bottomLayer.backgroundColor = [UIColor colorWithRed:236 /255.0f green:236 /255.0f blue:236 /255.0f alpha:1].CGColor;
            [self.contentView.layer addSublayer:_bottomLayer];
        }
        
        self.contentView.backgroundColor = [UIColor colorWithRed:245 /255.0f green:245 /255.0f blue:245 /255.0f alpha:1];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)createCategoryItem:(SortModel *)category{
    _lbName.text = category.Name;
//    _lbDesc.text = category.categoryName;
}

@end
