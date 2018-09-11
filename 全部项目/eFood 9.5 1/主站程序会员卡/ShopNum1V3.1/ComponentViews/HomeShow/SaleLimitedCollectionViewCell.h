//
//  SaleLimitedCollectionViewCell.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-14.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SaleProductModel.h"

@interface SaleLimitedCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *showImage;//展示图片

@property (nonatomic, strong) UILabel *priceLabel;//价格

@property (nonatomic, strong) UILabel *rmbLabel; //约人名币

@property (nonatomic, strong) UILabel *TimeLabel;//时间

@property (nonatomic, strong) UILabel *NameLabel;//时间

@property (nonatomic, strong) UIImageView *timeImage;//时间图片

//根据数据模型创建视图
-(void)creatSaleLimitedCollectionViewCellWithMerchandiseIntroModel:(SaleProductModel *) intro;

@end
