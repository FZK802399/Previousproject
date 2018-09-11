//
//  ListViewTableViewCell1.m
//  whxfj
//
//  Created by 司马帅帅 on 14-8-23.
//  Copyright (c) 2014年 baobin. All rights reserved.
//

#import "ListViewTableViewCell1.h"
#import "ListViewInfo.h"

@interface ListViewTableViewCell1 ()
{
    UILabel *titleLabel;
    UITextView *textView;
    UIImageView *imageView;
    UILabel *timeLabel;
    UITextView *addressTextView;
    UITextView *titleTextView;
    ListViewType listViewType;
}
@end

@implementation ListViewTableViewCell1

- (id)initWithStyle:(UITableViewCellStyle)style_ reuseIdentifier:(NSString *)reuseIdentifier_ listViewType:(ListViewType)listViewType_
{
    listViewType = listViewType_;
    return [self initWithStyle:style_ reuseIdentifier:reuseIdentifier_];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self addSubviewsOfCell];
    }
    return self;
}

- (void)addSubviewsOfCell
{
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, self.frame.size.width-10-10, 30)];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
    [self.contentView addSubview:titleLabel];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(titleLabel.frame)+5, 120, 100)];
    [self.contentView addSubview:imageView];
    
    if ((listViewType == LISTVIEWTYPE_WHC)||(listViewType == LISTVIEWTYPE_HKB)||(listViewType == LISTVIEWTYPE_HFX)) {
        textView = [[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+5, CGRectGetMaxY(titleLabel.frame)-3, self.frame.size.width-CGRectGetMaxY(imageView.frame)-5, 100+7)];
        [textView setUserInteractionEnabled:NO];
        [textView setScrollEnabled:NO];
        [textView setFont:[UIFont systemFontOfSize:12]];
        [self.contentView addSubview:textView];
    } else if ((listViewType == LISTVIEWTYPE_ZHK)||(listViewType == LISTVIEWTYPE_HDH)) {
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+10, 40, self.frame.size.width-CGRectGetMaxY(imageView.frame)-10, 20)];
        [timeLabel setFont:[UIFont systemFontOfSize:14]];
        [self.contentView addSubview:timeLabel];
        
        addressTextView = [[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+5, CGRectGetMaxY(timeLabel.frame), self.frame.size.width-CGRectGetMaxY(imageView.frame)-10, 70)];
        [addressTextView setUserInteractionEnabled:NO];
        [addressTextView setEditable:NO];
        [addressTextView setFont:[UIFont systemFontOfSize:14]];
        [self.contentView addSubview:addressTextView];
    } else if (listViewType == LISTVIEWTYPE_QXX){
        titleTextView = [[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+5, 50, self.frame.size.width-CGRectGetMaxY(imageView.frame)-10, 50)];
        [titleTextView setUserInteractionEnabled:NO];
        [titleTextView setEditable:NO];
        [titleTextView setFont:[UIFont systemFontOfSize:14]];
        [self.contentView addSubview:titleTextView];
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+10,CGRectGetMaxY(titleTextView.frame), self.frame.size.width-CGRectGetMaxY(imageView.frame)-10, 20)];
        [timeLabel setFont:[UIFont systemFontOfSize:14]];
        [self.contentView addSubview:timeLabel];
    }
    
}

- (void)setSubviewsOfCellWithListViewInfo:(ListViewInfo *)listViewInfo_{
    if (listViewType == LISTVIEWTYPE_QXX)  {
        [titleLabel setText:listViewInfo_.quName];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    } else {
        [titleLabel setText:listViewInfo_.title];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
    }
    
    if ((listViewType == LISTVIEWTYPE_WHC)||(listViewType == LISTVIEWTYPE_HKB)||(listViewType == LISTVIEWTYPE_HFX)) {
        [textView setText:listViewInfo_.miaoshu];
    } else if ((listViewType == LISTVIEWTYPE_ZHK)||(listViewType == LISTVIEWTYPE_HDH)) {
        [timeLabel setText:listViewInfo_.timeString];
        [addressTextView setText:listViewInfo_.addressString];
    } else if (listViewType == LISTVIEWTYPE_QXX) {
        [titleTextView setText:listViewInfo_.title];
        [timeLabel setText:listViewInfo_.timeString];
    }
    
    [self performSelectorInBackground:@selector(setImageViewWith:) withObject:listViewInfo_.thumbString];
}

//设置缩略图
- (void)setImageViewWith:(NSString *)adImagString
{
    [imageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:adImagString]]]];
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
