//
//  NoCanCouponsTableViewCell.h
//  ShopNum1V3.1
//
//  Created by 森泓投资 on 16/8/15.
//  Copyright © 2016年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponsModel.h"

@class CouponsModel;

@interface NoCanCouponsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backImage;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyMakeLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponsLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic ,strong) CouponsModel *ncmodel;



+ (NoCanCouponsTableViewCell *)nocCanCoupons;




@end
