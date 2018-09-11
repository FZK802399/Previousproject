//
//  PanoDetailViewController.m
//  美丽中国
//
//  Created by 司马帅帅 on 15/7/22.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import "PanoDetailViewController.h"
#import "PanoInfo.h"
#import "MBProgressHUD.h"
#import "UIUtils.h"
#import "Header.h"
#import "PanoDetailBottomView.h"
#import "MapViewController.h"
#import "AudioDownloader.h"
#import <AVFoundation/AVFoundation.h>
#import "AFNetworking.h"
#import "CommentInfo.h"
#import "CommentUserInfo.h"
#import "CommentListCell.h"

//弹出的Frame
#define PopViewFrame CGRectMake(0.0f, [UIUtils getWindowHeight]-44.0f-44.0f-20.0f-200.0f, [UIUtils getWindowWidth], 200.0f)
//隐藏的Frame
#define HideViewFrame CGRectMake(0.0f, [UIUtils getWindowHeight]-44.0f-44.0f-20.0f, [UIUtils getWindowWidth], 200.0f)
//深度隐藏的Frame
#define ProHideViewFrame CGRectMake(0.0f, [UIUtils getWindowHeight]-44.0f-20.0f, [UIUtils getWindowWidth], 200.0f)

#define TEXT_COLOR [UIColor colorWithPatternImage:[UIImage imageNamed:@"dot.png"]]
#define POPVIEW_BACKGROUND_COLOR [UIColor colorWithPatternImage:[UIImage imageNamed:@"section_view_header_background.png"]]

@interface PanoDetailViewController ()<UIWebViewDelegate,UIGestureRecognizerDelegate,PDBVDelegate,AudioDownloaderDelegate,AVAudioPlayerDelegate,UITableViewDataSource,UITableViewDelegate,CommentListCellDelegate>
{
    PanoInfo *_panoInfo;
    UIWebView *_webView;//显示全景的UIWebView
    MBProgressHUD *_HUD;
    PanoDetailBottomView *_bottomView;//底部视图
    AudioDownloader *_audioDownloader;//语音下载器
    AudioDownloader *_commentAudioDownloader;//评论语音下载器
    AVAudioPlayer *_audioPlayer;//语音播放器
    AVAudioPlayer *_commentAudioPlayer;//评论语音播放器
    
    UIView *_descriptionPopView;//文字简介弹出视图
    UITextView *_descriptionTextView;//文字简介视图
    UIView *_commentListPopView;//评论列表弹出视图
    UILabel *_commentCountLabel;//评论人数标签
    UITableView *_commentListTableView;//评论列表视图
    UIView *_sharePopView;//分享弹出视图
    UIImageView *_cityHeaderView;//城市头像视图
    
    NSMutableArray *_commentInfoArray;//承载CommentInfo对象的数组
    
    int _playAudioIndex;//播放语音的index
}
@end

@implementation PanoDetailViewController

- (void)dealloc
{
    NSLog(@"PanoDetailViewController dealloc");
    _webView.delegate = nil;
    _audioPlayer.delegate = nil;
    _commentAudioPlayer.delegate = nil;
    _audioDownloader.delegate = nil;
    _commentAudioDownloader.delegate = nil;
}

- (id)initWithPanoInfo:(PanoInfo*)panoInfo
{
    self = [super init];
    if (self) {
        _panoInfo = panoInfo;
        _playAudioIndex = 0;//默认值
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _panoInfo.name;
    
    //设置导航栏
    [self setNavigationBar];
    
    //添加_webView
    [self addWebView];
    
    //添加文字简介弹出视图
    [self addDescriptionPopView];
    
    //添加分享弹出视图
    [self addSharePopView];
    
    //添加评论列表弹出视图
    [self addCommentListPopView];
    
    //添加底部视图 和 城市头像视图
    [self addBottomViewAndCityHeaderView];
    
    //加载评论数据
    [self loadCommentListData];
}

#pragma mark UI界面显示
//添加_webView
- (void)addWebView
{
    CGRect frame = self.view.frame;
    frame.origin.y = -44-20;
    _webView = [[UIWebView alloc] initWithFrame:frame];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    //请求接口
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_panoInfo.panoUrl]];
    [_webView loadRequest:request];
    NSLog(@"全景接口 %@",_panoInfo.panoUrl);
    
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapWebView)];
    doubleTapGesture.numberOfTapsRequired = 2;
    doubleTapGesture.delegate = self;
    [_webView addGestureRecognizer:doubleTapGesture];
}

//添加底部视图 和 城市头像视图
- (void)addBottomViewAndCityHeaderView
{
    //底部视图
    _bottomView = [[PanoDetailBottomView alloc] initWithFrame:CGRectMake(0, [UIUtils getWindowHeight]-44-44-20, [UIUtils getWindowWidth], 44)];
    _bottomView.delegate = self;
    [self.view addSubview:_bottomView];
    
    //城市头像视图
    _cityHeaderView = [[UIImageView alloc] initWithFrame:CGRectMake([UIUtils getWindowWidth]-60, CGRectGetMinY(_bottomView.frame)-60.0f, 60.0f, 60.0f)];
    _cityHeaderView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_icon.png",_panoInfo.province]];
    [self.view addSubview:_cityHeaderView];
}

//添加文字简介弹出视图
- (void)addDescriptionPopView
{
    //添加简介弹出视图
    _descriptionPopView = [[UIView alloc] initWithFrame:HideViewFrame];
    _descriptionPopView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_descriptionPopView];
    
    //添加弹出视图上方标签
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIUtils getWindowWidth], 25.0f)];
    descriptionLabel.backgroundColor = POPVIEW_BACKGROUND_COLOR;
    descriptionLabel.textColor = TEXT_COLOR;
    descriptionLabel.font = [UIFont systemFontOfSize:14];
    descriptionLabel.text = @"   文字简介";
    [_descriptionPopView addSubview:descriptionLabel];
    
    //添加简介视图
    _descriptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(0.0f, 25.0f, [UIUtils getWindowWidth], 175.0f)];
    _descriptionTextView.bounces = NO;
    _descriptionTextView.editable = NO;
    _descriptionTextView.textColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8f];
    _descriptionTextView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundImage.png"]];
    _descriptionTextView.font = [UIFont systemFontOfSize:16];
    if ([UIUtils isBlankString:_panoInfo.panoDescription]) {
        _descriptionTextView.text = @"很抱歉,该景区暂时没有详细简介!";
    } else {
        _descriptionTextView.text = _panoInfo.panoDescription;
    }
    [_descriptionPopView addSubview:_descriptionTextView];
}

//添加分享弹出视图
- (void)addSharePopView
{
    _sharePopView = [[UIView alloc] initWithFrame:HideViewFrame];
    _sharePopView.backgroundColor = POPVIEW_BACKGROUND_COLOR;
    [self.view addSubview:_sharePopView];
}

//添加评论列表弹出视图
- (void)addCommentListPopView
{
    //添加评论列表弹出视图
    _commentListPopView = [[UIView alloc] initWithFrame:HideViewFrame];
    [self.view addSubview:_commentListPopView];
    
    //添加弹出视图上方标签
    _commentCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIUtils getWindowWidth], 25.0f)];
    _commentCountLabel.backgroundColor = POPVIEW_BACKGROUND_COLOR;
    _commentCountLabel.textColor = TEXT_COLOR;
    _commentCountLabel.font = [UIFont systemFontOfSize:14.0f];
    _commentCountLabel.text = [NSString stringWithFormat:@"   %@人评论", _panoInfo.commentCount];
    [_commentListPopView addSubview:_commentCountLabel];
    
    //添加评论列表视图
    _commentListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 25.0f, [UIUtils getWindowWidth], 175.0f) style:UITableViewStylePlain];
    _commentListTableView.bounces = NO;
    _commentListTableView.delegate = self;
    _commentListTableView.dataSource = self;
    [_commentListPopView addSubview:_commentListTableView];
}

//设置导航栏
- (void)setNavigationBar
{
    //设置返回按钮
    UIImage *backImageNormal = [UIImage imageNamed:@"nav_back_button_normal.png"];
    UIImage *backImageHighlight = [UIImage imageNamed:@"nav_back_button_highlight.png"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(15.0f, 5.0f, backImageNormal.size.width/1.8, backImageNormal.size.height/1.8);
    [backButton setBackgroundImage:backImageNormal forState:UIControlStateNormal];
    [backButton setBackgroundImage:backImageHighlight forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backBarButton;
    
    //设置地图按钮
    UIImage *mapButtonImageNormal = [UIImage imageNamed:@"map_button_normal.png"];
    UIImage *mapButtonImageHighlight = [UIImage imageNamed:@"map_button_normal.png"];
    UIButton *mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    mapButton.frame = CGRectMake(0.0f, 0.0f, mapButtonImageNormal.size.width/2, mapButtonImageNormal.size.height/2);
    [mapButton setBackgroundImage:mapButtonImageNormal forState:UIControlStateNormal];
    [mapButton setBackgroundImage:mapButtonImageHighlight forState:UIControlStateHighlighted];
    [mapButton addTarget:self action:@selector(showMap) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *mapBarButton = [[UIBarButtonItem alloc] initWithCustomView:mapButton];
    self.navigationItem.rightBarButtonItem = mapBarButton;

}

#pragma mark 执行操作

//播放语音
- (void)playAudio
{
    //初始化语音播放器_audioPlayer
    if (!_audioPlayer) {
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:_audioDownloader.audioFilePath] error:nil];
        //设置声音大小
        [_audioPlayer setVolume:1.0f];
        _audioPlayer.delegate = self;
    }
    
    if (_audioPlayer.isPlaying) {
        NSLog(@"正在播放 现在暂停");
        [_audioPlayer pause];
        //显示_bottomView的playAudioBaseView
        [_bottomView.playAudioBaseView setHidden:NO];
        //_bottomView的playAudioIndicatorView停止旋转
        [_bottomView.playAudioIndicatorView stopAnimating];
        //_bottomView的playAudioAnimationView停止做动画
        [_bottomView.playAudioAnimationView stopAnimating];
    } else {
        NSLog(@"已经暂停 现在播放");
        [_audioPlayer prepareToPlay];
        [_audioPlayer play];
        //隐藏_bottomView的playAudioBaseView
        [_bottomView.playAudioBaseView setHidden:YES];
        //_bottomView的playAudioIndicatorView停止旋转
        [_bottomView.playAudioIndicatorView stopAnimating];
        //_bottomView的playAudioAnimationView开始做动画
        [_bottomView.playAudioAnimationView startAnimating];
    }
}

//播放评论语音
- (void)playCommentAudio
{
    //初始化评论语音播放器_commentAudioPlayer
    if (!_commentAudioPlayer) {
        NSLog(@"zoumeizou");
        _commentAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:_commentAudioDownloader.audioFilePath] error:nil];
        [_commentAudioPlayer setVolume:1.0f];
        _commentAudioPlayer.delegate = self;
    }
    
    //获取正在播放语音的CommentListCell
    CommentListCell *playAudioCell = [self getPlayAudioCell];
    
    if (_commentAudioPlayer.isPlaying) {
        NSLog(@"评论语音正在播放 现在暂停");
        [_commentAudioPlayer pause];
        
        //显示playAudioCell的audioButtonBaseView
        [playAudioCell.audioButtonBaseView setHidden:NO];
        //playAudioCell的audioButtonIndicatorView停止旋转
        [playAudioCell.audioButtonIndicatorView stopAnimating];
        //playAudioCell的audioButtonAnimationView停止做动画
        [playAudioCell.audioButtonAnimationView stopAnimating];
        
    } else {
        NSLog(@"评论语音已经暂停 现在播放");
        [_commentAudioPlayer prepareToPlay];
        [_commentAudioPlayer play];
        
        //隐藏playAudioCell的audioButtonBaseView
        [playAudioCell.audioButtonBaseView setHidden:YES];
        //playAudioCell的audioButtonIndicatorView停止旋转
        [playAudioCell.audioButtonIndicatorView stopAnimating];
        //playAudioCell的audioButtonAnimationView开始做动画
        [playAudioCell.audioButtonAnimationView startAnimating];
    }
}

//双击_webView
- (void)tapWebView
{
    NSLog(@"双击_webView");
    CGRect navigationBarFrame = self.navigationController.navigationBar.frame;
    //动画开始前 先隐藏_descriptionPopView和_commentListPopView和_sharePopView
    if (navigationBarFrame.origin.y == 20) {
        [_descriptionPopView setFrame:ProHideViewFrame];
        [_commentListPopView setFrame:ProHideViewFrame];
        [_sharePopView setFrame:ProHideViewFrame];
        
    } else {
        [_bottomView setHidden:NO];
    }
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect navigationBarFrame = self.navigationController.navigationBar.frame;
                         CGRect bottomViewFrame = _bottomView.frame;
                         CGRect cityHeaderViewFrame = _cityHeaderView.frame;
                         if (navigationBarFrame.origin.y == 20) {
                             //重置按钮被选中状态
                             [_bottomView resetSelectedButton];
                             //隐藏navigationBar
                             navigationBarFrame.origin.y = -44;
                             bottomViewFrame.origin.y = bottomViewFrame.origin.y+44;
                             cityHeaderViewFrame.origin.y = cityHeaderViewFrame.origin.y+44;
                         } else {
                             //显示navigationBar
                             navigationBarFrame.origin.y = 20;
                             bottomViewFrame.origin.y = bottomViewFrame.origin.y-44;
                             cityHeaderViewFrame.origin.y = cityHeaderViewFrame.origin.y-44;
                         }
                         [self.navigationController.navigationBar setFrame:navigationBarFrame];
                         [_bottomView setFrame:bottomViewFrame];
                         [_cityHeaderView setFrame:cityHeaderViewFrame];
                     } completion:^(BOOL finished) {
                         //动画结束后再恢复_descriptionPopView和_commentListPopView和_sharePopView
                         if (navigationBarFrame.origin.y == -44) {                             [_descriptionPopView setFrame:HideViewFrame];
                             [_commentListPopView setFrame:HideViewFrame];
                             [_sharePopView setFrame:HideViewFrame];
                             
                         } else {
                             [_bottomView setHidden:YES];
                         }

                     }];
}

//点击地图按钮
- (void)showMap
{
    //重置解说播放
    [self resetAudioPlayer];
    //重置评论播放
    [self resetCommentAudioPlayer];
    
    MapViewController *mapViewController = [[MapViewController alloc] initWithPanoInfo:_panoInfo];
    [self.navigationController pushViewController:mapViewController animated:YES];
}

//点击返回按钮
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

//加载评论数据
- (void)loadCommentListData
{
    NSString *userID = [USER_DEFAULT objectForKey:@"UserId"];
    
    //AFNetworking 发送GET请求
    NSString *urlString = [NSString stringWithFormat:@"%@%@",LOCAL_HOST,PANO_COMMENT_LIST_REQUEST];
    //请求参数
    NSDictionary *parameters = @{@"appKey":APPKEY,@"userId":userID,@"panoId":_panoInfo.panoId,@"sign":@"1"};
    //初始化请求（同时也创建了一个线程）
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //设置请求可以接受的内容的样式
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //发送GET请求
    [manager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"请求成功 %@",responseObject);
        //初始化_commentInfoArray
        if (!_commentInfoArray) {
            _commentInfoArray = [[NSMutableArray alloc] init];
        }
        NSArray *array = (NSArray *)responseObject;
        for (NSDictionary *dictionary in array) {
            CommentInfo *commentInfo = [[CommentInfo alloc] initWithDictionary:dictionary];
            [_commentInfoArray addObject:commentInfo];
        }
        [_commentListTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败 %@",error);
    }];
}

//获取正在播放语音的CommentListCell
- (CommentListCell *)getPlayAudioCell
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_playAudioIndex inSection:0];
    //获取播放语音的cell
    CommentListCell *playAudioCell = (CommentListCell *)[_commentListTableView cellForRowAtIndexPath:indexPath];
    return playAudioCell;
}

//重置解说播放
- (void)resetAudioPlayer
{
    if (_audioPlayer.isPlaying) {
        [_audioPlayer stop];
    }
    if (_audioPlayer) {
        _audioPlayer.delegate = nil;
        _audioPlayer = nil;
    }
    //如果_audioDownloader正在下载则 删除_audioDownloader
    if (_audioDownloader.isAudioDownloading) {
        _audioDownloader.delegate = self;
        _audioDownloader = nil;
    }
    [_bottomView.playAudioBaseView setHidden:NO];
    [_bottomView.playAudioAnimationView stopAnimating];
    [_bottomView.playAudioIndicatorView stopAnimating];
}

//重置评论播放
- (void)resetCommentAudioPlayer
{
    if (_commentAudioPlayer.isPlaying) {
        [_commentAudioPlayer stop];
    }
    if (_commentAudioPlayer) {
        _commentAudioPlayer.delegate = nil;
        _commentAudioPlayer = nil;
    }
    
    //只要点击一个新的评论播放按钮就要删除_commentAudioDownloader 因为评论的语音路径取决于_commentAudioDownloader
    _commentAudioDownloader.delegate = nil;
    _commentAudioDownloader = nil;
    
    //获得正在播方法的CommentListCell
    CommentListCell *playAudioCell = [self getPlayAudioCell];
    [playAudioCell.audioButtonBaseView setHidden:NO];
    [playAudioCell.audioButtonAnimationView stopAnimating];
    [playAudioCell.audioButtonIndicatorView stopAnimating];
    
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

#pragma mark UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)aWebView {
    NSLog(@"全景加载开始");
    //显示提示
    [self show:MBProgressHUDModeIndeterminate message:@"努力加载中......" customView:self.view];
}
- (void)webViewDidFinishLoad:(UIWebView *)aWebView {
    NSLog(@"全景加载完成");
    //隐藏HUD
    //隐藏HUD
    [self hideHUDafterDelay:0.3f];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"全景加载失败");
    //隐藏HUD
    [self hideHUDafterDelay:0.3f];
}

#pragma mark UIGestureRecognizerDelegate
//如果返回YES允许多个手势并存 否则不允许 默认返回NO
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark PDBVDelegate
//点击语音解说播放按钮
- (void)pdbvPlayAudioButtonPressed
{
    NSLog(@"pdbvPlayAudioButtonPressed");

    //重置评论播放
    [self resetCommentAudioPlayer];
    
    //初始化语音下载器_audioDownloader
    if (!_audioDownloader) {
        _audioDownloader = [[AudioDownloader alloc] initWithPanoID:_panoInfo.panoId];
        _audioDownloader.delegate = self;
    }
    
    //如果下载的语音存在
    if ([[NSFileManager defaultManager] fileExistsAtPath:_audioDownloader.audioFilePath]) {
        
        NSLog(@"播放语音");
        //播放语音"
        [self playAudio];
        
    //如果要下载的语音不存在则开始下载
    } else {
        //下载语音
        [_audioDownloader downloadWithUrl:_panoInfo.audioUrl];
    }
}

- (void)pdbvDescriptionButtonPressed
{
    NSLog(@"pdbvDescriptionButtonPressed");
    //隐藏_commentListPopView和_sharePopView
    if (_commentListPopView.frame.origin.y == PopViewFrame.origin.y) {
        [_commentListPopView setFrame:HideViewFrame];
    }
    if (_sharePopView.frame.origin.y == PopViewFrame.origin.y) {
        [_sharePopView setFrame:HideViewFrame];
    }
    //显示或隐藏_descriptionPopView
    [UIView animateWithDuration:0.4f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         if (_descriptionPopView.frame.origin.y == HideViewFrame.origin.y) {
                             [_descriptionPopView setFrame:PopViewFrame];
                         } else {
                             [_descriptionPopView setFrame:HideViewFrame];
                         }
                     } completion:nil];
}

- (void)pdbvCommentListButtonPressed
{
    NSLog(@"pdbvCommentListButtonPressed");
    //隐藏_descriptionPopView和_sharePopView
    if (_descriptionPopView.frame.origin.y == PopViewFrame.origin.y) {
        [_descriptionPopView setFrame:HideViewFrame];
    }
    if (_sharePopView.frame.origin.y == PopViewFrame.origin.y) {
        [_sharePopView setFrame:HideViewFrame];
    }
    //显示或隐藏_descriptionPopView
    [UIView animateWithDuration:0.4f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         if (_commentListPopView.frame.origin.y == HideViewFrame.origin.y) {
                             [_commentListPopView setFrame:PopViewFrame];
                         } else {
                             [_commentListPopView setFrame:HideViewFrame];
                         }
                     } completion:nil];
}

- (void)pdbvShareButtonPressed
{
    NSLog(@"pdbvShareButtonPressed");
    //隐藏_descriptionPopView和_sharePopView
    if (_descriptionPopView.frame.origin.y == PopViewFrame.origin.y) {
        [_descriptionPopView setFrame:HideViewFrame];
    }
    if (_commentListPopView.frame.origin.y == PopViewFrame.origin.y) {
        [_commentListPopView setFrame:HideViewFrame];
    }
    //显示或隐藏_descriptionPopView
    [UIView animateWithDuration:0.4f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         if (_sharePopView.frame.origin.y == HideViewFrame.origin.y) {
                             [_sharePopView setFrame:PopViewFrame];
                         } else {
                             [_sharePopView setFrame:HideViewFrame];
                         }
                     } completion:nil];
}

#pragma mark AudioDownloaderDelegate
//语音下载开始
- (void)audioDownloaderStart
{
    //隐藏_bottomView的playAudioBaseView
    [_bottomView.playAudioBaseView setHidden:YES];
    //_bottomView的playAudioIndicatorView开始旋转
    [_bottomView.playAudioIndicatorView startAnimating];
}

//语音下载结束
- (void)audioDownloaderFinished
{
    //播放语音
    [self playAudio];
}

//语音下载失败
- (void)audioDownloaderFailed
{
    //显示_bottomView的playAudioBaseView
    [_bottomView.playAudioBaseView setHidden:NO];
    //_bottomView的playAudioIndicatorView停止旋转
    [_bottomView.playAudioIndicatorView stopAnimating];
}

//评论语音开始下载
- (void)commentAudioDownloaderStart
{
    //获取正在播放语音的CommentListCell
    CommentListCell *playAudioCell = [self getPlayAudioCell];
    //隐藏playAudioCell的audioButtonBaseView
    [playAudioCell.audioButtonBaseView setHidden:YES];
    //playAudioCell的audioButtonIndicatorView开始旋转
    [playAudioCell.audioButtonIndicatorView startAnimating];
}

//评论语音下载完成
- (void)commentAudioDownloaderFinished
{
    //播放评论语音
    [self playCommentAudio];
}

//评论语音下载失败
- (void)commentAudioDownloaderFailed
{
    //获取正在播放语音的CommentListCell
    CommentListCell *playAudioCell = [self getPlayAudioCell];
    //显示playAudioCell的audioButtonBaseView
    [playAudioCell.audioButtonBaseView setHidden:NO];
    //playAudioCell的audioButtonIndicatorView停止旋转
    [playAudioCell.audioButtonIndicatorView stopAnimating];
}

#pragma mark AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    //显示_bottomView的playAudioBaseView
    [_bottomView.playAudioBaseView setHidden:NO];
    //_bottomView的playAudioIndicatorView停止旋转
    [_bottomView.playAudioAnimationView stopAnimating];
    
    //获取正在播放语音的CommentListCell
    CommentListCell *playAudioCell = [self getPlayAudioCell];
    //显示playAudioCell的audioButtonBaseView
    [playAudioCell.audioButtonBaseView setHidden:NO];
    //playAudioCell的audioButtonAnimationView停止转动
    [playAudioCell.audioButtonAnimationView stopAnimating];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _commentInfoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    CommentListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[CommentListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.delegate = self;
    }
    cell.audioButton.tag = indexPath.row;
    CommentInfo *commentInfo = _commentInfoArray[indexPath.row];
    [cell setContentView:commentInfo];
    
    //tableView滚动时 当_commentAudioPlayer正在播放 设置相应的audioButtonBaseView和audioButtonAnimationView和audioButtonIndicatorView 
    if (_commentAudioPlayer.isPlaying) {
        if (_playAudioIndex == indexPath.row) {
            [cell.audioButtonBaseView setHidden:YES];
            [cell.audioButtonAnimationView startAnimating];
            [cell.audioButtonIndicatorView stopAnimating];
        } else {
            [cell.audioButtonBaseView setHidden:NO];
            [cell.audioButtonAnimationView stopAnimating];
            [cell.audioButtonIndicatorView stopAnimating];
        }
    }
    
    //tableView滚动时 当_commentAudioDownloader正在下载 设置相应的audioButtonBaseView和audioButtonAnimationView和audioButtonIndicatorView
    if (_commentAudioDownloader.isCommentAudioDownloading) {
        if (_playAudioIndex == indexPath.row) {
            [cell.audioButtonBaseView setHidden:YES];
            [cell.audioButtonAnimationView stopAnimating];
            [cell.audioButtonIndicatorView startAnimating];
        } else {
            [cell.audioButtonBaseView setHidden:NO];
            [cell.audioButtonAnimationView stopAnimating];
            [cell.audioButtonIndicatorView stopAnimating];
        }
    }
    
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [CommentListCell getCellHeight];
}

#pragma mark CommentListCellDelegate
- (void)commentListCellAudioButtonPressed:(int)index
{
    NSLog(@"点击评论语音 %d",index);
    //如果这次点击的和上次点击的不是同一个语音播放按钮
    if (_playAudioIndex != index) {
        
        //重置解说播放
        [self resetAudioPlayer];
        //重置评论播放
        [self resetCommentAudioPlayer];
        
        //获取新的播放的index
        _playAudioIndex = index;
    }
    
    //获取播放语音的CommentInfo对象
    CommentInfo *commentInfo = _commentInfoArray[index];
    //初始化评论语音下载器_commentAudioDownloader
    if (!_commentAudioDownloader) {
        _commentAudioDownloader = [[AudioDownloader alloc] initWithUserID:commentInfo.commentUserInfo.userId commentOriginalTime:commentInfo.commentOriginalTime];
        _commentAudioDownloader.delegate = self;
    }
    //如果下载的评论语音存在
    if ([[NSFileManager defaultManager] fileExistsAtPath:_commentAudioDownloader.audioFilePath]) {
        
        NSLog(@"播放评论语音");
        //播放评论语音
        [self playCommentAudio];
        
    //如果要下载的评论语音不存在则开始下载
    } else {
        //下载评论语音
        NSString *commentAudioUrl = [NSString stringWithFormat:@"%@/uploadfile/audio/%@/%@/%@.m4a",LOCAL_HOST_SECONDE,commentInfo.commentUserInfo.userId,_panoInfo.panoId,commentInfo.commentOriginalTime];
        NSLog(@"请求的评论语音路径 %@", commentAudioUrl);
        [_commentAudioDownloader downloadWithUrl:commentAudioUrl];
    }
}

@end








