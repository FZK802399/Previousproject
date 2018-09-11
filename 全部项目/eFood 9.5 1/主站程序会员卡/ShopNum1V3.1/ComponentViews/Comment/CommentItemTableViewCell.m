//
//  CommentItemTableViewCell.m
//  Shop
//
//  Created by Ocean Zhang on 4/12/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import "CommentItemTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@interface CommentItemTableViewCell()

@property (nonatomic, strong) UILabel *lbMemberID;

@property (nonatomic, strong) UILabel *lbComment;

@property (nonatomic, strong) UILabel *lbCommentDate;

@property (nonatomic, strong) UILabel *lbCommentTitle;

@end

@implementation CommentItemTableViewCell

@synthesize lbMemberID = _lbMemberID;
@synthesize lbComment = _lbComment;
@synthesize lbCommentDate = _lbCommentDate;
@synthesize lbCommentTitle = _lbCommentTitle;

CGFloat height = 115;
CGFloat nameWidth = 64;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIFont *fontSize14 = [UIFont systemFontOfSize:14.0f];
        
        if(_lbMemberID == nil){
            _lbMemberID = [[UILabel alloc] initWithFrame:CGRectMake(250, 4, nameWidth, 21)];
            _lbMemberID.textColor = [UIColor colorWithRed:164 /255.0f green:164 /255.0f blue:164 /255.0f alpha:1];
            _lbMemberID.font = fontSize14;
            _lbMemberID.backgroundColor = [UIColor clearColor];
            _lbMemberID.textAlignment = NSTextAlignmentRight;
            [self.contentView addSubview:_lbMemberID];
        }
        
        if(_lbCommentTitle == nil){
            _lbCommentTitle = [[UILabel alloc] initWithFrame:CGRectMake(6, 4, 250, 21)];
            _lbCommentTitle.textColor = [UIColor darkTextColor];
            _lbCommentTitle.font = fontSize14;
            _lbCommentTitle.backgroundColor = [UIColor clearColor];
            _lbCommentTitle.textAlignment = NSTextAlignmentLeft;
            [self.contentView addSubview:_lbCommentTitle];
        }
        
        UIImageView * iconImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_appraisal.png"]];
        iconImage.frame = CGRectMake(10, 35, 13, 13);
        [self.contentView addSubview:iconImage];
        
        if(_lbComment == nil){
            _lbComment = [[UILabel alloc] initWithFrame:CGRectMake(35, 31, 263, 42)];
            _lbComment.textColor = [UIColor colorWithRed:57 /255.0f green:66 /255.0f blue:71 /255.0f alpha:1];
            _lbComment.font = fontSize14;
            _lbComment.backgroundColor = [UIColor clearColor];
            _lbComment.lineBreakMode = NSLineBreakByCharWrapping;
            _lbComment.numberOfLines = 2;
            [self.contentView addSubview:_lbComment];
        }
        
        if(_lbCommentDate == nil){
            _lbCommentDate = [[UILabel alloc] initWithFrame:CGRectMake(35, 80, 255, 21)];
            _lbCommentDate.textColor = [UIColor colorWithRed:181 /255.0f green:181 /255.0f blue:181 /255.0f alpha:1];
            _lbCommentDate.font = fontSize14;
            _lbCommentDate.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:_lbCommentDate];
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
        bottomLayer.frame = CGRectMake(0, height - 5, 320, 5);
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
}

- (void)createCommentDetailItem:(CommentDetailModel *)detail{
    _lbMemberID.text = detail.memberLoginID;
    _lbComment.text = detail.comment;
    _lbCommentDate.text = detail.commentTimeStr;
    _lbCommentTitle.text = detail.commenttitle;
//    CGSize maximumLabelSize = CGSizeMake(320 - nameWidth, 1000);
//    CGSize expectedLabelSize = [_lbComment.text sizeWithFont:_lbComment.font
//                                           constrainedToSize:maximumLabelSize
//                                               lineBreakMode:_lbComment.lineBreakMode];
//    
//    
//    if(expectedLabelSize.height > height - 20){
//        _lbComment.frame = CGRectMake(35, 31, 320 - nameWidth, expectedLabelSize.height);
//        _lbCommentDate.frame = CGRectMake(35, _lbComment.frame.size.height + _lbComment.frame.origin.y, 320 - nameWidth, 20);
//        CALayer *bottomLayer = [CALayer layer];
//        bottomLayer.frame = CGRectMake(0, expectedLabelSize.height + 20 - 5, 320, 5);
//        bottomLayer.backgroundColor = [UIColor colorWithRed:246 /255.0f green:246 /255.0f blue:246 /255.0f alpha:1].CGColor;
//        [self.contentView.layer addSublayer:bottomLayer];
//        [self.contentView setFrame:CGRectMake(0, 0, 320, expectedLabelSize.height + 20)];
//    }else{
//        
//        _lbComment.frame = CGRectMake(35, 31, 320 - nameWidth, height - 20);
//        _lbCommentDate.frame = CGRectMake(35, height - 25, 320 - nameWidth, 20);
//        CALayer *bottomLayer = [CALayer layer];
//        bottomLayer.frame = CGRectMake(0, height - 5, 320, 5);
//        bottomLayer.backgroundColor = [UIColor colorWithRed:246 /255.0f green:246 /255.0f blue:246 /255.0f alpha:1].CGColor;
//        [self.contentView.layer addSublayer:bottomLayer];
//        [self.contentView setFrame:CGRectMake(0, 0, 320, height)];
//    }
}

@end
