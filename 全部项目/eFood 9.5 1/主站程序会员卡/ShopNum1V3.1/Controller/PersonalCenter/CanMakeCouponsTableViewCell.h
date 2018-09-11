//
//  CanMakeCouponsTableViewCell.h
//  ShopNum1V3.1
//
//  Created by 森泓投资 on 16/8/15.
//  Copyright © 2016年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponsModel.h"

@class CouponsModel;

@interface CanMakeCouponsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backImage;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyMakeLabel;
@property (weak, nonatomic) IBOutlet UILabel *CouponsLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

@property (nonatomic ,assign) BOOL isSelect;

@property (nonatomic ,assign) BOOL didSelect;
@property (nonatomic ,strong) CouponsModel *cmodel;


@property (nonatomic,assign) NSInteger indexNum;
+ (CanMakeCouponsTableViewCell *)canMakeCoupons;


@end
