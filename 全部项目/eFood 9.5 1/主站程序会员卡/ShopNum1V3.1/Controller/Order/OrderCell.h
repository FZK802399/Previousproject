//
//  OrderCell.h
//  ShopNum1V3.1
//
//  Created by yons on 15/11/24.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderMerchandiseIntroModel.h"
@interface OrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *type;

@property (nonatomic,strong)OrderMerchandiseIntroModel * model;
@end
