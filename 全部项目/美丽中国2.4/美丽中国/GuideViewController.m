//
//  GuideViewController.m
//  美丽中国
//
//  Created by 司马帅帅 on 15/7/19.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import "GuideViewController.h"
#import "AFNetworking.h"
#import "Header.h"
#import "UIUtils.h"
#import "GuideInfo.h"
#import "GuideViewCell.h"
#import "MBProgressHUD.h"
#import "ZipArchive.h"
#import "GuideMapViewController.h"
#import "ViewController.h"

static NSString *cellIdentifier = @"cellIdentifier";

@interface GuideViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *_guideInfoArray;
    UICollectionView *_collectionView;
    MBProgressHUD *_HUD;//提示
    NSString *_guidePath;//导游的存储路径
    ZipArchive *_zipArchive;//zip解压
    BOOL _isLoadGuide;//是否正在下载一个导游
    NSOperationQueue *_queue;//导游下载队列
}
@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //初始化_guidePath
    [self initGuidePath];
    //添加内容视图
    [self addContentView];
    //加载数据
    [self loadData];
}

//初始化_guidePath
- (void)initGuidePath
{
    //初始化导游存储路径
    if (!_guidePath) {
        _guidePath = GUIDE_PATH;
        //判断文件路径是否存在 如果不存在 创建文件夹
        if (![[NSFileManager defaultManager] fileExistsAtPath:_guidePath]) {
            [[NSFileManager defaultManager]
             createDirectoryAtPath:_guidePath
             withIntermediateDirectories:YES
             attributes:nil
             error:nil];
        }
    }
    NSLog(@"_guidePath %@",_guidePath);
}

//添加内容视图
- (void)addContentView
{
    if (!_collectionView) {
        CGRect collectionFrame = self.view.frame;
        collectionFrame.size.height = collectionFrame.size.height-44-20-44;
        _collectionView = [[UICollectionView alloc] initWithFrame:collectionFrame collectionViewLayout:[UICollectionViewFlowLayout new]];
        [_collectionView registerClass:[GuideViewCell class] forCellWithReuseIdentifier:cellIdentifier];
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
    NSString *urlString = [NSString stringWithFormat:@"%@%@",LOCAL_HOST,GUIDE_LIST_REQUEST];
    //初始化请求（同时也创建了一个线程）
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //设置请求可以接受的内容的样式
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //发送GET请求
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"请求成功 %@",responseObject);
        //初始化_guideInfoArray
        if (!_guideInfoArray) {
            _guideInfoArray = [[NSMutableArray alloc] init];
        }
        
        NSDictionary *array = (NSDictionary *)responseObject[@"tourinfo"];
        for (NSDictionary *dictionary in array) {
            GuideInfo *guideInfo = [[GuideInfo alloc] initWithDictionary:dictionary];
            [_guideInfoArray addObject:guideInfo];
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

//下载并解压导游数据
- (void) loadAndUnzipDataWithDataPath:(NSString *)guideDataPath andGuideInfo:(GuideInfo *)guideInfo andIndexPath:(NSIndexPath*)indexPath
{
    if (_isLoadGuide) {
        NSLog(@"正在下载一个导游 此时其他导游不能下载");
    } else {
        _isLoadGuide = YES;
        
        //初始化导游下载队列_queue
        if (!_queue) {
            _queue = [[NSOperationQueue alloc] init];
            _queue.maxConcurrentOperationCount = 1;
        }
        
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
            NSLog(@"下载 数据包 dataUrl %@",guideInfo.dataUrl);
            
            //获取被点击的cell
            GuideViewCell *cell = (GuideViewCell*)[_collectionView cellForItemAtIndexPath:indexPath];
            [cell showProgressView];
            
            //单个导游 数据压缩包的存储路径
            NSString *zipPath = [guideDataPath stringByAppendingPathComponent:@"data.zip"];
            //下载压缩包
            //初始化下载请求
            NSURL *url = [[NSURL alloc] initWithString:guideInfo.dataUrl];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            //创建一个请求操作operation
            AFHTTPRequestOperation *zipOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            
            //设置操作operation的输出流为存储路径
            zipOperation.outputStream  = [NSOutputStream outputStreamToFileAtPath:zipPath append:NO];
            
            //下载进度
            [zipOperation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
                // 设置进度条的百分比
                CGFloat precent = (CGFloat)totalBytesRead / totalBytesExpectedToRead;
                NSLog(@"%f", precent);
                [cell updateProgressWithValue:precent];
            }];
            
            [zipOperation start];
            
            //语音下载完成
            [zipOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                //显示提示
                [self show:MBProgressHUDModeIndeterminate message:@"正在解压数据..." customView:self.view];
                
                NSLog(@"压缩包下载完成");
                _isLoadGuide = NO;
                [cell hideProgressView];
                
                //初始化zip解压器
                if (!_zipArchive) {
                    _zipArchive = [[ZipArchive alloc] init];
                }
                
                //解压zip包
                if ([_zipArchive UnzipOpenFile:zipPath]) {
                    BOOL result = [_zipArchive UnzipFileTo:guideDataPath overWrite:YES];
                    if (result) {
                        NSLog(@"解压成功");
                        //隐藏HUD
                        [self hideHUDafterDelay:0.3f];
                        //删除解压完的zip文件
                        [[NSFileManager defaultManager] removeItemAtPath:zipPath error:nil];
                        //刷新_collectionView
                        [_collectionView reloadData];
                    } else {
                        NSLog(@"解压失败");
                        //隐藏HUD
                        [self hideHUDafterDelay:0.3f];
                    }
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"压缩包下载失败");
                _isLoadGuide = NO;
                [cell hideProgressView];
            }];
            
        }];
        [operation addExecutionBlock:^{
            NSLog(@"下载 配置文件 configUrl %@",guideInfo.configUrl);
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:guideInfo.configUrl]];
            //单个导游 配置文件的存储路径
            NSString *jsonPath = [guideDataPath stringByAppendingPathComponent:@"config.json"];
            [data writeToFile:jsonPath atomically:YES];
            
        }];
        [operation addExecutionBlock:^{
            NSLog(@"下载 导游图标 imageUrl %@",guideInfo.imageUrl);
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:guideInfo.imageUrl]];
            //单个导游 图标的存储路径
            NSString *imagePath = [guideDataPath stringByAppendingPathComponent:@"guideIcon.png"];
            [data writeToFile:imagePath atomically:YES];
            
        }];
        [operation setCompletionBlock:^{
            NSLog(@"下载三个数据完成");
        }];
        
        //给队列添加操作
        [_queue addOperation:operation];
    }
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
    return _guideInfoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GuideViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    GuideInfo *guideInfo = _guideInfoArray[indexPath.row];
    [cell setContentView:guideInfo];
    
    return cell;
}

#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(([UIUtils getWindowWidth]-10*5)/4, ([UIUtils getWindowWidth]-10*5)/4+14);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    return edgeInsets;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GuideInfo *guideInfo = _guideInfoArray[indexPath.row];
    
    //获取单个导游的存储路径
    NSString *guideDataPath = [_guidePath stringByAppendingPathComponent:guideInfo.namePath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:guideDataPath]) {
        [[NSFileManager defaultManager]
         createDirectoryAtPath:guideDataPath
         withIntermediateDirectories:YES
         attributes:nil
         error:nil];
    }
    
    //解压后全景的首页tour.html的路径(用这个路径可以判断zip包是否下载完成并且解压完成)
    NSString *tourHtmlPath = [guideDataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/view_fullview/mytour/tour.html",guideInfo.namePath]];
    
    //判断全景首页tour.html是否存在
    if ([[NSFileManager defaultManager] fileExistsAtPath:tourHtmlPath]) {
        NSLog(@"导游已经存在 可以进入导游页面");
        GuideMapViewController *guideMapViewController = [[GuideMapViewController alloc] initWithGuideInfo:guideInfo];
        [_viewController.navigationController pushViewController:guideMapViewController animated:YES];
    } else {
        //下载并解压导游数据
        [self loadAndUnzipDataWithDataPath:guideDataPath andGuideInfo:guideInfo andIndexPath:(NSIndexPath*)indexPath];
    }
}

@end






