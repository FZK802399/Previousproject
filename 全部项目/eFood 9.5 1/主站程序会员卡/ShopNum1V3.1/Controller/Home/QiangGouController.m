//
//  QiangGouController.m
//  ShopNum1V3.1
//
//  Created by Right on 15/11/28.
//  Copyright © 2015年 WFS. All rights reserved.
//

#import "QiangGouController.h"
#import "MJRefresh.h"
#import "ProductOneLineListCell.h"
#import "GetXiangshiQiang.h"
#import "DZYMerchandiseDetailController.h"
@interface QiangGouController ()
@property (strong, nonatomic) NSMutableArray *products;
@property (strong, nonatomic) UICollectionViewFlowLayout *listLayout;
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation QiangGouController
+ (instancetype) create {
    return [[QiangGouController alloc]init];
}
- (instancetype) init{
    return [super initWithCollectionViewLayout:self.listLayout];
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
- (void) setupUI {
    self.title = @"限时抢购";
    //导航栏穿透属性
//    self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:self.listLayout];
    self.collectionView.backgroundColor = RGB(239, 239, 239);
//    self.collectionView.dataSource = self;
//    self.collectionView.delegate   = self;
    // 注册cell
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
    LZLOG(@"QiangGouController 销毁");
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

    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFire) userInfo:nil repeats:YES];
}
- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = YES;
    [self.timer invalidate];
//    self.timer = nil;
}

- (void)loadDataForWeb {
    GetXiangshiQiang *api = [[GetXiangshiQiang alloc]initWithPageIndex:self.index count:8];
    // 返回XianShiQiangMode
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
- (void) timerFire{
   [self.collectionView.visibleCells enumerateObjectsUsingBlock:^(ProductOneLineListCell *obj, NSUInteger idx, BOOL *stop) {
       [obj updateTimeLabel];
   }];
}
#pragma mark - <collection代理>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.products.count;
}
// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ProductOneLineListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kProductOneLineListCell forIndexPath:indexPath];
    [self timerFire];
    XianShiQiangMode *mode = self.products[indexPath.item];
    cell.mode = mode;
    return cell;
  
}

- (void)  collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    XianShiQiangMode *model = self.products[indexPath.item];
    DZYMerchandiseDetailController *detailVC = [DZYMerchandiseDetailController create];
    detailVC.Guid = model.ProductGuid;
//    detailVC.EndTime = model.EndTime;
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
