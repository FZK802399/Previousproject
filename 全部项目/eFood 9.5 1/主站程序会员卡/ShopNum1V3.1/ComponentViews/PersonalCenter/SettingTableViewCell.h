//
//  SettingTableViewCell.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-21.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingModel.h"
@interface SettingTableViewCell : UITableViewCell
@property (strong, nonatomic) UILabel *menuName;
@property (strong, nonatomic) UILabel *tipNum;
@property (strong, nonatomic) UIButton *detailButton;

@property (nonatomic, weak) UITableView *myTableView;
@property (nonatomic, strong) NSIndexPath *indexPath;

//根据数据模型创建视图
-(void)creatSettingTableViewCellWithSettingModel:(SettingModel *)intro;

@end
