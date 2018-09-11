//
//  BrandCenterViewController.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-9.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "WFSViewController.h"

@interface BrandCenterViewController : WFSViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
//推荐大牌
//@property (strong, nonatomic) IBOutlet UICollectionView *recommendView;
//@property (strong,nonatomic) NSMutableArray * recommendBrandData;
//所有品牌
@property (strong, nonatomic) IBOutlet UICollectionView *allBrandView;

+ (instancetype) create;

@end
