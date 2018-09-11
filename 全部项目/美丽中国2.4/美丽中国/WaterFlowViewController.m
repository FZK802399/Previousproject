//
//  WaterFlowViewController.m
//  美丽中国
//
//  Created by 司马帅帅 on 15/7/19.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import "WaterFlowViewController.h"
#import "UIUtils.h"
#import "Header.h"
#import "AFNetworking.h"
#import "CityInfo.h"
#import "ZWCollectionViewFlowLayout.h"
#import "WaterFlowViewCell.h"
#import "MBProgressHUD.h"
#import "CityListViewController.h"
#import "ViewController.h"

static NSString *cellIdentifier = @"cellIdentifier";

@interface WaterFlowViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,ZWwaterFlowDelegate>
{
    NSMutableArray *_cityInfoArray;//承载CityInfo对象的数组
    NSMutableArray *_heightArray;//承载cell高度的数组
    UICollectionView *_collectionView;//集合视图
    ZWCollectionViewFlowLayout *_flowLayout;//布局
    MBProgressHUD *_HUD;//提示
}
@end

@implementation WaterFlowViewController

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
    
    //初始化自定义布局
    _flowLayout = [[ZWCollectionViewFlowLayout alloc] init];
    _flowLayout.itemCount = 33;
    _flowLayout.degelate = self;
    
    CGRect collectionFrame = self.view.frame;
    collectionFrame.size.height = collectionFrame.size.height-44-20-44;
    //初始化_collectionView
    _collectionView = [[UICollectionView alloc] initWithFrame:collectionFrame collectionViewLayout:_flowLayout];
    //注册显示的cell的类型
    [_collectionView registerClass:[WaterFlowViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    [_collectionView setBackgroundColor:[UIColor clearColor]];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
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
    NSString *urlString = [NSString stringWithFormat:@"%@%@",LOCAL_HOST,CiTY_LIST_REQUEST];
    //初始化请求（同时也创建了一个线程）
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //设置请求可以接受的内容的样式
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //发送GET请求
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"请求成功 %@",responseObject);
        //初始化_cityInfoArray
        if (!_cityInfoArray) {
            _cityInfoArray = [[NSMutableArray alloc] init];
        }
        NSArray *array = (NSArray *)responseObject;
        for (NSDictionary *dictionary in array) {
            CityInfo *cityInfo = [[CityInfo alloc] initWithDictionary:dictionary];
            [_cityInfoArray addObject:cityInfo];
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
    _HUD = [[MBProgressHUD alloc] initWithView:_customView];
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
    return _cityInfoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WaterFlowViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    CityInfo *cityInfo = _cityInfoArray[indexPath.item];
    [cell setContentView:cityInfo];
    return cell;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击 %ld",(long)indexPath.item);
    CityInfo *cityInfo = _cityInfoArray[indexPath.item];
    CityListViewController *cityListVC = [[CityListViewController alloc] initWithCityInfo:cityInfo];
    [self.viewController.navigationController pushViewController:cityListVC animated:YES];
}

#pragma mark ZWwaterFlowDelegate
- (CGFloat)ZWwaterFlow:(ZWCollectionViewFlowLayout *)waterFlow heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPach
{
    CityInfo *cityInfo = _cityInfoArray[indexPach.item];
    int height = cityInfo.height;
    return height;
}

@end
