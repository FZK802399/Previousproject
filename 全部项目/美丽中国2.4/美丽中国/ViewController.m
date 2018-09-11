//
//  ViewController.m
//  美丽中国
//
//  Created by 司马帅帅 on 15/7/19.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import "ViewController.h"
#import "WaterFlowViewController.h"
#import "CategoryViewController.h"
#import "GuideViewController.h"
#import "SwitchBottomView.h"
#import "UIUtils.h"

@interface ViewController ()<SBVDelegate>
{
    WaterFlowViewController *_waterFlowVC;
    CategoryViewController *_categoryVC;
    GuideViewController *_guideVC;
    SwitchBottomView *_switchBottomView;
    
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //把状态栏设置为白色
    [self setStatusBarColor];
    //设定导航栏
    [self setNavigationBar];
    //添加选择按钮
    [self addSwitchBottomView];
    //瀑布流按钮被点击
    [self sbvWaterFlowButtonPress];
    
}

//把状态栏设置为白色
- (void)setStatusBarColor
{
    //设置状态栏为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

//设定导航栏
- (void)setNavigationBar
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation_bar_background_image.png"] forBarMetrics:UIBarMetricsDefault];
    //设置navigationbar的title颜色
    NSDictionary *dictionary = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self.navigationController.navigationBar setTitleTextAttributes:dictionary];
}

//添加选择按钮
- (void)addSwitchBottomView
{
    _switchBottomView = [[SwitchBottomView alloc] initWithFrame:CGRectMake(0, [UIUtils getWindowHeight]-44-44-20, [UIUtils getWindowWidth], 44)];
    _switchBottomView.delegate = self;
    [self.view addSubview:_switchBottomView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark SBVDelegate
- (void)sbvGuideButtonPress
{
    self.title = @"导游服务";
    if (!_guideVC) {
        _guideVC = [[GuideViewController alloc] init];
        _guideVC.viewController = self;
        [_guideVC.view setFrame:CGRectMake(0, 0, [UIUtils getWindowWidth], [UIUtils getWindowHeight]-44-44-20)];
    }
    if (_categoryVC.view.superview) {
        [_categoryVC.view removeFromSuperview];
    }
    if (_waterFlowVC.view.superview) {
        [_waterFlowVC.view removeFromSuperview];
    }
    if (!_guideVC.view.superview) {
        [self.view insertSubview:_guideVC.view atIndex:0];
    }

}
- (void)sbvCategoryButtonPress
{
    self.title = @"特色分类";
    if (!_categoryVC) {
        _categoryVC = [[CategoryViewController alloc] init];
        _categoryVC.viewController = self;
        [_categoryVC.view setFrame:CGRectMake(0, 0, [UIUtils getWindowWidth], [UIUtils getWindowHeight]-44-44-20)];
    }
    if (!_categoryVC.view.superview) {
        [self.view addSubview: _categoryVC.view];
        [self.view insertSubview:_categoryVC.view atIndex:0];
    }
    if (_waterFlowVC.view.superview) {
        [_waterFlowVC.view removeFromSuperview];
    }
    if (_guideVC.view.superview) {
        [_guideVC.view removeFromSuperview];
    }
}
- (void)sbvWaterFlowButtonPress
{
    self.title = @"城市列表";
    if (!_waterFlowVC) {
        _waterFlowVC = [[WaterFlowViewController alloc] init];
        _waterFlowVC.viewController = self;
        [_waterFlowVC.view setFrame:CGRectMake(0, 0, [UIUtils getWindowWidth], [UIUtils getWindowHeight]-44)];
    }
    if (_categoryVC.view.superview) {
        [_categoryVC.view removeFromSuperview];
    }
    if (!_waterFlowVC.view.superview) {
        [self.view insertSubview:_waterFlowVC.view atIndex:0];
    }
    if (_guideVC.view.superview) {
        [_guideVC.view removeFromSuperview];
    }
}

@end
