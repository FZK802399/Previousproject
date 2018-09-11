//
//  FXCell.h
//  万汇江分界面
//
//  Created by dzy_PC on 15/11/25.
//  Copyright (c) 2015年 dzy_PC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXModel.h"
@interface FXCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *price;

@property (nonatomic,strong)FXModel * model;
@end
