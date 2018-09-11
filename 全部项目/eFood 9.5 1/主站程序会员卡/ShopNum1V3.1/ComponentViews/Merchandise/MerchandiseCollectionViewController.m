//
//  MerchandiseCollectionViewController.m
//  Shop
//
//  Created by Mac on 15/11/4.
//  Copyright (c) 2015年 ocean. All rights reserved.
//

#import "MerchandiseCollectionViewController.h"
#import "MJRefresh.h"
#import "SeventhCollectionViewCell.h"

static NSString *kSeventhCellIdentfier = @"SeventhCollectionViewCell";

@interface MerchandiseCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation MerchandiseCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc]init];
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 0, 0, 0); //设置其边界
    flowLayout.minimumLineSpacing = 5;
    flowLayout.minimumInteritemSpacing = 5;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor colorWithWhite:0.933 alpha:1.000];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    
    _pageIndex = 1;
    _pageSize = 10;
    // 注册Cell
    UINib *seventhNib = [UINib nibWithNibName:kSeventhCellIdentfier bundle:nil];
    [self.collectionView registerNib:seventhNib forCellWithReuseIdentifier:kSeventhCellIdentfier];
      
    
    ZDXWeakSelf(weakSelf);
    [self.collectionView addHeaderWithCallback:^{
//        [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
        weakSelf.pageIndex = 1;
        [weakSelf.dataSource removeAllObjects];
        [weakSelf setupCollectionViewData];
    }];
    
    [self.collectionView addFooterWithCallback:^{
//        [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
//        NSInteger oldCount = [weakSelf.dataSource count] > _pageSize ? [weakSelf.dataSource count] : _pageSize;
//        weakSelf.pageIndex = oldCount / weakSelf.pageSize + 1;
        _pageIndex ++;
        [weakSelf setupCollectionViewData];
    }];

}

- (void)setupCollectionViewData {
    //    [_loading startLoading];
    void(^loadMerchandise)(NSArray *,NSError *) = ^void(NSArray *list, NSError *error){

        [self.collectionView footerEndRefreshing];
        [self.collectionView headerEndRefreshing];
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        if (error) {
            [self showErrorMessage:@"网络错误"];
        } else {
            NSMutableArray *signalPageData = [[NSMutableArray alloc] initWithArray:list];
            [_dataSource addObjectsFromArray:signalPageData];            
#warning 空数据处理
            if ([_dataSource count] == 0) {
                if ([_delegate respondsToSelector:@selector(noResultWarning)]) {
                    [self.collectionView removeFromSuperview];
                    [_delegate noResultWarning];
                }
            }
            [self.collectionView reloadData];
        }
        //        [_loading stopLoading];
    };
    NSDictionary * getDataDic;
    AppConfig * appConfig = [AppConfig sharedAppConfig];
    [appConfig loadConfig];
    switch (self.viewType) {
        case MerchandiseForFilter:
        {
            //筛选产品
            //筛选产品
            self.dict[@"pageIndex"] = @(_pageIndex);
            self.dict[@"pageCount"] = @(_pageSize);
            [MerchandiseIntroModel getMerchandiseListByFilterParamer:self.dict CategoryID:self.categoryID andBlocks:^(NSArray *merchandiseList, NSError *error) {
                loadMerchandise(merchandiseList,error);
            }];
        }
            break;
        case MerchandiseForSearch:
        {
            getDataDic = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"-1", @"ProductCategoryID",
                          self.sorts, @"sorts",
                          self.isAsc, @"isASC",
                          [NSString stringWithFormat:@"%d",_pageIndex], @"pageIndex",
                          [NSString stringWithFormat:@"%d",_pageSize], @"pageCount",
                          self.keyWords, @"name",
                          @"", @"BrandGuid",
                          appConfig.appSign, @"AppSign",
                          nil];
            //搜索产品
            [MerchandiseIntroModel getSearchProductListByParamer: getDataDic
                                                       andBlocks:^(NSArray *introArr,NSError *error){
                                                           loadMerchandise(introArr,error);
                                                       }];
        }
            break;
        case MerchandiseForCategory:
        {
            getDataDic = [NSDictionary dictionaryWithObjectsAndKeys:
                          self.keyWords, @"ProductCategoryID",
                          self.sorts, @"sorts",
                          self.isAsc, @"isASC",
                          [NSString stringWithFormat:@"%d",_pageIndex], @"pageIndex",
                          [NSString stringWithFormat:@"%d",_pageSize], @"pageCount",
                          @"", @"name",
                          @"", @"BrandGuid",
                          appConfig.appSign, @"AppSign",
                          nil];            
//            NSLog(@"%@",getDataDic);
            //分类查看
            [MerchandiseIntroModel getSearchProductListByParamer:getDataDic
                                                       andBlocks:^(NSArray *lsit, NSError *error){
                                                           loadMerchandise(lsit,error);
                                                       }];
        }
            break;
        case MerchandiseForBrand:
        {
            
            getDataDic = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"-1", @"ProductCategoryID",
                          self.sorts, @"sorts",
                          self.isAsc, @"isASC",
                          [NSString stringWithFormat:@"%d",_pageIndex], @"pageIndex",
                          [NSString stringWithFormat:@"%d",_pageSize], @"pageCount",
                          @"", @"name",
                          self.keyWords, @"BrandGuid",
                          appConfig.appSign, @"AppSign",
                          nil];
            //品牌查看
            [MerchandiseIntroModel getSearchProductListByParamer:getDataDic
                                                       andBlocks:^(NSArray *list,NSError *error){
                                                           loadMerchandise(list,error);
                                                       }];
        }
            break;
        case MerchandiseForHomeCategory:
        {
            //店铺分类
            [MerchandiseIntroModel getShopMerchandiseByCategory:self.shopCategoryID
                                                          Sorts:self.sorts
                                                          isAsc:self.isAsc
                                                      pageIndex:_pageIndex
                                                      pageCount:_pageSize
                                                         shopID:self.shopID
                                                           name:self.keyWords
                                                      andBlocks:^(NSArray *list,NSError *error){
                                                          loadMerchandise(list,error);
                                                      }];
        }
            break;
        case MerchandiseForFavo0:
        {
            //收藏
            //            [MerchandiseIntroModel getFavoMerchandiseList:_pageIndex pageCount:_pageSize andblock:^(NSArray *list, NSError *error){
            //                loadMerchandise(list,error);
            //            }];
        }
            break;
        case MerchandiseForScore:
        {
            if (self.shopID == 1) {
                getDataDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"0", @"ScoreProductCategoryID",
                              [NSString stringWithFormat:@"%d",_pageIndex], @"pageIndex",
                              [NSString stringWithFormat:@"%d",_pageSize], @"pageSize",
                              @"0", @"IsBest",
                              @"0", @"IsNew",
                              @"1", @"IsHot",
                              @"0", @"IsRecommend",
                              appConfig.appSign, @"AppSign",
                              nil];
                
            }else if (self.shopID == 2){
                getDataDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"0", @"ScoreProductCategoryID",
                              [NSString stringWithFormat:@"%d",_pageIndex], @"pageIndex",
                              [NSString stringWithFormat:@"%d",_pageSize], @"pageSize",
                              @"0", @"IsBest",
                              @"1", @"IsNew",
                              @"0", @"IsHot",
                              @"0", @"IsRecommend",
                              appConfig.appSign, @"AppSign",
                              nil];
            }else if (self.shopID == 3){
                getDataDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"0", @"ScoreProductCategoryID",
                              [NSString stringWithFormat:@"%d",_pageIndex], @"pageIndex",
                              [NSString stringWithFormat:@"%d",_pageSize], @"pageSize",
                              @"1", @"IsBest",
                              @"0", @"IsNew",
                              @"0", @"IsHot",
                              @"0", @"IsRecommend",
                              appConfig.appSign, @"AppSign",
                              nil];
            }else if (self.shopID == 4){
                getDataDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"0", @"ScoreProductCategoryID",
                              [NSString stringWithFormat:@"%d",_pageIndex], @"pageIndex",
                              [NSString stringWithFormat:@"%d",_pageSize], @"pageSize",
                              @"0", @"IsBest",
                              @"0", @"IsNew",
                              @"0", @"IsHot",
                              @"1", @"IsRecommend",
                              appConfig.appSign, @"AppSign",
                              nil];
            }
            
            if (self.shopCategoryID > 0) {
                getDataDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSString stringWithFormat:@"%d", self.shopCategoryID], @"ScoreProductCategoryID",
                              [NSString stringWithFormat:@"%d",_pageIndex], @"pageIndex",
                              [NSString stringWithFormat:@"%d",_pageSize], @"pageSize",
                              @"0", @"IsBest",
                              @"0", @"IsNew",
                              @"0", @"IsHot",
                              @"0", @"IsRecommend",
                              appConfig.appSign, @"AppSign",
                              nil];
            }
            
            
            [ScoreProductIntroModel getScoreMerchandiseIntroForHomeShowByParamer:getDataDic andBlocks:^(NSArray *merchandiseList, NSError *error) {
                loadMerchandise(merchandiseList,error);
            }];
            
            
        }
            break;
    }
}

#pragma mark - Setter Getter
- (void)setDelegate:(id<MerchandiseCollectionViewDelegate>)delegate {
    _delegate = delegate;
//    [self setupCollectionViewData];
    [self.collectionView headerBeginRefreshing];
}

- (void)reloadData {
//    [self.collectionView setContentOffset:CGPointMake(0, 0) animated:YES];
    self.pageIndex = 1;
    [self.dataSource removeAllObjects];
//    [self setupCollectionViewData];
    if (self.collectionView.superview != self.view) {
        [self.view addSubview:self.collectionView];
    }
    [self.collectionView headerBeginRefreshing];
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataSource;
}

#pragma mark - UICollectionViewDelegate DataSource FlowLayoutDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    SeventhCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSeventhCellIdentfier forIndexPath:indexPath];
    // 暂无数据
    if (self.dataSource.count > 0) {
//        [cell updateViewWithMerchandiseModel:self.dataSource[indexPath.row]];
        [cell creatSearchTableViewCellWithMerchandiseIntroModel:self.dataSource[indexPath.row]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Name : %@", ((MerchandiseIntroModel *)self.dataSource[indexPath.row]).name);
    if ([self.delegate respondsToSelector:@selector(didSelectItemAtIndexModel:)]) {
        [self.delegate didSelectItemAtIndexModel:(MerchandiseIntroModel *)self.dataSource[indexPath.row]];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = floorf(SCREEN_WIDTH / 2 - 2.5f);
    return CGSizeMake(width, width + 55);
}






























@end
