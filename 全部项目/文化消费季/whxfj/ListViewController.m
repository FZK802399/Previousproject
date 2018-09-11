//
//  ListViewController.m
//  whxfj
//
//  Created by 司马帅帅 on 14-8-23.
//  Copyright (c) 2014年 baobin. All rights reserved.
//

#import "ListViewController.h"
#import "ASIHTTPRequest.h"
#import "ListViewInfo.h"
#import "ListViewTableViewCell1.h"
#import "DetailViewController.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "SearchViewController.h"

#define IMAGEVIEW_WIDTH 320
#define IMAGEVIEW_HEIGHT 111

@interface ListViewController () <ASIHTTPRequestDelegate, UITableViewDataSource, UITableViewDelegate>
{
    ListViewType listViewType;
    UIImageView *adImageView;
    UITableView *listTableView;
    NSMutableArray *listViewInfoArray;
    NSString *catId;
    MBProgressHUD *HUD;
}
@end

@implementation ListViewController

- (id)initWith:(ListViewType)listViewType_
{
    self = [super init];
    if (self) {
        listViewInfoArray = [[NSMutableArray alloc] initWithCapacity:10];
        listViewType = listViewType_;
        switch (listViewType) {
            case LISTVIEWTYPE_WHC:
                self.title = @"文化潮";
                break;
            case LISTVIEWTYPE_HKB:
                self.title = @"惠快报";
                break;
            case LISTVIEWTYPE_HDH:
                self.title = @"活动汇";
                break;
            case LISTVIEWTYPE_ZHK:
                self.title = @"展会控";
                break;
            case LISTVIEWTYPE_QXX:
                self.title = @"区县行";
                break;
            case LISTVIEWTYPE_HFX:
                self.title = @"惠分享";
                break;
            default:
                break;
        }
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    switch (listViewType) {
        case LISTVIEWTYPE_WHC:
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"1_nav.png"] forBarMetrics:UIBarMetricsDefault];
            break;
        case LISTVIEWTYPE_HKB:
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"2_nav.png"] forBarMetrics:UIBarMetricsDefault];
            break;
        case LISTVIEWTYPE_HDH:
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"3_nav.png"] forBarMetrics:UIBarMetricsDefault];
            break;
        case LISTVIEWTYPE_ZHK:
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"4_nav.png"] forBarMetrics:UIBarMetricsDefault];
            break;
        case LISTVIEWTYPE_QXX:
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"5_nav.png"] forBarMetrics:UIBarMetricsDefault];
            break;
        case LISTVIEWTYPE_HFX:
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"6_nav.png"] forBarMetrics:UIBarMetricsDefault];
            break;
    
        default:
            break;
    }
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 50)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setText:self.title];
    self.navigationItem.titleView = titleLabel;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backButton setFrame:CGRectMake(0, 0, 30, 30)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateHighlighted];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchButton addTarget:self action:@selector(pushToSearchViewController) forControlEvents:UIControlEventTouchUpInside];
    [searchButton setFrame:CGRectMake(0, 0, 30, 30)];
    [searchButton setBackgroundImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
    [searchButton setBackgroundImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateHighlighted];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    //添加adImageView
    adImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, IMAGEVIEW_WIDTH, IMAGEVIEW_HEIGHT)];
    [self.view addSubview:adImageView];
    
    if (isIos7System) {
        listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(adImageView.frame), self.view.frame.size.width, self.view.frame.size.height-CGRectGetMaxY(adImageView.frame)-44-20) style:UITableViewStylePlain];
    } else {
        listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(adImageView.frame), self.view.frame.size.width, self.view.frame.size.height-CGRectGetMaxY(adImageView.frame)-44) style:UITableViewStylePlain];
    }
    listTableView.delegate = self;
    listTableView.dataSource = self;
    [self.view addSubview:listTableView];
    
    [self loadList];
}

- (void)loadList
{
    NSString *requestString;
    switch (listViewType) {
        case LISTVIEWTYPE_WHC:
            requestString = [NSString stringWithFormat:@"http://xfj.weittui.com/api.php?op=xfj_list&catid=9"];
            catId = @"9";
            break;
        case LISTVIEWTYPE_HKB:
            self.title = @"惠快报";
            requestString = [NSString stringWithFormat:@"http://xfj.weittui.com/api.php?op=xfj_list&catid=10"];
            catId = @"10";
            break;
        case LISTVIEWTYPE_HDH:
            self.title = @"活动汇";
            requestString = [NSString stringWithFormat:@"http://xfj.weittui.com/api.php?op=xfj_list&catid=12"];
            catId = @"12";
            break;
        case LISTVIEWTYPE_ZHK:
            self.title = @"展会控";
            requestString = [NSString stringWithFormat:@"http://xfj.weittui.com/api.php?op=xfj_list&catid=13"];
            catId = @"13";
            break;
        case LISTVIEWTYPE_QXX:
            self.title = @"区县行";
            requestString = [NSString stringWithFormat:@"http://xfj.weittui.com/api.php?op=xfj_list&catid=14"];
            catId = @"14";
            break;
        case LISTVIEWTYPE_HFX:
            self.title = @"惠分享";
            requestString = [NSString stringWithFormat:@"http://xfj.weittui.com/api.php?op=xfj_list&catid=11"];
            catId = @"11";
            break;
        default:
            break;
    }
    ASIHTTPRequest *asiListRequest = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:requestString]];
    [asiListRequest setDelegate:self];
    [asiListRequest startAsynchronous];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pushToSearchViewController;
{
    
    if ([self isConnectionAvailable]) {
        SearchViewController *searchViewController = [[SearchViewController alloc] init];
        searchViewController.title = self.title;
        searchViewController.catId = catId;
        [self.navigationController pushViewController:searchViewController animated:YES];
    } else {
        [self show:MBProgressHUDModeText message:@"当前网络不可用，不能进行搜索！" customView:nil];
        [self hiddenHUDShort];
    }
}

//判断网络连接是否正常
- (BOOL)isConnectionAvailable {
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            NSLog(@"网络状态 notReachable");
            isExistenceNetwork = NO;
            break;
        case ReachableViaWiFi:
            NSLog(@"网络状态 WIFI");
            isExistenceNetwork = YES;
            break;
        case ReachableViaWWAN:
            NSLog(@"网络状态 3G");
            isExistenceNetwork = YES;
            break;
    }
    return isExistenceNetwork;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark HUD
//展示HUD
- (void)show:(MBProgressHUDMode)mode_ message:(NSString *)message_ customView:(id)customView_
{
    HUD = [[MBProgressHUD alloc] initWithView:[[UIApplication sharedApplication] keyWindow]];
    [self.navigationController.view addSubview:HUD];
    HUD.mode = mode_;
    HUD.customView = customView_;
    HUD.animationType = MBProgressHUDAnimationZoom;
    HUD.labelText = message_;
    [HUD show:YES];
}

//隐藏HUD 时间短
- (void)hiddenHUDShort
{
    [HUD hide:YES afterDelay:0.5f];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listViewInfoArray.count;
}

- (UITableViewCell *)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    ListViewTableViewCell1 *cell = (ListViewTableViewCell1 *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ListViewTableViewCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier listViewType:listViewType];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    ListViewInfo *listViewInfo = listViewInfoArray[indexPath.row];
    [cell setSubviewsOfCellWithListViewInfo:listViewInfo];
    
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 145.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListViewInfo *listViewInfo = listViewInfoArray[indexPath.row];
    DetailViewController *detailViewController = [[DetailViewController alloc] init];
    detailViewController.webUrlString = [NSString stringWithFormat:@"http://xfj.weittui.com/api.php?op=xfj_showshare&catid=%@&cid=%@", catId, listViewInfo.webId];
    detailViewController.titleString = listViewInfo.title;
    detailViewController.title = self.title;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark ASIHTTPRequestDelegate
- (void)requestStarted:(ASIHTTPRequest *)request
{
    NSLog(@"开始请求");
    [self show:MBProgressHUDModeIndeterminate message:nil customView:nil];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [self hiddenHUDShort];
    NSError *error = nil;
    NSDictionary *dic = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingAllowFragments error:&error];
    NSLog(@"dic %@", dic);
    NSDictionary *adDic = [dic objectForKey:@"ad"];
    NSString *adImagString = [adDic objectForKey:@"adImag"];
    NSString *adUrlString = [adDic objectForKey:@"adUrl"];
    [self performSelectorInBackground:@selector(setImageViewWith:) withObject:adImagString];
    NSArray *listArray = [dic objectForKey:@"listData"];
    for (NSDictionary *listDictionary in listArray) {
        ListViewInfo *listViewInfo = [[ListViewInfo alloc] initWithDictionary:listDictionary];
        [listViewInfoArray addObject:listViewInfo];
    }
    [listTableView reloadData];
}

//设置广告图片
- (void)setImageViewWith:(NSString *)adImagString
{
    [adImageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:adImagString]]]];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self hiddenHUDShort];
}

@end
