//
//  ScoreCell.h
//  ShopNum1V3.1
//
//  Created by yons on 15/11/25.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DzyScoreModel.h"
#import "AdvancePaymentModel.h"
@interface ScoreCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *price;
///积分明细
@property (nonatomic,strong)DzyScoreModel * model;
///预存款明细
@property (nonatomic,strong)AdvancePaymentModel * advanceModel;
@end
