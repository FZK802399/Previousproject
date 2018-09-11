//
//  LocalDraftViewController.m
//  旅拍1.0
//
//  Created by 司马帅帅 on 15/7/7.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import "LocalDraftViewController.h"
#import "FMDB.h"
#import "FMDBTool.h"
#import "DraftInfo.h"
#import "UIUtils.h"
#import "DraftViewController.h"
#import "Header.h"

#define Table_Name @"draft_table"

@interface LocalDraftViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
    FMDatabase *_db;
    NSMutableArray *_draftInfoArray;
}
@end

@implementation LocalDraftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"本地草稿";
    [self.navigationController.view setBackgroundColor:LIGHT_PURPLE_COLOR];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //设置navigationbar
    [self setNavigationBar];
    
    //添加_tableView
    [self addTableView];
    
    //加载数据
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

//添加_tableView
- (void)addTableView
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor redColor];
    [self.view addSubview:_tableView];
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

//加载数据
- (void)loadData
{
    if (!_draftInfoArray) {
        _draftInfoArray = [[NSMutableArray alloc] init];
    }
    if (!_db) {
        _db = [FMDBTool createDataBase];
    }
    if ([_db open]) {
        NSString *sqlString = [NSString stringWithFormat:@"select * from %@;",Table_Name];
        FMResultSet *rs = [_db executeQuery:sqlString];
        while (rs.next) {
            int draftId = [rs intForColumn:@"id"];
            NSString *title = [rs stringForColumn:@"title"];
            int imageCount = [rs intForColumn:@"imagecount"];
            NSString *textString = [rs stringForColumn:@"textarray"];
            NSString *dateLine = [rs stringForColumn:@"dateline"];
            
            //初始化DraftInfo对象
            DraftInfo *draftInfo = [[DraftInfo alloc] init];
            draftInfo.draftId = draftId;
            draftInfo.title = title;
            draftInfo.imageCount = imageCount;
            NSData *data = [textString dataUsingEncoding:NSUTF8StringEncoding];
            draftInfo.textArray = (NSArray *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            draftInfo.dateLine = dateLine;
            [_draftInfoArray addObject:draftInfo];
            [_tableView reloadData];
        }
    }
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
    return _draftInfoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    DraftInfo *draftInfo = _draftInfoArray[indexPath.row];
    if ([UIUtils isBlankString:draftInfo.title]) {
        [cell.textLabel setText:@"[无标题]"];
    } else {
        [cell.textLabel setText:draftInfo.title];
    }
    [cell.detailTextLabel setText:draftInfo.dateLine];
    
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DraftInfo *draftInfo = _draftInfoArray[indexPath.row];
    DraftViewController *draftViewController = [[DraftViewController alloc] initWithDraftInfo:draftInfo];
    [self.navigationController pushViewController:draftViewController animated:YES];
}

@end



