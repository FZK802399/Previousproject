//
//  LimitSaleDetailViewController.m
//  ShopNum1V3.1
//
//  Created by Mac on 15/12/24.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "LimitSaleDetailViewController.h"
#import "SubmitOrderViewController.h"
#import "ZDXMoveView.h"
#import "DZYSubmitOrderController.h"
#import "YiYuanGouPinJiaViewController.h"

#import "MerchandiseDetailCollectionViewCell.h"
#import "InstructionsCollectionViewCell.h"
#import "PinJiaCollectionViewCell.h"
#import "LimitNameCollectionViewCell.h"
#import "LimitFirstCollectionViewCell.h"
#import "YiYuanPinJiaCollectionViewCell.h"
#import "MerchandiseSpecificationItem.h"

#import "XianShiQiangMode.h"
#import "SaleProductModel.h"
#import "MerchandisePingJiaModel.h"
#import "MerchandiseDetailModel.h"
#import "FootMarkModel.h"
#import "MerchandiseSpecificationPriceModel.h"
#import "OrderMerchandiseSubmitModel.h"
#import "PanicBuyingModel.h"
#import "NSString+GF.h"
#import "ChaiDan.h"

#import "DZYShowImageView.h"

///环信
#import "EMIMHelper.h"
#import "ChatViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

@interface LimitSaleDetailViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, ZDXMoveViewDelegate, LimitFirstCollectionViewCellDelegate, MerchandiseSpecficationItemDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (copy, nonatomic) NSArray *collectionViewData;
@property (copy, nonatomic) NSArray *instructionsData; //活动说明

@property (copy, nonatomic) NSArray *detailData; // 详情页数据
@property (copy, nonatomic) NSArray *pinJiaData; // 评价页数据
@property (copy, nonatomic) NSArray *mingDanData; // 名单列表数据
@property (copy, nonatomic) NSArray *XianShiData; //限时活动说明
@property (copy, nonatomic) NSArray *XianLiangData; //限量活动说明

@property (assign, nonatomic) NSInteger pinJiaCount;

@property (strong, nonatomic) MerchandiseDetailModel *currentDetailModel;
@property (strong, nonatomic) MerchandiseSpecificationItem *specificationItem;
@property (strong, nonatomic) OrderMerchandiseSubmitModel * subimitModel;

@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (strong, nonatomic) ZDXMoveView *moveView;
@property (nonatomic, strong) UIView *backImageView;

///客服按钮
@property (weak, nonatomic) IBOutlet UIButton *kefuBtn;
///
@property (weak, nonatomic) UIWebView * goodsView;

@end

@implementation LimitSaleDetailViewController
{
    NSInteger currentIndex;
    BOOL isCollect;
    BOOL isEndTime; // 限量抢时的时间开关
    NSTimer *showTimer;
    NSString *Guid;
    //购物车最大数量
    NSInteger shopcartMaxCount;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadLeftBackBtn];
    self.buyButton.layer.cornerRadius = 3.0f;
    
    [self setupNib];
    
    Guid = self.model.ProductGuid;
    if (self.saleType == SaleTypeXianShiGou) {
        self.title = @"限时抢购";
    } else if (self.saleType == SaleTypeXianLiangGou) {
        self.title = @"限量抢购";
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginEnd) name:HUANXIN_LOGINEND_NOTICE object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadCommonProductDetail];
    [self setupPinJiaView];
#pragma mark - 限量抢购的倒计时
    if (self.saleType == SaleTypeXianShiGou) {
        showTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                     target:self
                                                   selector:@selector(timeDecreasing)
                                                   userInfo:nil
                                                    repeats:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (showTimer) {
        [showTimer invalidate];
    }
}

- (void)loadCommonProductDetail{
    
    NSDictionary * detailDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                Guid,@"id",
                                @"1",@"flag",
                                kWebAppSign,@"AppSign",nil];
    ZDXWeakSelf(weakSelf);
    [self showLoadView];
    [MerchandiseDetailModel getMerchandiseDetailByParamer:detailDic andblock:^(MerchandiseDetailModel *detail, NSError *error) {
        [weakSelf hideLoadView];
        if (error) {
            [self showAlertWithMessage:@"网络错误"];
        }else {
            if (detail.guid) {
                shopcartMaxCount = detail.repertoryCount;
                detail.shopPrice = weakSelf.model.PanicBuyingPrice.doubleValue;
                detail.repertoryCount = weakSelf.model.RestrictCount.integerValue;
                
                NSInteger count = weakSelf.model.RestrictCount.integerValue - weakSelf.model.SaleNumber.integerValue;
                if (count <= 0) {
                    [weakSelf.buyButton setTitle:@"抢完了" forState:UIControlStateNormal];
                    weakSelf.buyButton.backgroundColor = [UIColor lightGrayColor];
                    weakSelf.buyButton.userInteractionEnabled = NO;
                    if (showTimer) {
                        [showTimer invalidate];
                    }
//                    return;
                }
                // 每个ID限购量
                if (![weakSelf.model.IDRestrictCount isEqual:[NSNull null]]) {
                    // 限购量，不能少于剩余件数
                    if (weakSelf.model.IDRestrictCount.integerValue <= count) {
                        detail.IDRestrictCount = weakSelf.model.IDRestrictCount.integerValue;
                    } else {
                        detail.IDRestrictCount = count;
                    }
                } else {
                    detail.IDRestrictCount = 1;
                }
        
                NSDictionary * addDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                         kWebAppSign,@"AppSign",
                                         detail.guid, @"ProductGuid",
                                         detail.name, @"ProductName",
                                         detail.originalImageStr, @"ProductOriginalImge",
                                         [NSString stringWithFormat:@"%.2f", detail.shopPrice],@"ProductShopPrice",
                                         [NSString stringWithFormat:@"%.2f", detail.marketPrice],@"ProductMarketPrice",
                                         self.appConfig.loginName, @"MemLoginID", nil];
                // 添加足迹
                [FootMarkModel addFootMarkByparameters:addDic andblock:^(NSInteger reslut, NSError *error) {
                    if (error) {
                        
                    }else{
                        if (reslut == 202) {
                            
                        }
                    }
                }];
                
                if ([weakSelf.appConfig isLogin]) {
                    if ([weakSelf.appConfig.collectGuidList containsObject:detail.guid]) {
                        // 已收藏
                        isCollect = YES;
                    } else {
                        isCollect = NO;
                    }
                }
                weakSelf.currentDetailModel = detail;
                
                //详情
                if (weakSelf.currentDetailModel.MobileDetail && weakSelf.currentDetailModel.MobileDetail.length > 0) {
                    weakSelf.detailData = @[weakSelf.currentDetailModel.MobileDetail];
                } else {
                    weakSelf.detailData = @[];
                }
                ///限时说明
                if (weakSelf.currentDetailModel.LimitTimeBuy && weakSelf.currentDetailModel.LimitTimeBuy.length > 0) {
                    weakSelf.XianShiData = @[weakSelf.currentDetailModel.LimitTimeBuy];
                } else {
                    weakSelf.XianShiData = @[];
                }
                ///限量说明
                if (weakSelf.currentDetailModel.LimitCountBuy && weakSelf.currentDetailModel.LimitCountBuy.length > 0) {
                    weakSelf.XianLiangData = @[weakSelf.currentDetailModel.LimitCountBuy];
                } else {
                    weakSelf.XianLiangData = @[];
                }
//                weakSelf.collectionViewData = weakSelf.detailData;
                if (self.saleType == SaleTypeXianShiGou) {
                    weakSelf.instructionsData = weakSelf.XianShiData;
                } else if (self.saleType == SaleTypeXianLiangGou) {
                    weakSelf.instructionsData = weakSelf.XianLiangData;
                }
                weakSelf.collectionViewData = weakSelf.instructionsData;
                [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:3]];
                
                weakSelf.specificationItem = [[MerchandiseSpecificationItem alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 100)];
                weakSelf.specificationItem.delegate = self;
                [weakSelf.specificationItem createSpecification:detail];

            } else {
                [weakSelf showAlertWithMessage:@"商品已下架"];
            }
        }
    }];
}

-(void)timeDecreasing {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    LimitFirstCollectionViewCell *cell = (LimitFirstCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    // 判断是否有时间
    if (self.model.EndTime) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        int unit =  NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"YYYY/MM/dd HH:mm:ss";
        NSDate *endDate = [formatter dateFromString:self.model.EndTime];
        NSDateComponents  *component = [calendar components:unit fromDate:[NSDate date] toDate:endDate options:0];
        // 活动结束
        if(component.day<=0 && component.hour<=0 && component.minute<=0 && component.second<=0) {
            isEndTime = YES;
//            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];           
            [self.buyButton setTitle:@"抢完了" forState:UIControlStateNormal];
            self.buyButton.backgroundColor = [UIColor lightGrayColor];
            self.buyButton.userInteractionEnabled = NO;
            if (showTimer) {
                [showTimer invalidate];
            }
            cell.isEndTime = YES;
        } else {
            cell.isEndTime = NO;
        }
        // 更新时间
        [cell updateTimeLabelWithComponent:component];
    } else {
        if (showTimer) {
            [showTimer invalidate];
        }
    }
}

- (void)setupNib {
    UINib *firstNib = [UINib nibWithNibName:kLimitFirstCellIdentifier bundle:nil];
    [self.collectionView registerNib:firstNib forCellWithReuseIdentifier:kLimitFirstCellIdentifier];
    
    UINib *detailNib = [UINib nibWithNibName:kMerchandiseDetailCellIdentifier bundle:nil];
    [self.collectionView registerNib:detailNib forCellWithReuseIdentifier:kMerchandiseDetailCellIdentifier];
    
    UINib *pinJiaNib = [UINib nibWithNibName:kPinJiaCellIdentifier bundle:nil];
    [self.collectionView registerNib:pinJiaNib forCellWithReuseIdentifier:kPinJiaCellIdentifier];
    
    UINib *listNib = [UINib nibWithNibName:kLimitListCellIdentifier bundle:nil];
    [self.collectionView registerNib:listNib forCellWithReuseIdentifier:kLimitListCellIdentifier];
    
    UINib *yiYuanGouPinJia = [UINib nibWithNibName:kYiYuanPinJiaCellIdentifier bundle:nil];
    [self.collectionView registerNib:yiYuanGouPinJia forCellWithReuseIdentifier:kYiYuanPinJiaCellIdentifier];
    
    UINib *instructionsNib = [UINib nibWithNibName:kInstructionsCollectionViewCellIdentifier bundle:nil];
    [self.collectionView registerNib:instructionsNib forCellWithReuseIdentifier:kInstructionsCollectionViewCellIdentifier];
}

/// MARK: 购买
- (IBAction)goBuy:(id)sender {
    
    if (![self.appConfig isLogin]) {
        [self presentViewController:ZDX_LOGIN animated:YES completion:nil];
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
}

// TODO: 抢购名单
- (void)setupMingDanData {
//    api/PanicBuyingList/
    
    ZDXWeakSelf(weakSelf);
    [self showLoadView];
    [PanicBuyingModel fetchPanicBuyingListWithParameter:@{@"ProductGuid" : Guid} block:^(NSArray *list, NSError *error) {
        [weakSelf hideLoadView];
        if (error) {
            [weakSelf showErrorMessage:@"网络异常，请检查网络设置"];
        } else {
            if (!list || list.count <= 0) {
                [weakSelf showMessage:@"暂无名单"];
                weakSelf.mingDanData = @[];
            } else {
                weakSelf.mingDanData = list;
            }
            weakSelf.collectionViewData = weakSelf.mingDanData;
            [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:3]];

        }
    }];
}

/// 评价列表
- (void)setupPinJiaView {
    // 添加评论及晒图，调接口
    //fxmhv811app.groupfly.cn/api/getproductassess?AppSign=8bffae3f7bc59d3821be2081e21728bf&startPage=1&pageSize=5&productID=9D0A20CA-242F-450C-8E74-96053162A305
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
//    dict[@"productID"] = @"9D0A20CA-242F-450C-8E74-96053162A305";
    dict[@"AppSign"] = kWebAppSign;
    dict[@"startPage"] = @"1";
    dict[@"pageSize"] = @"100";
    dict[@"productID"] = Guid;
    
    ZDXWeakSelf(weakSelf);
    [self showLoadView];
    [MerchandisePingJiaModel fetchMerchandisePingJiaListWithParameters:dict block:^(NSArray *list, NSError *error) {
        [weakSelf hideLoadView];
        if (error) {
            [weakSelf showErrorMessage:@"网络错误"];
        } else {
            if (list && list.count > 0) {
                weakSelf.pinJiaData = list;
                weakSelf.pinJiaCount = list.count;
                [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
            }
        }
    }];
}

- (ZDXMoveView *)moveView {
    if (!_moveView) {
        _moveView = [[ZDXMoveView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40) buttons:@[@"活动说明",@"商品详细", @"抢购名单"]];
        _moveView.backgroundColor = [UIColor whiteColor];
        _moveView.buttonTitleSelectedColor = MAIN_BLUE;
        _moveView.topLineColor = [UIColor whiteColor];
        _moveView.buttonTitleNormalFontSize = 13.0f;
        _moveView.delegate = self;
    }
    return _moveView;
}

// 分享
- (IBAction)share:(id)sender {
    NSString *shareURL = self.saleType == SaleTypeXianShiGou ?
    [NSString stringWithFormat:@"http://senghongwap.efood7.com/pages/PanicbuyingDetail.html?id=%@&proguid=%@",self.model.Guid,self.model.ProductGuid]
    : [NSString stringWithFormat:@"http://senghongwap.efood7.com/pages/QuotaProductDetail.html?id=%@&proguid=%@",self.model.Guid,self.model.ProductGuid];
    //1、创建分享参数
    NSArray* imageArray = @[_currentDetailModel.originalImageStr];
    //    NSString * shareURL = _currentDetailModel.PCUrl;
    //    （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:_currentDetailModel.name
                                         images:imageArray
                                            url:[NSURL URLWithString:shareURL]
                                          title:@"Efood7来自澳洲的出口商"
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

#pragma mark - MoveViewDelegate
-(void)moveView:(ZDXMoveView *)moveView didSelectButtonIndex:(NSInteger)index {
    self.collectionView.scrollEnabled = YES;
    currentIndex = index;
    switch (index) {
        case 0: // 说明
            self.collectionViewData = self.instructionsData;
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:3]];
//            if (self.detailData) {
//                if (self.detailData.count == 0) {
//                    [self showMessage:@"暂无详情"];
//                }
//                self.collectionViewData = self.detailData;
//                [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:3]];
//            }
            break;
        case 1: // 详情
//            if (self.pinJiaData) {
//                if (self.pinJiaData.count == 0) {
//                    [self showMessage:@"暂无评价"];
//                }
//                self.collectionViewData = self.pinJiaData;
//                [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:3]];
//            } else {
//                [self setupPinJiaView];
//            }
            if (self.detailData) {
                if (self.detailData.count == 0) {
                    [self showMessage:@"暂无详情"];
                }
                self.collectionViewData = self.detailData;
                [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:3]];
            }
            break;
        case 2: // 名单
            if (self.mingDanData) {
                if (self.mingDanData.count == 0) {
                    [self showMessage:@"暂无名单"];
                }
                self.collectionViewData = self.mingDanData;
                [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:3]];
            } else {
                [self setupMingDanData];
            }
            break;
        default:
            break;
    }
}

#pragma mark - 收藏
- (void)didSelectCollect {
    //收藏
    if (![self.appConfig isLogin]) {
        [self presentViewController:ZDX_LOGIN animated:YES completion:nil];
    }else{
        NSDictionary * addCollectDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                        self.appConfig.loginName,@"MemLoginID",
                                        Guid,@"productGuid",
                                        kWebAppSign,@"AppSign",nil];
        
        ZDXWeakSelf(weakSelf);
        [MerchandiseDetailModel addMerchandiseToCollectByParamer:addCollectDic andblock:^(NSInteger result, NSError *error) {
            if (error) {
                [weakSelf showErrorMessage:@"网络错误"];
            }else {
                if (result == 202) {
                    [weakSelf showSuccessMessage:@"收藏成功"];
                    [weakSelf favoSuccessed];
                }else {
                    [weakSelf showErrorMessage:@"收藏失败"];
                }
            }
        }];
    }
}

- (void)favoSuccessed{
    NSMutableArray * tempArray = [NSMutableArray arrayWithArray:self.appConfig.collectGuidList];
    if (!tempArray) {
        tempArray = [NSMutableArray arrayWithCapacity:0];
    }
    [tempArray addObject:Guid];
    
    self.appConfig.collectGuidList = [NSMutableArray arrayWithArray:tempArray];
    [self.appConfig saveConfig];
    // 收藏
    isCollect = YES;
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
}

#pragma mark - UICollectionView Delegate DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 3) {
        return self.collectionViewData.count;
    } else {
        return 1;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == 0) {
        LimitFirstCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLimitFirstCellIdentifier forIndexPath:indexPath];
        cell.isCollect = isCollect;
        cell.saleType = self.saleType;
        cell.isEndTime = isEndTime;
        [cell updateViewWithModel:self.model];
        [cell beginScorll];
        cell.delegate = self;
        return cell;
    } else if (section == 3) {
        switch (currentIndex) {
            case 0: { // 商品详细
//                MerchandiseDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMerchandiseDetailCellIdentifier forIndexPath:indexPath];
////                cell.webView.scalesPageToFit = YES;
//                NSString * str = [NSString stringWithFormat:@"<head><style>img{max-width:%.0fpx !important;}</style></head>%@",LZScreenWidth-14,_detailData.firstObject];
//                [cell.webView loadHTMLString:str baseURL:[NSURL URLWithString:kWebMainBaseUrl]];
//                cell.webView.scrollView.delegate = self;
//                cell.webView.scrollView.scrollEnabled = NO;
//                return cell;
                InstructionsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kInstructionsCollectionViewCellIdentifier forIndexPath:indexPath];
                [cell updateViewWithInstructionsString:self.instructionsData.firstObject];
                return cell;
            }
                break;
            case 1: { // 商品详细
                MerchandiseDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMerchandiseDetailCellIdentifier forIndexPath:indexPath];
                NSString * str = [NSString stringWithFormat:@"<head><style>img{max-width:%.0fpx !important;}</style></head>%@",LZScreenWidth-14,_detailData.firstObject];
                
                NSLog(@"sdadsadasasssadsadsassasaadasssssssssssss%@",str);
                
                
                [cell.webView loadHTMLString:str baseURL:[NSURL URLWithString:kWebMainBaseUrl]];
                cell.webView.scrollView.delegate = self;
                cell.webView.scrollView.scrollEnabled = NO;
                self.goodsView = cell.webView;
                
                UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
                [cell.webView addGestureRecognizer:singleTap];
                singleTap.delegate = self;
                singleTap.cancelsTouchesInView = NO;
                
                return cell;
            }
                break;
            case 2: { // 抢购名单
                LimitNameCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLimitListCellIdentifier forIndexPath:indexPath];
                [cell updateViewWithModel:self.collectionViewData[row]];
                return cell;
            }
                break;
            default:
                break;
        }

    }else if (section == 1) {
        YiYuanPinJiaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kYiYuanPinJiaCellIdentifier forIndexPath:indexPath];
        [cell updateViewWithPinJiaCount:self.pinJiaCount];
        return cell;
    }
    return nil;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusabelView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        reusabelView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"LimitSaleDetailHeadView" forIndexPath:indexPath];
        [reusabelView addSubview:self.moveView];
    }
    return reusabelView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        return CGSizeMake(SCREEN_WIDTH, 40);
    } else {
        return CGSizeZero;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    CGSize itemSize = CGSizeMake(SCREEN_WIDTH, 0);
    if (section == 0) {
        if (self.saleType == SaleTypeXianLiangGou) {
            itemSize.height = 340;
        } else {
//            itemSize.height = 315;
            itemSize.height = 340;
        }
    }
    else if (section == 1) {
        itemSize.height = 55;
    }
    else if(section == 3) {
        switch (currentIndex) {
            case 0:
//                itemSize.height = [InstructionsCollectionViewCell cellSizeWithInstructions:self.instructionsData.firstObject].height;
                itemSize.height = SCREEN_HEIGHT - 64 - 45 - 40;
                break;
            case 1:
                itemSize.height = SCREEN_HEIGHT - 64 - 45 - 40;
                break;
            case 2:
                itemSize.height = 45;
                break;
            default:
                break;
        }
    }
    return itemSize;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 0) {
        if (self.pinJiaCount > 0) {
            // 去商品评价
            [self performSegueWithIdentifier:@"kSegueLimitSaleToPinJia" sender:self];
        } else {
            [self showMessage:@"暂无评价"];
        }
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}


#pragma mark - 规格视图代理
// 根据规格参数查询价格库存及商品价格
-(void)chooseSpec{

    
    NSDictionary * priceDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               _currentDetailModel.guid,@"productGuid",
                               [NSString stringWithFormat:@"%@", _specificationItem.specificationName], @"Detail",
                               kWebAppSign, @"AppSign", nil];
    NSLog(@"asdadsadsadasdada%@",priceDic);
    [MerchandiseSpecificationPriceModel getPriceWithparameters:priceDic andblock:^(MerchandiseSpecificationPriceModel *price, NSError *error) {
        if (error) {
            
        }else {
            if (price) {
//                shopcartMaxCount = price.GoodsStock;
//                if (self.saleType == SaleTypeXianLiangGou) {
                shopcartMaxCount = self.model.RestrictCount.integerValue;
//                }
                [_specificationItem setRepertoryCount:shopcartMaxCount];
                [_specificationItem setShopPrice:_currentDetailModel.shopPrice];
            }
            
        }
    }];
}

//创建完成  规格视图
-(void)createFinished{
    LZLOG(@"Frame : %@", NSStringFromCGRect(self.specificationItem.frame));    
}

// 规格视图关闭
-(void)closeFinished{
    [self.backImageView removeFromSuperview];
    self.backImageView = nil;
}

#pragma mark -  确定提交订单  规格视图
-(void)sureBtnFinished{
    AppConfig * config = [AppConfig sharedAppConfig];
    [config loadConfig];
    self.subimitModel = [[OrderMerchandiseSubmitModel alloc] init];
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
    _subimitModel.IncomeTax = _currentDetailModel.IncomeTax;
    _subimitModel.SpecificationValue = @"";
    _subimitModel.ShopID = @"0";
    _subimitModel.ShopName = @"";
    _subimitModel.CreateTime = [NSDate date];
    _subimitModel.IsJoinActivity = 0;
    _subimitModel.IsPresent = 0;
    _subimitModel.RepertoryNumber = @"JK";
    _subimitModel.ExtensionAttriutes = @"M";
    
    _currentDetailModel.buyNumber = _specificationItem.selectCount;
    //添加购物车
    
    if (_specificationItem.selectCount > _currentDetailModel.LimitBuyCount && _currentDetailModel.LimitBuyCount != 0) {
        [self showAlertWithMessage:[NSString stringWithFormat:@"超过最大限制购买数量，限购数量为%ld",_currentDetailModel.LimitBuyCount]];
        return;
    }
    [_specificationItem removeFromSuperview];
    [self closeFinished];
    //购买
#warning
//    [self performSegueWithIdentifier:@"kSegueLimitToSubmit" sender:self];
    DZYSubmitOrderController * sovc = [DZYSubmitOrderController create];
    [ChaiDanModel getRateWithBlock:^(CGFloat rate,CGFloat PostageMoney,CGFloat SplitPostageMoney) {
        if (rate != -1) {
            sovc.productArr = [ChaiDan ChanDanWithArr:[NSMutableArray arrayWithObject:_subimitModel] Rate:rate];
            sovc.PostageMoney = PostageMoney;
            sovc.SplitPostageMoney = SplitPostageMoney;
            [self.navigationController pushViewController:sovc animated:YES];
        }
        else
        {
            [MBProgressHUD showMessage:@"网络错误，请稍候再试" hideAfterTime:2];
        }
    }];
    
    
    
}

#pragma UIScrollViewDelegate

// 滑动视图，当手指离开屏幕那一霎那，调用该方法。一次有效滑动，只执行一次。
// decelerate,指代，当我们手指离开那一瞬后，视图是否还将继续向前滚动（一段距离），经过测试，decelerate=YES
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView != self.collectionView) {
        if ([scrollView contentOffset].y < -50) {
            [self.collectionView setContentOffset:CGPointZero animated:YES];
            self.collectionView.scrollEnabled = YES;
            scrollView.scrollEnabled = NO;
        }
    }
}

// 滚动视图减速完成，滚动将停止时，调用该方法。一次有效滑动，只执行一次。
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.collectionView) {
        
        UICollectionViewCell *cell = (MerchandiseDetailCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:3]];
        
        if ([cell isKindOfClass:[MerchandiseDetailCollectionViewCell class]]) {
            MerchandiseDetailCollectionViewCell *detailCell = (MerchandiseDetailCollectionViewCell *)cell;
            UIScrollView *webScrollView = detailCell.webView.scrollView;
            CGPoint point = [detailCell convertPoint:CGPointZero fromView:self.collectionView];
            if (fabsf(point.y) == ([scrollView contentOffset].y + 40)) {
                self.collectionView.scrollEnabled = NO;
                webScrollView.scrollEnabled = YES;
            } else {
                self.collectionView.scrollEnabled = YES;
                webScrollView.scrollEnabled = NO;
            }
        }
    }
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SubmitOrderViewController * sovc = [segue destinationViewController];
    if ([segue.identifier isEqualToString:@"kSegueLimitToSubmit"]) {
        NSArray *productArray = [NSArray arrayWithObjects:_subimitModel, nil];
        sovc.submitProductType = SubmitOrderForCommon;
        sovc.productArray = productArray;
        sovc.totalPrice = _subimitModel.BuyNumber * _subimitModel.BuyPrice;
        sovc.totalWeight = _specificationItem.selectCount * _currentDetailModel.productWeight;
    }
    if ([segue.identifier isEqualToString:@"kSegueLimitSaleToPinJia"]) {
        YiYuanGouPinJiaViewController *pinJiaVC = [segue destinationViewController];
        pinJiaVC.pinJiaData = self.pinJiaData;
    }
}

#pragma mark - 环信
- (IBAction)kefuClick:(UIButton *)sender {
    self.kefuBtn.userInteractionEnabled = NO;
    [[EMIMHelper defaultHelper] loginEasemobSDK];
}

- (void)loginEnd{
    self.kefuBtn.userInteractionEnabled = YES;
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"注意" message:@"请选择是否发送商品信息" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    alertView.tag = 99;
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 99) {
        ChatViewController * chatController = [[ChatViewController alloc] initWithChatter:@"food7" type:eAfterSaleType];
        chatController.title = @"客服";
        if (buttonIndex == 0) {  //否
            chatController.commodityInfo = nil;
        }else{
            chatController.commodityInfo = @{@"type":@"track", @"title":@"EFOOD", @"imageName":@"", @"desc":_currentDetailModel.name, @"price":[NSString stringWithFormat:@"AU$%.2f",_currentDetailModel.shopPrice], @"img_url":_currentDetailModel.originalImageStr, @"item_url":[NSString stringWithFormat:@"http://senghongwap.efood7.com/pages/ProductDetail.html?id=%@",_currentDetailModel.guid]};
        }
        [self.navigationController pushViewController:chatController animated:YES];
    }
}

#pragma mark - 商品详情点击事件
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    CGPoint pt = [sender locationInView:self.goodsView];
    NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", pt.x, pt.y];
    NSString *urlToSave = [self.goodsView stringByEvaluatingJavaScriptFromString:imgURL];
    if (![urlToSave isEqualToString:@""]) {
        [self showImageWithUrl:urlToSave];
    }
}

-(void)showImageWithUrl:(NSString *)url
{
    DZYShowImageView * view = [[DZYShowImageView alloc]initWithFrame:[UIScreen mainScreen].bounds url:url];
    [view show];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:HUANXIN_LOGINEND_NOTICE object:nil];
}

@end
