//
//  PersonalCenterViewController.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-4.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "RefundOrderController.h"
#import "InformationController.h"
#import "UserInfoModel.h"
#import "OrderController.h"
#import "FootMarkViewController.h"
#import "ScoreViewController.h"
#import "FXController.h"
#import "ShoppingCartViewController.h"
#import "ChongZhiViewController.h"
#import "AdvanceController.h"
#import "OrderListController.h"
#import "FavourTicketModel.h"
#import "FavourTicketViewController.h"
#import "MembershipCardTV.h"
#import "MyCouponsVC.h"
#import "SearchResultViewController.h"


@interface PersonalCenterViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ChongZhiDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
///头像
@property (weak, nonatomic) IBOutlet UIImageView *imgView;  //70 70
///姓名
@property (weak, nonatomic) IBOutlet UILabel *name;
///预存款
@property (weak, nonatomic) IBOutlet UILabel *advance;
///积分
@property (weak, nonatomic) IBOutlet UILabel *score;
///积分
@property (nonatomic,assign) NSInteger scoreNum;
///预存款
@property (nonatomic,assign) CGFloat advanceNum;
@property (nonatomic,strong) NSString * mobile;
@property (nonatomic,assign)OrderStatus personOrderType;
@property (nonatomic,assign)ListViewType viewType;

@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UIButton *addMoney;

@property (weak, nonatomic) IBOutlet UILabel *ticketLabel;// 优惠券
@property (nonatomic,assign) NSInteger ticketNum; //优惠券个数
@property (copy, nonatomic) NSArray *ticketData;

@property (weak, nonatomic) IBOutlet UILabel *waitPayCountLabel; // 待付款个数
@property (weak, nonatomic) IBOutlet UILabel *waitDeliverCountLabel; // 待发货个数
@property (weak, nonatomic) IBOutlet UILabel *waitReceiveCountLabel; // 待收货个数

@property (weak, nonatomic) IBOutlet UIBarButtonItem *goMessageButton;  // 去消息中心

//会员卡
@property (nonatomic ,weak) NSString *cardGUID;


@end

static NSString *const cardID = @"f98ae50f-52a6-422c-a5e3-0a31a5bd3db3";


@implementation PersonalCenterViewController
{
    UIView *messageView;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView.rowHeight = 42.0f;
    AppConfig * config = [AppConfig sharedAppConfig];
    [config loadConfig];
    if (config.isLogin) {
        [self loadDataFromWeb];
        [self setupTicketData];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [messageView removeFromSuperview];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self basicStep];
}



-(void)basicStep
{
//    self.tableView.rowHeight = 44.0f;
    
    self.buttonView.layer.borderColor = LINE_LIGHTGRAY.CGColor;
    self.buttonView.layer.borderWidth = 0.5f;
    
    
    self.imgView.layer.cornerRadius = CGRectGetWidth(self.imgView.frame) / 2.0f;
    self.imgView.layer.borderColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5].CGColor;
    self.imgView.layer.borderWidth = 2;
    self.imgView.layer.masksToBounds = YES;
//    self.addMoney.layer.cornerRadius = 3;
//    self.addMoney.layer.borderColor = [UIColor whiteColor].CGColor;
//    self.addMoney.layer.borderWidth = 1;
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
    view.backgroundColor = BACKGROUND_GRAY;
    self.tableView.tableFooterView = view;
    self.tableView.backgroundColor = BACKGROUND_GRAY;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    ///跳转积分详情
    UITapGestureRecognizer * scoreTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scoreDetail)];
    scoreTap.numberOfTapsRequired = 1;
    self.score.userInteractionEnabled = YES;
    [self.score addGestureRecognizer:scoreTap];

    
    ///修改个人信息
    UITapGestureRecognizer * imgTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(updateInformation)];
    imgTap.numberOfTapsRequired = 1;
    self.imgView.userInteractionEnabled = YES;
    [self.imgView addGestureRecognizer:imgTap];
    
    
    
    ///预存款明细
    UITapGestureRecognizer * advanTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(advanInformation)];
    imgTap.numberOfTapsRequired = 1;
    self.advance.userInteractionEnabled = YES;
    [self.advance addGestureRecognizer:advanTap];
    
    self.waitPayCountLabel.layer.borderColor = MAIN_ORANGE.CGColor;
    self.waitPayCountLabel.layer.borderWidth = 1.2f;
    self.waitPayCountLabel.layer.cornerRadius = CGRectGetWidth(self.waitPayCountLabel.frame) / 2.0f;
    
    self.waitDeliverCountLabel.layer.borderColor = MAIN_ORANGE.CGColor;
    self.waitDeliverCountLabel.layer.borderWidth = 1.2f;
    self.waitDeliverCountLabel.layer.cornerRadius = CGRectGetWidth(self.waitDeliverCountLabel.frame) / 2.0f;
    
    self.waitReceiveCountLabel.layer.borderColor = MAIN_ORANGE.CGColor;
    self.waitReceiveCountLabel.layer.borderWidth = 1.2f;
    self.waitReceiveCountLabel.layer.cornerRadius = CGRectGetWidth(self.waitReceiveCountLabel.frame) / 2.0f;
    
    messageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
    messageView.layer.cornerRadius = CGRectGetWidth(messageView.frame) / 2;
    messageView.backgroundColor = MAIN_ORANGE;
    messageView.center = CGPointMake(SCREEN_WIDTH - 18, 15);
    messageView.hidden = YES;
}

-(void)loadDataFromWeb
{
    AppConfig * config = [AppConfig sharedAppConfig];
    [config loadConfig];
    NSDictionary * userinfoDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                  config.loginName, @"MemLoginID",
                                  config.appSign, @"AppSign",nil];
    [UserInfoModel getUserInfoByParamer:userinfoDic andblocks:^(UserInfoModel *user, NSError *error) {
        self.name.text = [user.RealName isEqualToString:@""]?user.userMobile:user.RealName;
        self.advance.text = [NSString stringWithFormat:@"余额: AU$ %.2f",user.userAdvancePayment];
        self.score.text = [NSString stringWithFormat:@"我的积分: %ld",user.userScore];
        config.userScore = user.userScore;
        [config saveConfig];
        self.scoreNum = user.userScore;
        self.advanceNum = user.userAdvancePayment;
        NSString * picStr = [NSString stringWithFormat:@"%@%@",kWebMainBaseUrl,user.userPhotoStr];
        [self.imgView setImageWithURL:[NSURL URLWithString:picStr] placeholderImage:[UIImage imageNamed:@"userphoto"]];
        
        self.mobile = user.userMobile;
        config.RealName = [user.RealName isEqualToString:@""]?user.userMobile:user.RealName;
        config.userUrlStr = picStr;
        config.Mobile = user.userMobile;
        [config saveConfig];

        if (user.MessageCount.integerValue > 0) {
            messageView.hidden = NO;
        } else {
            messageView.hidden = YES;
            [self.navigationController.navigationBar addSubview:messageView];
        }
        
        if (user.NoPaymentCount.integerValue > 0) {
            self.waitPayCountLabel.hidden = NO;
            self.waitPayCountLabel.text = user.NoPaymentCount.stringValue;
        } else {
            self.waitPayCountLabel.hidden = YES;
        }
        
        if (user.NoShippedCount.integerValue > 0) {
            self.waitDeliverCountLabel.hidden = NO;
            self.waitDeliverCountLabel.text = user.NoShippedCount.stringValue;
        } else {
            self.waitDeliverCountLabel.hidden = YES;
        }
        
        if (user.NoReceivedCount.integerValue > 0) {
            self.waitReceiveCountLabel.hidden = NO;
            self.waitReceiveCountLabel.text = user.NoReceivedCount.stringValue;
        } else {
            self.waitReceiveCountLabel.hidden = YES;
        }
        
    }];
}

- (void)setupTicketData {
    ZDXWeakSelf(weakSelf);
    [FavourTicketModel fetchFavourTicketListWithParameter:@{@"AppSign" : [AppConfig sharedAppConfig].appSign , @"MemLoginID" : [AppConfig sharedAppConfig].loginName} block:^(NSArray *list, NSError *error) {
        if (error) {
            
        } else {
            if (list && list.count > 0) {
                weakSelf.ticketData = list;
                weakSelf.ticketNum = list.count;
                weakSelf.ticketLabel.text = @"我的优惠券";
            }
        }
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
  //  return 4;
    
   return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor = FONT_BLACK;
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    switch (indexPath.section) {
            /*
        case 0:
            cell.textLabel.text = @"一元订单";
            cell.imageView.image = [UIImage imageNamed:@"yiyuangou"];
            break;
             */
        case 0:
            cell.textLabel.text = @"我的收藏";
            cell.imageView.image = [UIImage imageNamed:@"collect"];
            break;
        case 1:
            cell.textLabel.text = @"我的团队";
            cell.imageView.image = [UIImage imageNamed:@"group"];
            break;
        case 2:
            cell.textLabel.text = @"管理收货地址";
            cell.imageView.image = [UIImage imageNamed:@"address"];
            break;
        case 3:
            cell.textLabel.text = @"会员卡";
            cell.imageView.image = [UIImage imageNamed:@"个人中心会员卡"];
            break;
        
        
        
        case 4:
            cell.textLabel.text = @"购买虚拟卡";
            cell.imageView.image = [UIImage imageNamed:@"购买_icon_充值卡12"];
            break;
        
        
        
        default:
            break;
    }
    ///分割线
//    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 44, [UIScreen mainScreen].bounds.size.width, 0.5)];
//    view.backgroundColor = LINE_LIGHTGRAY;
//    [cell addSubview:view];
    cell.layer.borderColor = LINE_LIGHTGRAY.CGColor;
    cell.layer.borderWidth = 0.5f;
    return cell;
}

-(CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 5;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
            /*
        case 0: { // 一元购
            [self performSegueWithIdentifier:@"kSegueCenterToYiYuanGouList" sender:self];
        }
            break;
             */
        case 0: { // 收藏
            _viewType = MerchandiseForFavo;
            [self performSegueWithIdentifier:kSeguePersonToCollect sender:self];
        }
            
            break;
        case 1: { // 我的团队
            FXController * vc = [[UIStoryboard storyboardWithName:@"Center" bundle:nil]instantiateViewControllerWithIdentifier:@"FXController"];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2: { // 收货地址
            [self performSegueWithIdentifier:kSeguePresonalToAddress sender:self];
        }
            break;
        case 3: { //会员卡
            MembershipCardTV *menberCard = [[MembershipCardTV alloc]init];
            menberCard.hidesBottomBarWhenPushed=YES;// 进入后隐藏tabbar
            [self.navigationController pushViewController:menberCard animated:YES];
            self.hidesBottomBarWhenPushed = NO;
            
        }
            break;
        case 4:{ //购买虚拟卡
            SearchResultViewController *search = [SearchResultViewController createSearchResultVC];
            search.searchText= @"购物卡";
            [self.navigationController pushViewController:search animated:YES];

        }
            break;
        default:
            break;
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:kSeguePersonToCollect]) {
        FootMarkViewController * fmvc = [segue destinationViewController];
        if ([fmvc respondsToSelector:@selector(setViewType:)]) {
            fmvc.viewType = _viewType;
        }
    }
//    
//    if ([segue.identifier isEqualToString:@"kSeguePresonalToTicket"]) {
//        FavourTicketViewController *ticketVC = [segue destinationViewController];
//        ticketVC.ticketData = self.ticketData;
//    }
    
//
//    LoginViewController * lgvc = [segue destinationViewController];
//    if ([segue.identifier isEqualToString:kSeguePersonalToLogin]) {
//        if ([lgvc respondsToSelector:@selector(setFatherViewType:)]) {
//            lgvc.FatherViewType = LoginForPersonal;
//        }
//    }
}
#pragma mark - 





#pragma mark - 积分明细
-(void)scoreDetail
{
    ScoreViewController * vc = [[ScoreViewController alloc]initWithStyle:UITableViewStyleGrouped];
    vc.scoreNum = self.scoreNum;
    vc.hidesBottomBarWhenPushed = YES;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:vc action:@selector(popViewControllerAnimated:)];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 优惠券列表
- (IBAction)gotoTicket:(id)sender {
    if (self.ticketNum > 0) {
        [self performSegueWithIdentifier:@"kSeguePresonalToTicket" sender:self];
    }
    
    MyCouponsVC *coupon = [[MyCouponsVC alloc]init];
    coupon.hidesBottomBarWhenPushed=YES;// 进入后隐藏tabbar

    [self.navigationController pushViewController:coupon animated:YES];
      self.hidesBottomBarWhenPushed = NO;
}


#pragma mark - 修改个人信息
-(IBAction)updateInformation
{
    InformationController * vc = [[UIStoryboard storyboardWithName:@"Center" bundle:nil]instantiateViewControllerWithIdentifier:@"InformationController"];
    vc.mobile = self.mobile;
    vc.hidesBottomBarWhenPushed = YES;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:vc action:@selector(popViewControllerAnimated:)];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 预存款明细
-(void)advanInformation
{
    AdvanceController * vc = [[AdvanceController alloc]initWithStyle:UITableViewStyleGrouped];
    vc.totalStr = [NSString stringWithFormat:@"AU$%.2f",self.advanceNum];
    vc.hidesBottomBarWhenPushed = YES;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:vc action:@selector(popViewControllerAnimated:)];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 系统设置
- (IBAction)systemClick:(id)sender {
    [self performSegueWithIdentifier:kSeguePersonalToSecurity sender:self];
}

- (IBAction)orderClick:(UIButton *)sender {
    if (sender.tag == 7) {
        RefundOrderController * vc = [[RefundOrderController alloc]initWithStyle:UITableViewStyleGrouped];
        vc.hidesBottomBarWhenPushed = YES;
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:vc action:@selector(popViewControllerAnimated:)];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        OrderListController * vc = [[OrderListController alloc]init];
        vc.OrderType = sender.tag;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)showMessageWithStr:(NSString *)str
{
//    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//    [alert show];
    [MBProgressHUD showMessage:str hideAfterTime:1.0f];
}


- (IBAction)gotoAllOrderList:(id)sender {
    OrderListController * vc = [[OrderListController alloc]init];
    vc.OrderType = ALL_ORDER;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)gotoMessage:(id)sender {
    [self performSegueWithIdentifier:kSeguePersonalToMessage sender:self];
}

#pragma mark - 充值
- (IBAction)addMoney:(UIButton *)sender {
    AdvanceController * vc = [[AdvanceController alloc]initWithStyle:UITableViewStyleGrouped];
    vc.totalStr = [NSString stringWithFormat:@"AU$%.2f",self.advanceNum];
    vc.hidesBottomBarWhenPushed = YES;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:vc action:@selector(popViewControllerAnimated:)];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)ChongZhiDidAddEndWithVC:(ChongZhiViewController *)vc
{
    [self loadDataFromWeb];
}
#pragma mark - UI

@end
