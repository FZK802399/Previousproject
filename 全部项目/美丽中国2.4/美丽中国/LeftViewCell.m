//
//  LeftViewCell.m
//  美丽中国
//
//  Created by 司马帅帅 on 15/7/21.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import "LeftViewCell.h"
#import "UIUtils.h"

@interface LeftViewCell ()
{
    UIImageView *_imageView;
    UILabel *_label;
}
@end

@implementation LeftViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //添加内容视图
        [self addContentView];
    }
    return self;
}

//添加内容视图
- (void)addContentView
{
    //设定背景视图
    UIView *cellBackGroundView = [[UIView alloc] init];
    cellBackGroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"guideservicebackground.png"]];
    self.backgroundView = cellBackGroundView;
    
    //设定被选中的背景视图
    UIView *cellBackGroundViewHighlight = [[UIView alloc] init];
    cellBackGroundViewHighlight.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"leftmenulist_highlight.png"]];
    self.selectedBackgroundView = cellBackGroundViewHighlight;
    
    //设定cell之间的分割线
    UIImageView *separatorLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftmenulist_separator.png"]];
    separatorLine.frame = CGRectMake(0.0f, self.frame.size.height-1, self.frame.size.width, 1);
    [self addSubview:separatorLine];
    
    //初始化_imageView
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, self.frame.size.height*0.7, self.frame.size.height*0.6)];
    [self addSubview:_imageView];

    //初始化_label
    _label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imageView.frame)+20, 0, 200, self.frame.size.height-3)];
    //设置字体颜色
    _label.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"leftmenulist_textcolor_dot.png"]];
    [_label setFont:[UIFont boldSystemFontOfSize:15]];
    [self addSubview:_label];
}


//设置内容视图显示内容
- (void)setContentView:(NSDictionary *)dictionary
{
    [_imageView setImage:dictionary[@"image"]];
    [_label setText:dictionary[@"text"]];
}

@end
