//
//  CategoryViewController.m
//  美丽中国
//
//  Created by 司马帅帅 on 15/7/19.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import "CategoryViewController.h"
#import "Header.h"
#import "UIUtils.h"
#import "AFNetworking.h"
#import "CategoryInfo.h"
#import "SortViewCell.h"
#import "MBProgressHUD.h"
#import "CategoryListViewController.h"
#import "ViewController.h"

static NSString *cellIdentifier = @"cellIdentifier";

@interface CategoryViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *_categoryInfoArray;//承载CategoryInfo对象
    UICollectionView *_collectionView;//集合视图
    MBProgressHUD *_HUD;//提示
}
@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置背景颜色
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundImage.png"]]];
    
    //添加内容视图
    [self addContentView];
    
    //加载数据
    [self loadData];
}

//添加内容视图
- (void)addContentView
{
    if (!_collectionView) {
        CGRect collectionFrame = self.view.frame;
        collectionFrame.size.height = collectionFrame.size.height-44-20-44;
        _collectionView = [[UICollectionView alloc] initWithFrame:collectionFrame collectionViewLayout:[UICollectionViewFlowLayout new]];
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        [_collectionView registerClass:[SortViewCell class] forCellWithReuseIdentifier:cellIdentifier];
        //设置代理
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    [self.view addSubview:_collectionView];
    
    //添加上方的logo图片
    UIImage *headerLogoImage = [UIImage imageNamed:@"header_logo.png"];
    UIImageView *headerLogoImageView = [[UIImageView alloc] initWithImage:headerLogoImage];
    headerLogoImageView.frame = CGRectMake(([UIUtils getWindowWidth]-headerLogoImage.size.width/2)/2, -headerLogoImage.size.height/2-10, headerLogoImage.size.width/2, headerLogoImage.size.height/2);
    [_collectionView addSubview:headerLogoImageView];
    
}

//加载数据
- (void)loadData
{
    //显示提示
    [self show:MBProgressHUDModeIndeterminate message:@"努力加载中......" customView:self.view];
    
    //AFNetworking 发送GET请求
    NSString *urlString = [NSString stringWithFormat:@"%@%@",LOCAL_HOST,CATEGORY_LIST_REQUEST];
     NSDictionary *dictionary = @{@"appKey":APPKEY};
    //初始化请求（同时也创建了一个线程）
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //设置请求可以接受的内容的样式
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //发送POST请求
    [manager POST:urlString parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"请求成功 %@",responseObject);
        
        //初始化_categoryInfoArray
        if (!_categoryInfoArray) {
            _categoryInfoArray = [[NSMutableArray alloc] init];
        }
        NSArray *array = (NSArray *)responseObject;
        for (NSDictionary *dictionary in array) {
            CategoryInfo *categoryInfo = [[CategoryInfo alloc] initWithDictionay:dictionary];
            [_categoryInfoArray addObject:categoryInfo];
        }
        //刷新_collectionView
        [_collectionView reloadData];
        
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

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _categoryInfoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SortViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    CategoryInfo *categoryInfo = _categoryInfoArray[indexPath.row];
    [cell setContentView:categoryInfo];
    
    return cell;
}

#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(([UIUtils getWindowWidth]-10*4)/3, ([UIUtils getWindowWidth]-10*4)/3);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    return edgeInsets;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryInfo *categoryInfo = _categoryInfoArray[indexPath.row];
    CategoryListViewController *categoryListViewController = [[CategoryListViewController alloc] initWithCategoryInfo:categoryInfo];
    [_viewController.navigationController pushViewController:categoryListViewController animated:YES];
}


@end
