//
//  CardNumberInformation.m
//  ShopNum1V3.1
//
//  Created by 森泓投资 on 16/7/8.
//  Copyright © 2016年 WFS. All rights reserved.
//

#import "CardNumberInformation.h"
#import "CardNumberItem.h"
#import "RechargeView.h"
#import "DonationVC.h"
#import "CardInformationVC.h"


@interface CardNumberInformation ()


//卡号
@property (weak, nonatomic) IBOutlet UILabel *CardNumber;
//面值
@property (weak, nonatomic) IBOutlet UILabel *FaceValue;

@property (nonatomic,assign)NSInteger money;

//卡密
@property (nonatomic,copy)NSString *cardPass;
//充入时间
@property (weak, nonatomic) IBOutlet UILabel *BuyCardTime;

//充值
@property (weak, nonatomic) IBOutlet UIButton *BuyCard;

//转赠
@property (weak, nonatomic) IBOutlet UIButton *Donation;



@end


@implementation CardNumberInformation

-(void)setCardItem:(CardNumberItem *)cardItem
{
    _cardItem = cardItem;
    self.CardNumber.text = [NSString stringWithFormat:@"%@",cardItem.cardNumber];
    self.FaceValue.text = cardItem.faceValue;
    self.BuyCardTime.text = cardItem.buyCardTime;
    self.cardPass = cardItem.cardPass;
}



- (IBAction)BuyCardMoney:(id)sender {
    
     RechargeView *alert = [[RechargeView alloc] initWithAlertViewHeight:248];
     alert.MembershipCardNumber.text = [NSString stringWithFormat:@"会员卡卡号:%@",_CardNumber.text];
     alert.cardNumber =  _CardNumber.text;
     alert.cardAmount  = [_FaceValue.text integerValue];
    _money= [_FaceValue.text integerValue];
     alert.FaceVlace.text  = [NSString stringWithFormat:@"会员卡面值:  RMB¥%@(约AU$%ld)",_FaceValue.text,_money*19/100];
     alert.cardPass = _cardPass;
    NSLog(@"***---111---***=%@  ***---222---***=%@ ***---333---***%@",_CardNumber.text,_FaceValue.text,_cardPass);
    
}

- (IBAction)giveCard:(id)sender {
    
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            DonationVC *dvc = [[DonationVC alloc]init];
            dvc.cardNumber = _CardNumber.text;
            dvc.cardAmount= _FaceValue.text;
            dvc.pass = _cardPass;
            [((UIViewController *)nextResponder).navigationController pushViewController:dvc animated:YES];
            
            break;
        }
    }}
+ (CardNumberInformation *)cardNumberInfo {
    CardNumberInformation *cell = [[[NSBundle mainBundle]loadNibNamed:@"CustomCell" owner:nil options:nil] firstObject];
    return cell;
}


@end
