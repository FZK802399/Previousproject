//
//  MerchandiseDetailViewController.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-7.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "MerchandiseDetailViewController.h"
#import "MoreDetailViewController.h"
#import "LoginViewController.h"
#import "RegionModel.h"
#import "FootMarkModel.h"
#import "BiJiaModel.h"
#import "TSLocateView.h"
#import "MerchandiseSpecificationPriceModel.h"
#import "AppiralViewController.h"
#import "ShoppingCartViewController.h"
#import "SubmitOrderViewController.h"
#import "DZYSubmitOrderController.h"

#import <QuartzCore/QuartzCore.h>
#import "UIView+ZDX.h"
#import "ZDXMoveView.h"
#import "PinJiaCollectionViewCell.h"
#import "MerchandiseDetailCollectionViewCell.h"
#import "MBProgressHUD.h"
#import "MerchandiseDetailModel.h"
#import "MerchandisePingJiaModel.h"
#import "NSString+GF.h"
#import "ChaiDan.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

@interface MerchandiseDetailViewController ()<ZDXMoveViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate,UIWebViewDelegate>

@property (nonatomic, strong) UIView *backImageView;

@property (weak, nonatomic) IBOutlet UIView *moveView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView; // 368
@property (copy, nonatomic) NSArray *collectionViewDataPinJia;
@property (copy, nonatomic) NSArray *collectionViewDataDetail;

@end

@implementation MerchandiseDetailViewController
{
    BOOL isAreaStock;
    NSTimer *showTimer;
    NSInteger alltime;
    //购物车最大数量
    NSInteger shopcartMaxCount;
    BOOL isPinJia; // 是否显示评价
    __weak IBOutlet NSLayoutConstraint *collectionViewConstraint;
    __weak IBOutlet NSLayoutConstraint *addShopCartButton;
}
@synthesize GuID;

+ (instancetype)createMerchandiseDetailVC {
    return [[UIStoryboard storyboardWithName:@"StoryboardIOS7" bundle:nil] instantiateViewControllerWithIdentifier:@"MerchandiseDetailViewController"];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
/**
 *  商品详情页已有分享商品功能，只是把分享按钮的约束设为了0，因此，后期如果需要增加分享功能，只需将分享按钮的宽度增加即可
 *
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.allDetilScroll.bounces = NO;
    [self loadLeftBackBtn];
    [self setupMoveView];
    [self registerNib];
    
//    self.biJiaData = @[@"京东 AU$1.00", @"淘宝 AU$1.00", @"1号店 AU$1.00", @"羊马头 AU$1.00", @"袋鼠购 AU$1.00"];
    
    self.priceView.layer.borderWidth = 0.5;
    self.priceView.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
    
    self.addressView.layer.borderWidth = 0.5;
    self.addressView.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
    
    self.addressLabel.text = @"请选择配送地区";
    
    if (self.appConfig.shopCartNum > 0) {
        self.ShopCartNumberLabel.text = [NSString stringWithFormat:@"%ld", self.appConfig.shopCartNum];
    }else {
        self.ShopCartNumberLabel.hidden = YES;
    }
    
    self.addShopCartBtn.layer.cornerRadius = 3.0f;
    self.goBuyBtn.layer.cornerRadius = 3.0f;
    self.allDetilScroll.delegate = self;
    self.collectionView.scrollEnabled = NO;
    self.allDetilScroll.showsVerticalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    
    [self.allDetilScroll setContentOffset:CGPointMake(0, 0) animated:YES];
    if (_specificationItem) {
        [_specificationItem removeFromSuperview];
        [self closeFinished];
    }
    
    if (self.detailType == ScoreMerchandiseDetailType) {
        //        [self.addShopCartBtn setHidden:NO];
        //        self.goBuyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //        self.goBuyBtn.frame = CGRectMake(149, 8, 120, 30);
        //        [self.goBuyBtn setBackgroundImage:[UIImage imageNamed:@"btn_goBuy_normal.png"] forState:UIControlStateNormal];
        //        [self.goBuyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
        //        [self.bottomView addSubview:self.goBuyBtn];
        //        self.goBuyBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [self.goBuyBtn addTarget:self action:@selector(sureBtnFinished) forControlEvents:UIControlEventTouchUpInside];
//        [self loadScoreProductDetail];
    }else {
        if (self.EndTime.length > 0) {
            //            NSLog(@"%@",self.EndTime);
            //            [self.addShopCartBtn setUserInteractionEnabled:NO];
            //            self.goBuyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            //            self.goBuyBtn.frame = CGRectMake(100, 8, 120, 30);
            //            [self.goBuyBtn setBackgroundImage:[UIImage imageNamed:@"btn_goBuy_normal.png"] forState:UIControlStateNormal];
//            [self.goBuyBtn setTitle:@"立即抢购" forState:UIControlStateNormal];
            //            self.goBuyBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
            //            [self.bottomView addSubview:self.goBuyBtn];
//            [self.goBuyBtn addTarget:self action:@selector(addShopCartBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            UIView * view = [self.view viewWithTag:77];
            [self.view bringSubviewToFront:view];
            [self.goButBtnTwo addTarget:self action:@selector(addShopCartBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }else {
            [self.addShopCartBtn setHidden:NO];
            //            self.goBuyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            //            self.goBuyBtn.frame = CGRectMake(149, 8, 120, 30);
            //            [self.goBuyBtn setBackgroundImage:[UIImage imageNamed:@"btn_goBuy_normal.png"] forState:UIControlStateNormal];
            //            [self.goBuyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
            //            [self.bottomView addSubview:self.goBuyBtn];
            //            self.goBuyBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
            [self.goBuyBtn addTarget:self action:@selector(addShopCartBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        [self loadCommonProductDetail];
    }
}


// 解决iOS7下返回后ScrollView无法滚动（iOS8下可以滚动）
-(void)viewDidLayoutSubviews {
    if (isPinJia) {
        if (self.collectionViewDataPinJia.count == 0) {
            collectionViewConstraint.constant = 0;
            [self.allDetilScroll setContentSize:CGSizeMake(SCREEN_WIDTH, 443+28)];
        } else {
            CGFloat height = SCREEN_HEIGHT - 64 - 35 - 40;
            collectionViewConstraint.constant = height - 8;
            [self.allDetilScroll setContentSize:CGSizeMake(SCREEN_WIDTH, 428 + height +28)];
        }
    } else {
        CGFloat constant;
        if (self.currentDetailModel.MobileDetail && self.currentDetailModel.MobileDetail.length > 0) {
            constant = SCREEN_HEIGHT - 64 - 35 - 40;
            collectionViewConstraint.constant = constant - 8;
            constant -= 15;
        }
        [self.allDetilScroll setContentSize:CGSizeMake(SCREEN_WIDTH, 443 + constant +28)];
    }
    NSLog(@"Height : %f", collectionViewConstraint.constant);
}

- (void)registerNib {
    isPinJia = NO;
    UINib *nib = [UINib nibWithNibName:kPinJiaCellIdentifier bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:kPinJiaCellIdentifier];
    
    UINib *nib1 = [UINib nibWithNibName:kMerchandiseDetailCellIdentifier bundle:nil];
    [self.collectionView registerNib:nib1 forCellWithReuseIdentifier:kMerchandiseDetailCellIdentifier];
}

- (void)setupMoveView {
    ZDXMoveView *moveView = [[ZDXMoveView alloc] initWithFrame:self.goDetialView.bounds];
    CGRect frame = self.goDetialView.bounds;
    frame.size.width = SCREEN_WIDTH;
    moveView.frame = frame;
    NSLog(@"Frame : %@", NSStringFromCGRect(frame));
    moveView.buttonsTitle = @[@"商品详情", @"商品评价"];
    [moveView setButtonTitleSelectedColor:[UIColor barTitleColor]];
    moveView.delegate = self;
    [self.goDetialView addSubview:moveView];
}

- (void)moveView:(ZDXMoveView *)moveView didSelectButtonIndex:(NSInteger)index {
    self.allDetilScroll.scrollEnabled = YES;
    if (index == 1) {        
        // 判断是否有评价内容
        isPinJia = YES;
        // 评价
        if (!self.collectionViewDataPinJia) {
            if (_currentDetailModel) {
                [self setupPinJiaView];
            } else {
                [self showAlertWithMessage:@"网络错误"];
            }
        } else {
            CGFloat constant;
            if (self.collectionViewDataPinJia.count == 0) {
                collectionViewConstraint.constant = 0;
                [self showMessage:@"暂无评价"];
            } else {
                constant = SCREEN_HEIGHT - 64 - 35 - 40;
                collectionViewConstraint.constant = constant - 8;
                constant -= 15;
            }
            [self.allDetilScroll setContentSize:CGSizeMake(SCREEN_WIDTH, 443 + constant)];
            [self.collectionView reloadData];
            [self.view setNeedsUpdateConstraints];
        }
    } else if (index == 0) {
        isPinJia = NO;
        // 商品详情        
        CGFloat constant;
        if (self.currentDetailModel.MobileDetail && self.currentDetailModel.MobileDetail.length > 0) {
            constant = SCREEN_HEIGHT - 64 - 35 - 40 ;
            collectionViewConstraint.constant = constant - 8;
            constant -= 15;
        } else {
            collectionViewConstraint.constant = 0;
            [self showMessage:@"暂无详情"];
        }
        [self.allDetilScroll setContentSize:CGSizeMake(SCREEN_WIDTH, 443 + constant)];
        [self.collectionView reloadData];
        [self.view setNeedsUpdateConstraints];
    }
}

-(void)loadRightShareBtn {
    
//    UIImage * backImage = [UIImage imageNamed:@"btn_share_normal.png"];
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 50, 33);
    [backBtn setTitle:@"分享" forState:UIControlStateNormal];
    [backBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(ShareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
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

//创建完成  规格视图
-(void)createFinished{
    NSLog(@"Frame : %@", NSStringFromCGRect(self.specificationItem.frame));
    
}

// 规格视图关闭
-(void)closeFinished{
    [self.backImageView removeFromSuperview];
    self.backImageView = nil;
    
//    [self LoadAllViews];
}

//确定按钮  规格视图
-(void)sureBtnFinished{
    
    if (self.detailType == ScoreMerchandiseDetailType) {
//        _subimitModel = [[OrderMerchandiseSubmitModel alloc] init];
//        _subimitModel.Attributes = _specificationItem.specificationValue;
//        _subimitModel.Name = _ScoreDetailModel.name;
//        _subimitModel.BuyNumber = _specificationItem.selectCount;
//        _subimitModel.BuyPrice = _ScoreDetailModel.prmo;
//        _subimitModel.Guid = _ScoreDetailModel.guid;
//        _subimitModel.Score = _ScoreDetailModel.ExchangeScore;
//        _subimitModel.MemLoginID = self.appConfig.loginName;
//        _subimitModel.OriginalImge = _ScoreDetailModel.originalImageStr;
//        _subimitModel.ProductGuid = _ScoreDetailModel.guid;
//        _subimitModel.SpecificationName = _specificationItem.specificationName;
//        _subimitModel.SpecificationValue = @"";
//        _subimitModel.ShopID = @"0";
//        _subimitModel.ShopName = @"";
//        _subimitModel.CreateTime = [NSDate date];
//        _subimitModel.IsJoinActivity = 0;
//        _subimitModel.IsPresent = 0;
//        _subimitModel.RepertoryNumber = @"JK";
//        _subimitModel.ExtensionAttriutes = @"M";
//        
//        if (self.stepType == AddShopCart) {
//            NSMutableDictionary * addshopCartDic = [NSMutableDictionary dictionaryWithCapacity:0];
//            [addshopCartDic setObject:[NSNumber numberWithInteger:_ScoreDetailModel.IsReal] forKey:@"IsReal"];
//            [addshopCartDic setObject:[NSNumber numberWithInteger:0] forKey:@"IsShipment"];
//            [addshopCartDic setObject:_ScoreDetailModel.originalImageStr forKey:@"OriginalImge"];
//            [addshopCartDic setObject:_ScoreDetailModel.guid forKey:@"Guid"];
//            [addshopCartDic setObject:self.appConfig.loginName forKey:@"MemLoginID"];
//            [addshopCartDic setObject:_ScoreDetailModel.name forKey:@"Name"];
//            [addshopCartDic setObject:[NSString stringWithFormat:@"%ld", _ScoreDetailModel.RepertoryCount] forKey:@"RepertoryNumber"];
//            [addshopCartDic setObject:[NSNumber numberWithInteger:_specificationItem.selectCount] forKey:@"BuyNumber"];
//            [addshopCartDic setObject:[NSNumber numberWithInteger:_ScoreDetailModel.ExchangeScore]  forKey:@"BuyScore"];
//            [addshopCartDic setObject:[NSNumber numberWithFloat:_ScoreDetailModel.prmo] forKey:@"prmo"];
//            [addshopCartDic setObject:@"0" forKey:@"CartType"];
//            [addshopCartDic setObject:[NSNumber numberWithInteger:87]  forKey:@"RepertoryCount"];
////            [addshopCartDic setObject:@"0" forKey:@"Attributes"];
//            [addshopCartDic setObject:_subimitModel.CreateTimeStr forKey:@"CreateTime"];
//            [addshopCartDic setObject:_ScoreDetailModel.guid forKey:@"ProductGuid"];
//            [addshopCartDic setObject:self.appConfig.appSign forKey:@"AppSign"];
//            
//            ZDXWeakSelf(weakSelf);
//            [ScoreProductDetialModel addScoreMerchandiseToShopCartByParamer:addshopCartDic andblock:^(NSInteger result, NSError *error) {
//                if (error) {
//                    
//                }else {
//                
//                    if (result == 202) {
//                        [weakSelf showSuccessMessage:@"添加成功"];
//                    }else {
//                        [self showAlertWithMessage:@"添加失败"];
//                    }
//                }
//            }];
//        }else {
//            //购买
//            [self performSegueWithIdentifier:kSegueDetailToBuy sender:self];
//        }
    }else {
        _subimitModel = [[OrderMerchandiseSubmitModel alloc] init];
        _subimitModel.Attributes = _specificationItem.specificationValue;
        _subimitModel.Name = _currentDetailModel.name;
        _subimitModel.BuyNumber = _specificationItem.selectCount;
        _subimitModel.BuyPrice = _currentDetailModel.shopPrice;
        _subimitModel.Guid = _currentDetailModel.guid;
        _subimitModel.MarketPrice = _currentDetailModel.marketPrice;
        _subimitModel.MemLoginID = self.appConfig.loginName;
        _subimitModel.OriginalImge = _currentDetailModel.originalImageStr;
        _subimitModel.ProductGuid = _currentDetailModel.guid;
        _subimitModel.SpecificationName = _specificationItem.specificationName;
        _subimitModel.SpecificationValue = @"";
        _subimitModel.ShopID = @"0";
        _subimitModel.ShopName = @"";
        _subimitModel.CreateTime = [NSDate date];
        _subimitModel.IsJoinActivity = 0;
        _subimitModel.IsPresent = 0;
        _subimitModel.RepertoryNumber = @"JK";
        _subimitModel.ExtensionAttriutes = @"M";
        ///税费
        _subimitModel.IncomeTax = _currentDetailModel.IncomeTax;
        
        _currentDetailModel.buyNumber = _specificationItem.selectCount;
        //添加购物车
        if (self.stepType == AddShopCart) {
            if (_specificationItem.selectCount > _currentDetailModel.LimitBuyCount && _currentDetailModel.LimitBuyCount != 0) {
                [self showAlertWithMessage:[NSString stringWithFormat:@"超过最大限制购买数量，限购数量为%ld",_currentDetailModel.LimitBuyCount]];
                return;
            }
            
            if (shopcartMaxCount > _currentDetailModel.LimitBuyCount && _currentDetailModel.LimitBuyCount != 0) {
                shopcartMaxCount = _currentDetailModel.LimitBuyCount;
            }
            
            NSDictionary * addDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSString stringWithFormat:@"%ld",_specificationItem.selectCount],@"BuyNumber",
                                     _specificationItem.specificationValue,@"Attributes",
                                     [NSString stringWithFormat:@"%f",_currentDetailModel.shopPrice],@"BuyPrice",
                                     _currentDetailModel.guid,@"ProductGuid",
                                     _specificationItem.specificationName,@"DetailedSpecifications",
                                     [NSNumber numberWithInteger:shopcartMaxCount],@"ExtensionAttriutes",
                                     self.appConfig.loginName,@"MemLoginID",
                                     kWebAppSign, @"AppSign", nil];
            
            ZDXWeakSelf(weakSelf);
            [MerchandiseDetailModel addMerchandiseToShopCartByParamer:addDic andblock:^(NSInteger result, NSError *error) {
                if (error) {
                    
                }else{
                    if (result == 202) {
                        [weakSelf showSuccessMessage:@"添加成功"];
                        [weakSelf.appConfig loadConfig];
                        NSInteger count = 0;
                        count += weakSelf.appConfig.shopCartNum;
                        count += _specificationItem.selectCount;
                        weakSelf.appConfig.shopCartNum = count;
                        [weakSelf.ShopCartNumberLabel setHidden:NO];
                        weakSelf.ShopCartNumberLabel.text = [NSString stringWithFormat:@"%ld", count];
                        [weakSelf.appConfig saveConfig];
                        [_specificationItem removeFromSuperview];
                        [weakSelf closeFinished];
                    }
                    else if (result == 101){
                        [self showAlertWithMessage:@"超过限购量(*包含购物车中该商品的数量)"];
                    }
                    else if (result == 100){
                        [self showAlertWithMessage:@"库存不足(*包含购物车中该商品的数量)"];
                    }
                    else {
                        [weakSelf showAlertWithMessage:@"添加失败"];
                    }
                }
            }];
        }else{
            if (_specificationItem.selectCount > _currentDetailModel.LimitBuyCount && _currentDetailModel.LimitBuyCount != 0) {
                [self showAlertWithMessage:[NSString stringWithFormat:@"超过最大限制购买数量，限购数量为%ld",_currentDetailModel.LimitBuyCount]];
                return;
            }
            [_specificationItem removeFromSuperview];
            [self closeFinished];
            //购买
//            [self performSegueWithIdentifier:kSegueDetailToBuy sender:self];
            DZYSubmitOrderController * sovc = [DZYSubmitOrderController create];
            [ChaiDanModel getRateWithBlock:^(CGFloat rate,CGFloat PostageMoney,CGFloat SplitPostageMoney) {
                if (rate != -1) {
                    sovc.productArr = [ChaiDan ChanDanWithArr:[NSMutableArray arrayWithObject:_subimitModel] Rate:rate];
                    sovc.SplitPostageMoney = SplitPostageMoney;
                    sovc.PostageMoney = PostageMoney;
                    [self.navigationController pushViewController:sovc animated:YES];
                }
                else
                {
                    [MBProgressHUD showMessage:@"网络错误，请稍候再试" hideAfterTime:2];
                }
            }];
            
//            SubmitOrderViewController * sovc = [segue destinationViewController];
//            NSArray *productArray = [NSArray arrayWithObjects:_subimitModel, nil];
//            if (self.detailType == ScoreMerchandiseDetailType) {
//                sovc.submitProductType = SubmitOrderForScore;
//            }else {
//                sovc.submitProductType = SubmitOrderForCommon;
//            }
//            sovc.productArray = productArray;
//            sovc.totalPrice = _subimitModel.BuyNumber * _subimitModel.BuyPrice;
//            sovc.totalWeight = _specificationItem.selectCount * _currentDetailModel.productWeight;
        }
    }
}

- (MerchandiseSpecificationItem *) specificationItem {
    if (!_specificationItem) {
        _specificationItem = [[MerchandiseSpecificationItem alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _specificationItem.delegate  =self;
    }
    return  _specificationItem;
}
//- (void)loadScoreProductDetail {
//    
//    NSDictionary * detailDic = [NSDictionary dictionaryWithObjectsAndKeys:
//                                GuID,@"id",
//                                kWebAppSign,@"AppSign",nil];
//    [ScoreProductDetialModel getScoreMerchandiseDetailWithParamer:detailDic andBlocks:^(ScoreProductDetialModel *detail, NSError *error) {
//        if (error) {
//            [self showAlertWithMessage:@"网络错误"];
//        }else {
//            if (detail) {
//                _ScoreDetailModel = detail;
//                _MobileDetail = detail.Detail;
//                [_ImageListView createMerchandiseImageListWithScoreProductDetialModel:detail];
//                [_priceView createScoreProductPriceIntro:detail];
//
//
////                _currentDetailModel = detail;
////                _MobileDetail = detail.MobileDetail;
////                [_ImageListView createMerchandiseImageListWith:detail];
////                [_priceView createMerchandisePriceIntro:detail withEndTime:self.EndTime];
////                _priceView.delegate = self;
////                if (self.EndTime.length > 0) {
////                    alltime = round([self RemainingTimeWithDateStr:self.EndTime]);
////                    if (showTimer == nil) {
////                        showTimer = [NSTimer scheduledTimerWithTimeInterval:1
////                                                                     target:self
////                                                                   selector:@selector(timeDecreasing)
////                                                                   userInfo:nil
////                                                                    repeats:YES];
////                    }
////                }
//                _specificationItem = [[MerchandiseSpecificationItem alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 100)];
//                _specificationItem.delegate = self;
//                [_specificationItem createScoreProductSpecification:detail];
//
//            }
//        }
//    }];
//}
//

-(void)loadCommonProductDetail{

    NSDictionary * detailDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                GuID,@"id",
                                kWebAppSign,@"AppSign",
                                self.appConfig.loginName,@"MemLoginID",nil];
    ZDXWeakSelf(weakSelf);
    [self showLoadView];
    [MerchandiseDetailModel getMerchandiseDetailByParamer:detailDic andblock:^(MerchandiseDetailModel *detail, NSError *error) {
        [weakSelf hideLoadView];
        if (error) {
            [self showAlertWithMessage:@"网络错误"];
        }else {
            if (detail.guid) {
                
                shopcartMaxCount = detail.repertoryCount;
                
                NSDictionary * addDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                         kWebAppSign,@"AppSign",
                                         detail.guid, @"ProductGuid",
                                         detail.name, @"ProductName",
                                         detail.originalImageStr, @"ProductOriginalImge",
                                         [NSString stringWithFormat:@"%.2f", detail.shopPrice],@"ProductShopPrice",
                                         [NSString stringWithFormat:@"%.2f", detail.marketPrice],@"ProductMarketPrice",
                                         self.appConfig.loginName, @"MemLoginID", nil];
                [FootMarkModel addFootMarkByparameters:addDic andblock:^(NSInteger reslut, NSError *error) {
                    if (error) {
                        
                    }else{
                        
                        if (reslut == 202) {
                            
                        }
                    }
                }];
                
                if ([self.appConfig isLogin]) {
                    if ([self.appConfig.collectGuidList containsObject:detail.guid]) {
                        [self.goShopCartBtn setImage:[UIImage imageNamed:@"yishoucang"] forState:UIControlStateDisabled];
                        [self.goShopCartBtn setEnabled:NO];
                    }
                }
                
                _currentDetailModel = detail;
                _MobileDetail = detail.MobileDetail;
                [_ImageListView createMerchandiseImageListWith:detail];
                [_priceView createMerchandisePriceIntro:detail withEndTime:self.EndTime];
                _priceView.delegate = self;
                _priceView.dataSource = self;
                // 配置详情页面
                [self setupBottomView];
                if (self.EndTime.length > 0) {
                    alltime = round([self RemainingTimeWithDateStr:self.EndTime]);
                    if (showTimer == nil) {
                        showTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                                     target:self
                                                                   selector:@selector(timeDecreasing)
                                                                   userInfo:nil
                                                                    repeats:YES];
                    }
                }
                [self.specificationItem createSpecification:detail];
            } else {
                [self showAlertWithMessage:@"商品已下架"];
            }
        }
    }];
}

//分享菜单显示
-(IBAction)ShareBtnClick:(id)sender {

    NSString *shareURL = [NSString stringWithFormat:@"%@/ProductDetail/%@.html", kWebMainBaseUrl,_currentDetailModel.guid];
    //1、创建分享参数
    NSArray* imageArray = @[_currentDetailModel.originalImageStr];
    //    NSString * shareURL = _currentDetailModel.PCUrl;
    //    （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"精品"
                                         images:imageArray
                                            url:[NSURL URLWithString:shareURL]
                                          title:_currentDetailModel.name
                                           type:SSDKContentTypeAuto];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];}
}


//计算时间
-(void)timeDecreasing{
    if (alltime > 0) {
        alltime --;
        _priceView.endTimeLabel.text = [self getTimeDifferenceWithTimeInterval:alltime];
    }else {
        if (showTimer) {
            [showTimer invalidate];
            showTimer = nil;
        }
        self.goBuyBtn.enabled = NO;
    }
}


-(NSString *)getTimeDifferenceWithTimeInterval:(NSInteger) remainingTime{
    NSString * timeStr;
    if (remainingTime <= 0) {
        timeStr = @"活动已结束";
    }else {
        NSInteger dayNum = remainingTime / 86400;
        NSInteger hourNum = remainingTime % 86400 / 3600;
        NSInteger minuteNum = remainingTime % 3600 / 60;
        NSInteger secondNum = remainingTime % 60;
        timeStr = [NSString stringWithFormat:@"剩余时间：%d天%d小时%d分%d秒",dayNum, hourNum, minuteNum, secondNum];
        
    }
    return timeStr;
}

-(NSTimeInterval)RemainingTimeWithDateStr:(NSString *)endtime{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSDate * endTimeDate = [dateFormatter dateFromString:endtime];
    NSTimeInterval timeSinceNow = [endTimeDate timeIntervalSinceNow];
    return timeSinceNow;
}

//根据规格参数查询价格库存
-(void)chooseSpec{
    
    NSDictionary * priceDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               _currentDetailModel.guid,@"productGuid",
                               [NSString stringWithFormat:@"%@", _specificationItem.specificationName], @"Detail",
                               kWebAppSign, @"AppSign", self.appConfig.loginName,@"MemLoginID", nil];
    [MerchandiseSpecificationPriceModel getPriceWithparameters:priceDic andblock:^(MerchandiseSpecificationPriceModel *price, NSError *error) {
        if (error) {
            
        }else {
            if (price) {
                shopcartMaxCount = price.GoodsStock;
                [_specificationItem setRepertoryCount:price.GoodsStock];
                [_specificationItem setShopPrice:price.GoodsPrice];
            }
        
        }
    }];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    TSLocateView * loca = (TSLocateView *)actionSheet;
    if(buttonIndex == 0) {
        
    }else {
        self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@", loca.procinelocate.name, loca.citylocate.name ,loca.regionlocate.name];
        [self checkAreaStockByProvinceCode:loca.procinelocate.code andCityCode:loca.citylocate.code andRegionCode:loca.regionlocate.code];
    }
}

- (IBAction)checkAreaAction:(id)sender {
    TSLocateView *locateView = [[TSLocateView alloc] initWithTitle:@"选择城市" delegate:self];
    [locateView showInView:self.view];
}

//区域库存查询
-(void)checkAreaStockByProvinceCode:(NSString *)ProvinceCode andCityCode:(NSString *)CityCode andRegionCode:(NSString *)RegionCode{
    NSDictionary * stockDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               self.GuID,@"ProducGuid",
                               ProvinceCode,@"province",
                               CityCode,@"city",
                               RegionCode,@"region",
                               kWebAppSign, @"AppSign",
                               nil];
    [MerchandiseDetailModel getMerchandiseAreaStockByParamer:stockDic andblock:^(NSInteger result, NSError *error) {
        if (error) {
            [self showAlertWithMessage:@"网络错误"];
        }else {
            if (result == 202) {
                isAreaStock = true;
                self.HaveProductLabel.text = @"有货";
                self.HaveProductLabel.textColor = [UIColor barTitleColor];
            }else{
                isAreaStock = false;
                self.HaveProductLabel.text = @"无货";
                self.HaveProductLabel.textColor = [UIColor redColor];
            }
        }
    }];
}

//收藏
-(void)favoTouch:(MerchandiseDetailModel *)detail{
    if (![self.appConfig isLogin]) {
//        [self performSegueWithIdentifier:kSegueFavToLogin sender:self];
        [self presentViewController:ZDX_LOGIN animated:YES completion:nil];
    }else{
        NSDictionary * addCollectDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                        self.appConfig.loginName,@"MemLoginID",
                                        detail.guid,@"productGuid",
                                        kWebAppSign,@"AppSign",nil];
        
        ZDXWeakSelf(weakSelf);
        [MerchandiseDetailModel addMerchandiseToCollectByParamer:addCollectDic andblock:^(NSInteger result, NSError *error) {
            if (error) {
                
            }else {
                if (result == 202) {
                    [weakSelf.priceView favoSuccessed];
                    [weakSelf.goShopCartBtn setImage:[UIImage imageNamed:@"yishoucang"] forState:UIControlStateDisabled];
                    weakSelf.goShopCartBtn.enabled  = NO;
                    [weakSelf showSuccessMessage:@"收藏成功"];
                }else {
                    [weakSelf showErrorMessage:@"收藏失败"];
                }
            }
        }];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:kSegueDetailtoMore]) {
        MoreDetailViewController * mdvc = [segue destinationViewController];
        if ([mdvc respondsToSelector:@selector(setHtmlStr:)]) {
            mdvc.htmlStr = _MobileDetail;
        }
    }
    
    
    if ([segue.identifier isEqualToString:kSegueDetailToAppraisal]) {
        AppiralViewController * alvc = [segue destinationViewController];
        if ([alvc respondsToSelector:@selector(setProductGuid:)]) {
            alvc.ProductGuid = self.GuID;
        }
    }
    
   
    if ([segue.identifier isEqualToString:kSegueFavToLogin]) {
         LoginViewController * lgvc = [segue destinationViewController];
        if ([lgvc respondsToSelector:@selector(setFatherViewType:)]) {
            lgvc.FatherViewType = LoginForShopFavo;
        }
    }
    
    if ([segue.identifier isEqualToString:kSegueDetailToBuy]) {
        SubmitOrderViewController * sovc = [segue destinationViewController];
        NSArray *productArray = [NSArray arrayWithObjects:_subimitModel, nil];
        if (self.detailType == ScoreMerchandiseDetailType) {
            sovc.submitProductType = SubmitOrderForScore;
        }else {
            sovc.submitProductType = SubmitOrderForCommon;
        }
        sovc.productArray = productArray;
        sovc.totalPrice = _subimitModel.BuyNumber * _subimitModel.BuyPrice;
        sovc.totalWeight = _specificationItem.selectCount * _currentDetailModel.productWeight;
    }
    // MARK: 客服
    if ([segue.identifier isEqualToString:@"kDetailToServer"]) {
        
    }
}

//添加购物车
- (IBAction)addShopCartBtnClick:(id)sender {
    if (self.EndTime.length > 0 && [((UIButton *)sender).currentTitle isEqualToString:@"加入购物车"]) {
        [self showErrorMessage:@"抢购商品不能添加哟~"];
        return;
    }
    
    UIButton * btn = (UIButton *)sender;
    
    if (![self.appConfig isLogin]) {
//        [self performSegueWithIdentifier:kSegueFavToLogin sender:self];
        [self presentViewController:ZDX_LOGIN animated:YES completion:nil];
    }else{
        if (self.detailType == ScoreMerchandiseDetailType) {
            if (_ScoreDetailModel.RepertoryCount <= 0) {
                [self showAlertWithMessage:@"该商品库存不足"];
                return;
            }
            
            if ([self.addressLabel.text isEqualToString:@"请选择配送地区"]) {
                [self showAlertWithMessage:@"请选择配送地区"];
                return;
            }
    
            if (!isAreaStock) {
                [self showAlertWithMessage:@"该区域无货不能配送"];
                return;
            }
            
            if (self.appConfig.userScore < _ScoreDetailModel.ExchangeScore) {
                [self showAlertWithMessage:@"积分不足，不能兑换"];
                return;
            }
            
            if (!self.backImageView) {
                self.backImageView = [[UIView alloc] initWithFrame:self.view.bounds];
                self.backImageView.backgroundColor = [UIColor blackColor];
                self.backImageView.alpha = 0.3f;
                self.backImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            }
            [self.view addSubview:self.backImageView];
            [self.view addSubview:_specificationItem];
            if (btn == self.goBuyBtn) {
                self.stepType = GoBUY;
            }else{
                self.stepType = AddShopCart;
            }
        }else {
            if (_currentDetailModel.repertoryCount <= 0) {
                [self showAlertWithMessage:@"该商品库存不足"];
                return;
            }
            
            if ([self.addressLabel.text isEqualToString:@"请选择配送地区"]) {
                [self showAlertWithMessage:@"请选择配送地区"];
                return;
            }
            
            if (!isAreaStock) {
                [self showAlertWithMessage:@"该区域无货不能配送"];
                return;
            }
            
            if (!self.backImageView) {
                self.backImageView = [[UIView alloc] initWithFrame:self.view.bounds];
                self.backImageView.backgroundColor = [UIColor blackColor];
                self.backImageView.alpha = 0.3f;
                self.backImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            }
            
            [self.view addSubview:self.backImageView];
            [self.view addSubview:_specificationItem];
            if ((btn == self.goBuyBtn)||(btn ==self.goButBtnTwo)) {
                self.stepType = GoBUY;
            }else{
                self.stepType = AddShopCart;
            }
        }
    }
}

//收藏
- (IBAction)goShopCartBtnClick:(id)sender {
    
    if ([self.appConfig isLogin]) {
        if (![self.appConfig.collectGuidList containsObject:_currentDetailModel.guid]) {
            [self favoTouch:_currentDetailModel];
        }
    }else{
        [self presentViewController:ZDX_LOGIN animated:YES completion:nil];
    }
}


- (void)setupPinJiaView {
    // 添加评论及晒图，调接口
    //fxmhv811app.groupfly.cn/api/getproductassess?AppSign=8bffae3f7bc59d3821be2081e21728bf&startPage=1&pageSize=5&productID=9D0A20CA-242F-450C-8E74-96053162A305
    [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"productID"] = _currentDetailModel.guid;
//    dict[@"productID"] = @"9D0A20CA-242F-450C-8E74-96053162A305";
    dict[@"AppSign"] = kWebAppSign;
    dict[@"startPage"] = @"1";
    dict[@"pageSize"] = @"100";
    [MerchandisePingJiaModel fetchMerchandisePingJiaListWithParameters:dict block:^(NSArray *list, NSError *error) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        if (error) {
//            [self showAlertWithMessage:@"获取评论信息失败"];
        } else {
            self.collectionViewDataPinJia = list;
            if (list.count == 0) {
                collectionViewConstraint.constant = 0;
                [self.allDetilScroll setContentSize:CGSizeMake(SCREEN_WIDTH, 443)];
                [self showMessage:@"暂无评价"];
            } else {
                CGFloat height = SCREEN_HEIGHT - 64 - 35 - 40 ;
                collectionViewConstraint.constant = height - 8;
                [self.allDetilScroll setContentSize:CGSizeMake(SCREEN_WIDTH, 428 + height)];
            }
            [self.collectionView reloadData];
        }
    }];
}

- (void)setupBottomView {

    CGFloat constant;
    if (self.currentDetailModel.MobileDetail && self.currentDetailModel.MobileDetail.length > 0) {
        constant = SCREEN_HEIGHT - 64 - 35 - 40 ;
    } else {
        collectionViewConstraint.constant = 0;
        [self showMessage:@"暂无详情"];
    }
    [self.allDetilScroll setContentSize:CGSizeMake(SCREEN_WIDTH, 443 + constant + 28)];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionView Delegate DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (isPinJia) {
        return self.collectionViewDataPinJia.count;
    } else {
        if (self.currentDetailModel.MobileDetail && self.currentDetailModel.MobileDetail.length > 0) {
            return 1;
        }
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell;
    if (isPinJia) {
        // 评价
        PinJiaCollectionViewCell *pinJiacell = [collectionView dequeueReusableCellWithReuseIdentifier:kPinJiaCellIdentifier forIndexPath:indexPath];
        MerchandisePingJiaModel *model = self.collectionViewDataPinJia[indexPath.row];
        [pinJiacell updateViewWithMerchandisePingJiaModel:model];
        cell = pinJiacell;
    } else {
        // 商品详情
        MerchandiseDetailCollectionViewCell *detailCell = [collectionView dequeueReusableCellWithReuseIdentifier:kMerchandiseDetailCellIdentifier forIndexPath:indexPath];
//        detailCell.webView.scalesPageToFit = YES;
        detailCell.webView.delegate = self;
//        [detailCell.webView loadHTMLString:[NSString htmlStringReplaceWithString:_currentDetailModel.MobileDetail] baseURL:nil];
        NSString * str = [NSString stringWithFormat:@"<head><style>img{max-width:%.0fpx !important;}</style></head>%@",LZScreenWidth-14,_currentDetailModel.MobileDetail];
        [detailCell.webView loadHTMLString:str baseURL:[NSURL URLWithString:kWebMainBaseUrl]];
        
        detailCell.webView.scrollView.delegate = self;
        detailCell.webView.scrollView.scrollEnabled = NO;
        cell = detailCell;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize itemSize;    
    if (isPinJia) {
        MerchandisePingJiaModel *model = self.collectionViewDataPinJia[indexPath.row];
        itemSize = [PinJiaCollectionViewCell sizeWithMerchandisePingJiaModel:model];
        //        itemSize = CGSizeMake(SCREEN_WIDTH, 150);
    } else {
        CGFloat constant;
        if (self.currentDetailModel.MobileDetail && self.currentDetailModel.MobileDetail.length > 0) {
            constant = SCREEN_HEIGHT - 64 - 35 - 40 - 10 ;
        }
        itemSize = CGSizeMake(SCREEN_WIDTH, constant);
    }
    return itemSize;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (isPinJia) {
        return 5;
    } else {
        return 0.1;
    }
}


#pragma mark - UIScrollViewDelegate

// 滑动视图，当手指离开屏幕那一霎那，调用该方法。一次有效滑动，只执行一次。
// decelerate,指代，当我们手指离开那一瞬后，视图是否还将继续向前滚动（一段距离），经过测试，decelerate=YES
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    if (scrollView != self.allDetilScroll) {
//        if ([scrollView contentOffset].y < -50) {
//            [self.allDetilScroll setContentOffset:CGPointZero animated:YES];
//            self.allDetilScroll.scrollEnabled = YES;
//            scrollView.scrollEnabled = NO;
//        }
//    }
    
    if (scrollView != self.collectionView && scrollView != self.allDetilScroll) {
        if ([scrollView contentOffset].y < -50) {
            [self.allDetilScroll setContentOffset:CGPointZero animated:YES];
            self.allDetilScroll.scrollEnabled = YES;
            scrollView.scrollEnabled = NO;
            self.collectionView.scrollEnabled = NO;
        }
    }
}

// 滚动视图减速完成，滚动将停止时，调用该方法。一次有效滑动，只执行一次。
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    if (scrollView != self.collectionView && scrollView != self.allDetilScroll) {
//        if ([scrollView contentOffset].y < -50) {
//            [self.allDetilScroll setContentOffset:CGPointZero animated:YES];
//            self.allDetilScroll.scrollEnabled = YES;
//            scrollView.scrollEnabled = NO;
//            self.collectionView.scrollEnabled = NO;
//        }
//    }
    
    CGFloat offset=scrollView.contentOffset.y;
    if (scrollView == self.allDetilScroll) {
        if (offset >= 350+28) {
            scrollView.scrollEnabled = NO;
            self.collectionView.scrollEnabled = YES;
            UICollectionViewCell *cell = (MerchandiseDetailCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
            if ([cell isKindOfClass:[MerchandiseDetailCollectionViewCell class]]) {
                MerchandiseDetailCollectionViewCell *detailCell = (MerchandiseDetailCollectionViewCell *)cell;
                detailCell.webView.scrollView.scrollEnabled = YES;
            }
        } else {
            self.collectionView.scrollEnabled = NO;
        }
    }
}

//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (![scrollView isEqual:self.allDetilScroll] && ![scrollView isEqual:self.collectionView]) {
//        if (scrollView.contentOffset.y <= -50) {
//            [self.allDetilScroll scrollRectToVisible:CGRectMake(0, 0, LZScreenWidth, 50) animated:YES];
//        }
//    }
//}

- (IBAction)gotoCart:(id)sender {
    if (![self.appConfig isLogin]) {
        [self presentViewController:ZDX_LOGIN animated:YES completion:nil];
        return;
    }
    ShoppingCartViewController * shopCart = [ShoppingCartViewController create];
    [self.navigationController pushViewController:shopCart animated:YES];
}

// MARK: 客服
- (IBAction)gotoServer:(id)sender {
    if (![self.appConfig isLogin]) {
        [self presentViewController:ZDX_LOGIN animated:YES completion:nil];
        return;
    }
    // 跳转到聊天页面
    [self performSegueWithIdentifier:@"kDetailToServer" sender:self];
}

//#pragma mark BiJiaViewDataSource Delegate
//- (NSInteger)biJiaViewNumberOfRows {
//    return self.biJiaData.count;
//}
//
//- (NSString *)biJiaViewTitleAtIndex:(NSInteger)index {
//    return self.biJiaData[index];
//}
//
//- (void)biJiaViewDidSelectRowAtIndex:(NSInteger)index {
//    NSLog(@"点了第%d行", index);
//}
//
//- (CGPoint)scrollViewContentOffset {
//    return [self.allDetilScroll contentOffset];
//}

@end
