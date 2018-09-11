//
//  SearchAndSortViewController.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-12.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "WFSViewController.h"

@interface SearchAndSortViewController : WFSViewController

@property (strong, nonatomic) IBOutlet UISearchBar *SortSearchBar;

@property (strong ,nonatomic) NSMutableArray * AllSorts;

@property (strong, nonatomic) IBOutlet UIImageView *SortTopImageView;
@property (strong, nonatomic) IBOutlet UICollectionView *SortAllCollectionView;
@property (strong, nonatomic) NSMutableArray *secondSortDatas;
@property (strong, nonatomic) NSMutableArray *secondBrandDatas;


@end
