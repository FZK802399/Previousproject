//
//  DevelopmentFXController.m
//  ShopNum1V3.1
//
//  Created by yons on 15/11/28.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "DevelopmentFXController.h"
#import "QRCodeGenerator.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

@interface DevelopmentFXController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@end

@implementation DevelopmentFXController
{
    NSString *shareURL;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发展会员";
    AppConfig * config = [AppConfig sharedAppConfig];
    [config loadConfig];
    NSString * str = [NSString stringWithFormat:@"http://senghongwap.efood7.com/pages/ShareRegister.html?CommendPeople=%@",config.loginName];
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.imgView.image = [QRCodeGenerator qrImageForString:str imageSize:[UIScreen mainScreen].bounds.size.width-100];
    shareURL = str;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 分享
- (IBAction)shareClick:(id)sender {
    UIImage * img = [UIImage imageNamed:@"180"];
    //1、创建分享参数
    NSArray* imageArray = @[img];
    //    NSString * shareURL = _currentDetailModel.PCUrl;
    //    （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"加入Efood7，购买货真价实的澳洲商品，更能获得佣金返现！"
                                         images:imageArray
                                            url:[NSURL URLWithString:shareURL]
                                          title:@"Efood7来自澳洲的出口商"
                                           type:SSDKContentTypeAuto];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];}
}

@end
