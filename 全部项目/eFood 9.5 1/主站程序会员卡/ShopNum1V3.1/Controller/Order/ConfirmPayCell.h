//
//  ConfirmPayCell.h
//  ShopNum1V3.1
//
//  Created by yons on 15/11/19.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayMentListModel.h"
@interface ConfirmPayCell : UITableViewCell

@property(nonatomic,strong)PayMentListModel * model;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@end
