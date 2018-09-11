//
//  BluePrintingTableViewCell.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-9-10.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BluePrintingModel.h"

@interface BluePrintingTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *MemberID;

@property (nonatomic, strong) UILabel *Comment;

@property (nonatomic, strong) UILabel *CommentDate;

@property (nonatomic, strong) UILabel *CommentTitle;

@property (nonatomic, strong) UIImageView *icon_image1;

@property (nonatomic, strong) UIImageView *icon_image2;

@property (nonatomic, strong) UIImageView *icon_image3;
//
- (void)createBluePrintingDetailItem:(BluePrintingModel *)detail;

@end
