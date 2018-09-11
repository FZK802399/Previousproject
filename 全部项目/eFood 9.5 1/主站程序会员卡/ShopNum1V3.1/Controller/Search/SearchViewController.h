//
//  SearchViewController.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-4.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : WFSViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong ,nonatomic) NSMutableArray *allItems;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

+ (instancetype)searchVC;

@end
