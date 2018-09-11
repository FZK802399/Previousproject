//
//  IntegralViewController.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-15.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "WFSViewController.h"
#import "PAImageView.h"
///积分兑换
@interface IntegralViewController : WFSViewController<UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *allScollView;
@property (strong, nonatomic) IBOutlet UILabel *userScore;

@property (strong, nonatomic) IBOutlet UILabel *userName;

@property (strong, nonatomic) PAImageView *userImage;

@property (strong, nonatomic) IBOutlet UIView *ScoreHotView;

@property (strong, nonatomic) IBOutlet UICollectionView *HotScoreProductView;

@property (strong, nonatomic) IBOutlet UIView *ScoreFreshView;

@property (strong, nonatomic) IBOutlet UICollectionView *FreshScoreProductView;

@property (strong, nonatomic) IBOutlet UIView *ScoreBoutiqueView;

@property (strong, nonatomic) IBOutlet UICollectionView *BoutiqueScoreProductView;

@property (strong, nonatomic) IBOutlet UIView *ScoreRecommendView;

@property (strong, nonatomic) IBOutlet UICollectionView *RecommendScoreProductView;

@property (strong, nonatomic) NSMutableArray *ScoreHotProductData;
@property (strong, nonatomic) NSMutableArray *ScoreFreshProductData;
@property (strong, nonatomic) NSMutableArray *ScoreRecommendProductData;
@property (strong, nonatomic) NSMutableArray *ScoreBoutiqueProductData;

@property (strong, nonatomic) IBOutlet UIButton *SigninButton;

- (IBAction)checkGetScore:(id)sender;
- (IBAction)getMoreMerchandiseAction:(id)sender;

@end
