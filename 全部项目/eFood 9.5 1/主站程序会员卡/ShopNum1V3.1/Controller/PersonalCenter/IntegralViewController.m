//
//  IntegralViewController.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-15.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "IntegralViewController.h"
#import "recommendCollectionViewCell.h"
#import "UserInfoModel.h"
#import "DZYMerchandiseDetailController.h"
#import "SearchResultViewController.h"

@interface IntegralViewController ()<XYSpriteDelegate>

@end

@implementation IntegralViewController
{
    NSString *GuID;
    
    NSString * todayStr;
    
    NSInteger TypeID;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //添加返回按钮
    [self loadLeftBackBtn];
//    [self loadRightFilterBtn];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyyMMdd";
    todayStr = [df stringFromDate:[NSDate date]];
    
    NSDictionary * checkDic = [self readApplicationData:@"SignIn"];
    if (checkDic) {
        if ([todayStr isEqualToString:[checkDic objectForKey:@"today"]]) {
            [self.SigninButton setImage:[UIImage imageNamed:@"btn_haveSignin_normal.png"] forState:UIControlStateNormal];
            self.SigninButton.enabled = NO;
        }
    }
    self.ScoreHotView.layer.borderWidth = 1;
    self.ScoreHotView.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
    self.ScoreFreshView.layer.borderWidth = 1;
    self.ScoreFreshView.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
    self.ScoreBoutiqueView.layer.borderWidth = 1;
    self.ScoreBoutiqueView.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
    self.ScoreRecommendView.layer.borderWidth = 1;
    self.ScoreRecommendView.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
    
    //签到按钮外观设计
    //    [self.SigninButton.layer setMasksToBounds:YES];
    //    [self.SigninButton.layer setCornerRadius:5.0f];
    //    [self.SigninButton.layer setBorderWidth:1.0f];
    
    [self.HotScoreProductView registerClass:[recommendCollectionViewCell class] forCellWithReuseIdentifier:kScoreProductCollectionCellMainView];
    [self.FreshScoreProductView registerClass:[recommendCollectionViewCell class] forCellWithReuseIdentifier:kScoreProductCollectionCellMainView];
    [self.RecommendScoreProductView registerClass:[recommendCollectionViewCell class] forCellWithReuseIdentifier:kScoreProductCollectionCellMainView];
    [self.BoutiqueScoreProductView registerClass:[recommendCollectionViewCell class] forCellWithReuseIdentifier:kScoreProductCollectionCellMainView];
    
    //适配ios6、7
    CGFloat originY = 20;
    
    self.userImage = [[PAImageView alloc]initWithFrame:CGRectMake(20, originY, 70, 70) backgroundProgressColor:[UIColor whiteColor] progressColor:[UIColor lightGrayColor]];
    UIImage *blankImg = [UIImage imageNamed:@"blank_home_banner.png"];
    [self.userImage updateWithImageWithURL:[NSURL URLWithString:@"http://fxv85.nrqiang.com/ImgUpload/70f70f0a66d61948708c529d417693bc.jpg_180x180.jpg"] placeholderImage:blankImg animated:YES];
    // Do any additional setup after loading the view.
    [self.allScollView addSubview:self.userImage];
    
    [self.allScollView addSubview:self.ScoreHotView];
    [self.allScollView addSubview:self.ScoreBoutiqueView];
    [self.allScollView addSubview:self.ScoreFreshView];
    [self.allScollView addSubview:self.ScoreRecommendView];
    
    [self.allScollView setContentSize:CGSizeMake(320, 2000)];
    self.allScollView.scrollEnabled = YES;
    
    [self loadUserScore];
    [self loadScoreHotProductView];
    [self loadScoreRecommendProductView];
    [self loadScoreBoutiqueProductView];
    [self loadScoreFreshProductView];
}

-(void)loadUserScore{
    
    NSDictionary * userinfoDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                  self.appConfig.loginName, @"MemLoginID",
                                  kWebAppSign, @"AppSign",nil];
    [UserInfoModel getUserInfoByParamer:userinfoDic andblocks:^(UserInfoModel *user, NSError *error) {
        if(error){
            
            [TSMessage showNotificationWithTitle:NSLocalizedString(@"获取信息错误，点击屏幕重新加载", nil)
                                        subtitle:NSLocalizedString(@"网络连接失败，请检查网络设置", nil)
                                            type:TSMessageNotificationTypeError];
            
        }else{
            
            //首先判断是否有数据
            if (user) {
                self.userName.text = user.loginName;
                self.userScore.text = [NSString stringWithFormat:@"积分：%d", user.userScore];
                UIImage *blankImg = [UIImage imageNamed:@"userphoto.png"];
                [self.userImage updateWithImageWithURL:user.userPhoto placeholderImage:blankImg animated:YES];
            }
        }
        
    }];
}

-(void)loadRightFilterBtn{
    
    UIImage * backImage = [UIImage imageNamed:@"barbtn_filter_normal.png"];
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, backImage.size.width, backImage.size.height);
    [backBtn setBackgroundImage:backImage forState:UIControlStateNormal];
//    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [backBtn addTarget:self action:@selector(filterMerchandiseAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    /**
     *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-5时，间距正好调整
     *  为0；width为正数时，正好相反，相当于往左移动width数值个像素
     */
    if (kCurrentSystemVersion >= 7.0) {
        negativeSpacer.width = -10;
    }else{
        negativeSpacer.width = 0;
    }
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, barBtnItem, nil];
    //    self.navigationItem.leftBarButtonItem = barBtnItem;
}

-(void)filterMerchandiseAction:(id)sender{

    [self performSegueWithIdentifier:kSegueScoreProductToSort sender:nil];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  加载ScoreProductView
 */
-(void)loadScoreBoutiqueProductView{
    
    NSDictionary *MerchandiseIntroDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                         @"0", @"ScoreProductCategoryID",
                                         @"1", @"pageIndex",
                                         @"4", @"pageSize",
                                         @"1", @"IsBest",
                                         @"0", @"IsNew",
                                         @"0", @"IsHot",
                                         @"0", @"IsRecommend",
                                         kWebAppSign, @"AppSign", nil];
    [ScoreProductIntroModel getScoreMerchandiseIntroForHomeShowByParamer:MerchandiseIntroDic andBlocks:^(NSArray *merchandiseList, NSError *error) {
        if(error){
            
            [TSMessage showNotificationWithTitle:NSLocalizedString(@"获取信息错误，点击屏幕重新加载", nil)
                                        subtitle:NSLocalizedString(@"网络连接失败，请检查网络设置", nil)
                                            type:TSMessageNotificationTypeError];
            
        }else{
            NSInteger introCount = [merchandiseList count];
            
            //首先判断该城市是否有数据
            if (introCount > 0) {
                self.ScoreBoutiqueProductData = [NSMutableArray arrayWithArray:merchandiseList];
                [self.BoutiqueScoreProductView reloadData];
                [self.allScollView addSubview:self.ScoreHotView];
                [self.allScollView addSubview:self.ScoreBoutiqueView];
                [self.allScollView addSubview:self.ScoreFreshView];
                [self.allScollView addSubview:self.ScoreRecommendView];
                
                [self.allScollView setContentSize:CGSizeMake(320, 2000)];
                self.allScollView.scrollEnabled = YES;
            }
        }
    }];
    
}

-(void)loadScoreHotProductView{
    
    NSDictionary *MerchandiseIntroDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                         @"0", @"ScoreProductCategoryID",
                                         @"1", @"pageIndex",
                                         @"4", @"pageSize",
                                         @"0", @"IsBest",
                                         @"0", @"IsNew",
                                         @"1", @"IsHot",
                                         @"0", @"IsRecommend",
                                         kWebAppSign, @"AppSign", nil];
    [ScoreProductIntroModel getScoreMerchandiseIntroForHomeShowByParamer:MerchandiseIntroDic andBlocks:^(NSArray *merchandiseList, NSError *error) {
        if(error){
            
            [TSMessage showNotificationWithTitle:NSLocalizedString(@"获取信息错误，点击屏幕重新加载", nil)
                                        subtitle:NSLocalizedString(@"网络连接失败，请检查网络设置", nil)
                                            type:TSMessageNotificationTypeError];
            
        }else{
            NSInteger introCount = [merchandiseList count];
            
            //首先判断该城市是否有数据
            if (introCount > 0) {
                self.ScoreHotProductData = [NSMutableArray arrayWithArray:merchandiseList];
                [self.HotScoreProductView reloadData];
                [self.allScollView addSubview:self.ScoreHotView];
                [self.allScollView addSubview:self.ScoreBoutiqueView];
                [self.allScollView addSubview:self.ScoreFreshView];
                [self.allScollView addSubview:self.ScoreRecommendView];
                
                [self.allScollView setContentSize:CGSizeMake(320, 2000)];
                self.allScollView.scrollEnabled = YES;
            }
        }
    }];
    
    
}

-(void)loadScoreFreshProductView{
    
    NSDictionary *MerchandiseIntroDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                         @"0", @"ScoreProductCategoryID",
                                         @"1", @"pageIndex",
                                         @"4", @"pageSize",
                                         @"0", @"IsBest",
                                         @"1", @"IsNew",
                                         @"0", @"IsHot",
                                         @"0", @"IsRecommend",
                                         kWebAppSign, @"AppSign", nil];
    [ScoreProductIntroModel getScoreMerchandiseIntroForHomeShowByParamer:MerchandiseIntroDic andBlocks:^(NSArray *merchandiseList, NSError *error) {
        if(error){
            
            [TSMessage showNotificationWithTitle:NSLocalizedString(@"获取信息错误，点击屏幕重新加载", nil)
                                        subtitle:NSLocalizedString(@"网络连接失败，请检查网络设置", nil)
                                            type:TSMessageNotificationTypeError];
            
        }else{
            NSInteger introCount = [merchandiseList count];
            
            //首先判断该城市是否有数据
            if (introCount > 0) {
                self.ScoreFreshProductData = [NSMutableArray arrayWithArray:merchandiseList];
                [self.FreshScoreProductView reloadData];
                [self.allScollView addSubview:self.ScoreHotView];
                [self.allScollView addSubview:self.ScoreBoutiqueView];
                [self.allScollView addSubview:self.ScoreFreshView];
                [self.allScollView addSubview:self.ScoreRecommendView];
                
                [self.allScollView setContentSize:CGSizeMake(320, 2000)];
                self.allScollView.scrollEnabled = YES;
            }
        }
    }];
    
}

-(void)loadScoreRecommendProductView{
    
    NSDictionary *MerchandiseIntroDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                         @"0", @"ScoreProductCategoryID",
                                         @"1", @"pageIndex",
                                         @"4", @"pageSize",
                                         @"0", @"IsBest",
                                         @"0", @"IsNew",
                                         @"0", @"IsHot",
                                         @"1", @"IsRecommend",
                                         kWebAppSign, @"AppSign", nil];
    [ScoreProductIntroModel getScoreMerchandiseIntroForHomeShowByParamer:MerchandiseIntroDic andBlocks:^(NSArray *merchandiseList, NSError *error) {
        if(error){
            
            [TSMessage showNotificationWithTitle:NSLocalizedString(@"获取信息错误，点击屏幕重新加载", nil)
                                        subtitle:NSLocalizedString(@"网络连接失败，请检查网络设置", nil)
                                            type:TSMessageNotificationTypeError];
            
        }else{
            NSInteger introCount = [merchandiseList count];
            
            //首先判断该城市是否有数据
            if (introCount > 0) {
                self.ScoreRecommendProductData = [NSMutableArray arrayWithArray:merchandiseList];
                [self.RecommendScoreProductView reloadData];
                [self.allScollView addSubview:self.ScoreHotView];
                [self.allScollView addSubview:self.ScoreBoutiqueView];
                [self.allScollView addSubview:self.ScoreFreshView];
                [self.allScollView addSubview:self.ScoreRecommendView];
                
                [self.allScollView setContentSize:CGSizeMake(320, 2000)];
                self.allScollView.scrollEnabled = YES;
            }
        }
    }];
    
}



#pragma mark - collection数据源代理

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == self.HotScoreProductView) {
        return self.ScoreHotProductData.count;
    }
    if (collectionView == self.FreshScoreProductView) {
        return self.ScoreFreshProductData.count;
    }
    if (collectionView == self.RecommendScoreProductView) {
        return self.ScoreRecommendProductData.count;
    }
    if (collectionView == self.BoutiqueScoreProductView) {
        return self.ScoreBoutiqueProductData.count;
    }
    return 0;
    
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ScoreProductIntroModel * ScoreProductModel = nil;
    recommendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kScoreProductCollectionCellMainView forIndexPath:indexPath];
    
    if (collectionView == self.HotScoreProductView) {
        ScoreProductModel = [self.ScoreHotProductData objectAtIndex:indexPath.row];
    }
    if (collectionView == self.FreshScoreProductView) {
        ScoreProductModel = [self.ScoreFreshProductData objectAtIndex:indexPath.row];    }
    if (collectionView == self.RecommendScoreProductView) {
        ScoreProductModel = [self.ScoreRecommendProductData objectAtIndex:indexPath.row];
    }
    if (collectionView == self.BoutiqueScoreProductView) {
        ScoreProductModel = [self.ScoreBoutiqueProductData objectAtIndex:indexPath.row];
    }
    
    [cell creatrecommendCollectionViewCellWithScoreProductIntroModel:ScoreProductModel];
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ScoreProductIntroModel * tempData = nil;
    
    if (collectionView == self.HotScoreProductView) {
        tempData = [self.ScoreHotProductData objectAtIndex:indexPath.row];
    }
    if (collectionView == self.FreshScoreProductView) {
        tempData = [self.ScoreFreshProductData objectAtIndex:indexPath.row];    }
    if (collectionView == self.RecommendScoreProductView) {
        tempData = [self.ScoreRecommendProductData objectAtIndex:indexPath.row];
    }
    if (collectionView == self.BoutiqueScoreProductView) {
        tempData = [self.ScoreBoutiqueProductData objectAtIndex:indexPath.row];
    }
    
    GuID = tempData.guid;
    
    [self performSegueWithIdentifier:kSegueScoreProductDetail sender:self];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DZYMerchandiseDetailController * mcdVC = [segue destinationViewController];
    if ([segue.identifier isEqualToString:kSegueScoreProductDetail]) {
        if ([mcdVC respondsToSelector:@selector(setGuid:)]) {
            mcdVC.Guid = GuID;
//            mcdVC.detailType = ScoreMerchandiseDetailType;
        }
    }
    
    SearchResultViewController * resultVC = [segue destinationViewController];
    if ([segue.identifier isEqualToString:kSegueScoreProductToList]) {
        if ([resultVC respondsToSelector:@selector(setShopID:)]) {
            resultVC.TitleName = @"积分商品";
            resultVC.ShopID = TypeID;
            resultVC.viewType = MerchandiseForScore;
        }
    }
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

-(void)signInAction{
    NSMutableDictionary * updateScoreDic = [[NSMutableDictionary alloc] init];
    [updateScoreDic setObject:self.appConfig.loginName forKey:@"MemLoginID"];
    [updateScoreDic setObject:@"10" forKey:@"Score"];
    [updateScoreDic setObject:kWebAppSign forKey:@"AppSign"];
    [UserInfoModel updateUserScoreByParamer:updateScoreDic andblocks:^(NSInteger result, NSError *error) {
        if(error){
            
            [TSMessage showNotificationWithTitle:NSLocalizedString(@"获取信息错误，点击屏幕重新加载", nil)
                                        subtitle:NSLocalizedString(@"网络连接失败，请检查网络设置", nil)
                                            type:TSMessageNotificationTypeError];
            
        }else{
            //首先判断是否有数据
            if (result == 202) {
                [self.SigninButton setImage:[UIImage imageNamed:@"btn_haveSignin_normal.png"] forState:UIControlStateNormal];
                self.SigninButton.enabled = NO;
                NSDictionary * checkDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                           todayStr,@"today", nil];
                [self writeApplicationData:checkDic writeFileName:@"SignIn"];
                [self loadUserScore];
                [self animationGetScore];
            }else{
                [self.SigninButton setImage:[UIImage imageNamed:@"btn_haveSignin_normal.png"] forState:UIControlStateNormal];
                self.SigninButton.enabled = NO;
                [self showAlertWithMessage:@"今天已经签过了！"];
            }
        }
        
    }];
    
    
    
}

-(void)animationGetScore{
    XYSpriteView *tmpSprite = [[XYSpriteView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 85)/2, (SCREEN_HEIGHT - 130)/2, 85, 130)];
    tmpSprite.firstImgIndex = 0;
    [tmpSprite formatImg:@"animation%d.png" count:41 repeatCount:1];
    [tmpSprite showImgWithIndex:1];
    tmpSprite.delegate = self;
    [[XYSpriteHelper sharedInstance].sprites setObject:tmpSprite forKey:@"a"];
    [self.view addSubview:tmpSprite];
    [[XYSpriteHelper sharedInstance] startAllSprites];
    [[XYSpriteHelper sharedInstance] startTimer];
    
}

-(void)spriteFinished:(XYSpriteView *)aSprite{
    [[XYSpriteHelper sharedInstance] clearAllSprites];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[XYSpriteHelper sharedInstance] stopTimer];
}

-(void)dealloc{
    [[XYSpriteHelper sharedInstance] clearAllSprites];
    
}

//领取更新积分
- (IBAction)checkGetScore:(id)sender {
    
    [self signInAction];
    
}

- (IBAction)getMoreMerchandiseAction:(id)sender {
    UIButton *moreBtn = (UIButton *)sender;
    TypeID = moreBtn.tag - 100;
    [self performSegueWithIdentifier:kSegueScoreProductToList sender:nil];
}
@end
