 //
//  HomePageController.m
//  HomePage
//
//  Created by GF on 15/11/20.
//  Copyright © 2015年 right. All rights reserved.
//

#import "HomePageController.h"
#import "UINavigationBar+BackgroundColor.h"
#import "LoginViewController.h"
#import "MessageViewController.h"

#import "BrandCenterViewController.h"
#import "ProductListController.h"
#import "SearchResultViewController.h"
#import "ProductListController.h"
#import "QiangGouController.h"
#import "DZYMerchandiseDetailController.h"
#import "LimitSaleDetailViewController.h"
#import "SearchViewController.h"
#import "LimitSaleViewController.h"
#import "YiYuanGouDetailViewController.h"
#import "MoreDetailViewController.h"
#import "FavourTicketViewController.h"
#import "ChatViewController.h"

//================组件===============
#import "NavTitleView.h"
#import "HomeCycleView.h"
#import "FIrstCollectionViewCell.h"
#import "SecondHeaderView.h"
#import "SecondContentCell.h"
#import "ImageFooterView.h"
#import "TitleHeaderView.h"
#import "XianShiQiangCell.h"
#import "ActivityBtnsCell.h"
#import "WeiNiTuiJianView.h"
#import "ProductListCell.h"
#import "ScanViewController.h"
#import "PromptFooterView.h"
#import "YiYuanCollectionViewCell.h"
#import "LimitCollectionViewCell.h"
#import "MemberCollectionViewCell.h"
#import "ShiYuanCollectionViewCell.h"
#import "BanJiaCollectionViewCell.h"
#import "TeJiaCollectionViewCell.h"
#import "XianLiangCollectionViewCell.h"
#import "FindCouponView.h"
#import "FindScoreView.h"
#import "FindNotWinView.h"
//===================================

//================接口===============
#import "AppSignModel.h"
#import "ProductInfoMode.h"
#import "GetAdvertApi.h"
#import "GetCatgroyApi.h"
#import "GetBannerApi.h"
#import "GetXiangshiQiang.h"
#import "GetProductInfoApi.h"
#import "GetTodayActivityApi.h"
#import "NoticeModel.h"
#import "HomeSectionTitleModel.h"
#import "FloorModel.h"
#import "FloorProductModel.h"
#import "MemberFloorModel.h"
#import "MemberFloorProductModel.h"
#import "SaleProductModel.h"
#import "YiYuanGouModel.h"
#import "RewardModel.h"
#import "MJRefresh.h"
#import "EMIMHelper.h"
//===================================

@interface HomePageController ()<UICollectionViewDelegateFlowLayout,HomeCycleViewDelegate,FIrstCollectionViewCellDelegate,TitleHeaderViewDelegate,NavTitleViewDelegate,ScanViewDelegate,ActivityBtnsCellDelegate, TeJiaCollectionViewCellDelegate, XianLiangCollectionViewCellDelegate, FindCouponViewDelegate, FindScoreViewDelegate, FindNotWinViewDelegate, ImageFooterViewDelegate, UIAlertViewDelegate>

// 所有head section 图标 标题 和详细标题
@property (copy, nonatomic) NSArray *sectionTitleData;
/// 滚动广告数组
@property (copy, nonatomic) NSArray *advertDatas;
/// 分类下方广告数组
@property (copy, nonatomic) NSArray *banners;
/// 分类数组
@property (copy, nonatomic) NSArray *categroyDatas;

/// 一元购
@property (copy, nonatomic) NSArray *yiYuanDatas;
/// 限时抢购
@property (copy, nonatomic) NSArray *xianShiQiangDatas;
/// 限量抢购
@property (copy, nonatomic) NSArray *xianLiangDatas;
/// 会员折扣
@property (copy, nonatomic) NSArray *memberDatas;
// 会员折扣头信息
@property (strong, nonatomic) MemberFloorModel *memberModel;

// 4个区的数据 分别是：头+内容
@property (copy, nonatomic) NSArray *fourSectionDatas;
/// 十元特区
@property (copy, nonatomic) NSArray *shiYuanDatas;
/// 半价抢购
@property (copy, nonatomic) NSArray *banJiaDatas;
/// 母婴特价
@property (copy, nonatomic) NSArray *muYinDatas;
/// 保健特价
@property (copy, nonatomic) NSArray *baoJianDatas;

/// 今日活动商品
@property (copy, nonatomic) NSArray *todayActivityDatas;
/// 为您推荐商品数组
@property (copy, nonatomic) NSArray *recommendProudcts;

/// 公告
@property (strong, nonatomic) SecondHeaderView *noticeView;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSTimer *timer1;
@property (assign, nonatomic) NSInteger timerCount;

// 公告数据
@property (copy, nonatomic) NSArray *noticeData;

// 寻宝数据
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIButton *findButton; // 宝箱按钮
@property (strong, nonatomic) FindCouponView *couponView; // 优惠券
@property (strong, nonatomic) FindScoreView *scoreView; // 积分
@property (strong, nonatomic) FindNotWinView *notWinView; // 未中奖
@property (strong, nonatomic) CAKeyframeAnimation *popAnimation;

@property (strong, nonatomic) FMDatabase * db;
// 关闭 开始滚动
@property (nonatomic, weak) HomeCycleView * cycleView;

/// 环信
@property (nonatomic, weak)UIButton * keFuBtn;
@property (nonatomic, assign)CGFloat beginOffsetY;
@property (nonatomic, assign)BOOL keFuHidden;
/// 切换到下一个试图 再回来的时候按钮不显示
@property (nonatomic, assign)BOOL goToNext;
// 会话管理者 检测是否有未读信息
@property (strong, nonatomic) EMConversation *conversation;
@end

@implementation HomePageController
{
    NSIndexPath *currentIndexPath;
    SaleType currentSaleType;
    NSString *currentTitle;
    CheckProductType currentProductType;
}



/// 今日活动占位数据
- (NSArray *) getActivity {
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 1; i<=3; i++) {
        NSString *imageName = [NSString stringWithFormat:@"jinrihuodong%d",i];
        [array addObject:imageName];
    }
    return array;
}

- (void) setupUI{
    UIBarButtonItem *back = [[UIBarButtonItem alloc]init];
    back.title = @"";
    self.navigationItem.backBarButtonItem = back;

//    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    ZDXWeakSelf(weakSelf);
    [self.collectionView addHeaderWithCallback:^{
        [weakSelf loadAdvertisment];
        [weakSelf loadNotice];
        [weakSelf loadCategory];
        [weakSelf loadBanner];
        [weakSelf loadXianShiQiang];
        [weakSelf loadTodayAcitivity];
        [weakSelf loadRecommend];
        // 五个楼层  10元、半价、母婴、保健、会员
        [weakSelf loadFourSectionData];
        // 限量抢购
        [weakSelf loadXianLiangDatas];
    }];
    
    NavTitleView *titleView = [NavTitleView create];
    titleView.delegate = self;
    self.navigationItem.titleView = titleView;
    
    // 发现寻宝
    self.findButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    [self.findButton setImage:[UIImage imageNamed:@"baoxiang"] forState:UIControlStateNormal];
    self.findButton.center = CGPointMake(SCREEN_WIDTH - 20, SCREEN_HEIGHT * 2/3);
    [self.findButton addTarget:self action:@selector(findTreasure) forControlEvents:UIControlEventTouchUpInside];
    self.findButton.hidden = YES;
    [self.view addSubview:self.findButton];
    
    UIButton * keFu = [[UIButton alloc]initWithFrame:CGRectMake(DZYWIDTH - 85, DZYHEIGHT - 50 - 80 - 10, 80, 80)];
    [keFu setImage:[UIImage imageNamed:@"kefu03"] forState:UIControlStateNormal];
    [keFu addTarget:self action:@selector(kefu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:keFu];
    self.keFuBtn = keFu;
    
    _conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:@"food7" conversationType:eConversationTypeChat];
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    // 注册组件
    [self registerColletionViewComponent];
    
    [self setupUI];
    ///读缓存
    [self loadDataForData];
    ///读网络数据
    [self loadDataForWeb];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginEnd) name:HUANXIN_LOGINEND_NOTICE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receive) name:HUANXIN_RECEIVE_NOTICE object:nil];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(refershNotice) userInfo:nil repeats:YES];
    self.timer1 = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateLimitCell) userInfo:nil repeats:YES];
    if (self.cycleView) {
        [self.cycleView beginScorll];
    }
    if (_conversation) {
        [_conversation loadAllMessages];
        NSInteger num =[_conversation unreadMessagesCount];
        if (num > 0) {
                        //客服按钮会显示 有新消息
            [self.keFuBtn setImage:[UIImage imageNamed:@"kefu03_new"] forState:UIControlStateNormal];
        }
        else{
            [self.keFuBtn setImage:[UIImage imageNamed:@"kefu03"] forState:UIControlStateNormal];
        }
    }
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    /*
    // 一元购
    [self loadYiYuanGouDatas];
     */
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.goToNext = NO;
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    [self.timer1 invalidate];
    self.timer1 = nil;
    self.timer = nil;
    [self.cycleView endScorll];
    self.goToNext = YES;
//    self.keFuBtn.transform = CGAffineTransformIdentity;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void) keyboardWillShow:(NSNotification*)notification{
    [NavTitleView showBlurEffectOnView:self.view];
}

- (void) loadDataForData
{
    NSString *path=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"home.sqlite"];
    //    NSLog(@"path - %@",path);
    self.db = [FMDatabase databaseWithPath:path];
    [self.db open];
    [self loadAdvertismentFromData];
    [self.db close];
}

- (void) loadDataForWeb {
    //获取AppSign
    ZDXWeakSelf(weakSelf);
    [AppSignModel getAppSignandBlocks:^(NSString *appSign, NSError *error) {
        if(error){
            [weakSelf showErrorMessage:@"网络异常，请检查网络设置.Error:0"];
        }else {
            
            if (appSign.length > 0) {
                [[AppConfig sharedAppConfig] loadConfig];
                [AppConfig sharedAppConfig].appSign = appSign;
                [[AppConfig sharedAppConfig] saveConfig];
                [[AppConfig sharedAppConfig] loadConfig];
    
                [self loadAdvertisment];
                [self loadNotice];
                [self loadCategory];
                [self loadBanner];
                [self loadXianShiQiang];
                [self loadTodayAcitivity];
                [self loadRecommend];
                // 五个楼层  10元、半价、母婴、保健、会员
                [self loadFourSectionData];
                // 限量抢购
                [self loadXianLiangDatas];
                /*  不要了 2016.3.29
                // 发现宝箱
                [self loadBaoXiang];
                 */
            }
        }
    }];
}

/*
- (void)loadBaoXiang {
    // setup1 宝箱出现时间比对
    // 宝箱出现时间：api/GetChestTime/   传入参数：AppSign
    
    ZDXWeakSelf(weakSelf);
    [[AFAppAPIClient sharedClient] getPath:@"/api/GetChestTime/" parameters:@{@"AppSign" : [AppConfig sharedAppConfig].appSign} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *Data = responseObject[@"Data"];
        NSString *time = Data[@"Time"];
        NSInteger lenght = [Data[@"Length"] integerValue];
        
        // 获取当前毫秒数
        NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
        [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss:SSS"];
        NSString *date =  [formatter stringFromDate:[NSDate date]];
        NSString *timeLocal = [[[NSString alloc] initWithFormat:@"%@", date] componentsSeparatedByString:@":"].lastObject;
        NSLog(@"Time: %@", timeLocal);
        
        if (time.length > 0) {
            NSString *winNumber = [timeLocal substringToIndex:lenght];
            if ([winNumber isEqualToString:time]) {
                NSLog(@"宝箱出现");
                // 获取奖励内容
                if ([[AppConfig sharedAppConfig] isLogin]) {
                    weakSelf.findButton.hidden = NO;
                }
            } else {
                NSLog(@"宝箱不出现");
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf showErrorMessage:@"网络异常，请检查网络设置"];
    }];
}
 */

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/efood7/id1079282526?l=zh&ls=1&mt=8"]];
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"获取更新！" message:@"好消息！现在可以免费下载新版本了。" delegate:self cancelButtonTitle:@"更新" otherButtonTitles:nil];
    [alert show];
}
/*
- (void)loadYiYuanGouDatas {
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"1", @"PageStart",
                          @"3", @"PageEnd",
                          [AppConfig sharedAppConfig].appSign, @"AppSign", nil];
    ZDXWeakSelf(weakSelf);
    [YiYuanGouModel fetchYiYuanGouListWithParameters:dict block:^(NSArray *list, NSError *error) {
        if (error) {
            [weakSelf showErrorMessage:@"网络异常，请检查网络设置"];
        } else {
            if (list && list.count > 0) {
                weakSelf.yiYuanDatas = list;
                [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:2]];
            }
        }
    }];
}
 */

#pragma mark - 限量活动api
- (void)loadXianLiangDatas {
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                                @"1", @"pageIndex",
                                                @"3", @"pageSize",
                                                [AppConfig sharedAppConfig].appSign, @"AppSign", nil];
    ZDXWeakSelf(weakSelf);
    [SaleProductModel getXianLiangListByParamer:dict andBlocks:^(NSArray *List, NSError *error) {
        if(error){
            [weakSelf showErrorMessage:@"网络异常，请检查网络设置。Error:6"];
        }else {
            NSInteger introCount = [List count];
            //首先判断是否有数据
            if (introCount > 0) {
                weakSelf.xianLiangDatas = List;
                [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:3]];
            }
        }
    }];
}

/*
- (void)loadMemberDatas {
//    http://senghongAPP.groupfly.cn/api/MemberFloor/
    NSDictionary *dict = @{@"AppSign" : [AppConfig sharedAppConfig].appSign};
    ZDXWeakSelf(weakSelf);
    
    [MemberFloorModel fetchMemberFloorListWithParameters:dict block:^(NSArray *list, NSError *error) {
        if (error) {
            [weakSelf showErrorMessage:@"网络异常，请检查网络设置"];
        } else {
            if (list && list.count > 0) {
                weakSelf.memberModel = list.firstObject;
                weakSelf.memberDatas = weakSelf.memberModel.MemberFloorsList;
                [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:4]];
            }
        }
    }];
}
 */

#pragma mark - 楼层信息api
- (void)loadFourSectionData {
    NSDictionary *dict = @{@"AppSign" : [AppConfig sharedAppConfig].appSign};
    ZDXWeakSelf(weakSelf);
    [FloorModel fetchFloorListWithParameters:dict block:^(NSArray *list, NSError *error) {
        if (error) {
            [weakSelf showErrorMessage:@"网络异常，请检查网络设置。Error:5"];
        } else {
            // 4个楼层
            [self.collectionView headerEndRefreshing];
            if (list && list.count > 0) {
                weakSelf.fourSectionDatas = list;
                weakSelf.shiYuanDatas = ((FloorModel *)list[0]).ProductList;
                weakSelf.banJiaDatas = ((FloorModel *)list[1]).ProductList;
                weakSelf.muYinDatas = ((FloorModel *)list[2]).ProductList;
                weakSelf.baoJianDatas = ((FloorModel *)list[3]).ProductList;
                weakSelf.memberDatas = ((FloorModel *)list[4]).ProductList;
                [weakSelf.collectionView reloadData];
            }
        }
    }];
}

#pragma mark - 顶部循环广告api
- (void) loadAdvertisment {
    GetAdvertApi *api = [[GetAdvertApi alloc] initWithDataType:CheckTypeAdvert];
    ZDXWeakSelf(weakSelf);
    [api startWtihCallBackSuccess:^(NSArray *DATA) {//BLOB
        weakSelf.advertDatas = DATA;
        if (!weakSelf.advertDatas.count) {
            weakSelf.advertDatas = @[@"banner1",@"banner1",@"banner1",@"banner1",@"banner1"];
        }
        [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    } failure:^(NSError *error) {
        [weakSelf showErrorMessage:@"网络异常，请检查网络设置。Error:1"];
    }];
}

- (void) loadAdvertismentFromData {
    NSDictionary * dict = [DZYTools loadDictWithName:@"ShopGGlist" DB:self.db];
    if (dict) {
        NSArray * arr = [BannerModel objectArrayWithKeyValuesArray:dict[@"ImageList"]];
        self.advertDatas = arr;
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    }
}

#pragma mark - 滚动信息api
- (void) loadNotice{
    
    __weak __typeof(&*self) weakSelf = self;
    AppConfig *config = [AppConfig sharedAppConfig];
    [config loadConfig];
    
    self.timerCount = 0;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"AppSign"] = config.appSign;
    [NoticeModel fetchNoticeListWithParameters:dict block:^(NSArray *list, CGFloat IOSversion, NSError *error) {
        if (error) {
            [weakSelf showErrorMessage:@"网络异常，请检查网络设置。Error:2"];
        } else {
            if (list.count > 0) {
                weakSelf.noticeData = list;
                [weakSelf refershNotice];
            }
            ///判断更新
            if (IOSversion > 0) {
                CGFloat Verison = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] doubleValue];
                ///当前包的版本小于后台设置的版本
                if (Verison < IOSversion) {
//                    
//                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"获取更新！" message:@"好消息！现在可以免费下载新版本了。" delegate:self cancelButtonTitle:@"更新" otherButtonTitles:nil];
//                    [alert show];
                }
            }
        }
    }];
}
- (void) loadCategory {
    GetCatgroyApi *api = [[GetCatgroyApi alloc]initWith:@0];
    [api startWithCallBack:^(NSArray *DATA) {
        self.categroyDatas = DATA;
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
    } failuer:nil];
}
- (void) loadBanner {
    GetBannerApi *api0 = [[GetBannerApi alloc]initWithBannerIndex:0];
    [api0 startWtihCallBackSuccess:^(NSArray *DATA) {
        NSMutableArray * arr = [NSMutableArray arrayWithArray:DATA];
        [arr removeObjectAtIndex:2];
        self.banners = [NSArray arrayWithArray:arr];
        [self getImage];
//        [self.collectionView reloadData];
    } failure:nil];
}
- (void) loadXianShiQiang{
    
    NSDictionary *limitedMerchandiseIntroDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                                @"1", @"pageIndex",
                                                @"3", @"pageSize",
                                                [AppConfig sharedAppConfig].appSign, @"AppSign", nil];
    ZDXWeakSelf(weakSelf);
    [SaleProductModel getSaleProductListByParamer:limitedMerchandiseIntroDic andBlocks:^(NSArray *SaleProductList, NSError *error) {
        if(error){
            [weakSelf showErrorMessage:@"网络异常，请检查网络设置。Error:3"];
        }else {
            NSInteger introCount = [SaleProductList count];
            //首先判断是否有数据
            if (introCount > 0) {                
                weakSelf.xianShiQiangDatas = SaleProductList;
                [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:2]];
                weakSelf.timer1 = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateLimitCell) userInfo:nil repeats:YES];
            }
        }
    }];
}

- (void) loadTodayAcitivity {
    [[[GetTodayActivityApi alloc]init] startWithCallBack:^(NSArray *DATA) {
        self.todayActivityDatas = DATA;
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:2]];
    } failuer:nil];
}

- (void) loadRecommend {
    GetProductInfoApi *api = [[GetProductInfoApi alloc]initWithType:CheckProductTypeRecommend pageIndex:1 pageCount:20];
    [api startWtihCallBackSuccess:^(NSArray *DATA) {
        self.recommendProudcts = DATA;
        [self.collectionView headerEndRefreshing];
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:9]];
    } failure:nil];
 
}

#pragma mark <UICollectionViewDataSource>
/// 分区
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 10;
}
/// 分区cell个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    switch (section) {
        case 0:// 推荐 新品等
            return 1;
            break;
        case 1://第二部分 8个item
            return self.categroyDatas.count;// > 8 ? 8 : self.categroyDatas.count;
            break;
            /*
        case 2:// 一元购
            return self.yiYuanDatas.count > 2 ? 2 : self.yiYuanDatas.count;
            break;
             */
        case 2:// 限时抢购
            return self.xianShiQiangDatas.count;
            break;
        case 3:// 限量抢购
            return self.xianLiangDatas.count;
            break;
        case 4:
            // 10元特区
            return self.shiYuanDatas.count;// > 2 ? 2 : self.shiYuanDatas.count;
            break;
        case 5:// 半价抢购
            return self.banJiaDatas.count;// > 3 ? 3 : self.banJiaDatas.count;
            break;
        case 6:// 母婴特价
            return self.muYinDatas.count;// > 3 ? 3 : self.muYinDatas.count;
            break;
        case 7:// 为您推荐的商品列表
            return self.baoJianDatas.count;// > 3 ? 3 : self.baoJianDatas.count;
            break;
        case 8:// 休闲食品
            return self.memberDatas.count;// > 3 ? 3 : self.memberDatas.count;
            break;
        case 9:// 为您推荐的商品列表
            return self.recommendProudcts.count;
            break;
        default:
            return 0;
            break;
    }
}

/// headerFooterView
- (UICollectionReusableView*) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

    NSInteger section = indexPath.section;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (section == 0) { // 滚动
            HomeCycleView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHomeCycleView forIndexPath:indexPath];
            header.delegate = self;
            header.images = self.advertDatas;
            [header beginScorll];
            self.cycleView = header;
            return header;
        } else if (section == 1) { // 时尚购
            SecondHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kSecondHeaderView forIndexPath:indexPath];
            self.noticeView = header;
            [self refershNotice];
            return header;
        } else if (section == 9) { // 为您推荐
            WeiNiTuiJianView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kWeiNiTuiJianView forIndexPath:indexPath];
            return header;
        } else {
            TitleHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kTitleHeaderView forIndexPath:indexPath];
            header.tag = section;
            header.delegate = self;
            
            // 会员
            if (section == 4 ||section == 5 || section == 6 || section == 7|| section == 8) {
                // 4个区  6-9
                NSInteger index = section - 4;
                FloorModel *model = self.fourSectionDatas[index];
                [header updateHeaderViewWithModel:model];
            } else if (section == 2) {
                [header updateHeaderViewWithModel:@"限时抢购"];
            }
            /*
            else if (section == 2) {
                [header updateHeaderViewWithModel:@"一元购"];
            }*/ else if (section == 3) {
                [header updateHeaderViewWithModel:@"限量抢购"];
            }
            return header;
        }
    }

    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        if (section == ([collectionView numberOfSections] - 1)) {
            PromptFooterView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kPromptFooterView forIndexPath:indexPath];
            return footer;
        } else {
            ImageFooterView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kImageFooterView forIndexPath:indexPath];
            footer.tag = section;
            footer.mode = self.banners[section];
            footer.delegate = self;
            return footer;
        }
    }
    return nil;
}

/// cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.row;
    switch (section) {
        case 0:{
            FIrstCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFirstContentCollectionViewCell forIndexPath:indexPath];
            cell.delegate = self;
            return cell;
        }
            break;
        case 1:{//第二部分 8个item
            SecondContentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSecondContentCell forIndexPath:indexPath];
            if (self.categroyDatas) {
                 cell.mode = self.categroyDatas[item];
            }
            return cell;
        }
            break;
            /*
        case 2:{//一元购
            YiYuanCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kYiYuanCollectionViewCell forIndexPath:indexPath];
            if (self.yiYuanDatas.count > 0) {
                [cell updateViewWithModel:self.yiYuanDatas[item]];
            }
            return cell;
        }
            break;
             */
        case 2:{// 限时抢购
            LimitCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLimitCollectionViewCell forIndexPath:indexPath];
            [cell updateViewWithModel:self.xianShiQiangDatas[item]];
            cell.saleType = SaleTypeXianShiGou;;
            if (self.xianShiQiangDatas.count > 0) {
                // 每秒更新倒计时
                [self updateLimitCell];
            }
            return cell;
        }
            break;
        case 3:{// 限量抢购
            LimitCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLimitCollectionViewCell forIndexPath:indexPath];
            [cell updateViewWithModel:self.xianLiangDatas[item]];
            cell.saleType = SaleTypeXianLiangGou;
            if (self.xianShiQiangDatas.count > 0) {
                // 每秒更新倒计时
                [self updateLimitCell];
            }
            return cell;
        }
            break;
        case 4:{//
            BanJiaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBanJiaCollectionViewCell forIndexPath:indexPath];
            [cell updateViewWithModel:self.shiYuanDatas[item]];
            return cell;
        }
            break;
        case 5: {//
            /*
            ShiYuanCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kShiYuanCollectionViewCell forIndexPath:indexPath];
            [cell updateViewWithModel:self.banJiaDatas[item]];
            return cell;
             */
            BanJiaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBanJiaCollectionViewCell forIndexPath:indexPath];
            [cell updateViewWithModel:self.banJiaDatas[item]];
            return cell;
        }
            break;
        case 6: {
            BanJiaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBanJiaCollectionViewCell forIndexPath:indexPath];
            [cell updateViewWithModel:self.muYinDatas[item]];
            return cell;
        }
        case 7: {
            BanJiaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBanJiaCollectionViewCell forIndexPath:indexPath];
            [cell updateViewWithModel:self.baoJianDatas[item]];
            return cell;
        }
            break;
        case 8:{// 会员折扣
            BanJiaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBanJiaCollectionViewCell forIndexPath:indexPath];
            [cell updateViewWithModel:self.memberDatas[item]];
            return cell;
        }
            break;
        case 9:{// 为您 推荐的商品列表
            ProductListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kProductListCell forIndexPath:indexPath];
            cell.mode = self.recommendProudcts[item];
            return cell;
        }
            break;
        default:
            break;
    }
    return nil;
}
#pragma mark - 布局代理<UICollectionViewDelegateFlowLayout>
/// 头部视图size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(LZScreenWidth, LZScreenWidth/640.0*212.0);
    } else if (section == 1) {
        return CGSizeMake(LZScreenWidth, 40);
    } else if (section == collectionView.numberOfSections - 1) {
        return CGSizeMake(SCREEN_WIDTH, 25);
    } else {
        return CGSizeMake(LZScreenWidth, 35);
    }
}
/// 底部视图size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == collectionView.numberOfSections - 1) {
        return CGSizeMake(LZScreenWidth, 40);
    } else {
        if (self.banners.count > section) {
            BannerModel * model = self.banners[section];
            return CGSizeMake(LZScreenWidth, model.height);
        } else {
            return CGSizeZero;
        }
    }
}

/// 偏移量  UIEdgeInsetsMake(上, 左, 下, 右)
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    switch (section) {
        case 0:// 推荐 新品等
            return UIEdgeInsetsMake(0.5, 0, 0.5, 0);
            break;
        case 1://第二部分 8个item
            return UIEdgeInsetsMake(0.5, 0.8, 0.5, 0.5);
            break;
            /*
        case 2:// 一元购
            return UIEdgeInsetsMake(0.5, 0.5, 0.5, 0.0);
            break;
             */
        case 2:// 限时抢购
            return UIEdgeInsetsMake(0.5, 0.5, 0.5, 0);
            break;
        case 3:// 限量抢购
            return UIEdgeInsetsMake(0.5, 0.5, 0.5, 0);
            break;
        case 4:// 南航会员
            return UIEdgeInsetsMake(0.5, 0.5, 0.5, 0);
            break;
        case 5:// 10元特区
            return UIEdgeInsetsMake(0.5, 0.5, 0.5, 0);
            break;
        case 6:// 半价抢购
            return UIEdgeInsetsMake(0.5, 0.5, 0.5, 0);
            break;
        case 7:// 母婴特价
            return UIEdgeInsetsMake(0.5, 0.5, 0.5, 0);
//            return UIEdgeInsetsMake(0.5, 0, 0, 0);
            break;
        case 8:// 保健特价
            return UIEdgeInsetsMake(0.5, 0.5, 0.5, 0);
            break;
        case 9:// 为您推荐的商品列表
            return UIEdgeInsetsMake(5, 0, 5, 0);
            break;
        default:
            return UIEdgeInsetsZero;
            break;
    }
}

/// 行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section == ([collectionView numberOfSections] - 1)) {
        return 5;
    }/* else if (section == 1 || section == 4) {
        return 0.5;
    } */
    else {
        return 0.5;
    }
}

/// 列间距
- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (section == ([collectionView numberOfSections] - 1)) {
        return 5;
    } else if (section == 5/* || section == 2*/) {
        return 0.5;
    } else {
        return 0.5;
    }
}

/// cellsize
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
   
    switch (section) {
        case 0:// 推荐 新品等
            return CGSizeMake(SCREEN_WIDTH, 80);
            break;
        case 1://第二部分 8个item
            return CGSizeMake((LZScreenWidth-1.5)/4.0f - 0.5, 120);
            break;
            /*
        case 2:// 一元购
            return [ShiYuanCollectionViewCell shiYuanCellSize];
//            return CGSizeMake((SCREEN_WIDTH - 0.5) / 2, 110);
            break;
             */
        case 2:// 限时抢购
            return [LimitCollectionViewCell XianShiCellSize];
//            return CGSizeMake(SCREEN_WIDTH / 3 - 0.5, 180);
            break;
        case 3:// 限量抢购
            return [LimitCollectionViewCell XianShiCellSize];
            break;
        case 4:// 10元特区
            return [BanJiaCollectionViewCell banJiaCellsize];
            break;
        case 5:// 半价抢购
            return [BanJiaCollectionViewCell banJiaCellsize];
            /*
            return [ShiYuanCollectionViewCell shiYuanCellSize];
//            return CGSizeMake((SCREEN_WIDTH - 2) / 3.0f, 180);
              */ 
            break;
            
        case 6:// 母婴特价
            return [BanJiaCollectionViewCell banJiaCellsize];
//            return CGSizeMake(SCREEN_WIDTH, 170);
            break;
        case 7:// 母婴特价
            return [BanJiaCollectionViewCell banJiaCellsize];
            //            return CGSizeMake(SCREEN_WIDTH, 170);
            break;
        case 8:// 会员折扣
            return [BanJiaCollectionViewCell banJiaCellsize];
            break;
        case 9:// 为您推荐的商品列表
            return [ProductListCell itemSizeForColumn:2 padding:5];
            break;
        default:
            return CGSizeZero;
            break;
    }
}

#pragma mark <UICollectionViewDelegate>
- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    currentIndexPath = indexPath;
    switch (section) {
//        case 0: {
//            LZLOG(@"000");
//        }
//            break;
        case 1:{//分类
            SortModel *mode = self.categroyDatas[indexPath.row];
            [self gotoMerchandiseListViewControllerWithTitleName:mode.Name categoryID:mode.SortID model:mode];
        }
            break;
            /*
        case 2:{//1元购
            
            YiYuanGouModel *model = self.yiYuanDatas[currentIndexPath.row];
            currentSaleType = SaleTypeYiYuanGou;
            if (model) {
                [self performSegueWithIdentifier:@"kSegueHomeToYiYuanGouDetail" sender:self];
            }
        }
            break;
             */
            break;
        case 2:{//限时抢
            
            SaleProductModel *model = self.xianShiQiangDatas[currentIndexPath.row];
            currentSaleType = SaleTypeXianShiGou;
            if (model) {
                [self performSegueWithIdentifier:@"kSegueHomeToLimitDetail" sender:self];
            }
        }
            break;
        case 3: {
            SaleProductModel *model = self.xianLiangDatas[currentIndexPath.row];
            currentSaleType = SaleTypeXianLiangGou;
            if (model) {
                [self performSegueWithIdentifier:@"kSegueHomeToLimitDetail" sender:self];
            }
        }
            break;
        case 4:{//10元
            FloorProductModel *model = self.shiYuanDatas[currentIndexPath.row];
            [self gotoMerchandiseDetailViewControllerWithGuid:model.Guid];
        }
            break;
        case 5:{//半价
            FloorProductModel *model = self.banJiaDatas[currentIndexPath.row];
            [self gotoMerchandiseDetailViewControllerWithGuid:model.Guid];
        }
            break;
        case 6:{//半价
            FloorProductModel *model = self.muYinDatas[currentIndexPath.row];
            [self gotoMerchandiseDetailViewControllerWithGuid:model.Guid];
        }
            break;
        case 7:{//半价
            FloorProductModel *model = self.baoJianDatas[currentIndexPath.row];
            [self gotoMerchandiseDetailViewControllerWithGuid:model.Guid];
        }
            break;
        case 8:{//会员
            FloorProductModel *model = self.memberDatas[currentIndexPath.row];
            [self gotoMerchandiseDetailViewControllerWithGuid:model.Guid];
        }
            break;
        case 9: {
            ProductInfoMode *model = self.recommendProudcts[indexPath.item];
            [self gotoMerchandiseDetailViewControllerWithGuid:model.Guid];
        }
            break;
        default:
            break;
    }
}
#pragma mark - 扫一扫代理
- (void) navTitleViewDidClickLeftBtn:(NavTitleView*)view{
    ScanViewController *sacn = [[ScanViewController alloc]init];
    sacn.delegate = self;
    [self.navigationController presentViewController:sacn animated:YES completion:nil];
}

// 搜索
- (void) navTitleViewDidClickRightBtn:(NavTitleView*)view{
    [self.navigationController pushViewController:[SearchViewController searchVC] animated:YES];
//    [[AppConfig sharedAppConfig] loadConfig];
//    if ([AppConfig sharedAppConfig].isLogin) {
//        [self.navigationController pushViewController:[MessageViewController create] animated:YES];
//    }else{
//        [self.navigationController pushViewController:[LoginViewController create] animated:YES];
//    }

}

- (void) navTitleView:(NavTitleView*)view searchText:(NSString*)text{
    if (!text.length) {
        return;
    }
    
    SearchResultViewController *nextVC = [SearchResultViewController createSearchResultVC];
    nextVC.searchText = text;
    nextVC.TitleName = text;
    [self.navigationController pushViewController:nextVC animated:YES];
}

// TODO: 扫一扫的问题
- (void)scanView:(ScanViewController *)controller didScanedCode:(NSString *)code{
    // 商品
//    NSLog(@"Code : %@", code);
    if ([code hasPrefix:@"http://"]) {
        NSString *productGuid = [code componentsSeparatedByString:@"?"].lastObject;
        if (productGuid && productGuid.length == 36) {
            [self gotoMerchandiseDetailViewControllerWithGuid:productGuid];
        }
    } else {
        [self showErrorMessage:@"暂无信息"];
    }
}

#pragma mark - 刷新公告
- (void)refershNotice {
//    NSString *notice = [NSString stringWithFormat:@"第%ld条通知",self.timerCount%6+1];
    if (self.noticeData && self.noticeData.count > 0 && self.noticeData.count >= self.timerCount) {
        NoticeModel *model = self.noticeData[self.timerCount];
        [self.noticeView refershWithNotice:model.Title];
        self.timerCount ++;
        if (self.timerCount == self.noticeData.count) {
            self.timerCount = 0;
        }
    }
}

#pragma mark - 头部滚动视图 按钮代理
- (void)HomeCycleViewDidClickIndex:(NSInteger)index{
    BannerModel * model = self.advertDatas[index];
    if (model.Url) {
        [self goViewUrl:model.Url];
    }
}

#pragma mark - 判断url并跳转
- (void)goViewUrl:(NSString *)url
{
    //跳网页
    if ([url hasPrefix:@"http://"]) {
        MoreDetailViewController *moreVC = ZDX_VC(@"StoryboardIOS7", @"MoreDetailViewController");
        moreVC.htmlStr = url;
        [self.navigationController pushViewController:moreVC animated:YES];
    }
    else
    {
        NSArray * arr = [url componentsSeparatedByString:@"|"];
        NSString * str = arr[0];
        //跳商品详情
        if ([str isEqualToString:@"product"]) {
            DZYMerchandiseDetailController * vc = [DZYMerchandiseDetailController create];
            vc.Guid = arr[1];
            [self.navigationController pushViewController:vc animated:YES];
        } //跳分类
        else if ([str isEqualToString:@"list"])
        {
            NSString * ID = arr[1];
            SortModel * model ;
            for (SortModel * mode in self.categroyDatas) {
                if ([mode.SortID isEqualToString:ID]) {
                    model = mode;
                }
            }
            SearchResultViewController *nextVC = [SearchResultViewController createSearchResultVC];
            nextVC.searchProductCategoryID = ID;
            nextVC.fatherModel = model;
            nextVC.TitleName = model.Name;
            [self.navigationController pushViewController:nextVC animated:YES];
        }// 跳品牌列表
        else if ([str isEqualToString:@"brandlist"])
        {
            NSString * BrandGuid = arr[1];
            SearchResultViewController *searchVC = [SearchResultViewController createSearchResultVC];
            searchVC.searchBrandGuid = BrandGuid;
            searchVC.TitleName = @"商品列表";
            [self.navigationController pushViewController:searchVC animated:YES];
        }
    }
}

#pragma mark - 分区头代理
- (void) titleHeaderViewDidTouch:(TitleHeaderView *)headerView{

    NSInteger tag = headerView.tag;
    LZLOG(@"%d", tag); // 2 - 9个
    switch (tag) {
            /*
        case 2: { // 1元购
            currentSaleType = SaleTypeYiYuanGou;
            [self performSegueWithIdentifier:@"kSegueLimitSale" sender:self];
        }
             
            break;
             */
        case 2: { // 限时抢
            currentSaleType = SaleTypeXianShiGou;
            [self performSegueWithIdentifier:@"kSegueLimitSale" sender:self];
        }
            break;
        case 3: { // 限量抢
            currentSaleType = SaleTypeXianLiangGou;
            [self performSegueWithIdentifier:@"kSegueLimitSale" sender:self];
        }
            break;
//        case 4: { // 会员折扣
//            FloorModel *model = self.fourSectionDatas[4];
//            [self gotoMerchandiseListViewControllerWithTitleName:model.Name categoryID:model.ProductID.stringValue model:nil];
//        }
//            break;
        default: {
            // 6 - 9
            NSInteger index = tag - 4;
            FloorModel *model = self.fourSectionDatas[index];
            SortModel * mode = nil;
            for (SortModel * data in self.categroyDatas) {
                if ([data.Name isEqualToString:model.Name]) {
                    mode = data;
                }
            }
            [self gotoMerchandiseListViewControllerWithTitleName:model.Name categoryID:model.ProductID.stringValue model:mode];
        }
            break;
    }
}

#pragma mark - 各广告代理
- (void)didSelectImageFooterView:(ImageFooterView *)imageFooterView OfUrl:(NSString *)url {
    if (url) {
        if (imageFooterView.tag == 0) { ///我也要开店
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
        else
        {
            [self goViewUrl:url];
        }
    }
}

#pragma mark - 1+2 母婴代理
- (void) activityBtnsCell:(ActivityBtnsCell *)cell didClickAtIndex:(NSInteger)index{
    ProductInfoMode *mode = self.todayActivityDatas[index];
    [self gotoMerchandiseDetailViewControllerWithGuid:mode.Guid];
}

#pragma mark - 限量抢购
- (void)didSelectXianLiangCellAtIndex:(NSInteger)index {
    if (self.xianLiangDatas.count > index) {
        currentSaleType = SaleTypeXianLiangGou;
        currentIndexPath = [NSIndexPath indexPathForItem:index inSection:4];
        [self performSegueWithIdentifier:@"kSegueHomeToLimitDetail" sender:self];
    }
}
                               

#pragma mark - 特价代理
- (void)teJiaCellDidSelectAtIndex:(NSInteger)index {
    FloorProductModel *model = self.baoJianDatas[index];
    DZYMerchandiseDetailController * vc = [DZYMerchandiseDetailController create];
    vc.Guid = model.Guid;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 推荐新品等代理
- (void)firstCollectionViewCell:(FIrstCollectionViewCell *)view clickAtIndex:(NSInteger)index {
    
    switch (index) {
        case 0: {// 推荐商品
//            ProductListController *nextVC = [ProductListController createWithType:CheckProductTypeBoutique title:@"推荐商品"];
//            [self.navigationController pushViewController:nextVC animated:YES];
            currentTitle = @"推荐商品";
            currentProductType = CheckProductTypeRecommend;
            [self performSegueWithIdentifier:@"kSegueHomeToProductList" sender:self];
        }
            break;
        case 1:// 品牌推荐
            [self.navigationController pushViewController:[BrandCenterViewController create] animated:YES];
            break;
        case 2:{// 新品上架
            currentTitle = @"新品上架";
            currentProductType = CheckProductTypeNew;
            [self performSegueWithIdentifier:@"kSegueHomeToProductList" sender:self];
//            ProductListController *nextVC = [ProductListController createWithType:CheckProductTypeNew title:@"新品上架"];
//            [self.navigationController pushViewController:nextVC animated:YES];
        }
            break;
        case 3:{// 热卖商品
            currentTitle = @"热卖商品";
            currentProductType = CheckProductTypeHot;
            [self performSegueWithIdentifier:@"kSegueHomeToProductList" sender:self];
//            ProductListController *nextVC = [ProductListController createWithType:CheckProductTypeHot title:@"热卖商品"];
//            [self.navigationController pushViewController:nextVC animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 注册组件
- (void) registerColletionViewComponent {
    // section-1
    [self.collectionView registerClass:[HomeCycleView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHomeCycleView];
    [self.collectionView registerClass:[FIrstCollectionViewCell class] forCellWithReuseIdentifier:kFirstContentCollectionViewCell];
    [self.collectionView registerClass:[ImageFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kImageFooterView];
    
    // section-2
    [self.collectionView registerClass:[SecondHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kSecondHeaderView];
    [self.collectionView registerNib:[UINib nibWithNibName:@"SecondContentCell" bundle:nil] forCellWithReuseIdentifier:kSecondContentCell];
//    [self.collectionView registerClass:[SecondContentCell class] forCellWithReuseIdentifier:kSecondContentCell];
    
    // section-3
    [self.collectionView registerClass:[TitleHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kTitleHeaderView];
    [self.collectionView registerClass:[YiYuanCollectionViewCell class] forCellWithReuseIdentifier:kYiYuanCollectionViewCell];
    // section-4
    [self.collectionView registerClass:[LimitCollectionViewCell class] forCellWithReuseIdentifier:kLimitCollectionViewCell];
    // section - 5 限量抢
    [self.collectionView registerClass:[XianLiangCollectionViewCell class] forCellWithReuseIdentifier:kXianLiangCellIdentifier];
    // section - 6
    [self.collectionView registerClass:[MemberCollectionViewCell class] forCellWithReuseIdentifier:kMemberCollectionViewCell];
    // section - 7
    [self.collectionView registerClass:[ShiYuanCollectionViewCell class] forCellWithReuseIdentifier:kShiYuanCollectionViewCell];
    // section - 8
    [self.collectionView registerClass:[BanJiaCollectionViewCell class] forCellWithReuseIdentifier:kBanJiaCollectionViewCell];
    // section - 9
    [self.collectionView registerClass:[ActivityBtnsCell class] forCellWithReuseIdentifier:kActivityBtnsCell];
    // section - 10
    [self.collectionView registerClass:[TeJiaCollectionViewCell class] forCellWithReuseIdentifier:kTeJiaCollectionViewCell];
    
    // section - 11
    [self.collectionView registerClass:[WeiNiTuiJianView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kWeiNiTuiJianView];
    [self.collectionView registerClass:[ProductListCell class] forCellWithReuseIdentifier:kProductListCell];
    [self.collectionView registerClass:[PromptFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kPromptFooterView];
}

/// 偏移量 item
-(UIBarButtonItem *) navigationSpace:(CGFloat)space {
    UIBarButtonItem *navigationSpace = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    
    if (LZCurrentSystemVersion >= 7.0) {
        navigationSpace.width = space;
    }else{
        navigationSpace.width = 0;
    }
    return navigationSpace;
}

- (void)updateLimitCell {
    [self.collectionView.visibleCells enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[LimitCollectionViewCell class]]) {
            LimitCollectionViewCell *cell = obj;
            [cell updateTimeLabel];
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"kSegueHomeToLimitDetail"]) {
        LimitSaleDetailViewController *detail = [segue destinationViewController];
        SaleProductModel *model;
        if (currentSaleType == SaleTypeXianShiGou) {
            model = self.xianShiQiangDatas[currentIndexPath.row];
        } else if (currentSaleType == SaleTypeXianLiangGou) {
            model = self.xianLiangDatas[currentIndexPath.row];
        }
        detail.model = model;
        detail.saleType = currentSaleType;
    }
    
    if ([segue.identifier isEqualToString:@"kSegueLimitSale"]) {
        LimitSaleViewController *lsVC = [segue destinationViewController];
        lsVC.saleType = currentSaleType;
    }
    
    if ([segue.identifier isEqualToString:@"kSegueHomeToYiYuanGouDetail"]) {
        YiYuanGouDetailViewController *detail = [segue destinationViewController];
        YiYuanGouModel *model = self.yiYuanDatas[currentIndexPath.row];
        detail.model = model;
    }
    if ([segue.identifier isEqualToString:@"kSegueHomeToProductList"]) {
        ProductListController *listVC = [segue destinationViewController];
        listVC.title = currentTitle;
        listVC.type = currentProductType;
    }
}

// MARK: 去商品详情
- (void)gotoMerchandiseDetailViewControllerWithGuid:(NSString *)guid {
    
    DZYMerchandiseDetailController * vc = [DZYMerchandiseDetailController create];
    vc.Guid = guid;
    [self.navigationController pushViewController:vc animated:YES];
    
}

// MARK: 去商品分类列表
- (void)gotoMerchandiseListViewControllerWithTitleName:(NSString *)titleName categoryID:(NSString *)categoryID model:(SortModel *)model
{
    SearchResultViewController *nextVC = [SearchResultViewController createSearchResultVC];
    nextVC.searchProductCategoryID = categoryID;
    nextVC.fatherModel = model;
    nextVC.TitleName = titleName;
    [self.navigationController pushViewController:nextVC animated:YES];
}

#pragma mark - 发现宝箱
- (void)findTreasure {
    [self.findButton setUserInteractionEnabled:NO];
    // api/GetReward/   传入参数：AppSign  、MemLoginID
    ZDXWeakSelf(weakSelf);
    [RewardModel fetchRewardWithparameters:@{@"AppSign" : [AppConfig sharedAppConfig].appSign, @"MemLoginID" : [AppConfig sharedAppConfig].loginName} block:^(RewardModel *model, NSError *error) {
        if (error) {
            [weakSelf showErrorMessage:@"网络异常，请检查网络设置"];
        } else {
            [weakSelf presentTreasureWithModel:model];
        }
    }];
}

// 弹出中奖信息
- (void)presentTreasureWithModel:(RewardModel *)model {
    
    // 寻宝背景视图
    self.contentView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.contentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    // 中奖弹出动画
    self.popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    self.popAnimation.duration = 0.3;
    self.popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                                 [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                                 [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                                 [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    self.popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
    self.popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                          [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                          [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//    NSLog(@"类型： %@", model.ChestsType);
    switch (model.ChestsType.integerValue) {
        case 0: // 未中奖
            self.notWinView = [[NSBundle mainBundle] loadNibNamed:@"FindNotWinView" owner:nil options:nil].firstObject;
            self.notWinView.delegate = self;
            self.notWinView.center = self.contentView.center;
            
            [self.contentView addSubview:self.notWinView];
            [[[[UIApplication sharedApplication].keyWindow subviews] firstObject] addSubview:self.contentView];
            [self.notWinView.layer addAnimation:self.popAnimation forKey:nil];
            break;
        case 1: // 积分
            self.scoreView = [[NSBundle mainBundle] loadNibNamed:@"FindScoreView" owner:nil options:nil].firstObject;
            self.scoreView.delegate = self;
            self.scoreView.center = self.contentView.center;
            
            [self.scoreView updateViewWithScore:model.Score];
            [self.contentView addSubview:self.scoreView];
            [[[[UIApplication sharedApplication].keyWindow subviews] firstObject] addSubview:self.contentView];
            [self.scoreView.layer addAnimation:self.popAnimation forKey:nil];
            break;
        case 2: // 优惠券
            self.couponView = [[NSBundle mainBundle] loadNibNamed:@"FindCouponView" owner:nil options:nil].firstObject;
            self.couponView.delegate = self;
            self.couponView.center = self.contentView.center;
            
            [self.couponView updateViewWithModel:model];
            [self.contentView addSubview:self.couponView];
            [[[[UIApplication sharedApplication].keyWindow subviews] firstObject] addSubview:self.contentView];
            [self.couponView.layer addAnimation:self.popAnimation forKey:nil];
            break;
        default:
            break;
    }
}

#pragma mark - 发现宝箱的代理方法
// 点击返回
- (void)didSelectBack {
    [self.contentView removeFromSuperview];
    self.findButton.hidden = YES;
}

// 点击马上查看
- (void)didSelectGotoLook {
    // 去优惠券列表
    [self.contentView removeFromSuperview];
    self.findButton.hidden = YES;
    
    FavourTicketViewController *ticketVC = ZDX_VC(@"StoryboardIOS7", @"FavourTicketViewController");
    [self.navigationController pushViewController:ticketVC animated:YES];
}

// 点击确定
- (void)didSelectComfirm {
    [self.contentView removeFromSuperview];
    self.findButton.hidden = YES;
}

// 错误信息
- (void)showErrorMessage:(NSString *)message {
    [MBProgressHUD showError:message];
}

- (void)getImage
{
    __block int i = 0;
    for (BannerModel * model in self.banners) {
        NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
        NSString * name = [model.Value stringByReplacingOccurrencesOfString:@"http://www.efood7.com/ImgUpload/" withString:@""];
        NSString *imgPath=[path stringByAppendingPathComponent:name];
        
        UIImage *image = [UIImage imageWithContentsOfFile:imgPath];
        
        if (image == nil) {
            NSURLSession * session = [NSURLSession sharedSession];
            NSURLSessionTask * task = [session dataTaskWithURL:[NSURL URLWithString:model.Value] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                UIImage * image = [UIImage imageWithData:data];
                
//                [UIImagePNGRepresentation(image) writeToFile:imgPath atomically:YES];
                [UIImageJPEGRepresentation(image, 0.1) writeToFile:imgPath atomically:YES];
                
                CGFloat height = LZScreenWidth/image.size.width * image.size.height;
                model.height = height;
                i++;
                if (i == self.banners.count-1) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.collectionView reloadData];
                    });
                }
            }];
            [task resume];
        }
        else
        {
            CGFloat height = LZScreenWidth/image.size.width * image.size.height;
            model.height = height;
            if (i == self.banners.count-1) {
                [self.collectionView reloadData];
            }
        }
    }
}

#pragma mark - 环信
- (void)kefu
{
    self.keFuBtn.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.keFuBtn.userInteractionEnabled = YES;
    });
    [[EMIMHelper defaultHelper] loginEasemobSDK];
}

- (void)loginEnd{
    ChatViewController * chatController = [[ChatViewController alloc] initWithChatter:@"food7" type:eAfterSaleType];
    chatController.title = @"客服";
    chatController.commodityInfo = nil;
    [self.navigationController pushViewController:chatController animated:YES];
}

#pragma mark -  scrollView代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.collectionView) {
        if (scrollView.contentOffset.y > self.beginOffsetY && self.keFuHidden == NO && self.goToNext == NO) {
            self.keFuHidden = YES;
            [self hidden];
        }
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == self.collectionView) {
        self.beginOffsetY = scrollView.contentOffset.y;
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == self.collectionView && self.keFuHidden == YES && !decelerate) {
        self.keFuHidden = NO;
        [self show];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.collectionView && self.keFuHidden == YES) {
        self.keFuHidden = NO;
        [self show];
    }
}

-(void)hidden
{
    [UIView animateWithDuration:0.5 animations:^{
        self.keFuBtn.transform = CGAffineTransformTranslate(self.keFuBtn.transform, 0, 100);
    }];
}

-(void)show
{
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionTransitionNone animations:^{
        self.keFuBtn.transform = CGAffineTransformTranslate(self.keFuBtn.transform, 0, -100);
    } completion:nil];
}

-(void)receive
{
    //和show hidden 动画重复了。 不能这样玩.
//    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse animations:^{
//        self.keFuBtn.transform = CGAffineTransformTranslate(self.keFuBtn.transform, 5, 0);
//    } completion:^(BOOL finished) {
//        
//    }];
    [self.keFuBtn setImage:[UIImage imageNamed:@"kefu03_new"] forState:UIControlStateNormal];
}
@end
