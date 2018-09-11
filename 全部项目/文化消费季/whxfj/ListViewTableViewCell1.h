//
//  ListViewTableViewCell1.h
//  whxfj
//
//  Created by 司马帅帅 on 14-8-23.
//  Copyright (c) 2014年 baobin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListViewController.h"

@class ListViewInfo;

@interface ListViewTableViewCell1 : UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style_ reuseIdentifier:(NSString *)reuseIdentifier_ listViewType:(ListViewType)listViewType_;
- (void)setSubviewsOfCellWithListViewInfo:(ListViewInfo *)listViewInfo_;

@end
