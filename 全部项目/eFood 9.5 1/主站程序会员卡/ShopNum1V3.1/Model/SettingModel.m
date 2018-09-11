//
//  SettingModel.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-21.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "SettingModel.h"

@implementation SettingModel
+ (id)itemWithMenuName:(NSString *)name cellTipnum:(NSInteger)number withcellType:(CellItemType)type{
    SettingModel *setting = [[SettingModel alloc] init];
    setting.MenuName = name;
    setting.Tipnum = number;
    setting.itemType = type;
    return setting;
}

@end
