//
//  MyListViewController.m
//  旅拍1.0
//
//  Created by 司马帅帅 on 15/7/7.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import "MyListViewController.h"
#import "Header.h"
#import "AFNetworking.h"
#import "WebInfo.h"
#import "MyListCell.h"
#import "WebViewController.h"

@interface MyListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_webInfoArray;
}
@end

@implementation MyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的旅拍";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //设置navigationbar
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
    _tableView.separatorColor = [UIColor redColor];
    [self.view addSubview:_tableView];
}

//加载数据
- (void)loadData
{
    if (!_webInfoArray) {
        _webInfoArray = [[NSMutableArray alloc] init];
    }
    NSString *urlString = [NSString stringWithFormat:@"%@%@",LocalWebSite,Request_Mylist];
    NSString *userId = [USER_DEFAULT objectForKey:@"UserId"];
    
    NSDictionary *dictionary = @{@"userId":userId,@"lastdatetime":@"000000"};
    //初始化一个请求（同时也创建了一个线程）
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //设置请求可以接受的内容的样式
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //发送POST请求
    [manager POST:urlString parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        for (NSDictionary *dictionary in responseObject) {
            WebInfo *webInfo = [[WebInfo alloc] initWithDictionary:dictionary];
            [_webInfoArray addObject:webInfo];
        }
        
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}

//设置navigationbar
- (void)setNavigationBar
{
    //设置navigationbar的title颜色
    NSDictionary *dictionary = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self.navigationController.navigationBar setTitleTextAttributes:dictionary];
    
    //设置navigationBar背景图片
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"lp_nav_purple.png"] forBarMetrics:UIBarMetricsDefault];
    
    //添加返回按钮
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"lp_nav_goback.png"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    //设置navigationbar上的按钮颜色
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

//返回
- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _webInfoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    MyListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[MyListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    WebInfo *webInfo = _webInfoArray[indexPath.row];
    [cell setContentView:webInfo];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MyListCell getCellHeight];
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WebInfo *webInfo = _webInfoArray[indexPath.row];
    WebViewController *webViewController = [[WebViewController alloc] initWithWebInfo:webInfo webViewType:WEBVIEW_TYPE_LIST];
    [self.navigationController pushViewController:webViewController animated:YES];
}

@end






