//
//  YiYuanGouPinJiaViewController.m
//  ShopNum1V3.1
//
//  Created by Mac on 15/12/29.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "YiYuanGouPinJiaViewController.h"
#import "PinJiaCollectionViewCell.h"

@interface YiYuanGouPinJiaViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation YiYuanGouPinJiaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadLeftBackBtn];
    self.automaticallyAdjustsScrollViewInsets = false;
    
    UINib *pinJiaNib = [UINib nibWithNibName:kPinJiaCellIdentifier bundle:nil];
    [self.collectionView registerNib:pinJiaNib forCellWithReuseIdentifier:kPinJiaCellIdentifier];
}

#pragma mark - UICollectionViewDelegate DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.pinJiaData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PinJiaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPinJiaCellIdentifier forIndexPath:indexPath];
    [cell updateViewWithMerchandisePingJiaModel:self.pinJiaData[indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [PinJiaCollectionViewCell sizeWithMerchandisePingJiaModel:self.pinJiaData[indexPath.row]];
}



@end
