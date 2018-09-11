//
//  FavourTicketViewController.m
//  ShopNum1V3.1
//
//  Created by Mac on 16/1/12.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import "FavourTicketViewController.h"
#import "FavourTicketModel.h"
#import "FavourTicketCollectionViewCell.h"

@interface FavourTicketViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation FavourTicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = false;
    UINib *nib = [UINib nibWithNibName:kFavourTicketCollectionViewCellIdentifier bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:kFavourTicketCollectionViewCellIdentifier];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.itemSize = CGSizeMake(SCREEN_WIDTH, 90);
    layout.minimumLineSpacing = 0.5;
//    layout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);
    
    if (!self.ticketData || self.ticketData.count == 0) {
        [self setupCollectionViewData];
    }
}

- (void)setupCollectionViewData {
    ZDXWeakSelf(weakSelf);
    [FavourTicketModel fetchFavourTicketListWithParameter:@{@"AppSign" : kWebAppSign , @"MemLoginID" : self.appConfig.loginName} block:^(NSArray *list, NSError *error) {
        if (error) {
            [weakSelf showErrorMessage:@"网络错误"];
        } else {
            if (list && list.count > 0) {
                weakSelf.ticketData = list;
                [weakSelf.collectionView reloadData];
            } else {
                [weakSelf showMessage:@"暂无优惠券"];
            }
        }
    }];
}


#pragma mark - UICollectionView Delegate DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.ticketData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FavourTicketCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFavourTicketCollectionViewCellIdentifier forIndexPath:indexPath];
    if (self.ticketData && self.ticketData.count > 0) {
        [cell updateViewWithFavourTicketModel:self.ticketData[indexPath.row]];
    }
    return cell;
}



@end
