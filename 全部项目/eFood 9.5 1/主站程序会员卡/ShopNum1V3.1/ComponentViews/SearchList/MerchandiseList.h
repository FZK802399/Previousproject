//
//  MerchandiseList.h
//  Shop
//
//  Created by Ocean Zhang on 3/25/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import "EGORefreshView.h"
#import "MerchandiseIntroModel.h"
#import "ScoreProductIntroModel.h"

typedef enum{
    ///查询
    MerchandiseForSearch = 0,
    ///分类
    MerchandiseForCategory = 1,
    ///品牌
    MerchandiseForBrand = 2,
    ///店铺分类
    MerchandiseForHomeCategory = 3,
    ///收藏
    MerchandiseForFavo0 = 4,
    ///积分
    MerchandiseForScore = 5,
    // 筛选
    MerchandiseForFilter = 6
    
} MerchandiseListViewType;


typedef enum {
    ShopMerchandiseNew = 0,
    ShopMerchandiseRecommend = 1,
    ShopMerchandiseHot = 2,
    ShopMerchandiseSales = 3,
    ShopMerchandiseLimited = 4
} ShopMerchandiseShowType;


//代理方法
@protocol MerchandiseListDelegate <NSObject>

@optional

- (void)selectedMerchandise:(MerchandiseIntroModel *)intro;

- (void)selectedScoreProductIntroModel:(ScoreProductIntroModel *)intro;

- (void)noResultWarningWithType:(BOOL )type;

@end

@interface MerchandiseList : EGORefreshView

//排序  ModifyTime:时间   Price：价格  SaleNumber：销售量
@property (nonatomic, strong) NSString *sorts;
// 分类
@property (copy, nonatomic) NSString *categoryID;
// 请求参数
@property (strong, nonatomic)NSMutableDictionary *dict;

//True：升序  false：降序
@property (nonatomic, strong) NSString *isAsc;

@property (nonatomic, strong) NSString *keyWords;

//0 search 1 Category
@property (nonatomic, assign) MerchandiseListViewType viewType;

@property (nonatomic, assign) id<MerchandiseListDelegate> delegate;

/// 0新品 1推荐 2热门 3促销
@property (nonatomic, assign) ShopMerchandiseShowType shopViewType;

@property (nonatomic, assign) NSInteger shopID;

@property (nonatomic, assign) NSInteger shopCategoryID;

@property (nonatomic, strong) UIViewController *parentVc;




- (void)refreshList;

- (void)getDataFromServer;
@end
