//
//  FootMarkViewController.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-11.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "WFSViewController.h"
#import "FootMarkTableViewCell.h"

typedef enum{
    ///足迹
    MerchandiseForFootMark = 0,
    ///收藏
    MerchandiseForFavo = 1,
    ///晒单
    MerchandiseForComment = 2
    
} ListViewType;

@interface FootMarkViewController : WFSViewController<UITableViewDelegate, UITableViewDataSource, FootMarkTableViewCellDelegate>

@property (strong, nonatomic) IBOutlet UITableView *FootMarkTableView;
@property (strong, nonatomic) NSMutableArray *FootMarkData;
@property (nonatomic, assign) ListViewType viewType;

@end
