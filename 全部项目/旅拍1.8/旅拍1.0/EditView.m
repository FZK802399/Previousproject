//
//  EditView.m
//  旅拍1.0
//
//  Created by fzkon 15/7/7.
//  Copyright (c) 2015年 fzk. All rights reserved.
//

#import "EditView.h"
#import "UIUtils.h"
#import "EditViewCell.h"
#import "ImageInfo.h"
#import "InputTextView.h"

#define MARGIN_WIDTH 20
#define TITLE_VIEW_HEIGHT 40
#define ADD_BUTTON_HEIGHT 60
#define TITLE_LARGE_COUNT 30//标题的字数限制
#define TITLECOUNTLABEL_WIDTH 35//标题剩余字数标签的宽
#define TITLECOUNTLABEL_HEIGHT 40//标题剩余字数标签的高

@interface EditView ()<UITableViewDataSource, UITableViewDelegate, EditViewCellDelegate, UIActionSheetDelegate,UITextViewDelegate,InputTextViewDelegate>
{
    UIImageView *_topView;//顶部视图
    UIButton *_backButton;//返回按钮
    UIButton *_uploadButton;//上传按钮
    UITextView *_titleView;//标题视图
    UILabel *_titleViewPlaceHolderLabel;//标题视图中显示默认文字视图
    
    UIView *_editTitleOpaqueView;//编辑标题视图的遮盖视图
    UITextView *_editTitleView;//编辑标题视图
    UILabel *_titleCountLabel;//显示标题剩余字数的标签
    int _titleCount;//标题剩余字数
    
    UIView *_bottomView;//底部视图
    UIButton *_cameraButton;//拍照按钮
    UIButton *_libraryButton;//相册按钮
    UITableView *_tableView;//表视图
    NSArray *_imageInfoArray;//存放ImageInfo对象的数组
    int _editIndex;//被编辑的索引
}
@end

@implementation EditView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //添加内容视图
        [self addContentView];
    }
    return self;
}

//用array刷新EditView显示的内容
- (void)reloadEditViewWithArray:(NSArray *)array andUpdateType:(UpdateType)updateType
{
    _imageInfoArray = array;
    [_tableView reloadData];
    if ([UIUtils isBlankString:_titleView.text]) {
        if (!_titleViewPlaceHolderLabel.superview) {
            [_titleView addSubview:_titleViewPlaceHolderLabel];
        }
    } else {
        if (_titleViewPlaceHolderLabel.superview) {
            [_titleViewPlaceHolderLabel removeFromSuperview];
        }
    }
    
    if ((updateType == UPDATETYPE_FOR_ADD_MORE_OBJECTS)||(updateType == UPDATETYPE_FOR_ADD_ONE_OBJECT)) {
        if ((_tableView.contentSize.height-_tableView.frame.size.height)>0) {
            [_tableView setContentOffset:CGPointMake(0, _tableView.contentSize.height-_tableView.frame.size.height) animated:YES];
        }
    }
    
    NSLog(@"count %lu",_imageInfoArray.count);
}

//添加内容视图
- (void)addContentView
{
    [self setBackgroundColor:LIGHT_WHITE_COLOR];
    
    //添加顶部紫色视图
    [self addTopView];
    
    //添加标题视图
    [self addTitleView];
    
    //添加表示图
    [self addTableView];
    
    //添加底部视图
    [self addBottomView];
}

#pragma mark 添加UI视图
//添加顶部紫色视图
- (void)addTopView
{
    //添加紫色视图
    _topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIUtils getWindowWidth], 44+20)];
    _topView.userInteractionEnabled = YES;
    [_topView setImage:[UIImage imageNamed:@"lp_nav_purple.png"]];
    [self addSubview:_topView];
    
    //添加返回按钮
    UIImage *backButtonImage = [UIImage imageNamed:@"lp_nav_goback.png"];
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_backButton setBackgroundImage:backButtonImage forState:UIControlStateNormal];
    [_backButton setFrame:CGRectMake(10, 20+5, backButtonImage.size.width, backButtonImage.size.height)];
    [_topView addSubview:_backButton];
    
    //添加上传按钮
    UIImage *uploadImageNormal = [UIImage imageNamed:@"lp_upload_button_normal.png"];
    UIImage *uploadImageHighlight = [UIImage imageNamed:@"lp_upload_button_highlight.png"];
    _uploadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_uploadButton addTarget:self action:@selector(uploadButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_uploadButton setBackgroundImage:uploadImageNormal forState:UIControlStateNormal];
    [_uploadButton setBackgroundImage:uploadImageHighlight forState:UIControlStateHighlighted];
    [_uploadButton setFrame:CGRectMake([UIUtils getWindowWidth]-uploadImageNormal.size.width-10, 20+5, uploadImageNormal.size.width, uploadImageNormal.size.height)];
    [_topView addSubview:_uploadButton];
}

//添加标题视图
- (void)addTitleView
{
    //添加标题视图
    _titleView = [[UITextView alloc] initWithFrame:CGRectMake(MARGIN_WIDTH, CGRectGetMaxY(_topView.frame)+5, [UIUtils getWindowWidth]-MARGIN_WIDTH*2, TITLE_VIEW_HEIGHT)];
    [_titleView setFont:[UIFont systemFontOfSize:20]];
    //给_titleView添加了一个点击手势
    UITapGestureRecognizer *tapTitleViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTitleView)];
    [_titleView addGestureRecognizer:tapTitleViewGesture];
    
    [_titleView setBackgroundColor:[UIColor grayColor]];
    [self addSubview:_titleView];
    
    //不能滚动
    _titleView.scrollEnabled = NO;
    //不能选择
    if (isIos7System) {
        [_titleView setSelectable:NO];
    }
    //不能编辑
    _titleView.editable = NO;
    
    //添加标题视图中显示默认文字视图
    _titleViewPlaceHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _titleView.frame.size.width, _titleView.frame.size.height)];
    [_titleViewPlaceHolderLabel setBackgroundColor:[UIColor clearColor]];
    [_titleViewPlaceHolderLabel setTextColor:[UIColor whiteColor]];
    [_titleViewPlaceHolderLabel setTextAlignment:NSTextAlignmentCenter];
    [_titleViewPlaceHolderLabel setText:@"输入标题"];
    [_titleView addSubview:_titleViewPlaceHolderLabel];

}

//添加表示图
- (void)addTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleView.frame)+5, [UIUtils getWindowWidth], [UIUtils getWindowHeight]-(CGRectGetMaxY(_titleView.frame)+5)-ADD_BUTTON_HEIGHT-10) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView setBackgroundColor:LIGHT_WHITE_COLOR];
    [self addSubview:_tableView];
}

//添加底部视图
- (void)addBottomView
{
    //添加底部背景视图
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIUtils getWindowHeight]-ADD_BUTTON_HEIGHT-10, [UIUtils getWindowWidth], ADD_BUTTON_HEIGHT+10)];
    [_bottomView setBackgroundColor:LIGHT_WHITE_COLOR];
    [self addSubview:_bottomView];
    
    //添加拍照按钮
    _cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cameraButton addTarget:self action:@selector(cameraButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_cameraButton setFrame:CGRectMake(MARGIN_WIDTH, 5, ([UIUtils getWindowWidth]-MARGIN_WIDTH*2-10)/2, ADD_BUTTON_HEIGHT)];
    [_cameraButton setBackgroundImage:[UIImage imageNamed:@"lp_cameraButtonImage_normal.png"] forState:UIControlStateNormal];
    [_cameraButton setBackgroundImage:[UIImage imageNamed:@"lp_cameraButtonImage_highlight.png"] forState:UIControlStateHighlighted];
    [_bottomView addSubview:_cameraButton];
    
    //添加相册按钮
    _libraryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_libraryButton addTarget:self action:@selector(libraryButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_libraryButton setFrame:CGRectMake(CGRectGetMaxX(_cameraButton.frame)+10, 5, ([UIUtils getWindowWidth]-MARGIN_WIDTH*2-10)/2, ADD_BUTTON_HEIGHT)];
    [_libraryButton setBackgroundImage:[UIImage imageNamed:@"lp_libraryButtonImage_normal.png"] forState:UIControlStateNormal];
    [_libraryButton setBackgroundImage:[UIImage imageNamed:@"lp_libraryButtonImage_highlight.png"] forState:UIControlStateHighlighted];
    [_bottomView addSubview:_libraryButton];
}

#pragma mark 常用方法
//点击_titleView
- (void)tapTitleView
{
    NSLog(@"tapTitleView");
    
    //初始化遮盖视图
    if (!_editTitleOpaqueView) {
        _editTitleOpaqueView = [[UIView alloc] initWithFrame:self.frame];
        //给遮盖视图添加点击手势
        UITapGestureRecognizer *tapOpaqueViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOpaqueView)];
        [_editTitleOpaqueView addGestureRecognizer:tapOpaqueViewGesture];
        [_editTitleOpaqueView setBackgroundColor:[UIColor clearColor]];
    }
    if (!_editTitleOpaqueView.superview) {
        [self addSubview:_editTitleOpaqueView];
        [UIView animateWithDuration:0.3
                         animations:^{
                             [_editTitleOpaqueView setBackgroundColor:LIGHT_OPAQUE_BLACK_COLOR];
                         } completion:nil];
    }
    
    //初始化_editTitleView
    if (!_editTitleView) {
        _editTitleView = [[UITextView alloc] initWithFrame:_titleView.frame];
        [_editTitleView setBackgroundColor:[UIColor whiteColor]];
        
        [_editTitleView setDelegate:self];
        _editTitleView.returnKeyType = UIReturnKeyDone;
        _editTitleView.scrollEnabled = NO;
        [_editTitleView setFont:[UIFont systemFontOfSize:20]];
    }
    [_editTitleView setText:_titleView.text];
    if (!_editTitleView.superview) {
        [_editTitleOpaqueView addSubview:_editTitleView];
    }
    if (!_editTitleView.isFirstResponder) {
        [_editTitleView becomeFirstResponder];
    }
    
    //添加显示标题字数标签
    if (!_titleCountLabel) {
        _titleCountLabel = [[UILabel alloc] init];
        [_titleCountLabel setFrame:CGRectMake(CGRectGetMaxX(_editTitleView.frame)-TITLECOUNTLABEL_WIDTH, CGRectGetMaxY(_editTitleView.frame), TITLECOUNTLABEL_WIDTH, TITLECOUNTLABEL_HEIGHT)];
        [_titleCountLabel setBackgroundColor:[UIColor clearColor]];
        [_titleCountLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleCountLabel setFont:[UIFont systemFontOfSize:20]];
    }
    [_titleCountLabel setTextColor:LIGHT_GREEN_COLOR];
    [_titleCountLabel setText:[NSString stringWithFormat:@"%d",(int)(TITLE_LARGE_COUNT-_editTitleView.text.length)]];
    if (!_titleCountLabel.superview) {
        [_editTitleOpaqueView addSubview:_titleCountLabel];
    }
}

//点击_editTitleOpaqueView
- (void)tapOpaqueView
{
    if (_titleCount<0) {
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"标题不能超过30个字，把多余的字删除。" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alerView show];
    } else {
        if (_editTitleOpaqueView.superview) {
            [UIView animateWithDuration:0.3
                             animations:^{
                                 [_editTitleOpaqueView setBackgroundColor:[UIColor clearColor]];
                             } completion:^(BOOL finished) {
                                 [_editTitleOpaqueView removeFromSuperview];
                             }];
        }
        
        if (![UIUtils isBlankString:_editTitleView.text]) {
            //标题赋值
            [_titleView setText:_editTitleView.text];
            if (_titleViewPlaceHolderLabel.superview) {
                [_titleViewPlaceHolderLabel removeFromSuperview];
            }
        } else {
            [_titleView setText:@""];
            if (!_titleViewPlaceHolderLabel.superview) {
                [_titleView addSubview:_titleViewPlaceHolderLabel];
            }
        }
    }
}

#pragma mark 点击按钮方法
- (void)backButtonPressed
{
    NSLog(@"backButtonPressed");
    if (self.delegate && [self.delegate respondsToSelector:@selector(editViewBackButtonPressed)]) {
        [self.delegate editViewBackButtonPressed];
    }
}

- (void)uploadButtonPressed
{
    NSLog(@"uploadButtonPressed");
    if (self.delegate && [self.delegate respondsToSelector:@selector(editViewUploadButtonPressed)]) {
        [self.delegate editViewUploadButtonPressed];
    }
}

- (void)cameraButtonPressed
{
    NSLog(@"cameraButtonPressed");
    if (self.delegate && [self.delegate respondsToSelector:@selector(editViewCameraButtonPressed)]) {
        [self.delegate editViewCameraButtonPressed];
    }
}

- (void)libraryButtonPressed
{
    NSLog(@"libraryButtonPressed");
    if (self.delegate && [self.delegate respondsToSelector:@selector(editViewLibraryButtonPressed)]) {
        [self.delegate editViewLibraryButtonPressed];
    }
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _imageInfoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *editViewCellIdentifier = @"editViewCellIdentifier";
    EditViewCell *cell = [tableView dequeueReusableCellWithIdentifier:editViewCellIdentifier];
    if (!cell) {
        cell = [[EditViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:editViewCellIdentifier];
        cell.delegate = self;
    }
    //设置tag
    cell.tag = indexPath.row;
    ImageInfo *imageInfo = _imageInfoArray[indexPath.row];
    [cell setContentView:imageInfo];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ImageInfo *imageInfo = _imageInfoArray[indexPath.row];
    return imageInfo.imageAndTextHeight;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(editViewDeleteImageInfoAtIndex:)]) {
        [self.delegate editViewDeleteImageInfoAtIndex:(int)indexPath.row];
    }
}

#pragma mark EditViewCellDelegate
- (void)editViewCellImageViewTapWithIndex:(int)index
{
    NSLog(@"editViewCellImageViewTapWithIndex %d",index);
    //编辑索引赋值
    _editIndex = index;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"更换照片"
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从手机相册选择", nil];
    [actionSheet showInView:self];
}

- (void)editViewCellTextViewTapWithIndex:(int)index
{
    NSLog(@"editViewCellTextViewTapWithIndex %d",index);
    //_editIndex赋值
    _editIndex = index;
    InputTextView *inputTextView = [[InputTextView alloc] initWithFrame:self.frame];
    inputTextView.delegate = self;
    
    ImageInfo *imageInfo = _imageInfoArray[index];
    [inputTextView showInView:self withImageInfo:imageInfo];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(editViewActionSheetCameraButtonPressed:)]) {
            [self.delegate editViewActionSheetCameraButtonPressed:_editIndex];
        }
    } else if (buttonIndex == 1) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(editViewActionSheetLibraryButtonPressed:)]) {
            [self.delegate editViewActionSheetLibraryButtonPressed:_editIndex];
        }
    }
}

#pragma mark UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSLog(@"text %@",text);
    //当点击键盘上的完成按钮 就执行tapOpaqueView方法
    if ([text isEqualToString:@"\n"]) {
        [self tapOpaqueView];
        return NO;
    }

    //点击删除键时 range.length为1 点击其他键时 range.length为0
    if (range.length == 1) {
        return YES;
    }
    
    //限定editTitleView的输入字数
    NSMutableString *editTitleViewText = [_editTitleView.text mutableCopy];
    [editTitleViewText replaceCharactersInRange:range withString:text];
    return [editTitleViewText length] < TITLE_LARGE_COUNT+9;
}

- (void)textViewDidChange:(UITextView *)textView
{
    //计算出title的高度
    int titleHeight=0;
    if (isIos7System) {
        CGFloat fixedWidth = textView.frame.size.width;
        CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
        titleHeight = newSize.height;
    } else {
        titleHeight = textView.contentSize.height;
    }
    
    //设置_editTitleView _titleView _tableView _titleCountLabel 的frame
    CGRect frame = _editTitleView.frame;
    frame.size.height = titleHeight;
    [_editTitleView setFrame:frame];
    [_titleView setFrame:frame];
    [_tableView setFrame:CGRectMake(0, CGRectGetMaxY(_titleView.frame)+5, [UIUtils getWindowWidth], [UIUtils getWindowHeight]-(CGRectGetMaxY(_titleView.frame)+5)-ADD_BUTTON_HEIGHT-10)];
    [_titleCountLabel setFrame:CGRectMake(CGRectGetMaxX(_editTitleView.frame)-TITLECOUNTLABEL_WIDTH, CGRectGetMaxY(_editTitleView.frame), TITLECOUNTLABEL_WIDTH, TITLECOUNTLABEL_HEIGHT)];
    
    //设置_titleCountLabel里面显示的内容
    _titleCount = (int)(TITLE_LARGE_COUNT-_editTitleView.text.length);
    [_titleCountLabel setText:[NSString stringWithFormat:@"%d",_titleCount]];
    if (_titleCount<0) {
        [_titleCountLabel setTextColor:LIGHT_RED_COLOR];
    } else {
        [_titleCountLabel setTextColor:LIGHT_GREEN_COLOR];
    }
}

#pragma mark InputTextViewDelegate
- (void)inputTextViewSaveImageInfo:(ImageInfo *)imageInfo
{
    NSLog(@"image %@ text %@",imageInfo.image,imageInfo.text);
    if (self.delegate && [self.delegate respondsToSelector:@selector(editViewInputTextViewSaveButtonPressedWithImageInfo:andIndex:)]) {
        [self.delegate editViewInputTextViewSaveButtonPressedWithImageInfo:imageInfo andIndex:_editIndex];
    }
}

@end







