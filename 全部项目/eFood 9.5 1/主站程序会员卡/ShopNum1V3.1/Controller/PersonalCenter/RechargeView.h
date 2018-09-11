//
//  RechargeView.h
//  ShopNum1V3.1
//
//  Created by 森泓投资 on 16/7/11.
//  Copyright © 2016年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>


#define MAINSCREENwidth   [UIScreen mainScreen].bounds.size.width
#define MAINSCREENheight  [UIScreen mainScreen].bounds.size.height
#define WINDOWFirst       [[[UIApplication sharedApplication] windows] firstObject]
#define RGBa(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#define AlertViewJianGe 19.5


@interface RechargeView : UIView


//页面的View
@property (nonatomic,strong)UIView *bGView;

//弹框顶部的view
@property (nonatomic ,strong)UILabel *BoxTop;

//弹框中间的view
@property (nonatomic ,strong)UIView *middleView;
//会员卡卡号
@property (nonatomic,strong)UILabel *MembershipCardNumber;
//会员卡面值
@property (nonatomic,strong)UILabel *FaceVlace;

//卡号
@property(nonatomic,copy)NSString *cardNumber;
//消费金额
@property(nonatomic,assign)NSUInteger cardAmount;
//卡密
@property(nonatomic,copy)NSString *cardPass;

@property (nonatomic,copy)NSString *account;
//转赠方
@property (nonatomic,strong)UILabel *DonationParty;
//收卡方
@property (nonatomic ,strong)UILabel *CardReceivingParty;

//上一步按钮
@property (nonatomic ,strong) UIButton *LastStep;
//确认转赠
@property (nonatomic ,strong) UIButton *Confirm;


@property (nonatomic,strong)NSString *time;
@property (nonatomic,strong)NSMutableString *outup;


- (instancetype)initWithAlertViewHeight:(CGFloat)height;

//定义block
@property (nonatomic,copy) void (^ VendorNameVCBlock)(NSString *tfText);

@end
