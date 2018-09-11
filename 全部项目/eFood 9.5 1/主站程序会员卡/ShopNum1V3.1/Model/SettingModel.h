//
//  SettingModel.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-21.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    CellItemTypeNone,
    CellItemTypeDisclosureIndicator,
    CellItemTypeDetailDisclosureButton,
    CellItemTypeCheckmark,
    CellItemTypeSwitch, // 扩充
    CellItemTypeButton
} CellItemType;

@interface SettingModel : NSObject
@property (nonatomic, strong) NSString * MenuName;
@property (nonatomic, assign) NSInteger Tipnum;
@property (assign, nonatomic) CellItemType itemType;
+ (id)itemWithMenuName:(NSString *)name cellTipnum:(NSInteger)number withcellType:(CellItemType)type;
@end
