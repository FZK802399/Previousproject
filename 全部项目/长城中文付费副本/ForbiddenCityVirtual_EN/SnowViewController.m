//
//  SnowViewController.m
//  ForbiddenCityVirtual_EN
//
//  Created by Heramerom on 13-8-27.
//  Copyright (c) 2013年 Duke Douglas. All rights reserved.
//

#import "SnowViewController.h"
#import "AudioPlayer.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Social/Social.h>
#import "UIAlertView+Blocks.h"
#import <Twitter/Twitter.h>

#define kButton_Width 123.0f
#define kButton_Offset ((kLCDH - kButton_Width * 3) / 2)
#define kButton_Height 57.0f
#define kButton_Y (kLCDW - 82.0f - 20)

#define SHARE_MESSAGE @"刚使用了《长城全景游》ipad客户端，太爽了，内嵌32张全景，通过专业语音讲解，带您穿越历史，身临其境，漫游长城。https://itunes.apple.com/us/app/zhang-cheng-quan-jing-you/id694990692?ls=1&mt=8"
#define SHARE_URL [NSURL URLWithString:@"itms-apps://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=682260999"]

@interface SnowViewController ()
{
    AudioPlayer *_audioPlayer;
    
    UIButton *_play;
    UISlider *_playback;
    UIButton *_soundOff;
    UISlider *_sound;
    UILabel  *_duration;
    UILabel  *_currentTime;
    
    UIImageView *_shareView;
}

@end

@implementation SnowViewController

@synthesize delegate = _delegate;

- (void)dealloc
{
    Release(_gyroscopeButton);
    Release(_soundButon);
    Release(_shareButton);
    Release(_toNomal);
    Release(_virtualWeb);
    Release(_barView);
    Release(_soundImage);
    Release(_play);
    Release(_playback);
    Release(_soundOff);
    Release(_sound);
    Release(_duration);
    Release(_currentTime);
    Release(_shareView);
    [_tcShare setDelegate:nil];
    [_sinaWeibo setDelegate:nil];
    Release(_sinaWeibo);;
    Release(_tcShare);
    
    [NOTIFICATION_CENTER removeObserver:self name:PLAYER_SOUND_VALUME_CHANGED object:nil];
    [NOTIFICATION_CENTER removeObserver:self name:PLAYER_STATE_CHANGED object:nil];
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:31.0f/255.0f green:31.0f/255.0f blue:31.0f/255.0f alpha:1.0]];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)
    {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:@"snow_tour_en" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:path];
    _virtualWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 1024, 748)];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_virtualWeb loadRequest:request];
    [self.view addSubview:_virtualWeb];
    
	[self configView];
}

/*******************10.20修改****************/

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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

/*******************10.20修改****************/


#pragma mark -
#pragma mark config view

- (void)configView
{
    _barView = [[UIView alloc] initWithFrame:CGRectMake(kButton_Offset, kButton_Y, kButton_Width * 3, kButton_Height)];
    [_barView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_barView];
    
    [self addSoundButton];
    [self addGyroButton];
    [self addToNomalButton];
    [self addSoundView];
    [self addShareButton];
    [self addShareView];
    [self addTopImage];
    
}

- (void)addSoundButton
{
    _soundButon = [[UIButton alloc] initWithFrame:CGRectMake( 0, 0, kButton_Width, kButton_Height)];
    [_soundButon setImage:[UIImage imageNamed:@"snowsound.png"] forState:UIControlStateNormal];
    [_soundButon addTarget:self action:@selector(showOrHiddenSoundView:) forControlEvents:UIControlEventTouchUpInside];
    [_barView addSubview:_soundButon];
}
- (void)addGyroButton
{
    _gyroscopeButton = [[UIButton alloc] initWithFrame:CGRectMake( 1 * kButton_Width - 1, 0, kButton_Width, kButton_Height)];
    [_gyroscopeButton setImage:[UIImage imageNamed:@"gyro.png"] forState:UIControlStateNormal];
    [_gyroscopeButton addTarget:self action:@selector(changeGyro:) forControlEvents:UIControlEventTouchUpInside];
    [_barView addSubview:_gyroscopeButton];
}

- (void)addToNomalButton
{
    _toNomal = [[UIButton alloc] initWithFrame:CGRectMake(937, 75, 64, 64)];
    [_toNomal setImage:[UIImage imageNamed:@"nomal.png"] forState:UIControlStateNormal];
    [_toNomal setImage:[UIImage imageNamed:@"nomal_h.png"] forState:UIControlStateHighlighted];
    [_toNomal addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_toNomal];
}

- (void)addShareButton
{
    _shareButton = [[UIButton alloc] initWithFrame:CGRectMake( 2 * kButton_Width - 2, 0, kButton_Width, kButton_Height)];
    [_shareButton setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
    [_shareButton setImage:[UIImage imageNamed:@"share_d.png"] forState:UIControlStateHighlighted];
    [_shareButton addTarget:self action:@selector(showOrHiddenShareView:) forControlEvents:UIControlEventTouchUpInside];
    [_barView addSubview:_shareButton];
}

- (void)addSoundView
{
    _soundImage = [[UIImageView alloc] initWithFrame:CGRectMake(170 + kButton_Width * 1, 610 - 20, 574, 71)];
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
    
    _audioPlayer = [AudioPlayer getInstance];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"xue" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    [_audioPlayer.audioPlayer setNumberOfLoops:100000];
    [_audioPlayer setSlider:_playback];
    [_audioPlayer setSoundSlider:_sound];
    [_audioPlayer setDuration:_duration];
    [_audioPlayer setCurrentTime:_currentTime];
    [_audioPlayer setSoundFilePath:url andPlay:YES];
    [_audioPlayer setCanChangeSoundFile:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setSoundImage) name:PLAYER_SOUND_VALUME_CHANGED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPlayerButtonImage) name:PLAYER_STATE_CHANGED object:nil];
    [self setPlayerButtonImage];
}

- (void)addShareView
{
    _shareView = [[UIImageView alloc] initWithFrame:CGRectMake(kLCDH / 2 - 269 / 2, kLCDW / 2 - 209 / 2 - 17, 290, 207)];
    [_shareView setImage:[UIImage imageNamed:@"share_bg.png"]];
    [_shareView setUserInteractionEnabled:YES];
    [self.view addSubview:_shareView];
    
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(290 - 47, 0, 47, 45)];
    [closeBtn setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [closeBtn setImage:[UIImage imageNamed:@"close_d.png"] forState:UIControlStateHighlighted];
    [closeBtn addTarget:self action:@selector(hiddenShareView:) forControlEvents:UIControlEventTouchUpInside];
    [_shareView addSubview:closeBtn];
    [closeBtn release];
    
    UIButton *facebookBtn = [[UIButton alloc] initWithFrame:CGRectMake(47, 82, 75, 75)];
    [facebookBtn setImage:[UIImage imageNamed:@"facebook.png"] forState:UIControlStateNormal];
    [facebookBtn addTarget:self action:@selector(shareToFacebook:) forControlEvents:UIControlEventTouchUpInside];
    [_shareView addSubview:facebookBtn];
    [facebookBtn release];
    
    UIButton *twitterBtn = [[UIButton alloc] initWithFrame:CGRectMake(47 + 20 + 75, 82, 75, 75)];
    [twitterBtn setImage:[UIImage imageNamed:@"twitter.png"] forState:UIControlStateNormal];
    [twitterBtn addTarget:self action:@selector(shareToTwitter:) forControlEvents:UIControlEventTouchUpInside];
    [_shareView addSubview:twitterBtn];
    [twitterBtn release];
    
    [_shareView setAlpha:0.0f];
}

- (void)addTopImage
{
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kLCDH, 54.0f)];
    [topLabel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"top.png"]]];
    [topLabel setText:@"The Great Wall"];
    [topLabel setTextAlignment:NSTextAlignmentCenter];
    [topLabel setFont:[UIFont fontWithName:kFont_Name size:24.0f]];
    [topLabel setTextColor:[UIColor whiteColor]];
    [self.view addSubview:topLabel];
    [topLabel release];
}

#pragma mark -
#pragma mark about view show or hide
- (void)showOrHiddenSoundView:(id)sender
{
    static BOOL bo = YES;
    bo = !bo;
    if (bo)
    {
        [_soundButon setImage:[UIImage imageNamed:@"snowsound.png"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.5f animations:^{
            [_soundImage setAlpha:0.0f];
        } completion:^(BOOL finished) {
            
        }];
    }
    else
    {
        [_soundButon setImage:[UIImage imageNamed:@"snowsound_h.png"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.5f animations:^{
            [_soundImage setAlpha:1];
        } completion:^(BOOL finished) {
            
        }];
    }
}
- (void)hiddenShareView:(id)sender
{
    [_shareButton setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.5f animations:^{
        [_shareView setAlpha:0.0f];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)showOrHiddenShareView:(id)sender
{
    [_shareButton setImage:[UIImage imageNamed:@"share_d.png"] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.5f animations:^{
        [_shareView setAlpha:1.0f];
    } completion:^(BOOL finished) {
    }];
}


- (void)changeGyro:(id)sender
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
    }
}

- (void)shareToFacebook:(id)sender
{
    [self shareToSina];
}

- (void)shareToTwitter:(id)sender
{
    [self shareToTencent];
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

- (void)dismissSelf
{
    _audioPlayer.canChangeSoundFile = YES;
    [_delegate performSelector:@selector(sceneFinishedLoadAndChangeSound)];
    [_delegate performSelector:@selector(reloadAudioPlayer)];
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark share to facebook and twitter
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
        UIImage *image = [UIImage imageNamed:@"4.jpg"];
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
    if (!_tcShare)
    {
        _tcShare = [[TCShareSDK alloc] init];
        [_tcShare setDelegate:self];
    }
    if ([_tcShare weiboHasAreadyLogin])
    {
        UIImage *image = [UIImage imageNamed:@"4.jpg"];
        NSData *data = UIImageJPEGRepresentation(image, 0.5f);
        [_tcShare shareWithMessage:SHARE_MESSAGE andPic:data];
    }
    else
    {
        [_tcShare login];
    }
}

#pragma mark -
#pragma mark sina weibo delegate method

- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    UIImage *image = [UIImage imageNamed:@"4.jpg"];
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

//请求成功回调方法
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
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送新浪微博失败!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
