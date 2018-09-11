//
//  DraftViewController.m
//  旅拍1.0
//
//  Created by 司马帅帅 on 15/7/16.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import "DraftViewController.h"
#import "EditView.h"
#import "DraftInfo.h"
#import "ImageInfo.h"

@interface DraftViewController ()<EditViewDelegate>
{
    EditView *_editView;
    DraftInfo *_draftInfo;
    NSMutableArray *_imageInfoArray;
}
@end

@implementation DraftViewController

- (id)initWithDraftInfo:(DraftInfo *)draftInfo
{
    self = [super init];
    if (self) {
        _draftInfo = draftInfo;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //隐藏navigationBar
    self.navigationController.navigationBarHidden = YES;
    
    //添加编辑视图
    [self addEditView];
    
    //加载数据
    [self loadData];
}

//添加编辑视图
- (void)addEditView
{
    _editView = [[EditView alloc] initWithFrame:self.view.frame];
    _editView.delegate = self;
    [self.view addSubview:_editView];
}

//加载数据
- (void)loadData
{
    if (!_imageInfoArray) {
        _imageInfoArray = [[NSMutableArray alloc] init];
    }
    for (int i=0; i<_draftInfo.imageCount; i++) {
        NSString *text = _draftInfo.textArray[i];
        UIImage *image = [self getImageWithDraftId:_draftInfo.draftId andImageId:i];
        ImageInfo *imageInfo = [[ImageInfo alloc] initWithImage:image andText:text];
        
        [_imageInfoArray addObject:imageInfo];
    }
    
    _editView.titleView.text = _draftInfo.title;
    //刷新_editView
    [_editView reloadEditViewWithArray:_imageInfoArray andUpdateType:UPDATETYPE_FOR_ADD_MORE_OBJECTS];
}

//获取图片
- (UIImage *)getImageWithDraftId:(int)draftId andImageId:(int)imageId
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths lastObject];
    NSString *draftPath = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"Draft/draft%d",draftId]];
    NSString *imagePath = [draftPath stringByAppendingPathComponent:[NSString stringWithFormat:@"image%d.jpg",imageId]];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    return image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark EditViewDelegate
- (void)editViewBackButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
