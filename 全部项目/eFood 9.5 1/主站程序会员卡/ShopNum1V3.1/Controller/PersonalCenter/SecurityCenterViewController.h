//
//  SecurityCenterViewController.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-9-11.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "WFSViewController.h"
///安全中心
@interface SecurityCenterViewController : WFSViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *currentTableView;
@property (strong, nonatomic) NSArray *currentTitles;
@property (strong, nonatomic) NSArray *currentTitle2s;
@end
