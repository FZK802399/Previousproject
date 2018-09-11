//
//  MerchandiseCollectionViewController.h
//  Shop
//
//  Created by Mac on 15/11/4.
//  Copyright (c) 2015年 ocean. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MerchandiseList.h"

@class MemberCenterViewController;
@class MerchandiseIntroModel;

@protocol MerchandiseCollectionViewDelegate <NSObject>

@required
// 选中某行代理
- (void)didSelectItemAtIndexModel:(MerchandiseIntroModel *)model;
- (void)noResultWarning;
@end

@interface MerchandiseCollectionViewController : WFSViewController

// 分类
@property (copy, nonatomic) NSString *categoryID;
// 请求参数
@property (strong, nonatomic)NSMutableDictionary *dict;

//排序  ModifyTime:时间   Price：价格  SaleNumber：销售量
@property (nonatomic, copy) NSString *sorts;
//True：升序  false：降序
@property (nonatomic, copy) NSString *isAsc;
@property (nonatomic, strong) NSString *keyWords;
// 0 search 1 Category
@property (nonatomic, assign) MerchandiseListViewType viewType;
@property (nonatomic, weak) id<MerchandiseCollectionViewDelegate> delegate;
/// 0新品 1推荐 2热门 3促销
@property (nonatomic, assign) ShopMerchandiseShowType shopViewType;
@property (nonatomic, assign) NSInteger shopID;
@property (nonatomic, assign) NSInteger shopCategoryID;
@property (nonatomic, strong) UICollectionView *collectionView;

- (void)reloadData;


@end
