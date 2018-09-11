//
//  SecurityCenterViewController.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-9-11.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "SecurityCenterViewController.h"
#import "FileService.h"
#import "AboutAppController.h"
#import "EMIMHelper.h"
@interface SecurityCenterTableViewCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *ActionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *detailIco;


@end

@implementation SecurityCenterTableViewCell



@end

//-------------------------------------------------------------------

#import "LoginViewController.h"
#import <ShareSDK/ShareSDK.h>

@interface SecurityCenterViewController ()<UIAlertViewDelegate>

@end

@implementation SecurityCenterViewController

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
    [self loadLeftBackBtn];
    self.currentTableView.rowHeight = 44.0f;
    
    self.currentTableView.layer.borderWidth = 1;
    self.currentTableView.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
    _currentTitles = [NSArray arrayWithObjects:@"登录密码",@"支付密码"/*,@"清除缓存"*/,@"关于", nil];
    _currentTitle2s = [NSArray arrayWithObjects:@"修改",@"修改"/*,@""*/,@"", nil];
    // Do any additional setup after loading the view.
    [self addFootView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOff) name:HUANXIN_LOGOFFEND_NOTICE object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) addFootView{
    
    CGFloat footerHeight = 60;
    // 尾部
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, footerHeight)];
    self.currentTableView.tableFooterView = footer;
    
    CGFloat footerWidth = SCREEN_WIDTH;
    CGFloat btnX =  10;
    CGFloat btnWidth = SCREEN_WIDTH - 2 * btnX;
    CGFloat btnHeight = 35;
    
    // 退出当前账号
    UIButton *logout = [UIButton buttonWithType:UIButtonTypeCustom];
    logout.frame = CGRectMake(btnX, 6, btnWidth, btnHeight);
    [logout setTitle:@"退出登录" forState:UIControlStateNormal];
    [logout setBackgroundColor:[UIColor colorWithRed:0.929 green:0.255 blue:0.235 alpha:1.000]];
    logout.layer.cornerRadius = 3.0f;
//    [logout setBackgroundImage:[UIImage resizeImage:@"bigButtonbg_normal.png"] forState:UIControlStateNormal];
//    [logout setBackgroundImage:[UIImage resizeImage:@"bigButtonbg_selected.png"] forState:UIControlStateHighlighted];
    [logout addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    logout.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [footer addSubview:logout];
}

-(void)logout{
    [self.appConfig loadConfig];
    [self.appConfig clearUserInfo];
    // 退出第三方登录
    [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
    [ShareSDK cancelAuthorize:SSDKPlatformTypeSinaWeibo];
    [ShareSDK cancelAuthorize:SSDKPlatformTypeQQ];
    
    // 聊天退出登录
    [[EMIMHelper defaultHelper]logoffEasemobSDK];
}

- (void)loginOff
{
    [self presentViewController:[[UIStoryboard storyboardWithName:@"StoryboardIOS7" bundle:nil] instantiateViewControllerWithIdentifier:@"NavLoginViewController"] animated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:NO];
}



#pragma mark - tableView数据源代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SecurityCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SecurityCenterTableViewCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.nameLabel.text = [_currentTitles objectAtIndex:indexPath.row];
    cell.ActionLabel.text = [_currentTitle2s objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:kSegueSecurityToLoginPWD sender:self];
    }
    
    if (indexPath.row == 1) {
        [self performSegueWithIdentifier:kSegueSecurityToPayPWD sender:self];
    }
//    if (indexPath.row == 2) {
//        NSString * path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
//        float data = [FileService folderSizeAtPath:path];
//        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"缓存大小为%.2fM.确定要清除缓存吗?",data] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        [alertView show];
//    }
    if (indexPath.row == 2) {
        AboutAppController * vc = [[AboutAppController alloc]init];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:vc action:@selector(popViewControllerAnimated:)];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 1) {
//        NSString * path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
//        [FileService clearCache:path];
//        [self showAlertWithMessage:@"清除成功"];
//    }
//}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//     LoginViewController *lgvc = [segue destinationViewController];
//     if ([segue.identifier isEqualToString:kSeguePersonalToLogin]) {
//         if ([lgvc respondsToSelector:@selector(setFatherViewType:)]) {
//             lgvc.FatherViewType = LoginForPersonal;
//         }
//     }
}


@end
