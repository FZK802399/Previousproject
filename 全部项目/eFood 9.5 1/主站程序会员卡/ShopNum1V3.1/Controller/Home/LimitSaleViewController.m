//
//  LimitSaleViewController.m
//  ShopNum1V3.1
//
//  Created by Mac on 15/11/27.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "LimitSaleViewController.h"
#import "LimitSaleDetailViewController.h"
#import "YiYuanGouDetailViewController.h"

#import "SaleProductModel.h"
#import "YiYuanGouModel.h"

#import "SaleLimitedCollectionViewCell.h"
#import "YiYuanGouCollectionViewCell.h"
#import "XianLiangQiangCollectionViewCell.h"

static NSString *LIMILTEDCollectionViewCellIdentifier = @"LIMILTEDCollectionViewCell";

@interface LimitSaleViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (copy, nonatomic) NSArray *collectionViewData;

@end

@implementation LimitSaleViewController
{
    NSTimer *showTimer;
    id currentModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadLeftBackBtn];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.collectionView registerClass:[YiYuanGouCollectionViewCell class] forCellWithReuseIdentifier:kYiYuanGouCellIdentifier];
    [self.collectionView registerClass:[SaleLimitedCollectionViewCell class] forCellWithReuseIdentifier:LIMILTEDCollectionViewCellIdentifier];
    [self.collectionView registerClass:[XianLiangQiangCollectionViewCell class] forCellWithReuseIdentifier:kXianLiangQiangCellIdentifier];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0.5;
    layout.sectionInset = UIEdgeInsetsZero;
    layout.itemSize = CGSizeMake(SCREEN_WIDTH, 100);
    
    [self setupCollectionViewData];
}

- (void)setupCollectionViewData {
    if (self.saleType == SaleTypeYiYuanGou) {
        self.title = @"一元购";
        [self setupYiYuanGouData];
    } else if (self.saleType == SaleTypeXianShiGou) {
        self.title = @"限时抢购";
        [self loadSaleLimitedView];
    } else if (self.saleType == SaleTypeXianLiangGou) {
        self.title = @"限量抢购";
        [self setupXianLiangData];
    }
}

// 1元购
- (void)setupYiYuanGouData {
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"1", @"PageStart",
                          @"100", @"PageEnd",
                          [AppConfig sharedAppConfig].appSign, @"AppSign", nil];
    ZDXWeakSelf(weakSelf);
    [YiYuanGouModel fetchYiYuanGouListWithParameters:dict block:^(NSArray *list, NSError *error) {
        if (error) {
            [weakSelf showErrorMessage:@"网络错误"];
        } else {
            if (list && list.count > 0) {
                weakSelf.collectionViewData = list;
                [weakSelf.collectionView reloadData];
            } else {
                [weakSelf showMessage:@"暂无数据"];
            }
        }
    }];
}

// 限量抢
- (void)setupXianLiangData {
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"1", @"pageIndex",
                          @"100", @"pageSize",
                          [AppConfig sharedAppConfig].appSign, @"AppSign", nil];
    
    ZDXWeakSelf(weakSelf);
    [SaleProductModel getXianLiangListByParamer:dict andBlocks:^(NSArray *List, NSError *error) {
        if(error){
            [weakSelf showErrorMessage:@"网络错误"];
        }else {
            NSInteger introCount = [List count];
            //首先判断是否有数据
            if (introCount > 0) {
                weakSelf.collectionViewData = List;
                [weakSelf.collectionView reloadData];
            } else {
                [weakSelf showMessage:@"暂无数据"];
            }
        }
    }];

}


// 限时抢
-(void)loadSaleLimitedView {
    
    NSDictionary *limitedMerchandiseIntroDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                                @"1", @"pageIndex",
                                                @"100", @"pageSize",
                                                kWebAppSign, @"AppSign", nil];
    
    ZDXWeakSelf(weakSelf);
    [SaleProductModel getSaleProductListByParamer:limitedMerchandiseIntroDic andBlocks:^(NSArray *SaleProductList, NSError *error) {
        if(error){            
            [weakSelf showErrorMessage:@"网络错误"];
        }else {
            NSInteger introCount = [SaleProductList count];
            //首先判断是否有数据
            if (introCount > 0) {
                weakSelf.collectionViewData = [NSMutableArray arrayWithArray:SaleProductList];
                [weakSelf.collectionView reloadData];
                showTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                             target:weakSelf
                                                           selector:@selector(timeDecreasing)
                                                           userInfo:nil
                                                            repeats:YES];
            } else {
                [weakSelf showMessage:@"暂无数据"];
            }
        }
    }];
}

-(void)timeDecreasing {
    for (SaleProductModel *temp in self.collectionViewData) {
        temp.RemainingTime -= 1;
    }
    [self.collectionView reloadData];
}

#pragma mark - collection数据源代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.collectionViewData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.saleType) {
        case SaleTypeYiYuanGou: {
            YiYuanGouCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kYiYuanGouCellIdentifier forIndexPath:indexPath];
            [cell updateViewWithModel:self.collectionViewData[indexPath.row]];
             return cell;
            break;
        }
        case SaleTypeXianShiGou: {
            SaleLimitedCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LIMILTEDCollectionViewCellIdentifier forIndexPath:indexPath];
            [cell creatSaleLimitedCollectionViewCellWithMerchandiseIntroModel:[self.collectionViewData objectAtIndex:indexPath.row]];
            return cell;
            break;
        }
        case SaleTypeXianLiangGou: {
            XianLiangQiangCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXianLiangQiangCellIdentifier forIndexPath:indexPath];
            [cell updateViewWithModel:self.collectionViewData[indexPath.row]];
            return cell;
            break;
        }
        default: {
            break;
        }
    }
    
    

    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    currentModel = [self.collectionViewData objectAtIndex:indexPath.row];
    
    if (self.saleType == SaleTypeYiYuanGou) {
        [self performSegueWithIdentifier:@"kSegueLimitSaleToYiYuanGou" sender:self];
    } else {
        [self performSegueWithIdentifier:@"kSegueLimitSaleToDetail" sender:self];
    }
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"kSegueLimitSaleToDetail"]) {
        LimitSaleDetailViewController *detailVC = [segue destinationViewController];
        detailVC.saleType = self.saleType;
        detailVC.model = currentModel;
    }
    if ([segue.identifier isEqualToString:@"kSegueLimitSaleToYiYuanGou"]) {
        YiYuanGouDetailViewController *detailVC = [segue destinationViewController];
        detailVC.model = currentModel;
    }
}


@end
