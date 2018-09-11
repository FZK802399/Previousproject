//
//  DZYSubmitOrderSectionFoot.m
//  ShopNum1V3.1
//
//  Created by yons on 16/1/20.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import "DZYSubmitOrderSectionFoot.h"


@interface DZYSubmitOrderSectionFoot ()

@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *shui;
@property (weak, nonatomic) IBOutlet UILabel *yunfei;
@property (weak, nonatomic) IBOutlet UILabel *rmbPrice;

//可使用优惠券数量
@property (weak, nonatomic) IBOutlet UILabel *canMakeCoupons;

@property (weak, nonatomic) IBOutlet UIButton *couponsClick;

- (IBAction)couponsBtn:(id)sender;


@property (nonatomic,assign)CGFloat shuiPrice;
@property (nonatomic,assign)CGFloat youFei;
@property (nonatomic,assign)CGFloat RMB;

@property (nonatomic,assign)CGFloat couponPrice;
@property (nonatomic,assign)NSInteger num;

@property (nonatomic,assign)NSInteger totalPrices;

@end

@implementation DZYSubmitOrderSectionFoot

-(void)setProductArr:(NSArray *)productArr
{
    _productArr = productArr;
    CGFloat totalPrice = 0;
    for (OrderMerchandiseSubmitModel * model in productArr) {
        totalPrice += model.BuyNumber * model.BuyPrice;
    }
    if (self.shuiPrice != 0) {
        totalPrice += self.shuiPrice;
    }
    if (self.youFei != 0) {
        totalPrice += self.youFei;
    }
    if (self.couponPrice != 0) {
        totalPrice -= self.couponPrice;
    }
    self.totalPrices = totalPrice;
    
    self.price.text = [NSString stringWithFormat:@"AU$%.2f",totalPrice];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _num = [[defaults objectForKey:@"num"]integerValue];
    self.canMakeCoupons.text = [NSString stringWithFormat:@"%lu张可用",_num];

}

-(void)setShuiPriceWithshuiPrice:(CGFloat )shuiPrice
{
    self.shuiPrice = shuiPrice;
    self.shui.text = [NSString stringWithFormat:@"本单税费：AU$%.2f",shuiPrice];
}

-(void)setYouFeiWithPrice:(CGFloat )youFei
{
    self.youFei = youFei;
     self.yunfei.text = [NSString stringWithFormat:@"运费：AU$%.2f",youFei];
}

-(void)setRMBWithPrice:(CGFloat )RMB
{
    self.RMB = RMB;
    self.rmbPrice.text = [NSString stringWithFormat:@"约¥ %.2f",RMB];
}

-(void)setCouponsPrice:(CGFloat )couponsPrice
{

    self.price.text = [NSString stringWithFormat:@"AU$%.2f",self.totalPrices-couponsPrice];

    

}


- (IBAction)couponsBtn:(id)sender {
    
    
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            
            if (self.aDelegate&&[self.aDelegate respondsToSelector:@selector(setDZYSubmitOrderSectionFootBlak)]) {
                
                [self.aDelegate setDZYSubmitOrderSectionFootBlak];
                
            }
            
            

            
            break;
        }
    }
    

    
}



@end
