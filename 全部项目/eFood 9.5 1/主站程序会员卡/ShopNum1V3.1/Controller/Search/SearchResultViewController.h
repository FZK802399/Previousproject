//
//  SearchResultViewController.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-13.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "WFSViewController.h"
#import "MerchandiseList.h"
#import "SortModel.h"

@interface SearchResultViewController : WFSViewController <MerchandiseListDelegate>
///无内容时的显示
@property (strong, nonatomic) IBOutlet UIView *noMessageView;

@property (copy, nonatomic) NSString * searchText;
@property (copy, nonatomic) NSString * searchBrandGuid;
@property (copy, nonatomic) NSString * searchProductCategoryID;
///父ID
@property (strong, nonatomic) SortModel * fatherModel;

@property (copy, nonatomic) NSString * TitleName;
///0 Search 1 Category
@property (nonatomic, assign) MerchandiseListViewType viewType;

@property (nonatomic, strong) MerchandiseList *merchandiseList;

@property (assign, nonatomic) NSInteger ShopID;

@property (assign, nonatomic) NSInteger ScoreProductCategoryID;

//顶部视图
@property (strong, nonatomic) IBOutlet UIView *topView;

@property (strong, nonatomic) IBOutlet UIButton *SortTimeBtn;
@property (strong, nonatomic) IBOutlet UIButton *SortPriceBtn;
@property (strong, nonatomic) IBOutlet UIButton *SortVolumeBtn;

@property (strong, nonatomic) IBOutlet UIImageView *noResultImage;
@property (strong, nonatomic) IBOutlet UILabel *noResultLabel;

- (IBAction)SortBtnClick:(id)sender;
+ (instancetype)createSearchResultVC;

@end
