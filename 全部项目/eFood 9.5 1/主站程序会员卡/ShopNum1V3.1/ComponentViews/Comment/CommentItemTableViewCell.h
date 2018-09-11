//
//  CommentItemTableViewCell.h
//  Shop
//
//  Created by Ocean Zhang on 4/12/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentDetailModel.h"

@interface CommentItemTableViewCell : UITableViewCell

- (void)createCommentDetailItem:(CommentDetailModel *)detail;

@end
