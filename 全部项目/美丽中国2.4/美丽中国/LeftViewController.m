//
//  LeftViewController.m
//  美丽中国
//
//  Created by 司马帅帅 on 15/7/19.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import "LeftViewController.h"
#import "UIUtils.h"
#import "SideBarMenuViewController.h"
#import "ViewController.h"
#import "FansViewController.h"
#import "UserViewController.h"
#import "SetViewController.h"
#import "LeftViewCell.h"

@interface LeftViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_cellInfoArray;
    UINavigationController *_navViewController;
    UINavigationController *_navFansViewController;
    UINavigationController *_navUserViewController;
    UINavigationController *_navSetViewController;
}
@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设定背景颜色
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"guideservicebackground.png"]];
    
    //加载数据
    [self loadData];
    
    //添加tableview
    [self addTableView];
}

//添加tableview
- (void)addTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, [UIUtils getWindowWidth], [UIUtils getWindowHeight]) style:UITableViewStylePlain];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
    
    //默认_tableView的第一行被选中
    NSIndexPath *selectedIndexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    [_tableView selectRowAtIndexPath:selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];

    //初始化fooderView
    UIImage *footerImage = [UIImage imageNamed:@"fooder_logo.png"];
    UIImageView *footerImageView = [[UIImageView alloc] initWithImage:footerImage];
    footerImageView.frame = CGRectMake(([UIUtils getWindowWidth]-40-footerImage.size.width*0.5)/2, 200+([UIUtils getWindowHeight]-220-footerImage.size.height*0.5)/2, footerImage.size.width*0.5, footerImage.size.height*0.5);
    [_tableView addSubview:footerImageView];
}

//加载数据
- (void)loadData
{
    _cellInfoArray = @[
                       @{@"image":[UIImage imageNamed:@"public_icon.png"],
                         @"text":@"全景主页"},
                       @{@"image":[UIImage imageNamed:@"follow_icon.png"],
                         @"text":@"粉丝列表"},
                       @{@"image":[UIImage imageNamed:@"indiv_icon.png"],
                         @"text":@"个人主页"},
                       @{@"image":[UIImage imageNamed:@"option_icon.png"],
                         @"text":@"设置"},
                       @{@"image":[UIImage imageNamed:@"evaluate_icon.png"],
                         @"text":@"感谢好评"},
                       ];
}

//展示相应的controller
- (void)showViewControllerWithIndex:(int)index
{
    switch (index) {
        case 0:
        {
            if (!_navViewController) {
                ViewController *viewController = [[ViewController alloc] init];
                _navViewController = [[UINavigationController alloc] initWithRootViewController:viewController];
            }
            [_sideBarMenuVC setRootViewController:_navViewController animated:YES];
        }
            break;
        case 1:
        {
            if (!_navFansViewController) {
                FansViewController *fansViewController = [[FansViewController alloc] init];
                _navFansViewController = [[UINavigationController alloc] initWithRootViewController:fansViewController];
            }
            [_sideBarMenuVC setRootViewController:_navFansViewController animated:YES];
        }
            break;
        case 2:
        {
            if (!_navUserViewController) {
                UserViewController *userViewController = [[UserViewController alloc] init];
                _navUserViewController = [[UINavigationController alloc] initWithRootViewController:userViewController];
            }
            [_sideBarMenuVC setRootViewController:_navUserViewController animated:YES];
        }
            break;
        case 3:
        {
            if (!_navSetViewController) {
                SetViewController *setViewController = [[SetViewController alloc] init];
                _navSetViewController = [[UINavigationController alloc] initWithRootViewController:setViewController];
            }
            [_sideBarMenuVC setRootViewController:_navSetViewController animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cellInfoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    LeftViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[LeftViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSDictionary *cellInfo = _cellInfoArray[indexPath.row];
    [cell setContentView:cellInfo];
    
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //展示相应的controller
    [self showViewControllerWithIndex:(int)indexPath.row];
}

@end
