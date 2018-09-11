//
//  SearchViewController.m
//  whxfj
//
//  Created by 司马帅帅 on 14-8-25.
//  Copyright (c) 2014年 baobin. All rights reserved.
//

#import "SearchViewController.h"
#import "ASIHTTPRequest.h"
#import "ListViewInfo.h"
#import "ListViewTableViewCell1.h"
#import "DetailViewController.h"
#import "MBProgressHUD.h"

@interface SearchViewController () <UISearchBarDelegate, ASIHTTPRequestDelegate, UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *listViewInfoArray;
    UITableView *searchListViewInfoTableView;
    UISearchBar *searchBar;
    MBProgressHUD *HUD;
}
@end

@implementation SearchViewController


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
    // Do any additional setup after loading the view.
    self.title = [NSString stringWithFormat:@"搜索%@",self.title];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
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
    [searchButton addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    [searchButton setFrame:CGRectMake(0, 0, 30, 30)];
    [searchButton setBackgroundImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
    [searchButton setBackgroundImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateHighlighted];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    //添加searchBar
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    searchBar.delegate = self;
    if (![searchBar respondsToSelector:@selector(barTintColor)]) {
        UIView *subView = [searchBar.subviews objectAtIndex:0];
        [subView removeFromSuperview];
    }
    searchBar.backgroundColor = [UIColor lightGrayColor];
    searchBar.placeholder = @"请输入旅拍标题关键字";
    searchBar.keyboardType = UIKeyboardTypeNamePhonePad;
    [searchBar becomeFirstResponder];
    [self.view addSubview:searchBar];
    
    //添加searchListViewInfoTableView
    if (isIos7System) {
        searchListViewInfoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height-44-40-20) style:UITableViewStylePlain];
    } else {
        searchListViewInfoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height-44-40) style:UITableViewStylePlain];
    }
    searchListViewInfoTableView.separatorColor = [UIColor purpleColor];
    searchListViewInfoTableView.delegate = self;
    searchListViewInfoTableView.dataSource = self;
    [self.view addSubview:searchListViewInfoTableView];
}

//返回
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

//搜索
- (void)search
{
    if ([self isBlankString:searchBar.text]) {
        [self show:MBProgressHUDModeText message:@"搜索内容不能为空" customView:nil];
        [self hiddenHUDWithMessage:@"搜索内容不能为空"];
    }else {
        [self searchRequest];
    }
    [searchBar resignFirstResponder];
}

- (void)searchRequest
{
    NSLog(@"请求");
    NSString *requestString = [NSString stringWithFormat:@"http://xfj.weittui.com/api.php?op=xfj_listsearch&catid=%@&keyword=%@",self.catId,searchBar.text];

    NSString * encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)requestString, NULL, NULL,  kCFStringEncodingUTF8 ));
    
    ASIHTTPRequest *asiListRequest = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:encodedString]];
    [asiListRequest setDelegate:self];
    [asiListRequest startAsynchronous];
}

//判断一个字符串是否为空 或者 只含有空格
- (BOOL)isBlankString:(NSString *)string
{
    if (string == nil) {
        return YES;
    }
    if (string == NULL) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        return YES;
    }
    return NO;
}

#pragma Mark HUD
//展示 风火轮HUD
- (void)showActivityHUD
{
    [self show:MBProgressHUDModeIndeterminate message:@"努力搜索中..." customView:nil];
}

//显示HUD
- (void)show:(MBProgressHUDMode)_mode message:(NSString *)_message customView:(id)_customView
{
    HUD = [[MBProgressHUD alloc] initWithView:[[UIApplication sharedApplication] keyWindow]];
    [self.view addSubview:HUD];
    HUD.mode = _mode;
    HUD.customView = _customView;
    HUD.animationType = MBProgressHUDAnimationZoom;
    HUD.labelText = _message;
    [HUD show:YES];
}

//隐藏HUD
- (void)hiddenHUD
{
    [HUD hide:YES afterDelay:0.5f];
}

//隐藏HUD并给以文字提示
- (void)hiddenHUDWithMessage:(NSString *)message
{
    HUD.mode = MBProgressHUDModeText;
    HUD.labelText = message;
    [HUD hide:YES afterDelay:1.5f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self search];
}

#pragma mark ASIHTTPRequestDelegate
- (void)requestStarted:(ASIHTTPRequest *)request
{
    NSLog(@"请求开始");
    [self showActivityHUD];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"请求结束 %@", [request responseString]);
    listViewInfoArray = [[NSMutableArray alloc] initWithCapacity:20];
    NSError *error = nil;
    NSDictionary *dic = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingAllowFragments error:&error];
    NSArray *listArray = [dic objectForKey:@"listData"];
    if (listArray.count != 0) {
        for (NSDictionary *dictionary in listArray) {
            NSLog(@"diction %@", dictionary);
            ListViewInfo *listViewInfo = [[ListViewInfo alloc] initWithDictionary:dictionary];
//            NSLog(@"web %@",webListInfo.webTitle);
            [listViewInfoArray addObject:listViewInfo];
        }
        [self hiddenHUD];
    } else {
        NSLog(@"没有搜索内容");
        [self hiddenHUDWithMessage:@"您搜索的旅拍不存在"];
    }
    [searchListViewInfoTableView reloadData];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"请求失败");
    [self hiddenHUD];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"count %d", listViewInfoArray.count);
    return listViewInfoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    ListViewTableViewCell1 *cell = (ListViewTableViewCell1 *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ListViewTableViewCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    ListViewInfo *listViewInfo = listViewInfoArray[indexPath.row];
    [cell setSubviewsOfCellWithListViewInfo:listViewInfo];
    
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListViewInfo *listViewInfo = listViewInfoArray[indexPath.row];
    DetailViewController *detailViewController = [[DetailViewController alloc] init];
    detailViewController.webUrlString = [NSString stringWithFormat:@"http://xfj.weittui.com/api.php?op=xfj_showshare&catid=%@&cid=%@", self.catId, listViewInfo.webId];
    detailViewController.titleString = listViewInfo.title;
    detailViewController.title = self.title;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 145.0f;
}

@end
