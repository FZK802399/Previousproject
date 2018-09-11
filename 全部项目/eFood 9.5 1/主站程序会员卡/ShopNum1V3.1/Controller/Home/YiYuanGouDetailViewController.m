//
//  YiYuanGouDetailViewController.m
//  ShopNum1V3.1
//
//  Created by Mac on 15/12/29.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "YiYuanGouDetailViewController.h"
#import "YiYuanGouModel.h"
#import "MerchandisePingJiaModel.h"
#import "MerchandiseDetailModel.h"
#import "FootMarkModel.h"
#import "MerchandiseSpecificationPriceModel.h"
#import "OrderMerchandiseSubmitModel.h"
#import "SubmitOrderViewController.h"
#import "ZDXMoveView.h"
#import "MerchandiseSpecificationItem.h"
#import "YiYuanFirstCollectionViewCell.h"
#import "YiYuanPinJiaCollectionViewCell.h"
#import "MerchandiseDetailCollectionViewCell.h"
#import "InstructionsCollectionViewCell.h"
#import "LimitNameCollectionViewCell.h"
#import "YiYuanGouPinJiaViewController.h"
#import "PinJiaCollectionViewCell.h"
#import "PanicBuyingModel.h"
#import "NSString+GF.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

@interface YiYuanGouDetailViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, ZDXMoveViewDelegate,  MerchandiseSpecficationItemDelegate, YiYuanFirstCollectionViewCellDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (copy, nonatomic) NSArray *collectionViewData;
@property (assign, nonatomic) NSInteger pinJiaCount;
@property (copy, nonatomic) NSArray *pinJiaData;
@property (copy, nonatomic) NSArray *instructionsData; //活动说明
@property (copy, nonatomic) NSArray *detailData;
@property (copy, nonatomic) NSArray *mingDanData;

@property (weak, nonatomic) IBOutlet UIButton *goBuyButton;
@property (strong, nonatomic) MerchandiseDetailModel *currentDetailModel;
@property (strong, nonatomic) MerchandiseSpecificationItem *specificationItem;
@property (strong, nonatomic) OrderMerchandiseSubmitModel * subimitModel;
@property (strong, nonatomic) ZDXMoveView *moveView;
@property (nonatomic, strong) UIView *backImageView;


@end

@implementation YiYuanGouDetailViewController
{
    NSInteger currentIndex;
    BOOL isCollect;
    NSString *Guid;
    //购物车最大数量
    NSInteger shopcartMaxCount;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadLeftBackBtn];
    self.goBuyButton.layer.cornerRadius = 3.0f;
    if (/*[self.model.ResidueNumber isEqualToNumber:self.model.RestrictCount]*/self.model.ResidueNumber.integerValue == 0) {
        self.goBuyButton.userInteractionEnabled = NO;
        self.goBuyButton.backgroundColor = [UIColor grayColor];
        [self.goBuyButton setTitle:@"已结束" forState:UIControlStateNormal];
    }
    Guid = self.model.Guid;
    [self setupNib];
    [self loadCommonProductDetail];
    [self setupPinJiaView];
    self.automaticallyAdjustsScrollViewInsets = false;
//    self.instructionsData = @[@"\n一元夺宝\n\n        1.进入活动区：点击网站，微信平台或app端的一元夺宝进入活动区。\n\n        2.挑选商品：每个商品都有自己的产品介绍，及启动当前夺宝活动所需的人数及金额。\n\n        3.参加活动：用户最少可支付一元(多买中奖率更高)，同时根据购买的数额得到相应数量的开奖号码，即可参加活动。\n\n        4.开始活动：当该活动所需的活动人数满员后，系统自动结束停止参加，开始抽奖。\n\n        5.开奖结果：跟据体育彩票当日彩票结果进行计算，例如开奖号码为88434，参加人数59人，计算余数（10000000+88434）% 59 = 24 （余数），中奖号码为10000001+24 = 1000025。"];
//    self.collectionViewData = self.instructionsData;
}

- (void)loadCommonProductDetail{
    
    NSDictionary * detailDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                Guid,@"id",
                                kWebAppSign,@"AppSign", nil];
    ZDXWeakSelf(weakSelf);
    [self showLoadView];
    [MerchandiseDetailModel getMerchandiseDetailByParamer:detailDic andblock:^(MerchandiseDetailModel *detail, NSError *error) {
        [weakSelf hideLoadView];
        if (error) {
            [self showAlertWithMessage:@"网络错误"];
        }else {
            if (detail.guid) {
                shopcartMaxCount = detail.repertoryCount;
                detail.shopPrice = 1.0f;
                detail.repertoryCount = weakSelf.model.RestrictCount.integerValue;
                
                NSInteger count = weakSelf.model.ResidueNumber.integerValue; // 剩余数量 
                if (count <= 0) {
                    [weakSelf.goBuyButton setTitle:@"抢完了" forState:UIControlStateNormal];
                    weakSelf.goBuyButton.backgroundColor = [UIColor lightGrayColor];
                    weakSelf.goBuyButton.userInteractionEnabled = NO;
//                    return;
                } else {
                    // 限购量，不能少于剩余件数
                    detail.IDRestrictCount = count;
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
               
                if (weakSelf.currentDetailModel.MobileDetail && weakSelf.currentDetailModel.MobileDetail.length > 0) {
//                    weakSelf.detailData = @[[NSString htmlStringReplaceWithString:weakSelf.currentDetailModel.MobileDetail]];
                    weakSelf.detailData = @[weakSelf.currentDetailModel.MobileDetail];
                } else {
                    weakSelf.detailData = @[];
                }
                
                ///一元购说明
                if (weakSelf.currentDetailModel.OneYuanGouMemo && weakSelf.currentDetailModel.OneYuanGouMemo.length > 0) {
                    weakSelf.instructionsData = @[weakSelf.currentDetailModel.OneYuanGouMemo];
                } else {
                    weakSelf.instructionsData = @[];
                }
                
                weakSelf.collectionViewData = weakSelf.instructionsData;
                
                [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:3]];
                
                weakSelf.specificationItem = [[MerchandiseSpecificationItem alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 100)];
                weakSelf.specificationItem.delegate = self;
                [weakSelf.specificationItem createSpecification:detail];
                [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
                
            } else {
                [weakSelf showAlertWithMessage:@"商品已下架"];
            }
        }
    }];
}

- (void)setupNib {
    UINib *firstNib = [UINib nibWithNibName:kYiYuanFirstCellIdentifier bundle:nil];
    [self.collectionView registerNib:firstNib forCellWithReuseIdentifier:kYiYuanFirstCellIdentifier];
    
    UINib *detailNib = [UINib nibWithNibName:kMerchandiseDetailCellIdentifier bundle:nil];
    [self.collectionView registerNib:detailNib forCellWithReuseIdentifier:kMerchandiseDetailCellIdentifier];
    
    UINib *pinJiaNib = [UINib nibWithNibName:kYiYuanPinJiaCellIdentifier bundle:nil];
    [self.collectionView registerNib:pinJiaNib forCellWithReuseIdentifier:kYiYuanPinJiaCellIdentifier];
    
    UINib *listNib = [UINib nibWithNibName:kLimitListCellIdentifier bundle:nil];
    [self.collectionView registerNib:listNib forCellWithReuseIdentifier:kLimitListCellIdentifier];
    
    UINib *instructionsNib = [UINib nibWithNibName:kInstructionsCollectionViewCellIdentifier bundle:nil];
    [self.collectionView registerNib:instructionsNib forCellWithReuseIdentifier:kInstructionsCollectionViewCellIdentifier];
}

// MARK: 购买
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

// TODO: 名单列表
- (void)setupMingDanData {
    ZDXWeakSelf(weakSelf);
    [self showLoadView];
    AppConfig * config = [AppConfig sharedAppConfig];
    [config loadConfig];
    [PanicBuyingModel fetchPanicBuyingListWithParameter:@{@"ProductGuid" : Guid,@"AppSign":config.appSign} block:^(NSArray *list, NSError *error) {
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

/// 336位置
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
        _moveView = [[ZDXMoveView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40) buttons:@[@"活动说明", @"商品详细", @"参与名单"]];
        _moveView.backgroundColor = [UIColor whiteColor];
        _moveView.buttonTitleSelectedColor = MAIN_BLUE;
        _moveView.topLineColor = [UIColor whiteColor];
        _moveView.buttonTitleNormalFontSize = 13.0f;
        _moveView.moveViewHeight = 2.0f;
        _moveView.addSeparation = YES;
        _moveView.delegate = self;
    }
    return _moveView;
}

// 分享
- (IBAction)share:(id)sender {
    NSString *shareURL = [NSString stringWithFormat:@"%@/ProductDetail/%@.html", kWebMainBaseUrl,Guid];
//    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK" ofType:@"png"];
//    
//    //构造分享内容
//    id<ISSContent> publishContent = [ShareSDK content:shareURL
//                                       defaultContent:@"上海森泓"
//                                                image:[ShareSDK imageWithPath:imagePath]
//                                                title:@"上海森泓"
//                                                  url:shareURL
//                                          description:@"上海森泓"
//                                            mediaType:SSPublishContentMediaTypeNews];
//    //创建弹出菜单容器
//    id<ISSContainer> container = [ShareSDK container];
//    [container setIPadContainerWithView:self.view arrowDirect:UIPopoverArrowDirectionUp];
//    
//    ZDXWeakSelf(weakSelf);
//    //弹出分享菜单
//    [ShareSDK showShareActionSheet:container
//                         shareList:nil
//                           content:publishContent
//                     statusBarTips:YES
//                       authOptions:nil
//                      shareOptions:nil
//                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                                
//                                if (state == SSResponseStateSuccess) {
//                                    if (type == ShareTypeCopy) {
//                                        [weakSelf showSuccessMessage:@"复制成功"];
//                                    } else {
//                                        [weakSelf showSuccessMessage:@"分享成功"];
//                                    }
//                                } else if (state == SSResponseStateFail) {
//                                    [weakSelf showErrorMessage:@"分享失败"];
//                                }
//                            }];
    

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

#pragma mark - MoveViewDelegate
-(void)moveView:(ZDXMoveView *)moveView didSelectButtonIndex:(NSInteger)index {    
    self.collectionView.scrollEnabled = YES;
    currentIndex = index;
    switch (index) {
        case 0: // 说明
            self.collectionViewData = self.instructionsData;
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:3]];
            break;
        case 1: // 详情
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
        YiYuanFirstCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kYiYuanFirstCellIdentifier forIndexPath:indexPath];
        cell.isCollect = isCollect;
        [cell updateViewWithModel:self.model];
        [cell beginScorll];
        cell.delegate = self;
        return cell;
    } else if (section == 3) {
        switch (currentIndex) {
            case 0: { // 活动说明
                InstructionsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kInstructionsCollectionViewCellIdentifier forIndexPath:indexPath];
                [cell updateViewWithInstructionsString:self.collectionViewData.firstObject];
                return cell;
            }
                break;
            case 1: { // 商品详细
                MerchandiseDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMerchandiseDetailCellIdentifier forIndexPath:indexPath];
//                cell.webView.scalesPageToFit = YES;
                cell.webView.scrollView.delegate = self;
                cell.webView.scrollView.scrollEnabled = NO;
                NSString * str = [NSString stringWithFormat:@"<head><style>img{max-width:%.0fpx !important;}</style></head>%@",LZScreenWidth-14,_detailData.firstObject];
                [cell.webView loadHTMLString:str baseURL:[NSURL URLWithString:kWebMainBaseUrl]];
//                NSLog(@"Detail : %@", self.detailData.firstObject);
                return cell;
            }
                break;
            case 2: { // 参与名单
                LimitNameCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLimitListCellIdentifier forIndexPath:indexPath];
                [cell updateViewWithModel:self.collectionViewData[row]];
                return cell;
            }
                break;
            default:
                break;
        }
        
    } else if (section == 1) {
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
        itemSize.height = 370;
    } else if (section == 1) {
        itemSize.height = 55;
    } else if (section == 3) {
        if (currentIndex == 0) {
//            itemSize.height = [InstructionsCollectionViewCell cellSizeWithInstructions:self.instructionsData.firstObject].height;
            itemSize.height = SCREEN_HEIGHT - 64 - 45 - 40;
        } else if (currentIndex == 1) {
            itemSize.height = SCREEN_HEIGHT - 64 - 45 - 40;
        } else if (currentIndex == 2) {
            itemSize.height = 45;
        }
    }
    return itemSize;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 0) {
        if (self.pinJiaCount > 0) {
            // 去商品评价
            [self performSegueWithIdentifier:@"kSegueYiYuanGouToPinJia" sender:self];
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
    [MerchandiseSpecificationPriceModel getPriceWithparameters:priceDic andblock:^(MerchandiseSpecificationPriceModel *price, NSError *error) {
        if (error) {
            
        }else {
            if (price) {
                shopcartMaxCount = self.model.RestrictCount.integerValue;
                [_specificationItem setRepertoryCount:shopcartMaxCount];
                [_specificationItem setShopPrice:_currentDetailModel.shopPrice];
            }
        }
    }];
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

#pragma mark -  确定提交订单  规格视图
-(void)sureBtnFinished{
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
    
    _currentDetailModel.buyNumber = _specificationItem.selectCount;
    //添加购物车
    
    if (_specificationItem.selectCount > _currentDetailModel.LimitBuyCount && _currentDetailModel.LimitBuyCount != 0) {
        [self showAlertWithMessage:[NSString stringWithFormat:@"超过最大限制购买数量，限购数量为%ld",_currentDetailModel.LimitBuyCount]];
        return;
    }
    [_specificationItem removeFromSuperview];
    [self closeFinished];
    //购买
    [self performSegueWithIdentifier:@"kSegueYiYuanToSubmit" sender:self];
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
    
    if ([segue.identifier isEqualToString:@"kSegueYiYuanToSubmit"]) {
        SubmitOrderViewController * sovc = [segue destinationViewController];
        NSArray *productArray = [NSArray arrayWithObjects:_subimitModel, nil];
        sovc.submitProductType = SubmitOrderForCommon;
        sovc.productArray = productArray;
        sovc.totalPrice = _subimitModel.BuyNumber * _subimitModel.BuyPrice;
        sovc.totalWeight = _specificationItem.selectCount * _currentDetailModel.productWeight;
        sovc.saleType = SaleTypeYiYuanGou;
    }
    
    if ([segue.identifier isEqualToString:@"kSegueYiYuanGouToPinJia"]) {
        YiYuanGouPinJiaViewController *pinJiaVC = [segue destinationViewController];
        pinJiaVC.pinJiaData = self.pinJiaData;
    }
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
