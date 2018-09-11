//
//  BluePrintingTableViewCell.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-9-10.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "BluePrintingTableViewCell.h"

@implementation BluePrintingTableViewCell

CGFloat allheight = 235;
CGFloat originX = 6;
CGFloat originY = 4;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        UIFont *fontSize14 = [UIFont systemFontOfSize:14.0f];
        
        if(_MemberID == nil){
            _MemberID = [[UILabel alloc] initWithFrame:CGRectMake(260, 4, 55, 21)];
            _MemberID.textColor = [UIColor redColor];
            _MemberID.font = fontSize14;
            _MemberID.backgroundColor = [UIColor clearColor];
            _MemberID.textAlignment = NSTextAlignmentRight;
            [self.contentView addSubview:_MemberID];
        }
        
        if(_CommentTitle == nil){
            _CommentTitle = [[UILabel alloc] initWithFrame:CGRectMake(6, 4, 200, 21)];
            _CommentTitle.textColor = [UIColor darkTextColor];
            _CommentTitle.font = fontSize14;
            _CommentTitle.backgroundColor = [UIColor clearColor];
            _CommentTitle.textAlignment = NSTextAlignmentLeft;
            [self.contentView addSubview:_CommentTitle];
        }
        
        UIImageView * iconImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_appraisal.png"]];
        iconImage.frame = CGRectMake(6, 157, 13, 13);
        [self.contentView addSubview:iconImage];
        
        if(_Comment == nil){
            _Comment = [[UILabel alloc] initWithFrame:CGRectMake(35, 150, 279, 42)];
            _Comment.textColor = [UIColor colorWithRed:171 /255.0f green:171 /255.0f blue:171 /255.0f alpha:1];
            _Comment.font = [UIFont systemFontOfSize:13];
            _Comment.backgroundColor = [UIColor clearColor];
            _Comment.lineBreakMode = NSLineBreakByCharWrapping;
            _Comment.numberOfLines = 2;
            [self.contentView addSubview:_Comment];
        }
        
        if(_CommentDate == nil){
            _CommentDate = [[UILabel alloc] initWithFrame:CGRectMake(35, 199, 255, 21)];
            _CommentDate.textColor = [UIColor colorWithRed:181 /255.0f green:181 /255.0f blue:181 /255.0f alpha:1];
            _CommentDate.font = fontSize14;
            _CommentDate.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:_CommentDate];
        }
        
        if(_icon_image1 == nil){
            _icon_image1 = [[UIImageView alloc] initWithFrame:CGRectMake(6, 38, 100, 100)];
            [self.contentView addSubview:_icon_image1];
        }
        
        if(_icon_image2 == nil){
            _icon_image2 = [[UIImageView alloc] initWithFrame:CGRectMake(110, 38, 100, 100)];

            [self.contentView addSubview:_icon_image2];
        }
        
        if(_icon_image3 == nil){
            _icon_image3 = [[UIImageView alloc] initWithFrame:CGRectMake(214, 38, 100, 100)];

            [self.contentView addSubview:_icon_image3];
        }
        
        CALayer *topLayer = [CALayer layer];
        topLayer.frame = CGRectMake(0, 0, 320, 1);
        topLayer.backgroundColor = [UIColor colorWithRed:236 /255.0f green:236 /255.0f blue:236 /255.0f alpha:1].CGColor;
        [self.contentView.layer addSublayer:topLayer];
        
        CALayer *topLayer2 = [CALayer layer];
        topLayer2.frame = CGRectMake(0, 29, 320, 1);
        topLayer2.backgroundColor = [UIColor colorWithRed:236 /255.0f green:236 /255.0f blue:236 /255.0f alpha:1].CGColor;
        [self.contentView.layer addSublayer:topLayer2];
        
        CALayer *bottomLayer = [CALayer layer];
        bottomLayer.frame = CGRectMake(0, allheight - 5, 320, 5);
        bottomLayer.backgroundColor = [UIColor colorWithRed:246 /255.0f green:246 /255.0f blue:246 /255.0f alpha:1].CGColor;
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

-(void)createBluePrintingDetailItem:(BluePrintingModel *)detail{
    _MemberID.text = detail.memberLoginID;
    _Comment.text = detail.comment;
    _CommentDate.text = detail.commentTimeStr;
    _CommentTitle.text = detail.commenttitle;
    UIImage *blankImg = [UIImage imageNamed:@"nopic"];
    if ([detail.commentImages count] > 0) {
        [_icon_image1 setImageWithURL:[detail.commentImages objectAtIndex:0] placeholderImage:blankImg];
    }
    if ([detail.commentImages count] > 1) {
        [_icon_image2 setImageWithURL:[detail.commentImages objectAtIndex:1] placeholderImage:blankImg];
    }
    if ([detail.commentImages count] > 2) {
        [_icon_image3 setImageWithURL:[detail.commentImages objectAtIndex:2] placeholderImage:blankImg];
    }
}

@end
