//
//  WFSViewController.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-6.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "WFSViewController.h"
@interface WFSViewController ()<UIAlertViewDelegate>

@property (strong, nonatomic) MBProgressHUD *hudView;

@end

@implementation WFSViewController


@synthesize appConfig = _appConfig;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _appConfig = [AppConfig sharedAppConfig];
    // Do any additional setup after loading the view.
}

//适配ios6、7
-(CGFloat)MatchIOS7:(CGFloat)originY {
    if (kCurrentSystemVersion >= 7.0) {
        originY += 64;
    }
    return originY;
}

-(UIColor *)getMatchTopColor{
    if (kCurrentSystemVersion >= 7.0) {
        return [UIColor colorWithRed:255/255.0 green:105/255.0 blue:100/255.0 alpha:1];
        
    }else{
        return [UIColor colorWithRed:255/255.0 green:90/255.0 blue:84/255.0 alpha:1];
    }
}

-(void)loadLeftBackBtn {
//    
//    UIImage * backImage = [UIImage imageNamed:@"back"];
//    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.frame = CGRectMake(0, 0, backImage.size.width, backImage.size.height);
//    [backBtn setBackgroundImage:backImage forState:UIControlStateNormal];
////    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
//    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
//    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem * barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
//    
//    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
//                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
//                                       target:nil action:nil];
//    /**
//     *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-5时，间距正好调整
//     *  为0；width为正数时，正好相反，相当于往左移动width数值个像素
//     */
//    if (kCurrentSystemVersion >= 7.0) {
//        negativeSpacer.width = -10;
//    }else {
//        negativeSpacer.width = 0;
//    }
//    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, barBtnItem, nil];
//    self.navigationItem.leftBarButtonItem = barBtnItem;
}

-(void)loadRightShortCutBtn {
    
    UIImage * backImage = [UIImage imageNamed:@"btn_shortcut_normal.png"];
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, backImage.size.width, backImage.size.height);
    [backBtn setBackgroundImage:backImage forState:UIControlStateNormal];
    //    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [backBtn addTarget:self action:@selector(gotoHomeTabBar) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    /**
     *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-5时，间距正好调整
     *  为0；width为正数时，正好相反，相当于往左移动width数值个像素
     */
    if (kCurrentSystemVersion >= 7.0) {
        negativeSpacer.width = -10;
    }else{
        negativeSpacer.width = 0;
    }
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, barBtnItem, nil];
    //    self.navigationItem.leftBarButtonItem = barBtnItem;
}


-(BOOL)writeApplicationData:(NSDictionary *)data  writeFileName:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    if (!documentsDirectory) {
//        NSLog(@"Documents directory not found!");
        return NO;
    }
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
    return ([data writeToFile:appFile atomically:YES]);
}

-(id)readApplicationData:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
    NSDictionary *myData = [[NSDictionary alloc] initWithContentsOfFile:appFile];
    return myData;
}


-(void)gotoHomeTabBar{
    CGFloat originY = 64;
//    originY = [self MatchIOS7:originY];
    if (_shortcutView == nil) {
        _shortcutView = [[ShortCutPopView alloc] initWithFrame:CGRectMake(170, originY, 150, 150)];
    }
    _shortcutView.delegate = self;
    [_shortcutView show];
}

-(void)didSelectRowAtIndexPath:(NSInteger)indexRow{
    [_shortcutView dismiss];
    if (indexRow > 0) {
        indexRow += 1;
    }
    if ([UIHelper getTabbarIndex] == indexRow) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else {
//        [self.navigationController popToRootViewControllerAnimated:YES];
        [UIHelper gotoTabbar:indexRow];
    
    }
}



-(AppConfig *)appConfig{

    return [AppConfig sharedAppConfig];
}

- (AppDelegate *)appDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showAlertWithMessage:(NSString *)message{
    [self showErrorMessage:message];
}



-(NSString *)getSearchPlistPath{
//    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *plistPaths = [docDir stringByAppendingPathComponent:@"searchWord.plist"];
//    [fm createFileAtPath:plistPaths contents:nil attributes:nil];
    return plistPaths;

}

-(void)SaveArrayToPlist:(NSArray *)Array{

    NSString *path = [self getSearchPlistPath];
    [Array writeToFile:path atomically:NO];
//    NSLog(@"save === %d", [NSKeyedArchiver archiveRootObject:Array toFile:path]);
    
}

-(NSMutableArray *)getSearchArray{
    NSString *path = [self getSearchPlistPath];
    NSMutableArray *searchData = [NSMutableArray arrayWithContentsOfFile:path];
    return searchData;
}

// window上
- (void)showSuccessMesaageInWindow:(NSString *)message {
    [MBProgressHUD showSuccess:message toView:[UIApplication sharedApplication].keyWindow];
}

/// 成功信息
- (void)showSuccessMessage:(NSString *)message {
    [MBProgressHUD showSuccess:message];    
}

// 错误信息
- (void)showErrorMessage:(NSString *)message {
    [MBProgressHUD showError:message];
}

// 一般信息
- (void)showMessage:(NSString *)message {
    [MBProgressHUD show:message hideAfterTime:1.0f];
}

/// 加载视图
- (void)showLoadView {
    [self showLoadViewWithMessage:nil];
}

/// 带字的加载视图
- (void)showLoadViewWithMessage:(NSString *)message {
    if (!_hudView) {
        _hudView = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    }
    if (message) {
        _hudView.labelText = message;
    }
    [_hudView show:YES];
}

/// 隐藏加载
- (void)hideLoadView {
    if (_hudView) {
        [_hudView hide:YES];
    }
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
