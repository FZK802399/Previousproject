//
//  ViewController.m
//  旅拍1.0
//
//  Created by 司马帅帅 on 15/7/6.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import "ViewController.h"
#import "UIUtils.h"
#import "SetViewController.h"
#import "MyListViewController.h"
#import "LocalDraftViewController.h"
#import "MainView.h"
#import "EditView.h"
#import "ImageInfo.h"
#import "Header.h"
#import "AFNetworking.h"
#import "WebInfo.h"
#import "WebViewController.h"
#import "PostProgressView.h"
#import "FMDB.h"
#import "FMDBTool.h"

#define Table_Name @"draft_table"

@interface ViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,MainViewDelegate,EditViewDelegate,UIAlertViewDelegate>
{
    MainView *_mainView;//主视图
    EditView *_editView;//编辑视图
    NSMutableArray *_imageInfoArray;//图片信息对象数组
    int _editIndex;//被编辑的索引
    UpdateType _updateType;//更新类型
    PostProgressView *_postProgressView;//上传进度视图
    
    FMDatabase *_db;//数据库
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    _imageInfoArray = [[NSMutableArray alloc] init];

    //把状态栏设置为白色
    [self setStatusBarColor];
    
    //添加主视图
    [self addMainView];
    
    //添加编辑视图
    [self addEditView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //向前放大动画效果
    [self scaleAnimationForeward];
}

//更新
- (void)updateImageInfo:(ImageInfo *)imageInfo updateType:(UpdateType)updateType index:(int)index
{
    if (updateType == UPDATETYPE_FOR_ADD_ONE_OBJECT) {
        [_imageInfoArray addObject:imageInfo];
    } else if (updateType == UPDATETYPE_FOR_EDIT_ONE_OBJECT) {
        [_imageInfoArray replaceObjectAtIndex:index withObject:imageInfo];
    } else if (updateType == UPDATETYPE_FOR_DELETE_ONE_OBJECT) {
        [_imageInfoArray removeObjectAtIndex:index];
    } else if (updateType == UPDATETYPE_FOR_DELETE_ALL_OBJECTS) {
        [_imageInfoArray removeAllObjects];
    }
    
    //如果_imageInfoArray的内容为空则显示MainView否则显示EditView
    if (_imageInfoArray.count == 0) {
        _editView.titleView.text = @"";
        [self showMainViewAnimation];
    } else {
        [self showEditViewAnimation];
    }

    //刷新_editView中tableView显示的内容
    [_editView reloadEditViewWithArray:_imageInfoArray andUpdateType:updateType];
}

//上传多张图片
- (void)uploadImages
{
    if ([UIUtils isBlankString:_editView.titleView.text]) {
        [_editView tapTitleView];
    } else {
        
        //展示上传进度视图
        [self showPostProgressView];
        
        //AFNetworking发送图片到服务器
        NSString *urlString = [NSString stringWithFormat:@"%@%@",LocalWebSite,Request_Upload];
        
        //参数字典
        NSString *uploadTimeString = [self getCurrentDateString];
        NSString *pageCountString = [NSString stringWithFormat:@"%d",(int)_imageInfoArray.count];
        NSString *userIDString = [USER_DEFAULT objectForKey:@"UserId"];
        NSString *titleString = _editView.titleView.text;
        NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:@"ios",@"platform",uploadTimeString,@"uploadTime",pageCountString,@"pageCount",userIDString,@"userId",titleString,@"title", nil];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        //设置请求可以接受的内容的样式
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        AFHTTPRequestOperation *uploadOperation = [manager POST:urlString parameters: parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            for (int i=0; i<_imageInfoArray.count; i++) {
                ImageInfo *imageInfo = _imageInfoArray[i];
                UIImage *image = imageInfo.image;
                NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
                //添加图片
                [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"image%d",i+1] fileName:@"image" mimeType:@"image/jpg"];
                if (![UIUtils isBlankString:imageInfo.text]) {
                    //添加文字
                    [formData appendPartWithFormData:[imageInfo.text dataUsingEncoding:NSUTF8StringEncoding] name:[NSString stringWithFormat:@"text%d",i+1]];
                }
            }
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"成功 %@",responseObject);
            
            //移除_postProgressView
            [_postProgressView removeView];
            
            WebInfo *webInfo = [[WebInfo alloc] initWithDictionary:responseObject];
            WebViewController *webViewController = [[WebViewController alloc] initWithWebInfo:webInfo webViewType:WEBVIEW_TYPE_POST];
            UINavigationController *navWebViewController = [[UINavigationController alloc] initWithRootViewController:webViewController];
            [self presentViewController:navWebViewController animated:YES completion:^{
                //删除所有
                [self updateImageInfo:nil updateType:UPDATETYPE_FOR_DELETE_ALL_OBJECTS index:0];
            }];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            //移除_postProgressView
            [_postProgressView removeView];
            
            NSLog(@"失败 %@",error);
        }];
        //添加上传进度block
        [uploadOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            //_postProgressView更新进度
            [_postProgressView updateWithValue:(double)totalBytesWritten/totalBytesExpectedToWrite];
        }];
        
    }
    
}

//展示上传进度视图
- (void)showPostProgressView
{
    if (!_postProgressView) {
        _postProgressView = [[PostProgressView alloc] initWithFrame:self.view.frame];
    }
    [_postProgressView showInView:self.view];
}

//获得当前的时间戳
- (NSString *)getCurrentDateString
{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSTimeInterval delta = [zone secondsFromGMTForDate:[NSDate date]];
    NSString *string = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] + delta];
    NSString *dateString = [[string componentsSeparatedByString:@"."]objectAtIndex:0];
    return dateString;
    
}
//保存草稿
- (void)saveDraft
{
    //标题
    NSString *title = _editView.titleView.text;
    if ([UIUtils isBlankString:title]) {
        title = @"";
    }
    
    //图片数量
    int imageCount = (int)_imageInfoArray.count;
    
    //描述数组的字符串
    NSMutableArray *textArray = [[NSMutableArray alloc] init];
    for (ImageInfo *imageInfo in _imageInfoArray) {
        NSString *text = imageInfo.text;
        if ([UIUtils isBlankString:text]) {
            text = @"";
        }
        [textArray addObject:text];
    }
    //把数组转换为字符串
    NSError *error;
    NSData *textData = [NSJSONSerialization dataWithJSONObject:textArray options:NSJSONWritingPrettyPrinted error:&error];
    NSString *textString = [[NSString alloc] initWithData:textData encoding:NSUTF8StringEncoding];
    
    //当前时间
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *zone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:zone];
    [formatter setDateFormat:@"MM月dd日HH点"];
    NSString *dateString = [formatter stringFromDate:date];
    
    BOOL result = [FMDBTool insertOnDB:_db withTableName:Table_Name andTitle:title imageCount:imageCount textString:textString dateline:dateString];
    if (result) {
        NSLog(@"插入数据成功");
        //获取最新一条数据的id
        int draftId = (int)[_db lastInsertRowId];
        //存储图片到磁盘
        [self saveImagesWithDraftId:draftId];
    } else {
        NSLog(@"插入数据失败");
    }
}

//存储图片到磁盘
- (void)saveImagesWithDraftId:(int)draftId
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths lastObject];
    NSString *draftPath = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"Draft/draft%d",draftId]];
    //判断文件夹路径是否存在 如果不存在 创建文件夹
    if (![[NSFileManager defaultManager] fileExistsAtPath:draftPath]) {
        [[NSFileManager defaultManager]
         createDirectoryAtPath:draftPath
         withIntermediateDirectories:YES
         attributes:nil
         error:nil];
    }
    //存储图片到相应的草稿文件夹
    for (int i=0; i<_imageInfoArray.count; i++) {
        ImageInfo *imageInfo = _imageInfoArray[i];
        UIImage *image = imageInfo.image;
        NSData *data = UIImageJPEGRepresentation(image, 1.0f);
        NSString *imagePath = [draftPath stringByAppendingPathComponent:[NSString stringWithFormat:@"image%d.jpg",i]];
        [data writeToFile:imagePath atomically:YES];
    }
    
}

//创建数据库中的表
- (void)createTable
{
    BOOL result = [FMDBTool createTableOnDB:_db withTableName:Table_Name];
    if (result) {
        NSLog(@"建表成功");
    } else {
        NSLog(@"建表失败");
    }
    [_db close];
}

#pragma mark 添加内容视图
//添加主视图
- (void)addMainView
{
    _mainView = [[MainView alloc] initWithFrame:self.view.frame];
    _mainView.delegate = self;
    [self.view addSubview:_mainView];
}

//添加编辑视图
- (void)addEditView
{
    _editView = [[EditView alloc] initWithFrame:self.view.frame];
    _editView.delegate = self;
    _editView.layer.transform = CATransform3DMakeScale(0.8, 0.8, 1.0);
    _editView.layer.opacity = 0.5;
}

//把状态栏设置为白色
- (void)setStatusBarColor
{
    //设置状态栏为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark 动画效果
//向前放大动画效果
- (void)scaleAnimationForeward
{
    [UIView animateWithDuration:0.2
                     animations:^{
                         _mainView.layer.transform = CATransform3DMakeScale(1, 1, 1);
                     } completion:nil];
}

//向后缩小动画效果
- (void)scaleAnimationBackward
{
    [UIView animateWithDuration:0.2
                     animations:^{
                         _mainView.layer.transform = CATransform3DMakeScale(0.8, 0.8, 1);
                     } completion:nil];

}

//切换到EditView时的动画效果
- (void)showEditViewAnimation
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         _mainView.layer.transform = CATransform3DMakeScale(0.8, 0.8, 1);
                         _mainView.layer.opacity = 0.5;
                     }
                     completion:^(BOOL finished) {
                         
                         //移除_mainView
                         if (_mainView.superview) {
                             [_mainView removeFromSuperview];
                         }
                         //添加_editView
                         if (!_editView.superview) {
                             [self.view addSubview:_editView];
                         }
                         [UIView animateWithDuration:0.3
                                          animations:^{
                                              _editView.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0);
                                              _editView.layer.opacity = 1.0;
                                          }
                                          completion:nil];
                     }];

}

//切换到MainView的动画效果
- (void)showMainViewAnimation
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         _editView.layer.transform = CATransform3DMakeScale(0.8, 0.8, 1);
                         _editView.layer.opacity = 0.5;
                     }
                     completion:^(BOOL finished) {
                         if (_editView.superview) {
                             [_editView removeFromSuperview];
                         }
                         if (!_mainView.superview) {
                             [self.view addSubview:_mainView];
                         }
                         
                         [UIView animateWithDuration:0.3
                                          animations:^{
                                              _mainView.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0);
                                              _mainView.layer.opacity = 1.0f;
                                          } completion:nil];
                     }];
}

#pragma mark 按钮点击方法
//设置按钮被点击
- (void)setButtonPressed
{
    //向后缩小动画效果
    [self scaleAnimationBackward];
    
    SetViewController *setViewController = [[SetViewController alloc] init];
    UINavigationController *navSetViewController = [[UINavigationController alloc] initWithRootViewController:setViewController];
    [self presentViewController:navSetViewController animated:YES completion:nil];
}

//我的旅拍按钮被点击
- (void)myListButtonPressed
{
    //向后缩小动画效果
    [self scaleAnimationBackward];
    
    MyListViewController *myListViewController = [[MyListViewController alloc] init];
    UINavigationController *navMyListViewController = [[UINavigationController alloc] initWithRootViewController:myListViewController];
    [self presentViewController:navMyListViewController animated:YES completion:nil];
}

//本地草稿按钮被点击
- (void)localDraftButtonPressed
{
    //向后缩小动画效果
    [self scaleAnimationBackward];
    
    LocalDraftViewController *localDraftViewController = [[LocalDraftViewController alloc] init];
    UINavigationController *navLocalDraftViewController = [[UINavigationController alloc] initWithRootViewController:localDraftViewController];
    [self presentViewController:navLocalDraftViewController animated:YES completion:nil];
}

//拍照按钮被点击
- (void)cameraButtonPressed
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"您的设备不支持拍照功能！"
                              message:nil
                              delegate:nil
                              cancelButtonTitle:@"我知道了"
                              otherButtonTitles:nil];
        [alert show];
    }
}

//相册按钮被点击
- (void)libraryButtonPressed
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"您的设备不支持照片库！"
                              message:nil
                              delegate:nil
                              cancelButtonTitle:@"知道了"
                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark MainViewDelegate
//设置按钮被点击
- (void)mainViewSetButtonPressed
{
    [self setButtonPressed];
}

//拍照按钮被点击
- (void)mainViewCameraButtonPressed
{
    _updateType = UPDATETYPE_FOR_ADD_ONE_OBJECT;
    [self cameraButtonPressed];
}

//相册按钮被点击
- (void)mainViewLibraryButtonPressed
{
    _updateType = UPDATETYPE_FOR_ADD_ONE_OBJECT;
    [self libraryButtonPressed];
}

//我的旅拍按钮被点击
- (void)mainViewMyListButtonPressed
{
    [self myListButtonPressed];
}

//本地草稿按钮被点击
- (void)mainViewLocalDraftButtonPressed
{
    [self localDraftButtonPressed];
}

#pragma mark EditViewDelegate
- (void)editViewBackButtonPressed
{
    NSLog(@"editViewBackButtonPressed");
    
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"是否保存本地草稿?"
                              message:@"保存草稿后可以再次编辑并且上传"
                              delegate:self
                              cancelButtonTitle:@"不保存"
                              otherButtonTitles:@"保存", nil];
    [alertView show];
    
}

- (void)editViewUploadButtonPressed
{
    NSLog(@"editViewUploadButtonPressed");
    //上传多张图片
    [self uploadImages];
}

- (void)editViewCameraButtonPressed
{
    NSLog(@"editViewCameraButtonPressed");
    _updateType = UPDATETYPE_FOR_ADD_ONE_OBJECT;
    [self cameraButtonPressed];
}

- (void)editViewLibraryButtonPressed
{
    NSLog(@"editViewLibraryButtonPressed");
    _updateType = UPDATETYPE_FOR_ADD_ONE_OBJECT;
    [self libraryButtonPressed];
}

- (void)editViewActionSheetCameraButtonPressed:(int)index
{
    NSLog(@"editViewActionSheetCameraButtonPressed %d",index);
    _editIndex = index;
    _updateType = UPDATETYPE_FOR_EDIT_ONE_OBJECT;
    [self cameraButtonPressed];
}

- (void)editViewActionSheetLibraryButtonPressed:(int)index
{
    NSLog(@"editViewActionSheetLibraryButtonPressed %d",index);
    _editIndex = index;
    _updateType = UPDATETYPE_FOR_EDIT_ONE_OBJECT;
    [self libraryButtonPressed];
}

- (void)editViewDeleteImageInfoAtIndex:(int)index
{
    [self updateImageInfo:nil updateType:UPDATETYPE_FOR_DELETE_ONE_OBJECT index:index];
}

- (void)editViewInputTextViewSaveButtonPressedWithImageInfo:(ImageInfo *)imageInfo andIndex:(int)index
{
    NSLog(@"text %@ index %d",imageInfo.text, index);
    [self updateImageInfo:imageInfo updateType:UPDATETYPE_FOR_EDIT_ONE_OBJECT index:index];
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //获取原始图片
    UIImage *originalImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    ImageInfo *imageInfo = [[ImageInfo alloc] initWithImage:originalImage andText:nil];
    
    //把状态栏设置为白色
    [self setStatusBarColor];
    [self dismissViewControllerAnimated:YES completion:^{
        //更新
        [self updateImageInfo:imageInfo updateType:_updateType index:_editIndex];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //把状态栏设置为白色
    [self setStatusBarColor];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        if (!_db) {
            //获取数据库存储路径
            _db = [FMDBTool createDataBase];
        }
        if ([_db open]) {
            //创建数据库中的表
            [self createTable];
        }
        if ([_db open]) {
            //保存草稿
            [self saveDraft];
        }
    }
    [self updateImageInfo:nil updateType:UPDATETYPE_FOR_DELETE_ALL_OBJECTS index:0];
}

@end





