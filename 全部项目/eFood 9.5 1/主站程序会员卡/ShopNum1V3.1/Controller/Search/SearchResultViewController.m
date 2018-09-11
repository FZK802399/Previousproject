//
//  SearchResultViewController.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-13.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "SearchResultViewController.h"
#import "DZYMerchandiseDetailController.h"
#import "MerchandiseCollectionViewController.h"
#import "MJRefresh.h"
#import "SearchResultCell.h"
#import "LZPopView.h"
#import "BrandModel.h"
#import "DZYTools.h"

@interface SearchResultViewController ()<MerchandiseCollectionViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) MerchandiseCollectionViewController *collectionView;

@property (nonatomic, weak)UIView * bigView;
///大小图切换
@property (retain, nonatomic) IBOutlet UIButton *changeViewButton;
///主视图（重写的）
@property (weak, nonatomic) IBOutlet UITableView *tableView;
///tableViewData
@property (nonatomic,strong) NSMutableArray * arr;
@property (nonatomic,strong) NSString * keyStr;
///内容视图
@property (weak, nonatomic) IBOutlet UIView *dataView;


///类型（价格 销量 综合）
@property (copy, nonatomic) NSString *selectSort;
///正反序
@property (copy, nonatomic) NSString *selectIsAcs;

///--- 父类 分类 (二级分类相关)
@property (strong, nonatomic) NSMutableArray *fatherData;
@property (strong, nonatomic) NSMutableArray *lineWidthArr;
@property (strong, nonatomic) NSMutableArray * headBtnArr;
@property (nonatomic,weak)UIView * headLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;
///--- 父类 分类 (二级分类相关)

///排序剪头
@property (weak, nonatomic) IBOutlet UIImageView *arrowOne;
@property (weak, nonatomic) IBOutlet UIImageView *arrowTwo;
@property (weak, nonatomic) IBOutlet UIImageView *arrowThree;
///排序剪头

///下拉刷新相关
@property (assign, nonatomic)NSInteger pageIndex;
@property (assign, nonatomic)NSInteger pageCount;
@property (assign, nonatomic)BOOL refresh;
///下拉刷新相关
@property (weak, nonatomic) IBOutlet UIButton *btn;



@end



@implementation SearchResultViewController
{
    NSString * productID;
}

+ (instancetype)createSearchResultVC {
    return [[UIStoryboard storyboardWithName:@"StoryboardIOS7" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchResultViewController"];
}

-(NSMutableArray *)fatherData
{
    if (_fatherData == nil) {
        _fatherData = [NSMutableArray array];
    }
    return _fatherData;
}

-(NSMutableArray *)lineWidthArr
{
    if (_lineWidthArr == nil) {
        _lineWidthArr = [NSMutableArray array];
    }
    return _lineWidthArr;
}

-(NSMutableArray *)headBtnArr
{
    if (_headBtnArr == nil) {
        _headBtnArr = [NSMutableArray array];
    }
    return _headBtnArr;
}

-(NSMutableArray *)arr
{
    if (_arr == nil) {
        _arr = [NSMutableArray array];
    }
    return _arr;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.tableView.rowHeight = 105.0f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.pageIndex = 1;
    self.pageCount = 10;
    self.refresh = NO;
    
    if (self.searchText.length > 0) {
        _viewType = MerchandiseForSearch;
        self.searchProductCategoryID = @"-1";
        _keyStr = self.searchText;
        self.noResultLabel.text = @"该关键字无搜索结果";
    }else if (self.searchBrandGuid.length > 0) {
        _viewType = MerchandiseForBrand;
        _keyStr = self.searchBrandGuid;
        self.noResultLabel.text = @"该品牌无商品";
    }else if ([self.searchProductCategoryID integerValue] >= 0) {
        _viewType = MerchandiseForCategory;
        _keyStr = self.searchProductCategoryID;
        self.noResultLabel.text = @"该类别无商品";
    }
    
    [self.tableView addFooterWithCallback:^{
        self.pageIndex += 1;
        self.refresh = YES;
        [self loadDataFromWeb];
    }];
    if (self.fatherModel) {
        self.topHeight.constant = 40;
        self.navigationItem.title = self.fatherModel.Name;
        [self loadFatherDataById:self.fatherModel.SortID];
    }
    else
    {
        self.title = self.TitleName;
    }
    [self drawLine];
    
    [self.noResultImage setHidden:YES];
    [self.noResultLabel setHidden:YES];
    
    self.arrowOne.hidden = NO;
    self.arrowTwo.hidden = YES;
    self.arrowThree.hidden = YES;
    
    self.selectSort = @"ModifyTime";
    self.selectIsAcs = @"true";
    
//    [self loadDataFromWeb];
    
//    [self loadSearchResultDataWithSortType:self.selectSort andSortASC:self.selectIsAcs];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_collectionView == nil) {
        _collectionView = [[MerchandiseCollectionViewController alloc] init];
        _collectionView.view.frame = self.dataView.bounds;;
        _collectionView.collectionView.frame = _collectionView.view.bounds;
        _collectionView.delegate = self;
        [self.dataView addSubview:_collectionView.view];
        self.bigView = _collectionView.view;
        
        _collectionView.keyWords = _keyStr;
        _collectionView.viewType = _viewType;
        _collectionView.sorts = self.selectSort;
        _collectionView.isAsc = self.selectIsAcs;
        _collectionView.shopID = _ShopID;
        [_collectionView reloadData];
    }
    
}

#pragma mark - 加载数据
-(void)loadDataFromWeb
{
    AppConfig * config = [AppConfig sharedAppConfig];
    [config loadConfig];
    [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
    if (self.refresh == NO) {
        [self.arr removeAllObjects];
    }
    
    NSDictionary * getDataDic = nil;
    switch (self.viewType) {
        case MerchandiseForSearch:
        {
            getDataDic = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"-1", @"ProductCategoryID",
                          self.selectSort, @"sorts",
                          self.selectIsAcs, @"isASC",
                          [NSString stringWithFormat:@"%ld",self.pageIndex], @"pageIndex",
                          [NSString stringWithFormat:@"%ld",self.pageCount], @"pageCount",
                          _keyStr, @"name",
                          @"", @"BrandGuid",
                          config.appSign, @"AppSign",
                          nil];
            //搜索产品
            [MerchandiseIntroModel getSearchProductListByParamer: getDataDic
                                                       andBlocks:^(NSArray *introArr,NSError *error){
                                                           if (self.refresh && introArr.count == 0) {
                                                               self.pageIndex -= 1;
                                                           }
                                                           [self.tableView footerEndRefreshing];
                                                           [self.arr addObjectsFromArray:introArr];
                                                           [self.tableView reloadData];
                                                       }];
        }
            break;
        case MerchandiseForCategory:
        {
            NSLog(@"分类查看");
            getDataDic = [NSDictionary dictionaryWithObjectsAndKeys:
                          _keyStr, @"ProductCategoryID",
                          self.selectSort, @"sorts",
                          self.selectIsAcs, @"isASC",
                          [NSString stringWithFormat:@"%ld",self.pageIndex], @"pageIndex",
                          [NSString stringWithFormat:@"%ld",self.pageCount], @"pageCount",
                          @"", @"name",
                          @"", @"BrandGuid",
                          config.appSign, @"AppSign",
                          nil];
            //分类查看
            [MerchandiseIntroModel getSearchProductListByParamer:getDataDic
                                                       andBlocks:^(NSArray *lsit, NSError *error){
                                                           if (self.refresh && lsit.count == 0) {
                                                               self.pageIndex -= 1;
                                                           }
                                                           [self.tableView footerEndRefreshing];
                                                           [self.arr addObjectsFromArray:lsit];
                                                           [self.tableView reloadData];
                                                       }];
        }
            break;
        case MerchandiseForBrand:
        {
            
            getDataDic = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"-1", @"ProductCategoryID",
                          self.selectSort, @"sorts",
                          self.selectIsAcs, @"isASC",
                          [NSString stringWithFormat:@"%ld",self.pageIndex], @"pageIndex",
                          [NSString stringWithFormat:@"%ld",self.pageCount], @"pageCount",
                          @"", @"name",
                          _keyStr, @"BrandGuid",
                          config.appSign, @"AppSign",
                          nil];
            //品牌查看
            [MerchandiseIntroModel getSearchProductListByParamer:getDataDic
                                                       andBlocks:^(NSArray *list,NSError *error){
                                                           if (self.refresh && list.count == 0) {
                                                               self.pageIndex -= 1;
                                                           }
                                                           [self.tableView footerEndRefreshing];
                                                           [self.arr addObjectsFromArray:list];
                                                           [self.tableView reloadData];
                                                       }];
        }
            break;
    }
}



///获取二级分类
-(void)loadFatherDataById:(NSString *) sortID {
    NSDictionary *getBrandIntroDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                      sortID, @"id",
                                      kWebAppSign, @"AppSign", nil];
    [SortModel getSecondSortsByParamer:getBrandIntroDic andBlocks:^(NSArray *sortsList, NSError *error) {
        if(error){
            
            [self showAlertWithMessage:NSLocalizedString(@"获取信息错误", nil)];
        }else{
            NSInteger introCount;
            if (![sortsList isEqual:[NSNull null]]) {
                introCount = [sortsList count];
            }
            [self.fatherData addObject:self.fatherModel];
            [self.fatherData addObjectsFromArray:sortsList];
            [self createHeadScrollViewWithArr:self.fatherData];
        }
    }];
}

///创建顶部滚动视图
-(void)createHeadScrollViewWithArr:(NSArray *)arr
{
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, LZScreenWidth, 40)];
    scrollView.showsHorizontalScrollIndicator = NO;
    CGFloat width = arr.count <= 4 ? LZScreenWidth/arr.count : LZScreenWidth/4;
    scrollView.contentSize = CGSizeMake(width*arr.count, 40);
    ///创建按钮
    for (SortModel * model in arr) {
        NSInteger i = [arr indexOfObject:model];
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(i*width, 0, width, 40)];
        btn.tag = i;
        if (i == 0) {
            [btn setTitle:@"全部" forState:UIControlStateNormal];
        }
        else
        {
            [btn setTitle:model.Name forState:UIControlStateNormal];
        }
        [btn setTitleColor:FONT_BLACK forState:UIControlStateNormal];
        [btn setTitleColor:MAIN_BLUE forState:UIControlStateSelected];
        [btn setTitleColor:MAIN_BLUE forState:UIControlStateSelected|UIControlStateHighlighted];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(headScrollViewDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:btn];
        [self.headBtnArr addObject:btn];
    }
    [self.view addSubview:scrollView];
    
    ///线
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 64+39, LZScreenWidth, 0.5)];
    line.backgroundColor = LINE_LIGHTGRAY;
    [self.view addSubview:line];
    
    for (SortModel * model in arr) {
        ///首次进入的点击
        NSInteger i = [arr indexOfObject:model];
        if ([model.SortID isEqualToString:self.searchProductCategoryID]) {
            UIButton * btn = [self.headBtnArr objectAtIndex:i];
            btn.selected = YES;
            if (btn.frame.origin.x >= LZScreenWidth) {
                [scrollView scrollRectToVisible:btn.frame animated:YES];
            }
        }
        ///获取每个按钮对应线的长度
        CGFloat width = 0;
        if (i == 0) {
            width = [DZYTools getSizeWithString:@"全部" FontNum:14].width;
        }
        else
        {
            width = [DZYTools getSizeWithString:model.Name FontNum:14].width;
        }
        [self.lineWidthArr addObject:[NSNumber numberWithDouble:width]];
    }
    
    [self createHeadScrollViewLineWithScrollView:scrollView];
}

#pragma mark - 二级分类的点击事件
-(void)headScrollViewDidClick:(UIButton *)btn
{
    for (UIButton * btnData in self.headBtnArr) {
        if (btnData == btn) {
            btnData.selected = YES;
        }
        else
        {
            btnData.selected = NO;
        }
    }
    CGPoint center = btn.center;
    center.y = 38;
    ///改变大小的动画
    CGFloat width = [self.lineWidthArr[btn.tag] floatValue];
    CGRect bounds = self.headLine.layer.bounds;
    bounds.size.width = width;
    [UIView animateWithDuration:0.3 animations:^{
        self.headLine.layer.bounds= bounds;
    }];
    ///改变位置的动画
    CABasicAnimation * ani = [[CABasicAnimation alloc]init];
    ani.keyPath = @"position";
    ani.toValue = [NSValue valueWithCGPoint:center];
    ani.duration = 0.5;
    ani.removedOnCompletion = NO;
    ani.fillMode = kCAFillModeForwards;
    [self.headLine.layer addAnimation:ani forKey:nil];
    
    SortModel * model = self.fatherData[btn.tag];
    self.searchProductCategoryID = model.SortID;
    _keyStr = model.SortID;
    if ([self.changeViewButton.currentTitle isEqualToString:@"大图"])
    {
        self.refresh = NO;
        self.pageIndex = 1;
        [self loadDataFromWeb];
    }
    else if ([self.changeViewButton.currentTitle isEqualToString:@"列表"])
    {
        _collectionView.keyWords = model.SortID;
        _collectionView.viewType = _viewType;
        _collectionView.sorts = self.selectSort;
        _collectionView.isAsc = self.selectIsAcs;
        _collectionView.shopID = _ShopID;
        [_collectionView reloadData];
    }
    
}

///二级分类下滚动的线
-(void)createHeadScrollViewLineWithScrollView:(UIScrollView *)scrollView
{
    UIButton * resultBtn = nil;
    for (UIButton * btn in self.headBtnArr) {
        if (btn.selected == YES) {
            resultBtn = btn;
        }
    }
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [_lineWidthArr[resultBtn.tag] doubleValue], 1)];
    view.backgroundColor = MAIN_BLUE;
    [scrollView addSubview:view];
    view.center = CGPointMake(resultBtn.center.x, 38);
    self.headLine = view;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[AFAppAPIClient sharedClient] cancelAllHTTPOperationsWithMethod:@"GET" path:kWebSearchProductPath];
}

// 画线 (综合 销量 价格 中间的线)
- (void)drawLine {
    int width = roundf(SCREEN_WIDTH / 4.0f);
    for (int i=1; i<4; i++) {
        UIView *sepView = [[UIView alloc] initWithFrame:CGRectMake(i*width, 12, 0.5, 15)];
        sepView.backgroundColor = [UIColor colorWithWhite:0.815 alpha:1.000];
        [self.topView addSubview:sepView];
    }
}

#pragma mark - tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchResultCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SearchResultCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"SearchResultCell" owner:nil options:nil].lastObject;
    }
    cell.model = [self.arr objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    productID = [[self.arr objectAtIndex:indexPath.row] valueForKey:@"guid"];
    [self performSegueWithIdentifier:kSegueResultToDetail sender:self];
}

#pragma mark 点击3个button的数据请求 （综合 销量 评价）
-(void)loadSearchResultDataWithSortType:(NSString *)sortType andSortASC:(NSString *)isasc {
    
    NSString * keystr;
    if (self.searchText.length > 0) {
        _viewType = MerchandiseForSearch;
        self.searchProductCategoryID = @"-1";
        keystr = self.searchText;
        self.noResultLabel.text = @"该关键字无搜索结果";
    }else if (self.searchBrandGuid.length > 0) {
        _viewType = MerchandiseForBrand;
        keystr = self.searchBrandGuid;
        self.noResultLabel.text = @"该品牌无商品";
    }else if ([self.searchProductCategoryID integerValue] >= 0) {
        _viewType = MerchandiseForCategory;
        keystr = self.searchProductCategoryID;
        self.noResultLabel.text = @"该类别无商品";
    }
    
    //    NSLog(@"shopid ==  %d", self.ShopID);
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    if ([self.changeViewButton.currentTitle isEqualToString:@"大图"]) {
        [self.dataView bringSubviewToFront:self.tableView];
        self.selectSort = sortType;
        self.selectIsAcs = isasc;
        self.refresh = NO;
        self.pageIndex = 1;
        [self loadDataFromWeb];
    } else if ([self.changeViewButton.currentTitle isEqualToString:@"列表"]) {
        // 大图显示
//        if (_collectionView == nil) {
//            _collectionView = [[MerchandiseCollectionViewController alloc] init];
//            _collectionView.view.frame = self.dataView.bounds;;
//            _collectionView.collectionView.frame = _collectionView.view.bounds;
//            _collectionView.delegate = self;
//            [self.dataView addSubview:_collectionView.view];
//            self.bigView = _collectionView.view;
//        }
        [self.dataView bringSubviewToFront:self.bigView];
        _collectionView.keyWords = keystr;
        _collectionView.viewType = _viewType;
        _collectionView.sorts = sortType;
        _collectionView.isAsc = isasc;
        _collectionView.shopID = _ShopID;
        [_collectionView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///没有商品 的时候显示的图
-(void)noResultWarningWithType:(BOOL)type
{
    [self.noResultImage setHidden:type];
    [self.noResultLabel setHidden:type];
}

///大图时的点击 跳转事件
- (void)didSelectItemAtIndexModel:(MerchandiseIntroModel *)model {
    productID = model.guid;
    [self performSegueWithIdentifier:kSegueResultToDetail sender:self];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DZYMerchandiseDetailController * mdvc = [segue destinationViewController];
    if ([segue.identifier isEqualToString:kSegueResultToDetail]) {
        if ([mdvc respondsToSelector:@selector(setGuid:)]) {
            mdvc.Guid = productID;
        }
    }
}

- (IBAction)SortBtnClick:(id)sender {
    UIButton *btnSender = (UIButton *)sender;
    NSInteger selectTag = btnSender.tag;
    
    //改变button title颜色
    [self.SortTimeBtn setTitleColor:[UIColor colorWithWhite:0.391 alpha:1.000] forState:UIControlStateNormal];
    [self.SortPriceBtn setTitleColor :[UIColor colorWithWhite:0.391 alpha:1.000] forState:UIControlStateNormal];
    [self.SortVolumeBtn setTitleColor:[UIColor colorWithWhite:0.391 alpha:1.000] forState:UIControlStateNormal];
    
    self.SortPriceBtn.tag = 0; //价格
    self.SortTimeBtn.tag = 0;  //综合
    self.SortVolumeBtn.tag = 0; //销量
    
    if(btnSender == self.SortTimeBtn) {
        self.selectSort = @"ModifyTime";
        [self.SortTimeBtn setTitleColor: [UIColor barTitleColor] forState:UIControlStateNormal];
    }else if (btnSender == self.SortPriceBtn) {
        self.selectSort = @"Price";
        [self.SortPriceBtn setTitleColor: [UIColor barTitleColor] forState:UIControlStateNormal];
        
    }else if (btnSender == self.SortVolumeBtn) {
        self.selectSort = @"SaleNumber";
        [self.SortVolumeBtn setTitleColor: [UIColor barTitleColor] forState:UIControlStateNormal];
    }
    
    //默认 0 降序
    self.selectIsAcs = @"false";
    
    if(selectTag != 0) {
        if(selectTag == 2) {
            self.selectIsAcs = @"true";
            btnSender.tag = 1;
        }else{
            self.selectIsAcs = @"false";
            btnSender.tag = 2;
        }
    }else {
        btnSender.tag = 2;
    }
#pragma mark - 小箭头
    if ([btnSender isEqual:_SortTimeBtn]) {  //综合
        self.arrowOne.hidden = NO;
        self.arrowTwo.hidden = YES;
        self.arrowThree.hidden = YES;
        if ([self.selectIsAcs isEqualToString:@"false"]) {
            self.arrowOne.image = [UIImage imageNamed:@"down"];
        }
        else
        {
            self.arrowOne.image = [UIImage imageNamed:@"up"];
        }
    }
    else if ([btnSender isEqual:_SortVolumeBtn])//销量
    {
        self.arrowOne.hidden = YES;
        self.arrowTwo.hidden = NO;
        self.arrowThree.hidden = YES;
        if ([self.selectIsAcs isEqualToString:@"false"]) {
            self.arrowTwo.image = [UIImage imageNamed:@"down"];
        }
        else
        {
            self.arrowTwo.image = [UIImage imageNamed:@"up"];
        }
    }
    else if ([btnSender isEqual:_SortPriceBtn]) //价格
    {
        self.arrowOne.hidden = YES;
        self.arrowTwo.hidden = YES;
        self.arrowThree.hidden = NO;
        if ([self.selectIsAcs isEqualToString:@"false"]) {
            self.arrowThree.image = [UIImage imageNamed:@"down"];
        }
        else
        {
            self.arrowThree.image = [UIImage imageNamed:@"up"];
        }
    }
    
    [self loadSearchResultDataWithSortType:self.selectSort andSortASC:self.selectIsAcs];
}

// 切换显示方式 列表和大图
- (IBAction)changeDisplayType:(id)sender {
    UIButton *button = sender;
    NSString *buttonStr = button.titleLabel.text;
    if ([buttonStr isEqualToString:@"列表"]) {
        [button setTitle:@"大图" forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"pic"] forState:UIControlStateNormal];
    } else if ([buttonStr isEqualToString:@"大图"]) {
        [button setTitle:@"列表" forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"list"] forState:UIControlStateNormal];
    }
    [self loadSearchResultDataWithSortType:self.selectSort andSortASC:self.selectIsAcs];
}


@end