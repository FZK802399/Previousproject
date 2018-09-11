//
//  ForbiddenCityDownloadViewViewController.m
//  BeiJing360
//
//  Created by Duke Douglas on 13-3-21.
//  Copyright (c) 2013年 __ChuangYiFengTong__. All rights reserved.
//

#import "ForbiddenCityViewController.h"
#import "IAPManager.h"
#import "SVProgressHUD.h"

#define kPathOfHtml @"gugong_iphone/tour1.html"

#define kWidth self.view.bounds.size.width
#define kHeight self.view.bounds.size.height
#define kOffSet 380

@interface ForbiddenCityViewController ()
{
    NSUInteger _totleSize;
    
    ASIHTTPRequest *_request;         //下载请求
    
    UIView *_downloadingView;         //下载视图
    UIProgressView *_downloadProgressView;
    UIActivityIndicatorView *_identifier;
    UILabel *_totleDataLabel;
    UILabel *_currentDataLabel;
    UILabel *_downloadLabel;
    UIButton *_closeBotton;
    UIButton *_downloadingButton;
    UILabel *_downloadDataLabel;      //下载button上的小label
    
    BOOL _isPayment;                  //判断当前按钮是购买按钮还是下载按钮
    BOOL _isDownloading;              //当前是否正在下载
    BOOL _isDismiss;                  //菊花是否存在
    
    UIScrollView *_paymentView;       //展示商品视图
    UIButton *_paymentButton;         //购买按钮
    UIScrollView *_imageScroll;
    UIButton *_nextButton;            //下一张图片按钮
    UIButton *_prevButton;            //上一张按钮
    
}

@end

@implementation ForbiddenCityViewController

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
    [self.view setBackgroundColor:[UIColor grayColor]];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(goBack:)];
    self.navigationItem.leftBarButtonItem = item;
    [item release];
    
    [self setTitle:@"故宫全景"];
    _isDismiss = YES;
    
    IAPManager *iapManager = [IAPManager getInstance];
    //判断商品是否已经购买
    if ([iapManager wasAlreadyPayment])         //已经购买
    {
        _isPayment = YES;
        if ([self unarchiveFileIsExist])         //判断文件是否已经下载
        {
            _isDownloaded = YES;
            [self showView];
        }
        else                                    
        {
            _isDownloaded = NO;
            [self showPaymentView];
            [self downloadRequest];
        }
    }
    else
    {
        _isPayment = NO;
        _isDownloaded = NO;
        [self showPaymentView];
    }
}

//当界面返回时，如果正在下载，则停止下载
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //如果正在请求商品，退出界面之前则停止进度轮
    if (!_isPayment)
    {
        [SVProgressHUD dismiss];
    }
    
}
- (void)goBack:(id)sender
{
    //如果正在下载，则停止下载
    if (_isDownloading)
    {
        NSString *mes = [NSString stringWithFormat:@"您已经下载了%2.0f%%,退出界面将暂停下载，再次进入界面是将继续下载", _downloadProgressView.progress * 100];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:mes delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert setDelegate:self];
        [alert show];
        [alert release];
//        [_request clearDelegatesAndCancel];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -
#pragma mark alert view delegate method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%d",buttonIndex);
    if (buttonIndex == 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -
#pragma mark show payment view
//显示购买界面
- (void)showPaymentView
{
    //整个视图是一个ScrollView
    _paymentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 44)];
    _paymentView.bounces = NO;
    //加背景
    UIImage *image = [UIImage imageNamed:@"backgrand.png"];
    [_paymentView setContentSize:image.size];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [imageView setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [_paymentView addSubview:imageView];
    [imageView release];
    imageView = nil;
    //加购买按钮
    _paymentButton = [[UIButton alloc] initWithFrame:CGRectMake(_paymentView.bounds.size.width - 90, 230 / 2 , 70, 24)];
    [_paymentButton setBackgroundImage:[UIImage imageNamed:@"button2.png"] forState:UIControlStateNormal];
    [_paymentButton addTarget:self action:@selector(paymentProduct:) forControlEvents:UIControlEventTouchUpInside];
    [_paymentView addSubview:_paymentButton];
    //加载下载按钮
    _downloadingButton = [[UIButton alloc] initWithFrame:CGRectMake(_paymentView.bounds.size.width - 90, 230 / 2 , 70, 24)];
    [_downloadingButton setBackgroundImage:[UIImage imageNamed:@"downloading.png"] forState:UIControlStateNormal];
    [_downloadingButton addTarget:self  action:@selector(beginDownload:) forControlEvents:UIControlEventTouchUpInside];
    _downloadDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(84 / 2, 48 / 4 - 7, 44 / 2 + 5, 28 / 2)];
    _downloadDataLabel.backgroundColor = [UIColor clearColor];
    _downloadDataLabel.textColor = [UIColor whiteColor];
    _downloadDataLabel.textAlignment = UITextAlignmentCenter;
    _downloadDataLabel.font = [UIFont boldSystemFontOfSize:10.5];
    [_downloadDataLabel setUserInteractionEnabled:YES];
    [_downloadingButton addSubview:_downloadDataLabel];
    [_paymentView addSubview:_downloadingButton];
    //判断当前是哪一个button
    [self hiddenPaymentButton];
    //加如下面的展示图片
    _imageScroll = [[UIScrollView alloc] initWithFrame:CGRectMake((_paymentView.bounds.size.width - 417 / 2) / 2, _paymentView.contentSize.height - 600 / 2, 417 / 2, 542 / 2)];
    [_imageScroll setContentSize:CGSizeMake(417, 542 / 2)];
    [_imageScroll setPagingEnabled:YES];
    [_imageScroll setShowsHorizontalScrollIndicator:NO];
    [_imageScroll setDelegate:self];
    
    UIImageView *scrollImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 417 / 2, 542 / 2)];
    [scrollImage1 setImage:[UIImage imageNamed:@"scrollimage1.png"]];
    [_imageScroll addSubview:scrollImage1];
    UIImageView *scrollImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(417 / 2, 0.0f, 417 / 2, 542 / 2)];
    [scrollImage2 setImage:[UIImage imageNamed:@"scrollimage2.png"]];
    [_imageScroll addSubview:scrollImage2];
    [_paymentView addSubview:_imageScroll];
    [scrollImage1 release];
    scrollImage1 = nil;
    [scrollImage2 release];
    scrollImage2 = nil;
    //加入上一页和下一页按钮
    _nextButton = [[UIButton alloc] initWithFrame:CGRectMake(_paymentView.contentSize.width - 78 / 2, _paymentView.contentSize.height - 385 / 2, 33 / 2, 55 / 2)];
    [_nextButton setBackgroundImage:[UIImage imageNamed:@"point1.png"] forState:UIControlStateNormal];
    [_nextButton addTarget:self action:@selector(nextPage:) forControlEvents:UIControlEventTouchUpInside];
    _prevButton = [[UIButton alloc] initWithFrame:CGRectMake((78 - 55 / 2) / 2, _paymentView.contentSize.height - 385 / 2, 33 / 2, 55 / 2)];
    [_prevButton setBackgroundImage:[UIImage imageNamed:@"point2.png"] forState:UIControlStateNormal];
    [_prevButton addTarget:self action:@selector(prevPage:) forControlEvents:UIControlEventTouchUpInside];
    [_prevButton setHidden:YES];
    [_paymentView addSubview:_prevButton];
    [_paymentView addSubview:_nextButton];
    [self.view addSubview:_paymentView];

    
}

//隐藏购买界面
- (void)hiddenPaymentView
{
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [_paymentView setAlpha:0.0f];
    [UIView commitAnimations];
}

- (void)showNavigationBar
{
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationDuration:0.35f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    if (self.navigationController.navigationBar.frame.origin.y == 20)
    {
        [self.navigationController.navigationBar setFrame:CGRectMake(0, -24, 320, 44)];
    }
    else
    {
        [self.navigationController.navigationBar setFrame:CGRectMake(0, 20, 320, 44)];
    }
    [UIView commitAnimations];
}

//隐藏购买按钮
- (void)hiddenPaymentButton
{
    if (_isDownloading)
    {
        [_downloadingButton setHidden:NO];
        [_paymentButton setHidden:YES];
    }
    else
    {
        [_downloadingButton setHidden:YES];
        [_paymentButton setHidden:NO];
    }

}

#pragma mark -
#pragma mark payment methods

//购买按钮回调方法
- (void)paymentProduct:(id)sender
{
        [self beginPayment];
}
//开始购买
- (void)beginPayment
{
    [SVProgressHUD showWithStatus:@"加载商品中，请耐心等待。。。"];
    IAPManager *iapManager = [IAPManager getInstance];
    [iapManager setDelegate:self];
    [iapManager loadProduct];
}
//加载商品成功
- (void)loadProductSuccessful
{
    [SVProgressHUD showWithStatus:@"商品加载成功，正在交易。。。"];
    
}
//交易成功
- (void)successPaymentTransaction
{
    [SVProgressHUD showSuccessWithStatus:@"交易成功，开始下载"];
    //开始下载文件
    [self downloadRequest];
}
//交易失败
- (void)failedPaymentTransaction
{
    [SVProgressHUD showErrorWithStatus:@"交易失败!!"];
}

#pragma mark -
#pragma mark scroller view delegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x == 417 / 2)
    {
        [_prevButton setHidden:NO];
        [_nextButton setHidden:YES];
    }
    if (scrollView.contentOffset.x == 0)
    {
        [_prevButton setHidden:YES];
        [_nextButton setHidden:NO];
    }
}

//上一页回调方法
- (void)prevPage:(id)sender
{
    [_imageScroll setContentOffset:CGPointMake(0, 0) animated:YES];
    [_prevButton setHidden:YES];
    [_nextButton setHidden:NO];
}
//下一页回调方法
- (void)nextPage:(id)sender
{
    [_imageScroll setContentOffset:CGPointMake(417 / 2, 0) animated:YES];
    [_prevButton setHidden:NO];
    [_nextButton setHidden:YES];
}

#pragma mark - file is exist
//下载的zip文件是否存在
-(BOOL)downloadFileIsExist
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:[self downloadFilePath]];
}
//解压的文件是否存在
- (BOOL)unarchiveFileIsExist
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:[self pathOfHtml]])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark - download request
//下载请求
- (void)downloadRequest
{
    [self fileDownloadView];  //正在下载中的视图
    _isDownloading = YES;
    _isPayment = YES;
    [self hiddenPaymentButton];
    [self beginDownload:nil];
    _request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:kFORBIDDEN_CITY_DOWNLOAD_URL]];
    [_request setDownloadDestinationPath:[self downloadFilePath]];  //设置下载路径
    [_request setDownloadProgressDelegate:self];                    //设置进度条
    [_request setTemporaryFileDownloadPath:[self pathOfCache]];     //设置缓存路径
    [_request setAllowResumeForFileDownloads:YES];                  //允许断点续传
    [_request setDelegate:self];                                    //设置代理为自己
    [_request setDidFinishSelector:@selector(downloadFinished:)];   //设置回调方法
    [_request startAsynchronous];                                   //开始异步下载
}
//下载完成
- (void)downloadFinished:(id)sender
{
    //解压文件
    [self unchiveFile];
    _isDownloading = NO;
}

#pragma mark - show view
//展示的View
- (void)showView
{
    if (!_isDismiss)
    {
        [SVProgressHUD dismiss];
    }
    if ([self htmlIsExist])
    {
        [self hiddenView];
        _showWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 480 - 20 - 44)];
        NSURLRequest *showRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:[self pathOfHtml]]];
        [_showWebView loadRequest:showRequest];
        [self.view addSubview:_showWebView];
        [_showWebView release];
        _showWebView = nil;
    }
}

#pragma mark - download views

//下载按钮回调方法
- (void)beginDownload:(id)sender
{
    if (_isDownloading)
    {
        if ([_downloadingView isHidden])
        {
            [_downloadingView setHidden:NO];
        }
        else
        {
            [_downloadingView setHidden:YES];
        }
    }
    else
    {
        [self downloadRequest];
    }
    
}

//下载中的view
 - (void)fileDownloadView
{
    _downloadingView = [[UIView alloc] initWithFrame:CGRectMake( 20, 220.0f, kWidth - 40,  90)];
    [_downloadingView setBackgroundColor:[UIColor blackColor]];
    [_downloadingView setAlpha:0.75f];
    [_downloadingView.layer setShadowOffset:CGSizeMake(5,5)];
    [_downloadingView.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [_downloadingView.layer setShadowOpacity:0.5f];
    [_downloadingView.layer setCornerRadius:15];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 32 / 2, 32 / 2)];
    [button setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closeDwonloadView:) forControlEvents:UIControlEventTouchUpInside];
    [_downloadingView addSubview:button];
    [button release];
    button = nil;
    [_paymentView addSubview:_downloadingView];
    [self fileDownloadingProgressView];
    [self fileDownloadingLabel];
    [self fileDownloadingDataLabel];
    [_downloadingView setHidden:YES];
}
//下载过程的进度条
- (void)fileDownloadingProgressView
{
    if (!_downloadProgressView) {
        _downloadProgressView = [[UIProgressView alloc] initWithFrame:CGRectMake(10.0f, _downloadingView.bounds.size.height / 2 - 3.5f, _downloadingView.bounds.size.width - 20.0f, 20)];
        [_downloadingView addSubview:_downloadProgressView];

    }
}
//下载的标签
- (void)fileDownloadingLabel
{
    _downloadLabel = [[UILabel alloc] initWithFrame:CGRectMake(_downloadingView.bounds.size.width / 2 - 60, 7.5f, 120, 30)];
    _downloadLabel.text = @"下载中...";
    _downloadLabel.textAlignment = UITextAlignmentCenter;
    _downloadLabel.textColor = [UIColor whiteColor];
    _downloadLabel.font = [UIFont systemFontOfSize:16.5f];
    [_downloadLabel setBackgroundColor:[UIColor clearColor]];
    [_downloadingView addSubview:_downloadLabel];
}
//下载中的数据label
- (void)fileDownloadingDataLabel
{
    _totleDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(_downloadingView.bounds.size.width / 2 - 60, _downloadingView.bounds.size.height - 28, 120, 20)];
    [_totleDataLabel setBackgroundColor:[UIColor clearColor]];
    _totleDataLabel.textAlignment = UITextAlignmentCenter;
    _totleDataLabel.font = [UIFont systemFontOfSize:14.0f];
    _totleDataLabel.textColor = [UIColor whiteColor];
    [_downloadingView addSubview:_totleDataLabel];
}

//隐藏下载视图
- (void)closeDwonloadView:(id)sender
{
    [_downloadingView setHidden:YES];
}
//隐藏简介试图
- (void)hiddenView
{
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [_paymentView setFrame:CGRectMake(0.0f, self.view.bounds.size.height, kWidth, kHeight)];
    [UIView commitAnimations];
}
#pragma mark - unarchive method
//解压文件
- (void)unchiveFile
{
    [SVProgressHUD showWithStatus:@"正在解压，请稍后。。。"];
    _isDismiss = NO;
    ZipArchive *archive = [[ZipArchive alloc] init];
    if ([archive UnzipOpenFile:[self downloadFilePath]])
    {
        if ([archive UnzipFileTo:[self archivePath] overWrite:YES]) {
            NSLog(@"unarchive successful");
            [self showView];
            [self removeZip];  //删除解压的文件
        }
        else
        {
            NSLog(@"unarchive failed");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"文件解压失败，请重新再试" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
            [alert release];
        }
    }
    [archive UnzipCloseFile];
    [archive release];
}
//删除zip包
- (void)removeZip
{
    NSFileManager *fileManamger = [NSFileManager defaultManager];
    NSString *path = [self downloadFilePath];
    if ([fileManamger fileExistsAtPath:path])
    {
        NSError *error = nil;
        if (![fileManamger removeItemAtPath:path error:&error])
        {
            NSLog(@"file delete error = %@", error);
        }
    }
}

#pragma mark - file path
//下载缓存路径
- (NSString *)pathOfCache
{
    NSString *cachePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"tmp"] stringByAppendingPathComponent:@"7za920.zip.download"];
//    NSLog(@"path = %@",cachePath);
    return cachePath;
}
//下载文件路径
- (NSString *)downloadFilePath
{
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"tmp"] stringByAppendingPathComponent:@"7za920.zip"];
    
//    NSLog(@"download file path = %@",path);
    return path;
}
//解压路径
- (NSString *)archivePath
{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/Unarchive"];
//    NSLog(@"archive path = %@",path);
    return path;
}

//网页文件路径
- (NSString *)pathOfHtml
{
    NSString *path = [[self archivePath] stringByAppendingPathComponent:kPathOfHtml];
//    NSLog(@"html path = %@", path);
    return path;
}
//网页文件是否存在
- (BOOL)htmlIsExist
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:[self pathOfHtml]];
}

#pragma mark - asi progress delegate method
//下载进度条的代理方法
- (void)setProgress:(float)newProgress
{
    [_downloadProgressView setProgress:newProgress];
    _totleDataLabel.text = [NSString stringWithFormat:@"%.2f M / %.2f M",_totleSize * newProgress / 1024.0 / 1024.0, _totleSize / 1024.0 / 1024.0];
    _downloadDataLabel.text = [NSString stringWithFormat:@"%2.0f%%",newProgress * 100];
    _downloadLabel.text = [NSString stringWithFormat:@"下载中    %2.0f%%",newProgress * 100];
}

#pragma mark - asihttp request delegate method
//收到数据头的回调方法
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"totleSize"] != 0)
    {
        _totleSize = [[NSUserDefaults standardUserDefaults] integerForKey:@"totleSize"];
    }
    else
    {
        if (request.contentLength != 0)
        {
            _totleSize = request.contentLength;
            [[NSUserDefaults standardUserDefaults] setInteger:_totleSize forKey:@"totleSize"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

#pragma mark - dealloc
- (void)dealloc
{
    [_downloadDataLabel release];  _downloadDataLabel = nil;
    [_request clearDelegatesAndCancel];
    [_downloadingButton release];  _downloadingButton = nil;
    [_closeBotton release];  _closeBotton = nil;
    [_imageScroll release];  _imageScroll = nil;
    [_nextButton release];   _nextButton = nil;
    [_prevButton release];   _prevButton = nil;
    [_paymentButton release];   _paymentButton = nil;
    [_downloadProgressView release];   _downloadProgressView = nil;
    [_totleDataLabel release];   _totleDataLabel = nil;
    [_showWebView release];    _showWebView = nil;
    [_currentDataLabel release];  _currentDataLabel = nil;
    [_downloadUrl release];  _downloadUrl = nil;
    [_identifier release];  _identifier = nil;
    [_downloadLabel release];   _downloadLabel = nil;
    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
