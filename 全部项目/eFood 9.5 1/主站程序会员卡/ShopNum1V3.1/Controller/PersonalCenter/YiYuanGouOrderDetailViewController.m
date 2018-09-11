//
//  YiYuanGouOrderDetailViewController.m
//  ShopNum1V3.1
//
//  Created by Mac on 15/12/31.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "YiYuanGouOrderDetailViewController.h"

#import "YiYuanGouDetailBaseCollectionViewCell.h"
#import "YiYuanGouDetailAddressCollectionViewCell.h"
#import "YiYuanGouDetailOrderCollectionViewCell.h"
#import "YiYuanGouDetailCouponsCollectionViewCell.h"
#import "YiYuanGouOrderDetailCollectionViewCell.h"
#import "LogisticsViewController.h"

#import "YiYuanGouModel.h"

@interface YiYuanGouOrderDetailViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, YiYuanGouDetailBaseCollectionViewCellDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) YiYuanGouModel *yiYuanGouModel;

@end

@implementation YiYuanGouOrderDetailViewController
{
    NSInteger couponsCellHeight;
    BOOL isExtend;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadLeftBackBtn];
    self.automaticallyAdjustsScrollViewInsets = NO;
    couponsCellHeight = 65;
    
    [self registerCells];
    [self setupCollectionViewData];
}

- (void)registerCells {
    
    [self.collectionView registerClass:[YiYuanGouDetailAddressCollectionViewCell class] forCellWithReuseIdentifier:kYiYuanGouDetailAddressCellIdentifier];
    [self.collectionView registerClass:[YiYuanGouDetailOrderCollectionViewCell class] forCellWithReuseIdentifier:kYiYuanGouDetailOrderCellIdentifier];
    [self.collectionView registerClass:[YiYuanGouDetailCouponsCollectionViewCell class] forCellWithReuseIdentifier:kYiYuanGouDetailCouponsCellIdentifier];
    [self.collectionView registerClass:[YiYuanGouOrderDetailCollectionViewCell class] forCellWithReuseIdentifier:kYiYuanGouOrderDetailCellIdentifier];
}

- (void)setupCollectionViewData {
    
    NSDictionary *dict = @{@"AppSign" : kWebAppSign,
                           @"OrderNumber" : self.orderNumber};
    
    ZDXWeakSelf(weakSelf)
    [YiYuanGouModel fetchYiYuanGouOrderDetailWithParameters:dict block:^(YiYuanGouModel *model, NSError *error) {
        if (error) {
            [weakSelf showErrorMessage:@"网络错误"];
        } else {
            if (model) {
                weakSelf.yiYuanGouModel = model;
                [weakSelf.collectionView reloadData];
            } else {
                [weakSelf showErrorMessage:@"获取订单信息失败"];
            }
        }
    }];
}

#pragma mark - UICollectionView Delegate DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YiYuanGouDetailBaseCollectionViewCell *cell;
    switch (indexPath.section) {
        case 0:
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:kYiYuanGouDetailAddressCellIdentifier forIndexPath:indexPath];
            break;
        case 1:
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:kYiYuanGouDetailOrderCellIdentifier forIndexPath:indexPath];
            break;
        case 2:
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:kYiYuanGouDetailCouponsCellIdentifier forIndexPath:indexPath];
            break;
        case 3:
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:kYiYuanGouOrderDetailCellIdentifier forIndexPath:indexPath];
            break;
        default:
            break;
    }
    if (self.yiYuanGouModel) {
        cell.delegate = self;
        self.yiYuanGouModel.isExtend = isExtend;
        [cell updateViewWithModel:self.yiYuanGouModel];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize itemSize = CGSizeMake(SCREEN_WIDTH, 0);
    switch (indexPath.section) {
        case 0:
            itemSize.height = 70;
            break;
        case 1:
            itemSize.height = 160;
            break;
        case 2:
            itemSize.height = couponsCellHeight;
            break;
        case 3:
            itemSize.height = 130;
            break;
        default:
            break;
    }
    return itemSize;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        // 物流明细
//        [self showMessage:@"查看物流"];
        
    } else if (indexPath.section == 2) {
        // 展开抽奖信息
        if (self.yiYuanGouModel.coupons.count > 1) {
            if (isExtend) {
                couponsCellHeight = 65;
            } else {
                couponsCellHeight += 25 * (self.yiYuanGouModel.coupons.count - 1);
            }
            isExtend = !isExtend;
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:2]];
        } else {
            [self showMessage:@"无更多抽奖券"];
        }
        
    }
}

- (void)didSelectCheckLogistics {
    LogisticsViewController * lvc= [[UIStoryboard storyboardWithName:@"StoryboardIOS7" bundle:nil]instantiateViewControllerWithIdentifier:@"LogisticsViewController"];
    NSString * str = [NSString stringWithFormat:@"http://m.kuaidi100.com/index_all.html?type=%@&postid=%@",self.yiYuanGouModel.LogisticsCompanyCode,self.yiYuanGouModel.ShipmentNumber];
    lvc.LogisticsURL = [NSURL URLWithString:str];
    [self.navigationController pushViewController:lvc animated:YES];
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
