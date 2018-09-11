//
//  SetViewController.m
//  旅拍1.0
//
//  Created by 司马帅帅 on 15/7/7.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import "SetViewController.h"

@interface SetViewController ()

@end

@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"个人设置";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //设置navigationbar
    [self setNavigationBar];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
