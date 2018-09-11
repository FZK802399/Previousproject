//
//  UpdateReturnOrderViewController.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-9-9.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "WFSViewController.h"

@interface UpdateReturnOrderViewController : WFSViewController
@property (strong, nonatomic) NSString * returnOrderGuid;
@property (strong, nonatomic) IBOutlet UITextField *logisticsCompany;
@property (strong, nonatomic) IBOutlet UITextField *logisticsNumber;
@property (strong, nonatomic) IBOutlet UIView *companyView;
@property (strong, nonatomic) IBOutlet UIView *NumberView;

@end
