//
//  RootViewController.h
//  ForbiddenCityVirtual_EN
//
//  Created by Heramerom on 13-6-24.
//  Copyright (c) 2013年 Duke Douglas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCShareSDK.h"
#import "SinaWeibo.h"

@interface RootViewController : UIViewController<UIWebViewDelegate, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate,CLLocationManagerDelegate, TCWeiboShareDelegate, SinaWeiboDelegate, SinaWeiboRequestDelegate>
{
    UIWebView *_virtualWeb;
    
    UIImageView *_topImage;
    UILabel *_topLabel;
    
    UIButton *_listButton;
    UIButton *_soundButon;
    UIButton *_photoButton;
    UIButton *_gyroscopeButton;
    UIButton *_infoButton;
    UIButton *_mapButton;
    UIButton *_shareButton;
    
    UIImageView *_listView;
    UITableView *_listTable;
    
//    UISegmentedControl *_changeLanguage;
}

@property (nonatomic, strong) NSNumber *photoPage;

- (void)loadSceneWithTag:(NSNumber *)tag;

- (void)audioPlay;

@end
