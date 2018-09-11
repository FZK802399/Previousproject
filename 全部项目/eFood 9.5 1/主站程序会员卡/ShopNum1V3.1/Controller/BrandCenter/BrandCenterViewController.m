//
//  BrandCenterViewController.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-9.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "BrandCenterViewController.h"
#import "brandCollectionViewCell.h"
#import "SearchResultViewController.h"
#import "ShopsViewController.h"
#import "ZDXMoveView.h"
#import "SearchResultViewController.h"

@interface BrandCenterViewController ()<ZDXMoveViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (copy, nonatomic) NSArray *recommendBrand; // 推荐品牌
@property (copy, nonatomic) NSArray *collectionViewData; // 储存视图数据
@property (copy, nonatomic) NSArray *allBrandData; // 所有品牌

@property (strong, nonatomic) ZDXMoveView *moveView;

@end

@implementation BrandCenterViewController
{
    NSString * brandGuid;
    NSString * brandName;
    NSString * webSiteUrl;
}
+ (instancetype) create {
    return [[UIStoryboard storyboardWithName:@"StoryboardIOS7" bundle:nil]instantiateViewControllerWithIdentifier:@"BrandCenterViewController"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"品牌推荐";
    [self loadLeftBackBtn];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.allBrandView.collectionViewLayout;
    layout.sectionInset = UIEdgeInsetsMake(3, 0, 0, 0);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 3;
    CGFloat itemWidth = (SCREEN_WIDTH - 9) / 4.0f;
    CGFloat itemHeight = itemWidth * 1.2;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    [self.allBrandView registerClass:[brandCollectionViewCell class] forCellWithReuseIdentifier:kAllBrandCollectionCellMainView];
    [self setupRecommendBrandData];
    [self setupMoveView];
}



- (void)setupMoveView {
    
    CGRect frame = self.topView.bounds;
    frame.size.width = SCREEN_WIDTH;
    self.moveView = [[ZDXMoveView alloc] initWithFrame:frame buttons:@[@"推荐大牌", @"全部品牌"]];
    NSLog(@"Frame : %@", NSStringFromCGRect(frame));
    self.moveView.addSeparation = YES;
    [self.moveView setButtonTitleSelectedColor:[UIColor barTitleColor]];
    [self.moveView setButtonTitleNormalColor:[UIColor colorWithWhite:0.361 alpha:1.000]];
    [self.moveView setButtonTitleNormalFontSize:14.0];
    [self.moveView setSeparationColor:[UIColor colorWithWhite:0.852 alpha:1.000]];
    [self.moveView setTopLineColor:[UIColor whiteColor]];
    [self.moveView setBottomLineColor:[UIColor colorWithWhite:0.852 alpha:1.000]];
    [self.moveView setMoveViewHeight:2.0];
    self.moveView.delegate = self;
    [self.topView addSubview:self.moveView];
}

- (void)setupRecommendBrandData{
//    IsRecommend=1&AppSign=
    ZDXWeakSelf(weakSelf);
    [self showLoadView];
    [BrandModel getRecommendBrandsByParamer:@{@"IsRecommend" : @"1" , @"AppSign" : kWebAppSign} andBlocks:^(NSArray *brandList, NSError *error) {
        [weakSelf hideLoadView];
        if (error) {
            [weakSelf showErrorMessage:@"网络错误"];
        } else {
            if (brandList && brandList.count > 0) {
                weakSelf.recommendBrand = brandList;
            } else {
                weakSelf.recommendBrand = @[];
                [weakSelf showMessage:@"暂无推荐品牌"];
            }
            weakSelf.collectionViewData = weakSelf.recommendBrand;
            [weakSelf.allBrandView reloadData];
        }
    }];
}


//加载全部品牌数据
-(void)loadAllBrandData {
    [self.appConfig loadConfig];
    NSDictionary *getBrandIntroDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                      kWebAppSign, @"AppSign", nil];
    ZDXWeakSelf(weakSelf);
    [self showLoadView];
    [BrandModel getAllBrandsByParamer:getBrandIntroDic andBlocks:^(NSArray *brandList, NSError *error) {
        [weakSelf hideLoadView];
        if(error){
            [weakSelf showErrorMessage:@"网络错误"];
        } else {
            NSInteger introCount;
            if (![brandList isEqual:[NSNull null]]) {
                introCount = [brandList count];
            }
            //首先判断是否有数据
            if (introCount > 0) {
                weakSelf.allBrandData = brandList;
            } else {
                weakSelf.allBrandData = @[];
                [weakSelf showMessage:@"暂无品牌"];
            }
            weakSelf.collectionViewData = weakSelf.allBrandData;
            [weakSelf.allBrandView reloadData];
        }
    }];
}

#pragma mark - 点击事件代理
- (void)moveView:(ZDXMoveView *)moveView didSelectButtonIndex:(NSInteger)index {
    if (index == 0) {
        // 推荐品牌
        if (self.recommendBrand.count == 0) {
            [self showMessage:@"暂无推荐品牌"];
        }
        self.collectionViewData = self.recommendBrand;
        [self.allBrandView reloadData];
    } else {
        // 全部品牌
        if (self.allBrandData) {
            if (self.allBrandData.count == 0) {
                [self showMessage:@"暂无品牌"];
            }
            self.collectionViewData = self.allBrandData;
            [self.allBrandView reloadData];
        } else {
            [self loadAllBrandData];
        }
    }
}

#pragma mark - collection数据源代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.collectionViewData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    brandCollectionViewCell *cell;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:kAllBrandCollectionCellMainView forIndexPath:indexPath];
    [cell creatbrandCollectionViewCellWithMerchandiseIntroModel:[self.collectionViewData objectAtIndex:indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BrandModel * tempBrand;
    tempBrand = [self.collectionViewData objectAtIndex:indexPath.row];
    brandGuid = tempBrand.guid;
    brandName = tempBrand.name;
    webSiteUrl = tempBrand.webSiteUrl;
    [self performSegueWithIdentifier:kSegueBrandCenterToResult sender:self];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
     if ([segue.identifier isEqualToString:kSegueBrandCenterToResult]) {
         SearchResultViewController *searchVC = [segue destinationViewController];
         searchVC.searchBrandGuid = brandGuid;
         searchVC.TitleName = brandName;
     }
 }

@end
