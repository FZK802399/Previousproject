//
//  YiYuanGouOrderListViewController.m
//  ShopNum1V3.1
//
//  Created by Mac on 15/12/31.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "YiYuanGouOrderListViewController.h"
#import "YiYuanGouOrderDetailViewController.h"
#import "MJRefresh.h"
#import "YiYuanGouOrderListCollectionViewCell.h"
#import "YiYuanGouModel.h"
#import "ConfirmPayController.h"

@interface YiYuanGouOrderListViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, YiYuanGouOrderListCollectionViewCellDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (copy, nonatomic) NSMutableArray *collectionViewData;

@end

@implementation YiYuanGouOrderListViewController
{
    NSInteger pageIndex;
    NSInteger pageSize;
    NSString *orderNumber;
    CGFloat allMoney;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self loadLeftBackBtn];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
//    self.navigationItem.leftBarButtonItem
    pageIndex = 1;
    pageSize = 20;
    
    [self.collectionView registerClass:[YiYuanGouOrderListCollectionViewCell class] forCellWithReuseIdentifier:kYiYuanGouOrderListCellIdentifier];
    
    ZDXWeakSelf(weakSelf);
    [self.collectionView addHeaderWithCallback:^{
        pageIndex = 1;
        [weakSelf.collectionViewData removeAllObjects];
        [weakSelf setupCollectionViewData];
    }];
    
    [self.collectionView addFooterWithCallback:^{
        pageIndex ++;
        [weakSelf setupCollectionViewData];
    }];
    
//    kSegueYiYuanGouListToDetail
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.collectionView headerBeginRefreshing];
}

- (void)setupCollectionViewData {
    NSDictionary *dict = @{@"AppSign" : kWebAppSign,
                           @"PageStart" : @(pageIndex),
                           @"PageEnd" : @(pageSize),
                           @"MemLoginID" : self.appConfig.loginName};
//    senghongapp.groupfly.cn/api/OnePurchaseOrderList?/AppSign=c29f79822c9b7943dd8755e9406de04b&PageStart=1&PageEnd=10
    ZDXWeakSelf(weakSelf);
    [YiYuanGouModel fetchYiYuanGouOrderListWithParameters:dict block:^(NSArray *list, NSError *error) {
        [weakSelf.collectionView headerEndRefreshing];
        [weakSelf.collectionView footerEndRefreshing];
        if (error) {
            [weakSelf showErrorMessage:@"网络错误"];
        } else {
            if (list && list.count > 0) {
                [weakSelf.collectionViewData addObjectsFromArray:list];
                [weakSelf.collectionView reloadData];
            } else {
                // 无数据时判断
                if (self.collectionViewData.count > 0) {
                    [weakSelf showMessage:@"暂无更多订单"];
                } else {
                    [weakSelf showMessage:@"暂无订单，赶紧去抢购吧~"];
                }
            }
        }
    }];
}

- (NSMutableArray *)collectionViewData {
    if (!_collectionViewData) {
        _collectionViewData = [NSMutableArray array];
    }
    return _collectionViewData;
}

#pragma mark - UICollectionView Delegate DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.collectionViewData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YiYuanGouOrderListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kYiYuanGouOrderListCellIdentifier forIndexPath:indexPath];
    cell.userInteractionEnabled = YES;
    if (self.collectionViewData.count > 0) {
        YiYuanGouModel *model = self.collectionViewData[indexPath.row];
        cell.delegate = self;
        [cell updateViewWithModel:model];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
//    YiYuanGouModel *model = self.collectionViewData[indexPath.row];
//    orderNumber = model.OrderNumber;
//    [self performSegueWithIdentifier:@"kSegueYiYuanGouListToDetail" sender:self];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    YiYuanGouModel *model = self.collectionViewData[indexPath.row];
    if ([model.OrderStatus isEqualToString:@"待付款"]) {
        ConfirmPayController * vc = ZDX_VC(@"StoryboardIOS7", @"ConfirmPayController");
        vc.saleType = SaleTypeYiYuanGou;
        vc.orderNumber = model.OrderNumber;
        vc.totalPrice = model.AllMoney.doubleValue;
        [self.navigationController pushViewController:vc animated:YES];
        return YES;
    }
    else
    {
        orderNumber = model.OrderNumber;
        [self performSegueWithIdentifier:@"kSegueYiYuanGouListToDetail" sender:self];
        return YES;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(SCREEN_WIDTH, 160);
}

#pragma mark - 付款代理
- (void)didSelectGoBuy:(YiYuanGouOrderListCollectionViewCell *)cell {
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    YiYuanGouModel *model = self.collectionViewData[indexPath.row];
    ConfirmPayController * vc = ZDX_VC(@"StoryboardIOS7", @"ConfirmPayController");
    vc.saleType = SaleTypeYiYuanGou;
    vc.orderNumber = model.OrderNumber;
    vc.totalPrice = model.AllMoney.doubleValue;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"kSegueYiYuanGouListToDetail"]) {
        YiYuanGouOrderDetailViewController *detailVC = [segue destinationViewController];
        detailVC.orderNumber = orderNumber;
    }
}

@end
