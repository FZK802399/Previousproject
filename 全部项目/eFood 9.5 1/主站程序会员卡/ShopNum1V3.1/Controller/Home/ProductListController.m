//
//  ProductListController.m
//  ShopNum1V3.1
//
//  Created by Right on 15/11/24.
//  Copyright © 2015年 WFS. All rights reserved.
//

#import "ProductListController.h"
#import "DZYMerchandiseDetailController.h"
#import "UINavigationBar+BackgroundColor.h"
#import "MJRefresh.h"
#import "CustomSegementView.h"
#import "ProductOneLineListCell.h"
#import "ProductListCell.h"

@interface ProductListController ()<CustomSegementViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UICollectionViewFlowLayout *listLayout;
@property (strong, nonatomic) UICollectionViewFlowLayout *collectLayout;
@property (strong, nonatomic) NSMutableArray *products;

@property (assign, nonatomic) NSInteger index;
@end

@implementation ProductListController
+ (instancetype) createWithType:(CheckProductType)type title:(NSString*)title{
    ProductListController *VC = [[ProductListController alloc]init];
    VC.type  = type;
    VC.title = title;
    return VC;
}
+ (instancetype) create {
    return [[ProductListController alloc]init];
}
- (NSMutableArray*) products{
    if (!_products) {
        _products = [NSMutableArray array];
    }
    return _products;
}
- (UICollectionViewFlowLayout*) listLayout{
    if (!_listLayout) {
        _listLayout = [[UICollectionViewFlowLayout alloc]init];
        _listLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _listLayout.minimumLineSpacing = 1;
        _listLayout.minimumInteritemSpacing = 0;
        _listLayout.itemSize = CGSizeMake(LZScreenWidth, 120);
    }
    return _listLayout;
}
- (UICollectionViewFlowLayout*) collectLayout{
    if (!_collectLayout) {
        _collectLayout = [[UICollectionViewFlowLayout alloc]init];
        _collectLayout.sectionInset = UIEdgeInsetsMake(5, 0, 0, 0);
        _collectLayout.minimumLineSpacing = 5;
        _collectLayout.minimumInteritemSpacing = 5;
        _collectLayout.itemSize = [ProductListCell itemSizeForColumn:2 padding:5];
    }
    return _collectLayout;
}
- (void) setupUI {
    
   self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"list"] style:UIBarButtonItemStylePlain target:self action:@selector(clickRightBtn:)];
    
    //导航栏穿透属性
    //    self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:self.listLayout];
    
    //    [self.collectionView setCollectionViewLayout:self.listLayout];
    ///大图显示
    [self.collectionView setCollectionViewLayout:self.collectLayout];
    self.collectionView.backgroundColor = RGB(239, 239, 239);
    self.collectionView.dataSource = self;
    self.collectionView.delegate   = self;
    // 注册cell
    [self.collectionView registerClass:[ProductListCell class] forCellWithReuseIdentifier:kProductListCell];
    [self.collectionView registerClass:[ProductOneLineListCell class] forCellWithReuseIdentifier:kProductOneLineListCell];
    [self.view addSubview:self.collectionView];
    
    __weak typeof(self) weakSelf = self;
    [self.collectionView addHeaderWithCallback:^{
        weakSelf.index = 1;
        [weakSelf loadDataForWeb];
    }];
    [self.collectionView addFooterWithCallback:^{
        weakSelf.index ++;
        [weakSelf loadDataForWeb];
    }];
}
- (void) dealloc {
    [self.collectionView removeHeader];
    [self.collectionView removeFooter];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];    
    self.index = 1;
    [self loadDataForWeb];
}
- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.translucent = NO;
}
- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = YES;
}
- (void)loadDataForWeb {
    GetProductInfoApi *api = [[GetProductInfoApi alloc]initWithType:self.type pageIndex:self.index pageCount:10];
    // NSArray<ProductInfoMode *> *DATA
    [api startWtihCallBackSuccess:^(NSArray *DATA) {
        if (self.index == 1) {
            [self.products removeAllObjects];
            [self.collectionView headerEndRefreshing];
        }else{
            [self.collectionView footerEndRefreshing];
        }
        [self.products addObjectsFromArray:DATA];
        [self.collectionView reloadData];
    } failure:nil];
}

- (void) clickRightBtn:(UIBarButtonItem*) sender{
    sender.enabled = NO;
    __weak typeof(self) weakSelf = self;
    if (self.collectionView.collectionViewLayout == self.listLayout) {
        [self.collectionView setCollectionViewLayout:self.collectLayout animated:YES completion:^(BOOL finished) {
            [weakSelf.collectionView reloadData];
            sender.enabled = YES;
        }];
    }else {
        [self.collectionView setCollectionViewLayout:self.listLayout animated:YES completion:^(BOOL finished) {
            [weakSelf.collectionView reloadData];
            sender.enabled = YES;
        }];
    }
}

#pragma mark - <collection代理>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.products.count;
}
// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView.collectionViewLayout == self.listLayout) {
        ProductOneLineListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kProductOneLineListCell forIndexPath:indexPath];
        cell.mode = self.products[indexPath.item];
        return cell;
    }else{
        ProductListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kProductListCell forIndexPath:indexPath];
        cell.mode = self.products[indexPath.item];
        return cell;

    }
}
- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ProductInfoMode *model = self.products[indexPath.item];
    DZYMerchandiseDetailController *detailVC = [DZYMerchandiseDetailController create];
    detailVC.Guid = model.Guid;
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
