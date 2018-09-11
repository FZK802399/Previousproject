//
//  BaseViewController.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-12.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "BaseViewController.h"
#import "Model/ShopCartMerchandiseModel.h"
#import "Model/AppSignModel.h"
#import "Model/MerchandiseCollectModel.h"
#import "LoginViewController.h"

@interface BaseViewController ()

@property (strong, nonatomic) UITabBarItem * cartItem;

@end

@implementation BaseViewController

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
    _appConfig = [AppConfig sharedAppConfig];
    [_appConfig loadConfig];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(goodsNumChange) name:KNotificationGoodsChange object:nil];
    
    
    UITabBarItem * homeItem = [self.tabBar.items objectAtIndex:0];
    homeItem = [self tabBarItem:homeItem image:[UIImage imageNamed:@"home"] selectedImage:[UIImage imageNamed:@"home_pre"]];
    
    UITabBarItem * searchItem = [self.tabBar.items objectAtIndex:1];
    searchItem = [self tabBarItem:searchItem image:[UIImage imageNamed:@"classify"] selectedImage:[UIImage imageNamed:@"classify_pre"]];
    
//    UITabBarItem * findItem = [self.tabBar.items objectAtIndex:2];
//    findItem = [self tabBarItem:findItem image:[UIImage imageNamed:@"faxian"] selectedImage:[UIImage imageNamed:@"faxian_pre"]];
    
    _cartItem = [self.tabBar.items objectAtIndex:2];
    _cartItem = [self tabBarItem:_cartItem image:[UIImage imageNamed:@"cart"] selectedImage:[UIImage imageNamed:@"cart_pre"]];
    
    UITabBarItem * accountItem = [self.tabBar.items objectAtIndex:3];
    accountItem = [self tabBarItem:accountItem image:[UIImage imageNamed:@"user"] selectedImage:[UIImage imageNamed:@"user_pre"]];
    

    if ([_appConfig isLogin]) {
        
        if (self.appConfig.appSign.length > 0) {
            //获取收藏列表
            NSDictionary * collectDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                         self.appConfig.loginName, @"MemLoginID",
                                         kWebAppSign, @"AppSign",
                                         @"1", @"pageIndex",
                                         @"20", @"pageCount",nil];
            
            [MerchandiseCollectModel getCollectListByparameters:collectDic andblock:^(NSArray *CollectList, NSError *error) {
                if (error) {
                    [MBProgressHUD showError:@"网络错误"];
                }else {
                    if ([CollectList count] > 0) {
                        NSMutableArray * collectGuids = [NSMutableArray arrayWithCapacity:0];
                        for (MerchandiseCollectModel *collectModel in CollectList) {
                            [collectGuids addObject:collectModel.ProductGuid];
                        }
                        _appConfig.collectGuidList = [NSMutableArray arrayWithArray: collectGuids];
                        [_appConfig saveConfig];
                    }
                }
            }];
            
            NSDictionary * shopcartDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                          self.appConfig.loginName,@"loginId",
                                          kWebAppSign,@"AppSign",
                                          nil];
            [ShopCartMerchandiseModel getShopCartMerchandiseListByParamer:shopcartDic andblock:^(NSArray *shopCartList, NSError *error) {
                if (error) {
                    //                [self showAlertWithMessage:@"网络错误"];
                }else{
                    NSInteger count = [shopCartList count];
                    if (count > 0) {
                        NSInteger sum = 0;
                        for (ShopCartMerchandiseModel *shopcart in shopCartList) {
                            sum += shopcart.buyNumber;
                        }
                        _appConfig.shopCartNum = sum;
                        [_appConfig saveConfig];
                        _cartItem.badgeValue = [NSString stringWithFormat:@"%d", sum];
                    }
                }
            }];
        }
        
//        [AppSignModel getAppSignandBlocks:^(NSString *appSign, NSError *error) {
//            if (appSign.length > 0) {
//                
//                [self.appConfig loadConfig];
//                self.appConfig.appSign = appSign;
//                [self.appConfig saveConfig];
//                
//                [self.appConfig loadConfig];
//                
//            }
//        }];
    }
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goodsNumChange
{
    [self.appConfig loadConfig];
    if (self.appConfig.shopCartNum > 0) {
        _cartItem.badgeValue = [NSString stringWithFormat:@"%ld", self.appConfig.shopCartNum];
    }else {
        _cartItem.badgeValue = nil;
    }
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if ([item.title isEqualToString:@"购物车"] || [item.title isEqualToString:@"个人中心"]) {
        [_appConfig loadConfig];
        if (![_appConfig isLogin]) {
            [self performSegueWithIdentifier:kSegueShopCartToLogin sender:self];
        }
    }
}

//这个方法应该抽出来放在分类里
- (UITabBarItem *)tabBarItem:(UITabBarItem *)tabBarItem image:(UIImage *)image selectedImage:(UIImage *)selectedImage {
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [tabBarItem setImage:image];
    [tabBarItem setSelectedImage:selectedImage];
    return tabBarItem;
}


#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    LoginViewController * lgvc = [segue destinationViewController];
    if ([segue.identifier isEqualToString:kSegueShopCartToLogin]) {
        if ([lgvc respondsToSelector:@selector(setFatherViewType:)]) {

            lgvc.FatherViewType = LoginForPersonal;
        }
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (void)dealloc
{
//    NSLog(@"baseDealloc");
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
