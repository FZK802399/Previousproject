//
//  CategoryListViewController.m
//  美丽中国
//
//  Created by 司马帅帅 on 15/7/25.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import "CategoryListViewController.h"
#import "CategoryInfo.h"
#import "PanoInfo.h"
#import "AFNetworking.h"
#import "Header.h"
#import "MBProgressHUD.h"
#import "SortListViewCell.h"
#import "PanoDetailViewController.h"

@interface CategoryListViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    CategoryInfo *_categoryInfo;
    MBProgressHUD *_HUD;
    NSMutableArray *_panoInfoArray;
    UITableView *_tableView;
}
@end

@implementation CategoryListViewController

- (id)initWithCategoryInfo:(CategoryInfo *)categoryInfo
{
    self = [super init];
    if (self) {
        _categoryInfo = categoryInfo;
        self.title = _categoryInfo.categoryName;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设置导航栏
    [self setNavigationBar];
    
    //添加_tableView
    [self addTableView];
    
    //加载数据
    [self loadData];
}

//添加_tableView
- (void)addTableView
{
    CGRect frame = self.view.frame;
    frame.size.height = frame.size.height-44-20;
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

//设置导航栏
- (void)setNavigationBar
{
    //设置返回按钮
    UIImage *backImageNormal = [UIImage imageNamed:@"nav_back_button_normal.png"];
    UIImage *backImageHighlight = [UIImage imageNamed:@"nav_back_button_highlight.png"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(15.0f, 5.0f, backImageNormal.size.width/1.8, backImageNormal.size.height/1.8);
    [backButton setBackgroundImage:backImageNormal forState:UIControlStateNormal];
    [backButton setBackgroundImage:backImageHighlight forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backBarButton;
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

//加载数据
- (void)loadData
{
    //显示提示
    [self show:MBProgressHUDModeIndeterminate message:@"努力加载中......" customView:self.view];
    
    //AFNetworking 发送GET请求
    NSString *urlString = [NSString stringWithFormat:@"%@%@",LOCAL_HOST,CATEGORY_SUB_LIST_REQUEST];
    NSLog(@"urlsting %@",urlString);
    NSString *userId = [USER_DEFAULT objectForKey:@"UserId"];
    NSDictionary *dictionary = @{@"appKey":APPKEY,@"userId":userId,@"id":_categoryInfo.categoryId};
    //初始化请求（同时也创建了一个线程）
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //设置请求可以接受的内容的样式
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //发送POST请求
    [manager POST:urlString parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"请求成功 %@",responseObject);
        
        //初始化_panoInfoArray
        if (!_panoInfoArray) {
            _panoInfoArray = [[NSMutableArray alloc] init];
        }
        NSArray *array = (NSArray *)responseObject;
        for (NSDictionary *dictionary in array) {
            PanoInfo *panoInfo = [[PanoInfo alloc] initWithDictionary:dictionary];
            [_panoInfoArray addObject:panoInfo];
        }
        
        //刷新_tableView
        [_tableView reloadData];
        //隐藏HUD
        [self hideHUDafterDelay:0.3f];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败 %@",error);
        //隐藏HUD
        [self hideHUDafterDelay:0.3f];
    }];
}

#pragma mark HUD
//展示HUD
-(void) show:(MBProgressHUDMode )_mode message:(NSString *)_message customView:(id)_customView
{
    _HUD = [[MBProgressHUD alloc] initWithView:[[UIApplication sharedApplication] keyWindow]];
    [_customView addSubview:_HUD];
    _HUD.mode=_mode;
    _HUD.customView = _customView;
    _HUD.animationType = MBProgressHUDAnimationZoom;
    _HUD.labelText = _message;
    [_HUD show:YES];
}

//隐藏HUD
- (void)hideHUDafterDelay:(CGFloat)delay
{
    [_HUD hide:YES afterDelay:delay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _panoInfoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    SortListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[SortListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    PanoInfo *panoInfo = _panoInfoArray[indexPath.row];
    [cell setContentView:panoInfo];
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [SortListViewCell getCellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PanoInfo *panoInfo = _panoInfoArray[indexPath.row];
    PanoDetailViewController *panoDetailViewController = [[PanoDetailViewController alloc] initWithPanoInfo:panoInfo];
    [self.navigationController pushViewController:panoDetailViewController animated:YES];
}

@end



