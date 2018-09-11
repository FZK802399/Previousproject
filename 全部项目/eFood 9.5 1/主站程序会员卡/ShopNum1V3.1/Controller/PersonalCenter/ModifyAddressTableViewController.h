//
//  ModifyAddressTableViewController.h
//  ShopNum1V3.1
//
//  Created by Mac on 16/1/3.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddressModel;

@interface ModifyAddressTableViewController : UITableViewController

@property (assign, nonatomic) BOOL isEditAddress; // 是否为编辑地址
@property (strong, nonatomic) AddressModel *currenAddressModel;

@end
