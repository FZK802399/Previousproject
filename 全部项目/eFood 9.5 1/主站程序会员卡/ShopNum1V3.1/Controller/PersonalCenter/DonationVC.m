//
//  DonationVC.m
//  ShopNum1V3.1
//
//  Created by 森泓投资 on 16/7/11.
//  Copyright © 2016年 WFS. All rights reserved.
//

#import "DonationVC.h"
#import "RechargeView.h"
#import "CardNumberInformation.h"
#import "MBProgressHUD+LZ.h"
#import "TransferSuccess.h"
#import "CardInformationVC.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "CardNumberItem.h"

@interface DonationVC ()<TransferSuccessDelegate>
//转赠的会员卡号
@property (strong, nonatomic) UITextField *DonationCard;
//再次输入卡号
@property (strong, nonatomic)  UITextField *AgainDonationCard;
//验证卡号
@property (weak, nonatomic)  UIButton *ConfirmDonation;
//上方的绿色横线
@property (weak, nonatomic) UIView *GreenBarTop01;
//下方的绿色横线
@property (weak, nonatomic) UIView *GreenBarBottom01;

@property (nonatomic ,assign) NSString *numbers;

@property (nonatomic,assign)NSInteger account;

@property (nonatomic, strong) TransferSuccess *alert;

@end

@implementation DonationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"转赠";
    
    _DonationCard = [[UITextField alloc] initWithFrame:CGRectMake(30, 80, 300, 40)];
    //_DonationCard.keyboardType = UIKeyboardTypeNumberPad;
    _DonationCard.tintColor = [UIColor grayColor];
    _DonationCard.placeholder = @"请输入会员卡卡号";
    [self.view addSubview:_DonationCard];
    
    _AgainDonationCard = [[UITextField alloc] initWithFrame:CGRectMake(30, 125, 300, 40)];
    //_AgainDonationCard.keyboardType = UIKeyboardTypeNumberPad;
    _AgainDonationCard.tintColor = [UIColor grayColor];
    _AgainDonationCard.placeholder = @"请再次输入卡号";
    [self.view addSubview:_AgainDonationCard];
    
    UIButton *ConfirmDonation = [UIButton buttonWithType:UIButtonTypeCustom];
    ConfirmDonation.frame = CGRectMake(30, 216, 300, 40);
    ConfirmDonation.titleLabel.font = [UIFont systemFontOfSize:15];
    [ConfirmDonation setTitle:@"确认转让" forState:UIControlStateNormal];
    [ConfirmDonation setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    ConfirmDonation.backgroundColor = [UIColor colorWithRed:61/255.0 green:163/255.0 blue:171/255.0 alpha:1.000];
    [ConfirmDonation addTarget:self action:@selector(ConDona) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ConfirmDonation];
    
    UIView *GreenBarTop01 = [[UIView alloc]initWithFrame:CGRectMake(30, 120, 300, 1)];
    GreenBarTop01.backgroundColor = [UIColor colorWithRed:61/255.0 green:163/255.0 blue:171/255.0 alpha:1.000];
    [self.view addSubview:GreenBarTop01];
    
    UIView *GreenBarBottom01 = [[UIView alloc] initWithFrame:CGRectMake(30, 165, 300, 1)];
    GreenBarBottom01.backgroundColor = [UIColor colorWithRed:61/255.0 green:163/255.0 blue:171/255.0 alpha:1.000];
    [self.view addSubview:GreenBarBottom01];

}

-(void)ConDona
{
    
//    if(_DonationCard.text !=_AgainDonationCard.text )
//    {
//         [MBProgressHUD showSuccess:@"两次输入的账号不同"];
//        
//          }
//    else{
    
    
       
    NSLog(@"11111111111111---------------==%@  !!!!!!!!!!!!!! !!222222222222---------=%@",_cardAmount,_cardNumber);
    self.alert = [[TransferSuccess alloc] initWithAlertViewHeight:248];
    self.alert.MembershipCardNumber.text = [NSString stringWithFormat:@"   会员卡卡号:%@",_cardNumber];
    self.alert.money = [_cardAmount integerValue]*19/100;
    self.alert.delegate = self;
    _account = self.alert.money;
    self.alert.FaceVlace.text = [NSString stringWithFormat:@"   会员卡面值:  ¥%@(约AU$%lu)",_cardAmount,_account];
    self.alert.DonationParty.text= [NSString stringWithFormat:@"   转赠方：%@",ApplicationDelegate.loginDic[@"Mobile"]];
    self.alert.CardReceivingParty.text = [NSString stringWithFormat:@"   收卡方：%@",_DonationCard.text];
    
    self.alert.amount = _cardAmount;
    self.alert.cardCode = _cardNumber;
    
    self.alert.sender =[[NSUserDefaults standardUserDefaults]objectForKey:@"Shop_Login_Name"];;
    self.alert.receive = _DonationCard.text;
    self.alert.pass = _pass;
    
    NSLog(@"!!!!!!!!!!!!!!!!!!!!!!!!!!@@@@@@@@@@@@@!!!!!!!!!!!!!!!!!!!!=%@",self.alert.cardCode);
//}
}

- (void)transferSuccessHidden {
    
    //[self.alert removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
