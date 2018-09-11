//
//  RootViewController.m
//  ForbiddenCityVirtual_EN
//
//  Created by Heramerom on 13-6-24.
//  Copyright (c) 2013年 Duke Douglas. All rights reserved.
//

#import "RootViewController.h"
#import "SceneInfo.h"
#import "AudioPlayer.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Twitter/Twitter.h>
#import <Social/Social.h>
#import "UIAlertView+Blocks.h"
#import "MapView.h"
#import "MySegment.h"
#import "FMDatabase.h"
#import "MobClick.h"
#import "IAPManager.h"
#import "CommentViewController.h"
#import "PaymentViewController.h"
#import "SinaWeibo.h"


#define kButton_Offset 204.0f
#define kButton_Width 131.0f
#define kButton_Height 57.0f
#define kButton_Y (kLCDW - 82.0f - 20)

#define SHARE_MESSAGE @"惊艳！一个美丽的中国女全景摄影师，拍下了全世界第一部普吉岛3D游记！https://itunes.apple.com/us/app/pu-ji-dao-jia-ri-quan-jing/id710213978?ls=1&mt=8"
#define SHARE_URL [NSURL URLWithString:@"https://itunes.apple.com/us/app/pu-ji-dao-jia-ri-quan-jing/id710213978?ls=1&mt=8"]

@interface RootViewController ()
{
    NSInteger _currentRow;
    NSMutableArray *_sceneInfos;
    
    UIImageView *_soundImage;
    UIButton *_play;
    UIButton *_soundOff;
    UISlider *_playback;
    UISlider *_sound;
    UILabel *_duration;
    UILabel *_currentTime;
    
    BOOL _audioAutoPlay;
    
    UIView *_barView;
    UIImageView *_barImage;
    
    UIButton *_guide;
        
    UIImageView *_shareView;
    
    AudioPlayer *_audioPlayer;
    
    MapView *_mapView;
    
    CurrentLanguage _currentLanguage;
        
    MySegment *_languageSegment;
    UIButton *_changeLanguage;
    
    //界面隐藏
    NSTimer *_hiddenTimer;
    NSInteger _viewCount;
    NSInteger _timeCount;
    
    CLLocationManager *_locationManager;
    
    UIImageView *_splash;
    
    //tecent微博
    TCShareSDK *_tcShare;
    SinaWeibo *_sinaWeibo;
}

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    Release(_virtualWeb);
    Release(_topImage);
    Release(_topLabel);
    Release(_listButton);
    Release(_soundButon);
    Release(_photoButton);
    Release(_gyroscopeButton);
    Release(_infoButton);
    Release(_mapButton);
    Release(_shareButton);
    Release(_listTable);
    Release(_listView);
    Release(_sceneInfos);
    Release(_play);
    Release(_soundImage);
    Release(_soundOff);
    Release(_sound);
    Release(_playback);
    Release(_duration);
    Release(_currentTime);
    Release(_shareView);
    Release(_audioPlayer);
    Release(_mapView);
    Release(_photoPage);
    Release(_languageSegment);
    Release(_changeLanguage);
    Release(_hiddenTimer);
    Release(_barView);
    Release(_barImage);
    Release(_locationManager);
    Release(_guide);
    Release(_splash);
    Release(_tcShare);
    Release(_sinaWeibo);
    
    [self removeNotification];
    
    [super dealloc];
}

#pragma mark -
#pragma mark about notification center observer method

- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPlayerButtonImage) name:PLAYER_STATE_CHANGED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setSoundImage) name:PLAYER_SOUND_VALUME_CHANGED object:nil];
    
    [NOTIFICATION_CENTER addObserver:self selector:@selector(paymentFatchProduct) name:kIAPFatchedNotification object:nil];
    [NOTIFICATION_CENTER addObserver:self selector:@selector(faildToPayment) name:kIAPPaymentFaildNotification object:nil];
    [NOTIFICATION_CENTER addObserver:self selector:@selector(successToPayment) name:kIAPPaymentSuccessedNotification object:nil];
}

- (void)removeNotification
{
    [NOTIFICATION_CENTER removeObserver:self name:PLAYER_STATE_CHANGED object:nil];
    [NOTIFICATION_CENTER removeObserver:self name:PLAYER_SOUND_VALUME_CHANGED object:nil];
    [NOTIFICATION_CENTER removeObserver:self name:kIAPPaymentSuccessedNotification object:nil];
    [NOTIFICATION_CENTER removeObserver:self name:kIAPPaymentFaildNotification object:nil];
    [NOTIFICATION_CENTER removeObserver:self name:kIAPFatchedNotification object:nil];
}

/*******************10.23修改****************/

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.view.bounds = CGRectMake(0, -20, kLCDH, kLCDW - 20);
    }
}

/*******************10.23修改****************/

- (void)viewDidLoad
{
    [super viewDidLoad];
    [NSThread sleepForTimeInterval:1.5f];    //设置闪屏时间为3.0s
    [self registerNotification];
    [self.view setBackgroundColor:[UIColor colorWithRed:220.0f/255.0f green:237.0f/255.0f blue:252.0f/255.0f alpha:1.0]];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)
    {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    _audioAutoPlay = YES;
    _currentLanguage = [[USER_DEFAULTS objectForKey:kCurrent_Language] intValue];
    _photoPage = [NSNumber numberWithInt:0];
    
    _hiddenTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(hiddenBar) userInfo:nil repeats:YES];
    [_hiddenTimer setFireDate:[NSDate distantFuture]];
    _viewCount = 0;
    
    _audioPlayer = [AudioPlayer getInstance];
    [self loadDatas];
    
    _virtualWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kLCDH, kLCDW - 20)];
    [_virtualWeb setDelegate:self];
    [self virtualWebLoadUrl];
    [self.view addSubview:_virtualWeb];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBar)];
    [_virtualWeb addGestureRecognizer:tap];
    [tap setDelegate:self];
    [tap release];
    
    [self configViews];
    
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager setDelegate:self];
    [_locationManager startUpdatingLocation];
    
}

- (void)addSplashView
{
    
}

- (void)hiddenSplashView
{
    [UIView animateWithDuration:0.5f animations:^{
        [_splash setAlpha:0.0f];
    } completion:^(BOOL finished) {
        [_splash removeFromSuperview];
        [self audioPlay];
    }];
}

- (void)loadDatas
{
    float wscale = 755.0f / 375;
    float hscale = 1120.0f / 561;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:10];
    for (NSDictionary *dic in array)
    {
        SceneInfo *sceneInfo = [[SceneInfo alloc] init];
        sceneInfo.identifier = [[dic objectForKey:@"id"] integerValue];
        sceneInfo.nameCN = [dic objectForKey:@"name_cn"];
        sceneInfo.nameEN = [dic objectForKey:@"name_en"];
        sceneInfo.scName = [dic objectForKey:@"scname"];
        sceneInfo.soundEN = [dic objectForKey:@"sound_en"];
        sceneInfo.soundCN = [dic objectForKey:@"sound_cn"];
        sceneInfo.longitude = [[dic objectForKey:@"longitude"] floatValue];
        sceneInfo.latitude = [[dic objectForKey:@"latitude"] floatValue];
        sceneInfo.detlaX = [[dic objectForKey:@"detlaX"] floatValue] / wscale;
        sceneInfo.detlaY = [[dic objectForKey:@"detlaY"] floatValue] / hscale;
        [mutableArray addObject:sceneInfo];
        [sceneInfo release];
    }
    NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"identifier" ascending:YES] autorelease];
    NSArray *sortDescriptorArray = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray = [mutableArray sortedArrayUsingDescriptors:sortDescriptorArray];
    if (_sceneInfos)
    {
        [_sceneInfos release];
        _sceneInfos = nil;
    }
    _sceneInfos = [[NSMutableArray alloc] initWithArray:sortedArray];
    
    [mutableArray release];
    mutableArray = nil;
    [data release];
    data = nil;
}

- (void)virtualWebLoadUrl
{
    if (_currentLanguage == English)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"tour_en" ofType:@"html"];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
        [_virtualWeb loadRequest:request];
    }
    else
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"tour_cn" ofType:@"html"];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
        [_virtualWeb loadRequest:request];
    }
}



#pragma mark -
#pragma mark config views
- (void)configViews
{
    [self addTopImage];
    [self addBarView];
    [self addListButton];
    [self addSoundsButton];
    [self addGyroButton];
    [self addMapButton];
    [self addShareButton];
    [self addListView];
    [self addSoundView];
    [self addShareView];
    [self addMapView];
    [self loadChangeLanguageSegmentControl];
    
}

- (void)addTopImage
{
    _topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kLCDH, 54.0f)];
    [_topLabel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"top.png"]]];
    [_topLabel setText:@"Phuket Holiday"];
    
    [_topLabel setTextAlignment:NSTextAlignmentCenter];
    [_topLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:24.0f]];
    [_topLabel setTextColor:[UIColor blackColor]];
    [_topLabel setShadowColor:[UIColor whiteColor]];
    [_topLabel setShadowOffset:CGSizeMake(2, 2)];
    [self.view addSubview:_topLabel];
    
}

- (void)addBarView
{
    _barImage = [[UIImageView alloc] initWithFrame:CGRectMake(kLCDH / 2 - 749.0f / 2, kLCDW - 130, 749, 94)];
    [_barImage setImage:[UIImage imageNamed:@"tablebar.png"]];
    [_barImage setUserInteractionEnabled:YES];
    [self.view addSubview:_barImage];
    _barView = [[UIView alloc] initWithFrame:CGRectMake(82, 25, kButton_Width * 5, kButton_Height)];
    [_barView setBackgroundColor:[UIColor clearColor]];
    [_barImage addSubview:_barView];
}

- (void)addListButton
{
    _listButton = [[UIButton alloc] initWithFrame:CGRectMake( 0 * kButton_Width, 0, kButton_Width, kButton_Height)];
    [_listButton setImage:[UIImage imageNamed:@"list.png"] forState:UIControlStateNormal];
    [_listButton addTarget:self action:@selector(showOrHiddenList:) forControlEvents:UIControlEventTouchUpInside];
    [_barView addSubview:_listButton];
}

- (void)addSoundsButton
{
    _soundButon = [[UIButton alloc] initWithFrame:CGRectMake( 1 * kButton_Width, 0, kButton_Width, kButton_Height)];
    [_soundButon setImage:[UIImage imageNamed:@"sound.png"] forState:UIControlStateNormal];
    [_soundButon addTarget:self action:@selector(showOrHiddenSoundView:) forControlEvents:UIControlEventTouchUpInside];
    [_barView addSubview:_soundButon];
}

- (void)addPhotoButton
{
    _photoButton = [[UIButton alloc] initWithFrame:CGRectMake( 2 * kButton_Width, 0, kButton_Width, kButton_Height)];
    [_photoButton setImage:[UIImage imageNamed:@"photo.png"] forState:UIControlStateNormal];
    [_photoButton setImage:[UIImage imageNamed:@"photo_d.jpg"] forState:UIControlStateHighlighted];
    [_photoButton addTarget:self action:@selector(showOrHiddenPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [_barView addSubview:_photoButton];
}

- (void)addGyroButton
{
    _gyroscopeButton = [[UIButton alloc] initWithFrame:CGRectMake( 2 * kButton_Width, 0, kButton_Width, kButton_Height)];
    [_gyroscopeButton setImage:[UIImage imageNamed:@"gyro.png"] forState:UIControlStateNormal];
    [_gyroscopeButton addTarget:self action:@selector(changeGyro:) forControlEvents:UIControlEventTouchUpInside];
    [_barView addSubview:_gyroscopeButton];
}

- (void)addInfoButton
{
    _infoButton = [[UIButton alloc] initWithFrame:CGRectMake( 4 * kButton_Width, 0, kButton_Width, kButton_Height)];
    [_infoButton setImage:[UIImage imageNamed:@"info.png"] forState:UIControlStateNormal];
    [_infoButton setImage:[UIImage imageNamed:@"info_d.jpg"] forState:UIControlStateHighlighted];
    [_infoButton addTarget:self action:@selector(showOrHiddenInfoView:) forControlEvents:UIControlEventTouchUpInside];
    [_barView addSubview:_infoButton];
}

- (void)addMapButton
{
    _mapButton = [[UIButton alloc] initWithFrame:CGRectMake( 3 * kButton_Width, 0, kButton_Width, kButton_Height)];
    [_mapButton setImage:[UIImage imageNamed:@"map.png"] forState:UIControlStateNormal];
    [_mapButton addTarget:self action:@selector(showOrHiddenMapView:) forControlEvents:UIControlEventTouchUpInside];
    [_barView addSubview:_mapButton];
}

- (void)addShareButton
{
    _shareButton = [[UIButton alloc] initWithFrame:CGRectMake( 4 * kButton_Width, 0, kButton_Width, kButton_Height)];
    [_shareButton setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
    [_shareButton addTarget:self action:@selector(showOrHiddenShareView:) forControlEvents:UIControlEventTouchUpInside];
    [_barView addSubview:_shareButton];
}

- (void)addListView
{
    _listView = [[UIImageView alloc] init];
    [_listView setUserInteractionEnabled:YES];
    [_listView setAlpha:0.0f];
    [self.view addSubview:_listView];
    
    _listTable = [[UITableView alloc] init];
    [_listTable setDelegate:self];
    [_listTable setDataSource:self];
    [_listTable setBackgroundColor:[UIColor clearColor]];
    [_listTable setSeparatorColor:[UIColor colorWithRed:203.0f / 255.0f green:203.0f / 255.0f blue:203.0f / 255.0f alpha:1.0f]];
    [_listView addSubview:_listTable];
    
    [self updateListViewAfterLanguageChenge];
}

- (void)addSoundView
{
    _soundImage = [[UIImageView alloc] initWithFrame:CGRectMake(312, 610 - 20, 574, 71)];
    [_soundImage setImage:[UIImage imageNamed:@"sound_bg.png"]];
    [_soundImage setUserInteractionEnabled:YES];
    [_soundImage setAlpha:0.0f];
    [self.view addSubview:_soundImage];
    
    _play = [[UIButton alloc] initWithFrame:CGRectMake(18, 7, 44, 44)];
    [_play addTarget:self action:@selector(playOrPauseSound:) forControlEvents:UIControlEventTouchUpInside];
    [self setPlayerButtonImage];
    [_soundImage addSubview:_play];
    
    _playback = [[UISlider alloc] initWithFrame:CGRectMake(76, 13, 270, 30)];
    [_playback setThumbImage:[UIImage imageNamed:@"thumb.png"] forState:UIControlStateNormal];
    [_playback setMaximumTrackTintColor:[UIColor colorWithRed:44.0/255 green:48.0/255 blue:49.0/255 alpha:1]];
    [_playback setMinimumTrackTintColor:[UIColor colorWithRed:243.0/255 green:183.0/255 blue:0 alpha:1.0]];
    [_soundImage addSubview:_playback];
    
    _soundOff = [[UIButton alloc] initWithFrame:CGRectMake(370, 7, 44, 44)];
    [_soundOff setImage:[UIImage imageNamed:@"sound_on.png"] forState:UIControlStateNormal];
    [_soundOff addTarget:self action:@selector(soundOnOrOff:) forControlEvents:UIControlEventTouchUpInside];
    [_soundImage addSubview:_soundOff];
    
    _sound = [[UISlider alloc] initWithFrame:CGRectMake(438, 13, 120, 30)];
    [_sound setThumbImage:[UIImage imageNamed:@"thumb.png"] forState:UIControlStateNormal];
    [_sound setMaximumTrackTintColor:[UIColor colorWithRed:44.0/255 green:48.0/255 blue:49.0/255 alpha:1]];
    [_sound setMinimumTrackTintColor:[UIColor colorWithRed:243.0/255 green:183.0/255 blue:0 alpha:1.0]];
    [_soundImage addSubview:_sound];
    
    _duration = [[UILabel alloc] initWithFrame:CGRectMake(302, 37, 47, 19)];
    _duration.font = [UIFont fontWithName:kFont_Name size:14.0f];
    _duration.backgroundColor = [UIColor clearColor];
    _duration.textAlignment = NSTextAlignmentCenter;
    [_duration setTextColor:[UIColor whiteColor]];
    [_soundImage addSubview:_duration];
    
    _currentTime = [[UILabel alloc] initWithFrame:CGRectMake(70, 37, 47, 19)];
    _currentTime.font = [UIFont fontWithName:kFont_Name size:14.0f];
    _currentTime.backgroundColor = [UIColor clearColor];
    _currentTime.textAlignment = NSTextAlignmentCenter;
    [_currentTime setTextColor:[UIColor colorWithRed:241.0f / 255.0f green:183.0f / 255.0f blue:0 alpha:1.0]];
    [_soundImage addSubview:_currentTime];
    
    [_audioPlayer setSlider:_playback];
    [_audioPlayer setSoundSlider:_sound];
    [_audioPlayer setDuration:_duration];
    [_audioPlayer setCurrentTime:_currentTime];
}

- (void)loadChangeLanguageSegmentControl
{
//    _languageSegment = [[MySegment alloc] initWithTag:self andSelect:@selector(changeLanguage:) andEvent:UIControlEventTouchUpInside];
//    [self.view addSubview:_languageSegment];
    
    _changeLanguage = [[UIButton alloc] initWithFrame:CGRectMake(kLCDH - 136 - 20, 54, 136, 71)];
    [self changeLanguageButtonImage];
    [_changeLanguage addTarget:self action:@selector(changeLanguage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_changeLanguage];
}

- (void)changeLanguageButtonImage
{
    if (_currentLanguage == English)
    {
        [_changeLanguage setImage:[UIImage imageNamed:@"tochi.png"] forState:UIControlStateNormal];
        [_changeLanguage setImage:[UIImage imageNamed:@"tochi_d.png"] forState:UIControlStateHighlighted];
    }
    else
    {
        [_changeLanguage setImage:[UIImage imageNamed:@"toeng.png"] forState:UIControlStateNormal];
        [_changeLanguage setImage:[UIImage imageNamed:@"toeng_d.png"] forState:UIControlStateHighlighted];
    }
}

- (void)changeLanguage
{
    if (_currentLanguage == English)
    {
        [USER_DEFAULTS setInteger:Chinese forKey:kCurrent_Language];
        [USER_DEFAULTS synchronize];
        _currentLanguage = Chinese;
    }
    else
    {
        [USER_DEFAULTS setInteger:English forKey:kCurrent_Language];
        [USER_DEFAULTS synchronize];
        _currentLanguage = English;
    }
    [_gyroscopeButton setImage:[UIImage imageNamed:@"gyro.png"] forState:UIControlStateNormal];
    [self changeLanguageButtonImage];
    [self virtualWebLoadUrl];
    [_listTable reloadData];
    [self updateListViewAfterLanguageChenge];
    [self updateShareImage];
    [self reloadMapPins];
}

- (void)addPhotosView
{
    
}

- (void)addShareView
{
    _shareView = [[UIImageView alloc] initWithFrame:CGRectMake(kLCDH / 2 - 529 / 2, kLCDW / 2 - 414 / 2 - 17, 529, 414)];
    [self updateShareImage];
    [_shareView setUserInteractionEnabled:YES];
    [self.view addSubview:_shareView];
    
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(529 - 70, 60, 40, 40)];
    [closeBtn setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [closeBtn setImage:[UIImage imageNamed:@"close_d.png"] forState:UIControlStateHighlighted];
    [closeBtn addTarget:self action:@selector(hiddenShareView:) forControlEvents:UIControlEventTouchUpInside];
    [_shareView addSubview:closeBtn];
    [closeBtn release];
    
    UIButton *facebookBtn = [[UIButton alloc] initWithFrame:CGRectMake(200, 190, 75, 75)];
    [facebookBtn setImage:[UIImage imageNamed:@"facebook.png"] forState:UIControlStateNormal];
    [facebookBtn addTarget:self action:@selector(shareToSina) forControlEvents:UIControlEventTouchUpInside];
    [_shareView addSubview:facebookBtn];
    [facebookBtn release];
    
    UIButton *twitterBtn = [[UIButton alloc] initWithFrame:CGRectMake(200 + 20 + 75, 190, 75, 75)];
    [twitterBtn setImage:[UIImage imageNamed:@"twitter.png"] forState:UIControlStateNormal];
    [twitterBtn addTarget:self action:@selector(shareToTencent) forControlEvents:UIControlEventTouchUpInside];
    [_shareView addSubview:twitterBtn];
    [twitterBtn release];
    
    [_shareView setAlpha:0.0f];
    
}

- (void)addMapView
{
    _mapView = [[MapView alloc] initWithPoints:_sceneInfos];
//    [_mapView addAnnotationWithSceneInfos:_sceneInfos];
    [_mapView setDelegate:self];
    [self.view addSubview:_mapView];
    [_mapView setAlpha:0.0f];
}

- (void)reloadMapPins
{
    [_mapView updateSceneTitleAfterLanguageChanged];
}

- (void)updateListViewAfterLanguageChenge
{
    if (_currentLanguage == English)
    {
        [UIView animateWithDuration:0.5f animations:^{
            _listView.image = [UIImage imageNamed:@"list_en.png"];
            _listView.frame = CGRectMake(184, 164 - 20, 562, 519);
            _listTable.frame = CGRectMake(23, 67 - 54, 562 - 23 * 2, 519 - 24 - 13);
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5f animations:^{
            _listView.image = [UIImage imageNamed:@"list_cn.png"];
            _listView.frame = CGRectMake(184, 164 - 20, 392, 519);
            _listTable.frame = CGRectMake(23, 67 - 54, 562 - 23 * 2 - 170, 519 - 24 - 13);
        }];
    }
}

- (void)updateShareImage
{
    if (_currentLanguage == English)
    {
        [_shareView setImage:[UIImage imageNamed:@"shareen_bg.png"]];
    }
    else
    {
        [_shareView setImage:[UIImage imageNamed:@"share_bg.png"]];
    }
}

- (void)firstLaunchGuide
{
    [_guide setHidden:YES];
    [_guide removeFromSuperview];
    [USER_DEFAULTS setBool:YES forKey:kWas_First_Launch];
    [USER_DEFAULTS synchronize];
}

#pragma mark -
#pragma mark change language

- (void)changeLanguage:(UIButton *)sender
{
    [_gyroscopeButton setImage:[UIImage imageNamed:@"gyro.png"] forState:UIControlStateNormal];
    _currentLanguage = sender.tag;
    [USER_DEFAULTS setInteger:_currentLanguage forKey:kCurrent_Language];
    [USER_DEFAULTS synchronize];
    [self virtualWebLoadUrl];
    [_listTable reloadData];
    [self updateListViewAfterLanguageChenge];
    [self reloadMapPins];
}

#pragma mark -
#pragma mark sound control

- (void)playOrPauseSound:(id)sender
{
    if (_audioPlayer.playerState == PlayerStatePlaying)
    {
        [_audioPlayer pause];
    }
    else
    {
        [_audioPlayer play];
    }
}

- (void)setPlayerButtonImage
{
    if (_audioPlayer.playerState == PlayerStatePlaying)
    {
        [_play setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_play setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    }
}

- (void)soundOnOrOff:(id)sender
{
    if (_audioPlayer.wasSoundOff)
    {
        [_audioPlayer soundOn];
    }
    else
    {
        [_audioPlayer soundOff];
    }
}

- (void)setSoundImage
{
    if (_audioPlayer.wasSoundOff)
    {
        [_soundOff setImage:[UIImage imageNamed:@"sound_off.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_soundOff setImage:[UIImage imageNamed:@"sound_on.png"] forState:UIControlStateNormal];
    }
}

#pragma mark -
#pragma mark audio player method

- (void)playSoundWithPath:(NSURL *)path
{
    [_audioPlayer setSoundFilePath:path andPlay:YES];
}

- (NSURL *)soundFilePathWithName:(NSString *)name
{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:path];
    return url;
}

- (void)sceneFinishedLoadAndChangeSound
{
    if (_currentLanguage == English)
    {
        NSURL *url = [self soundFilePathWithName:[[self currentScene] soundEN]];
        [_audioPlayer setSoundFilePath:url andPlay:_audioAutoPlay];
    }
    else
    {
        NSURL *url = [self soundFilePathWithName:[[self currentScene] soundCN]];
        [_audioPlayer setSoundFilePath:url andPlay:_audioAutoPlay];
    }
}

- (void)audioPlay
{
    _audioAutoPlay = YES;
    [self sceneFinishedLoadAndChangeSound];
}

#pragma mark -
#pragma mark buttons method
- (void)showOrHiddenList:(id)sender
{
    if (_mapView.alpha == 1.0f)
    {
        [self showOrHiddenMapView:nil];
    }
    if (_soundImage.alpha == 1.0f)
    {
        [self showOrHiddenSoundView:nil];
    }

    static BOOL bo = YES;
    bo = !bo;
    if (bo)
    {
        [self viewRelease];
        [_listButton setImage:[UIImage imageNamed:@"list.png"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.5f animations:^{
            [_listView setAlpha:0.0f];
        } completion:^(BOOL finished) {
            
        }];
    }
    else
    {
        [self viewRetain];
        if (_shareView.alpha == 1.0f)
        {
            [self hiddenShareView:nil];
        }
        [_listButton setImage:[UIImage imageNamed:@"list_d.png"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.5f animations:^{
            [_listView setAlpha:1.0f];
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)showOrHiddenSoundView:(id)sender
{
    if (_listView.alpha == 1.0f)
    {
        [self showOrHiddenList:nil];
    }
    if (_mapView.alpha == 1.0f)
    {
        [self showOrHiddenMapView:nil];
    }
    static BOOL bo = YES;
    bo = !bo;
    if (bo)
    {
        [self viewRelease];
        [_soundButon setImage:[UIImage imageNamed:@"sound.png"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.5f animations:^{
            [_soundImage setAlpha:0.0f];
        } completion:^(BOOL finished) {
            
        }];
    }
    else
    {
        [self viewRetain];
        [_soundButon setImage:[UIImage imageNamed:@"sound_d.png"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.5f animations:^{
            [_soundImage setAlpha:1];
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)showOrHiddenPhoto:(id)sender
{

}

- (void)changeGyro:(id)sender
{
    if (!wasComment)
    {
        CommentViewController *comment = [[[CommentViewController alloc] init] autorelease];
        [comment setDelegate:self];
        [self viewRetain];
        [self presentModalViewController:comment animated:YES];
    }
    else
    {
        static BOOL bo = YES;
        bo = !bo;
        if (bo)
        {
            [_gyroscopeButton setImage:[UIImage imageNamed:@"gyro.png"] forState:UIControlStateNormal];
            [_virtualWeb stringByEvaluatingJavaScriptFromString:@"choose_gyro()"];
        }
        else
        {
            [_gyroscopeButton setImage:[UIImage imageNamed:@"gyro_d.png"] forState:UIControlStateNormal];
            [_virtualWeb stringByEvaluatingJavaScriptFromString:@"choose_gyro()"];
            [self hiddenAllViews];
        }
        [MobClick event:@"gyroButtonPress"];
    }
}



- (void)showOrHiddenInfoView:(id)sender
{

}

- (void)showOrHiddenMapView:(id)sender
{
    if (_listView.alpha == 1.0f)
    {
        [self showOrHiddenList:nil];
    }
    if (_soundImage.alpha == 1.0f)
    {
        [self showOrHiddenSoundView:nil];
    }
    static BOOL bo = YES;
    bo = !bo;
    if (bo)
    {
        [self viewRelease];
        [_mapButton setImage:[UIImage imageNamed:@"map.png"] forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.5f animations:^{
            [_mapView setAlpha:0.0f];
        } completion:^(BOOL finished) {
           
        }];
    }
    else
    {
        [self viewRetain];
        if (_shareView.alpha == 1.0f)
        {
            [self hiddenShareView:nil];
        }
        [_mapButton setImage:[UIImage imageNamed:@"map_d.png"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.5f animations:^{
            [_mapView setAlpha:1.0f];
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)showOrHiddenShareView:(id)sender
{
    [self hiddenListView];
    [self hiddenMapView];
    [self viewRetain];
    [UIView animateWithDuration:0.5f animations:^{
        [_shareView setAlpha:1.0f];
    } completion:^(BOOL finished) {
    }];
    [_shareButton setImage:[UIImage imageNamed:@"share_d.png"] forState:UIControlStateNormal];
    [MobClick event:@"shareButtonPress"];
}

#pragma mark -
#pragma mark share method

- (void)hiddenShareView:(id)sender
{
    [self viewRelease];
    [UIView animateWithDuration:0.5f animations:^{
        [_shareView setAlpha:0.0f];
    } completion:^(BOOL finished) {

    }];
    [_shareButton setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
}

- (void)shareToFacebook:(id)sender
{
    DLog(@"share to facebook");
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"gugong6" ofType:@"JPG"];
//    UIImage *image = [UIImage imageWithContentsOfFile:path];
    [self shareToFacebookWithMessage:SHARE_MESSAGE andUrl:SHARE_URL andImage:nil];
    [MobClick event:@"shareToFacebook"];
}

- (void)shareToTwitter:(id)sender
{
    DLog(@"share to twitter");
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"gugong6" ofType:@"JPG"];
//    UIImage *image = [UIImage imageWithContentsOfFile:path];
    [self shareToTwitterWithMessage:SHARE_MESSAGE andUrl:SHARE_URL andImage:nil];
    [MobClick event:@"shareToTwitter"];
}

#pragma mark -
#pragma mark web view delegate method
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSString *url = [request.URL absoluteString];
//    NSLog(@"%@", url);
    if ([url isEqualToString:@"http://www.baidu.com/"])
    {
        [self sceneDidFinishedLoad];
        return NO;
    }
    if ([url isEqualToString:@"http://www.quanjingke.com/"])
    {
        [self loadSceneOrShowPayment];
        return NO;
    }
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

#pragma mark -
#pragma mark finish load scene

- (void)sceneDidFinishedLoad
{
    [self sceneFinishedLoadAndChangeSound];             //改变声音
    [self sceneFinishedLoadAndCheangeList];             //更新列表
    [self updateTopLabel];                              //更新顶部的标题
    [self updateMap];                                   //更新地图
    
    [self hiddenMapView];
    [self hiddenListView];
}

- (void)updateMap
{
    SceneInfo *info = [self currentScene];
    [_mapView showCalloutViewWithTag:info.identifier];
}


- (void)updateTopLabel
{
    SceneInfo *info = [self currentScene];
    if (_currentLanguage == English)
    {
        _topLabel.text = info.nameEN;
    }
    else
    {
        _topLabel.text = info.nameCN;
    }
}

- (SceneInfo *)currentScene
{
    NSString *scenename = [_virtualWeb stringByEvaluatingJavaScriptFromString:@"currentSceneName()"];
//    DLog(@"%@", scenename);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"scName = %@",scenename];
    NSArray *array = [_sceneInfos filteredArrayUsingPredicate:predicate];
    return array[0];
}

#pragma mark -
#pragma mark about scene and list

- (void)loadSceneWithTag:(NSNumber *)tag
{
    SceneInfo *info = [_sceneInfos objectAtIndex:[tag integerValue] - 1];
    [self loadSceneWithName:info.scName];
}

- (void)loadSceneWithName:(NSString *)name
{
    DLog(@"%@", name);
    [_virtualWeb stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"loadscene(\"%@\")",name]];
}

- (void)updateListRow:(NSInteger)row
{
    if (_currentRow == row -1)
    {
        return;
    }
    _currentRow = row - 1;
    [_listTable reloadData];
    NSIndexPath *index = [NSIndexPath indexPathForRow:row - 1 inSection:0];
    [_listTable scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (void)sceneFinishedLoadAndCheangeList
{
    [self updateListRow:[[self currentScene] identifier]];
}

#pragma mark -
#pragma mark table view delegate method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _sceneInfos.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *free = @"free";
    static NSString *pay = @"pay";
    static NSString *select = @"select";
    
    UITableViewCell *cell = nil;
    if (_currentLanguage == English)
    {
        if (!wasEnglishPaid && (indexPath.row > kFreeSceneCount - 1))
        {
            cell = [tableView dequeueReusableCellWithIdentifier:pay];
        }
        else
        {
            if (indexPath.row == _currentRow)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:select];
            }
            else
            {
                cell = [tableView dequeueReusableCellWithIdentifier:free];
            }
        }
    }
    else
    {
        if (!wasChinesePaid && (indexPath.row > kFreeSceneCount - 1))
        {
            cell = [tableView dequeueReusableCellWithIdentifier:pay];
        }
        else
        {
            if (indexPath.row == _currentRow)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:select];
            }
            else
            {
                cell = [tableView dequeueReusableCellWithIdentifier:free];
            }
        }
    }
    if (!cell)
    {
        if (_currentLanguage == English)
        {
            if (!wasEnglishPaid && indexPath.row > kFreeSceneCount - 1)
            {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:pay] autorelease];
                cell.textLabel.textColor = [UIColor grayColor];

                UILabel *distance = [[UILabel alloc] initWithFrame:CGRectMake(392, 0, 562 - 23 * 2 - 392, 54.0f)];
                distance.tag = 1;
                distance.backgroundColor = [UIColor clearColor];
                distance.textAlignment = NSTextAlignmentRight;
                distance.textColor = [UIColor grayColor];
                [cell.contentView addSubview:distance];
                [distance release];
                [cell.imageView setImage:[UIImage imageNamed:@"pay.png"]];
            }
            else
            {
                if (indexPath.row == _currentRow)
                {
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:select] autorelease];
                    cell.textLabel.textColor = [UIColor colorWithRed:255.0 / 255 green:0 blue:0 alpha:1];

                    UILabel *distance = [[UILabel alloc] initWithFrame:CGRectMake(392, 0, 562 - 23 * 2 - 392, 54.0f)];
                    distance.tag = 1;
                    distance.backgroundColor = [UIColor clearColor];
                    distance.textAlignment = NSTextAlignmentRight;
                    distance.textColor = [UIColor colorWithRed:255.0 / 255 green:0 blue:0 alpha:1];
                    [cell.contentView addSubview:distance];
                    [distance release];
                }
                else
                {
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:free] autorelease];
                    cell.textLabel.textColor = [UIColor colorWithRed:255.0 / 255 green:196.0 / 255 blue:0 alpha:1];

                    UILabel *distance = [[UILabel alloc] initWithFrame:CGRectMake(392, 0, 562 - 23 * 2 - 392, 54.0f)];
                    distance.tag = 1;
                    distance.backgroundColor = [UIColor clearColor];
                    distance.textAlignment = NSTextAlignmentRight;
                    distance.textColor = [UIColor colorWithRed:255.0 / 255 green:196.0 / 255 blue:0 alpha:1];
                    [cell.contentView addSubview:distance];
                    [distance release];
                }
                [cell.imageView setImage:[UIImage imageNamed:@"free.png"]];
            }
        }
        else
        {
            if (!wasChinesePaid && indexPath.row > kFreeSceneCount - 1)
            {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:pay] autorelease];
                cell.textLabel.textColor = [UIColor grayColor];
                
                UILabel *distance = [[UILabel alloc] initWithFrame:CGRectMake(382, 0, 562 - 23 * 2 - 382, 54.0f)];
                distance.tag = 1;
                distance.backgroundColor = [UIColor clearColor];
                distance.textAlignment = NSTextAlignmentRight;
                distance.textColor = [UIColor grayColor];
                [cell.contentView addSubview:distance];
                [distance release];
                [cell.imageView setImage:[UIImage imageNamed:@"pay.png"]];
            }
            else
            {
                if (indexPath.row == _currentRow)
                {
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:select] autorelease];
                    cell.textLabel.textColor = [UIColor colorWithRed:255.0 / 255 green:0 blue:0 alpha:1];
                    
                    UILabel *distance = [[UILabel alloc] initWithFrame:CGRectMake(382, 0, 562 - 23 * 2 - 382, 54.0f)];
                    distance.tag = 1;
                    distance.backgroundColor = [UIColor clearColor];
                    distance.textAlignment = NSTextAlignmentRight;
                    distance.textColor = [UIColor colorWithRed:255.0 / 255 green:0 blue:0 alpha:1];
                    [cell.contentView addSubview:distance];
                    [distance release];                }
                else
                {
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:free] autorelease];
                    cell.textLabel.textColor = [UIColor colorWithRed:255.0 / 255 green:196.0 / 255 blue:0 alpha:1];
                    
                    UILabel *distance = [[UILabel alloc] initWithFrame:CGRectMake(382, 0, 562 - 23 * 2 - 382, 54.0f)];
                    distance.tag = 1;
                    distance.backgroundColor = [UIColor clearColor];
                    distance.textAlignment = NSTextAlignmentRight;
                    distance.textColor = [UIColor colorWithRed:255.0 / 255 green:196.0 / 255 blue:0 alpha:1];
                    [cell.contentView addSubview:distance];
                    [distance release];
                }
                [cell.imageView setImage:[UIImage imageNamed:@"free.png"]];
            }
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.textLabel.font = [UIFont fontWithName:kFont_Name size:16.0f];
        cell.backgroundColor = [UIColor clearColor];
    }
    if (_currentLanguage == English)
    {
        UILabel *distance = (UILabel *)[cell.contentView viewWithTag:1];
        distance.frame = CGRectMake(392, 0, 562 - 23 * 2 - 392, 54.0f);
        SceneInfo *info = [_sceneInfos objectAtIndex:indexPath.row];
        cell.textLabel.text = [info nameEN];
        if (info.distance > 1000)
        {
            distance.text = [NSString stringWithFormat:@"%.2f KM", info.distance / 1000];
        }
        else
        {
            distance.text = [NSString stringWithFormat:@"%.1f M", info.distance];
        }
    }
    else
    {
        UILabel *distance = (UILabel *)[cell.contentView viewWithTag:1];
        distance.frame = CGRectMake(240, 0, 562 - 23 * 2 - 240 - 170, 54.0f);
        SceneInfo *info = [_sceneInfos objectAtIndex:indexPath.row];
        cell.textLabel.text = [info nameCN];
        if (info.distance > 1000)
        {
            distance.text = [NSString stringWithFormat:@"%.2f KM", info.distance / 1000];
        }
        else
        {
            distance.text = [NSString stringWithFormat:@"%.1f M", info.distance];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_currentLanguage == English)
    {
        if (!wasEnglishPaid && indexPath.row > kFreeSceneCount - 1)
        {
            [self showPaymentView];
        }
        else
        {
            _currentRow = indexPath.row;
            [self loadSceneWithName:[[_sceneInfos objectAtIndex:_currentRow] scName]];
            [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
            [tableView reloadData];
        }
    }
    else
    {
        if (!wasChinesePaid && indexPath.row > kFreeSceneCount - 1)
        {
            [self showPaymentView];
        }
        else
        {
            _currentRow = indexPath.row;
            [self loadSceneWithName:[[_sceneInfos objectAtIndex:_currentRow] scName]];
            [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
            [tableView reloadData];
        }
    }
}

#pragma mark -
#pragma mark about payment method

- (void)loadSceneOrShowPayment
{
    if (_currentLanguage == English && !wasEnglishPaid)
    {
        [self showPaymentView];
    }
    else if (_currentLanguage == Chinese && !wasChinesePaid)
    {
        [self showPaymentView];
    }
    else
    {
        [self loadSceneWithTag:@4];
    }
}

- (void)showPaymentView
{
    PaymentViewController *payment = [[[PaymentViewController alloc] init] autorelease];
    [payment setDelegate:self];
    [self viewRetain];
    [MobClick event:@"showPaymentView"];
    [self presentModalViewController:payment animated:YES];
}

- (void)restorePayment
{
    IAPManager *iapManager = [IAPManager getInstance];
    [iapManager restorePayment];
}

- (void)beginToPayment
{
    if (CURRENTLANGUAGE == English)
    {
        [self beginPaymentWithProductID:kEnglishProductID];
    }
    else
    {
        [self beginPaymentWithProductID:kChineseProductID];
    }
    
    [MobClick event:@"beginToPayment"];
}

- (void)beginPaymentWithProductID:(NSString *)productID
{
    IAPManager *iapManager = [IAPManager getInstance];
    [iapManager loadProductWithProductID:productID];
}

- (void)paymentFatchProduct
{
    
}

- (void)faildToPayment
{
    
}

- (void)successToPayment
{
    [self updateAfterSuccessPayment];
}


- (void)updateAfterSuccessPayment
{
    [_listTable reloadData];
    [_mapView updateMapAfterPaymentSuccess];
}



#pragma mark -
#pragma mark hidden View

- (void)hiddenAllViews
{
    [self hiddenListView];
    [self hiddenMapView];
    [self hiddenPlayerView];
    [self hiddenShareView];
}

- (void)hiddenShareView
{
    if (_shareView.alpha == 1.0f)
    {
        [self hiddenShareView:nil];
    }
}

- (void)hiddenListView
{
    if (_listView.alpha == 1.0)
    {
        [self showOrHiddenList:nil];
    }
}

- (void)hiddenPlayerView
{
    if (_soundImage.alpha == 1.0)
    {
        [self showOrHiddenSoundView:nil];
    }
}

- (void)hiddenMapView
{
    if (_mapView.alpha == 1.0)
    {
        [self showOrHiddenMapView:nil];
    }
}


#pragma mark -
#pragma mark gesture method

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    [self hiddenListView];
    [self hiddenMapView];
    
    return YES;
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark -
#pragma mark about hidden bar method

- (void)viewRetain
{
    _viewCount += 1;
    [self viewCountValueChanged];
}

- (void)viewRelease
{
    _viewCount -= 1;
    [self viewCountValueChanged];
}

- (void)viewCountValueChanged
{
    if (_viewCount == 0)
    {
        _timeCount = 0;
        [_hiddenTimer setFireDate:[NSDate date]];
    }
    else
    {
        [_hiddenTimer setFireDate:[NSDate distantFuture]];
    }
}

- (void)hiddenBar
{
    _timeCount += 1;
    if (_timeCount < 50)
    {
        return;
    }
    [_barImage setUserInteractionEnabled:NO];
    [UIView animateWithDuration:0.5f animations:^{
        [_barImage setFrame:CGRectMake(kLCDH / 2 - 749.0f / 2, kLCDW - 20, 749, 94)];
    } completion:^(BOOL finished) {
        [_hiddenTimer setFireDate:[NSDate distantFuture]];
    }];
}

- (void)showBar
{
    if (_barImage.userInteractionEnabled == YES)
    {
        _timeCount = 0;
        return;
    }
    DLog(@"show bar");
    [UIView animateWithDuration:0.5f animations:^{
        [_barImage setFrame:CGRectMake(kLCDH / 2 - 749.0f / 2, kLCDW - 130, 749, 94)];
    } completion:^(BOOL finished) {
        _timeCount = 0;
        [_hiddenTimer setFireDate:[NSDate date]];
        [_barImage setUserInteractionEnabled:YES];
    }];
}

#pragma mark -
#pragma mark location manager delegate method
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocationCoordinate2D coordinate = [self transGPS:newLocation.coordinate];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    [self makeSceneDistance:location];
    Release(location);
    [_listTable reloadData];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([error code] == kCLErrorDenied)
    {
        
    }
}

- (void)makeSceneDistance:(CLLocation *)newLocation
{
    for (SceneInfo *scInfo in _sceneInfos)
    {
        CLLocation *location = [[CLLocation alloc] initWithLatitude:scInfo.latitude longitude:scInfo.longitude];
        scInfo.distance = [location distanceFromLocation:newLocation];
        [location release];
        location = nil;
    }
}


//将手机坐标转化为火星坐标
- (CLLocationCoordinate2D)transGPS:(CLLocationCoordinate2D)phoneGPS
{
    int TenLat=0;
    int TenLog=0;
    TenLat = (int)(phoneGPS.latitude*10);
    TenLog = (int)(phoneGPS.longitude*10);
    int offLat=0;
    int offLog=0;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"gps" ofType:@"db"];
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    if (!db.open)
    {
        NSLog(@"database can not open");
        return phoneGPS;
    }
    else
    {
        FMResultSet *results = [db executeQuery:@"select offLat,offLog from gpsT where lat=? and log = ?", @(TenLat), @(TenLog)];
        while ([results next])
        {
            offLat = [results intForColumn:@"offLat"];
            offLog = [results intForColumn:@"offLog"];
        }
        [results close];
    }
    phoneGPS.latitude = phoneGPS.latitude+offLat*0.0001;
    phoneGPS.longitude = phoneGPS.longitude+offLog*0.0001;
    return phoneGPS;
}



#pragma mark -
#pragma mark share to twitter and facebook

- (void)shareToTwitterWithMessage:(NSString *)message andUrl:(NSURL *)url andImage:(UIImage *)image
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        if (kDEVICE_VERSION < 6.0)
        {
            TWTweetComposeViewController *twitter = [[[TWTweetComposeViewController alloc] init] autorelease];
            [twitter setInitialText:message];
            [twitter addURL:url];
            [twitter addImage:image];
            [self presentViewController:twitter animated:YES completion:^{
                nil;
            }];
        }
        else
        {
            SLComposeViewController *social = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            [social setInitialText:message];
            [social addURL:url];
            [social addImage:image];
            [self presentViewController:social animated:YES completion:^{
                nil;
            }];
        }
    }
    else
    {
        [UIAlertView showAlertViewWithTitle:@"No Twitter Accounts" message:@"There are no Twitter configured. You can add or create a Facebook account in Settings" cancelButtonTitle:@"dismiss" otherButtonTitles:nil onDismiss:^(int buttonIndex) {
            
        } onCancel:^{
            
        }];
    }
}

- (void)shareToFacebookWithMessage:(NSString *)message andUrl:(NSURL *)aUrl andImage:(UIImage *)image
{
    if (kDEVICE_VERSION < 6.0)
    {
        NSURL* url = [NSURL URLWithString:@"https://developers.facebook.com/"];
        FBAppCall *appCall = [FBDialogs presentShareDialogWithLink:url name:@"hello facebook" caption:nil description:message picture:nil clientState:nil handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
            if (error)
            {
                DLog(@"with error : %@",error.description);
            }
            else
            {
                DLog(@"open facebook app ok");
            }
        }];
        if (!appCall)
        {
            BOOL displayedNativeDialog = [FBDialogs presentOSIntegratedShareDialogModallyFrom:self initialText:message image:image url:url handler:^(FBOSIntegratedShareDialogResult result, NSError *error) {
                if (error)
                {
                    DLog(@"post error : %@", error.description);
                }
                else
                {
                    DLog(@"post ok");
                }
            }];
            if (!displayedNativeDialog)
            {
                [self performPublishAction:^{
                    [FBRequestConnection startForPostStatusUpdate:message completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                        nil;
                    }];
                }];
            }
        }
    }
    else
    {
         if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
         {
             SLComposeViewController *facebook = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
             [facebook setInitialText:message];
             [facebook addURL:aUrl];
             [facebook addImage:image];
             [self presentViewController:facebook animated:YES completion:^{
                 nil;
             }];
         }
         else
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Facebook Accounts" message:@"There are no Twitter configured. You can add or create a Facebook account in Settings" delegate:nil cancelButtonTitle:@"dismiss" otherButtonTitles: nil];
             [alert show];
             [alert release];
         }
    }
}

- (void) performPublishAction:(void (^)(void)) action
{
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
        [FBSession.activeSession requestNewPublishPermissions:@[@"publish_actions"] defaultAudience:FBSessionDefaultAudienceFriends completionHandler:^(FBSession *session, NSError *error)
         {
             if (!error)
             {
                 action();
             }
         }];
    } else
    {
        action();
    }
    
}

- (void)configSinaWeibo
{
    _sinaWeibo = [[SinaWeibo alloc] initWithAppKey:kSinaAppKey appSecret:kSinaSecret appRedirectURI:kSinaRedirectURI andDelegate:self];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *sinaWeiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
    
    if ([sinaWeiboInfo objectForKey:@"AccessTokenKey"] && [sinaWeiboInfo objectForKey:@"ExpirationDateKey"] && [sinaWeiboInfo objectForKey:@"UserIDKey"])
    {
        _sinaWeibo.accessToken = [sinaWeiboInfo objectForKey:@"AccessTokenKey"];
        
        _sinaWeibo.expirationDate = [sinaWeiboInfo objectForKey:@"ExpirationDateKey"];
        
        _sinaWeibo.userID = [sinaWeiboInfo objectForKey:@"UserIDKey"];
    
    }
}


- (void)shareToSina
{
    if (!_sinaWeibo)
    {
        [self configSinaWeibo];
    }
    
    if (![_sinaWeibo isLoggedIn])
    {
        [_sinaWeibo logIn];
    }
    else
    {
        UIImage *image = [UIImage imageNamed:@"sqlash-Landscape~ipad.jpg"];
        NSData *data = UIImageJPEGRepresentation(image, 0.5f);
        [_sinaWeibo requestWithURL:@"statuses/upload.json"
                            params:[NSMutableDictionary dictionaryWithObjectsAndKeys:SHARE_MESSAGE, @"status", data, @"pic", nil]
                        httpMethod:@"POST"
                          delegate:self];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)shareToTencent
{
    [MobClick event:@"shareToTecent"];
    if (!_tcShare)
    {
        _tcShare = [[TCShareSDK alloc] init];
        [_tcShare setDelegate:self];
    }
    if ([_tcShare weiboHasAreadyLogin])
    {
        UIImage *image = [UIImage imageNamed:@"sqlash-Landscape~ipad.jpg"];
        NSData *data = UIImageJPEGRepresentation(image, 0.5f);
        [_tcShare shareWithMessage:SHARE_MESSAGE andPic:data];
    }
    else
    {
        [_tcShare login];
    }
}

#pragma mark -
#pragma mark tencent weibo delegate method

- (void)weiboWasSuccessLogin
{
    [self shareToTencent];
}
- (void)weiboWasFaildLogin
{
    
}

- (void)shareFaildWithError:(NSError *)error
{
    [UIAlertView showAlertViewWithTitle:@"提示" message:@"无法分享到腾讯微博，请检查网络连接" cancelButtonTitle:@"确定" otherButtonTitles:nil onDismiss:^(int buttonIndex) {
    } onCancel:^{
        
    }];
}

- (void)shareFinishedWithResult:(NSString *)result
{
    [UIAlertView showAlertViewWithTitle:@"提示" message:@"成功分享到腾讯微博" cancelButtonTitle:@"确定" otherButtonTitles:nil onDismiss:^(int buttonIndex) {
    } onCancel:^{
        
    }];
}

#pragma mark sina weibo delegate method

- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    UIImage *image = [UIImage imageNamed:@"sqlash-Landscape~ipad.jpg"];
    NSData *data = UIImageJPEGRepresentation(image, 0.5f);
    [_sinaWeibo requestWithURL:@"statuses/upload.json"
                        params:[NSMutableDictionary dictionaryWithObjectsAndKeys:SHARE_MESSAGE, @"status", data, @"pic", nil]
                    httpMethod:@"POST"
                      delegate:self];
    [self storeAuthData];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo;
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

//分享失败
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if ([request.url hasSuffix:@"statuses/upload.json"]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"成功分享到新浪微博" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    }
}

- (void)storeAuthData
{
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              _sinaWeibo.accessToken, @"AccessTokenKey",
                              _sinaWeibo.expirationDate, @"ExpirationDateKey",
                              _sinaWeibo.userID, @"UserIDKey",
                              _sinaWeibo.refreshToken, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//请求失败回调方法
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if ([request.url hasSuffix:@"statuses/upload.json"]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"分享到新浪微博失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    }
}

#pragma mark -
#pragma mark observe method

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
   
}



#pragma receive memory
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
