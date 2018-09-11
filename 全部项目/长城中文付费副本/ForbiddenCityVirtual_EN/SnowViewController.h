//
//  SnowViewController.h
//  ForbiddenCityVirtual_EN
//
//  Created by Heramerom on 13-8-27.
//  Copyright (c) 2013年 Duke Douglas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
#import "TCShareSDK.h"

@interface SnowViewController : UIViewController<SinaWeiboRequestDelegate, SinaWeiboDelegate, TCWeiboShareDelegate>
{
    UIButton *_soundButon;
    UIButton *_gyroscopeButton;
    UIButton *_shareButton;
    
    UIButton *_toNomal;
    
    UIWebView *_virtualWeb;
    
    UIView *_barView;
    
    UIImageView *_soundImage;
    
    SinaWeibo *_sinaWeibo;
    TCShareSDK *_tcShare;
}

@property (nonatomic, assign) id delegate;

@end
