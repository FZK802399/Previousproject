//
//  CityListViewController.m
//  美丽中国
//
//  Created by 司马帅帅 on 15/7/21.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import "CityListViewController.h"
#import "Header.h"
#import "UIUtils.h"
#import "AFNetworking.h"
#import "CityInfo.h"
#import "PanoInfo.h"
#import "CityListCell.h"
#import "SWSnapshotStackView.h"
#import "MBProgressHUD.h"
#import "PanoDetailViewController.h"

//文字颜色
#define TEXT_COLOR [UIColor colorWithPatternImage:[UIImage imageNamed:@"dot.png"]]

@interface CityListViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *_panoInfoArray;//承载PanoInfo的数组
    UITableView *_tableView;
    CityInfo *_cityInfo;//城市对象
    MBProgressHUD *_HUD;
}
@end

@implementation CityListViewController

- (id)initWithCityInfo:(CityInfo*)cityInfo
{
    self = [super init];
    if (self) {
        _cityInfo = cityInfo;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundImage.png"]]];
    self.title = _cityInfo.cityName;
    
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
    //添加顶部图片视图
    //计算图片的高度
    float height = (double)200/320*[UIUtils getWindowWidth];
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIUtils getWindowWidth], height)];
    [headerImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",_cityInfo.cityName]]];
    [self.view addSubview:headerImageView];
    
    //初始化headView
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIUtils getWindowWidth], height)];
    headView.backgroundColor = [UIColor clearColor];
    
    //添加headView底部的视图
    UIView *headBottomView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetHeight(headView.frame)-30.0f, [UIUtils getWindowWidth], 30.0f)];
    headBottomView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundImage.png"]];
    [headView addSubview:headBottomView];
    
    //添加城市的Icon视图 用了第三方类SWSnapshotStackView给图片加了效果
    SWSnapshotStackView *cityIconView = [[SWSnapshotStackView alloc] initWithFrame:CGRectMake(14.0f, height - 60.0f, 70.0f, 70.0f)];
    cityIconView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_icon.png",_cityInfo.cityName]];
    cityIconView.displayAsStack = NO;
    [headView addSubview:cityIconView];
    
    //景区个数的标签
    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cityIconView.frame)+5, height-30.0f, 200.0f, 30.0f)];
    [countLabel setBackgroundColor:[UIColor clearColor]];
    countLabel.textColor = TEXT_COLOR;
    countLabel.font = [UIFont systemFontOfSize:15.0f];
    [countLabel setText:[NSString stringWithFormat:@"%@个景点",_cityInfo.panoCount]];
    [headView addSubview:countLabel];
    
    CGRect frame = self.view.frame;
    frame.size.height = frame.size.height-44-20;
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //设置背景颜色
    [_tableView setBackgroundColor:[UIColor clearColor]];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    //设置_tableView的tableHeaderView
    _tableView.tableHeaderView = headView;
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
    
    //用户id
    NSString *userID = [USER_DEFAULT objectForKey:@"UserId"];
    //省份名称
    NSString *province = _cityInfo.cityName;

    //AFNetworking 发送GET请求
    NSString *urlString = [NSString stringWithFormat:@"%@%@",LOCAL_HOST,CITY_PANO_LIST_REQUEST];
    //请求参数
    NSDictionary *parameters = @{@"appKey":APPKEY,@"userId":userID,@"province":province,@"sign":@"1"};
    //初始化请求（同时也创建了一个线程）
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //设置请求可以接受的内容的样式
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //发送GET请求
    [manager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"请求成功 %@",responseObject);
        
        //初始化_panoInfoArray
        if (!_panoInfoArray) {
            _panoInfoArray = [[NSMutableArray alloc] init];
        }

        NSArray *array = (NSArray *)responseObject;
        for (NSDictionary *dictionary in array) {
            PanoInfo *panoInfo = [[PanoInfo alloc] initWithDictionary:dictionary];
            NSLog(@"asdfasf %@ %@",panoInfo.name,panoInfo.address);
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
    CityListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[CityListCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    PanoInfo *panoInfo = _panoInfoArray[indexPath.row];
    [cell setContentView:panoInfo];
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PanoInfo *panoInfo = _panoInfoArray[indexPath.row];
    PanoDetailViewController *panoDetailVC = [[PanoDetailViewController alloc] initWithPanoInfo:panoInfo];
    [self.navigationController pushViewController:panoDetailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [CityListCell getHeight];
}

@end
