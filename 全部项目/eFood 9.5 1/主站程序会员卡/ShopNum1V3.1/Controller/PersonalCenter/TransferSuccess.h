//
//  TransferSuccess.h
//  ShopNum1V3.1
//
//  Created by 森泓投资 on 16/7/13.
//  Copyright © 2016年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TransferSuccessDelegate <NSObject>

- (void)transferSuccessHidden;

@end

@interface TransferSuccess : UIView

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
//转赠方
@property (nonatomic,strong)UILabel *DonationParty;
//收卡方
@property (nonatomic ,strong)UILabel *CardReceivingParty;

@property (weak, nonatomic) id <TransferSuccessDelegate> delegate;

//消费金额
@property (nonatomic ,copy) NSString *amount;
//卡号
@property (nonatomic ,copy) NSString *cardCode;
//转赠方
@property (nonatomic ,copy) NSString *sender;
//收卡
@property (nonatomic,copy)NSString *receive;
//卡密
@property (nonatomic,copy)NSString *pass;

//上一步按钮
@property (nonatomic ,strong) UIButton *LastStep;
//确认转赠
@property (nonatomic ,strong) UIButton *Confirm;
@property (nonatomic,assign)NSUInteger money;

- (instancetype)initWithAlertViewHeight:(CGFloat)height;

@end
