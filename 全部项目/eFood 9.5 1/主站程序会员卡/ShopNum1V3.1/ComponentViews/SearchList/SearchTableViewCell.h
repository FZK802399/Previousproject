//
//  SearchTableViewCell.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-13.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MerchandiseIntroModel.h"
#import "ScoreProductIntroModel.h"

@interface SearchTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *showImage;//展示图片

@property (nonatomic, strong) UILabel *nameLabel;//商品名称

@property (nonatomic, strong) UILabel *MarketPriceLabel;//商品市场价格

@property (nonatomic, strong) UILabel *ShopPriceLabel;//商品店铺价格

@property (nonatomic, strong) UILabel *saleNumLabel;//商品销量

@property (strong, nonatomic) UIButton *detailButton;

//根据数据模型创建视图
-(void)creatSearchTableViewCellWithMerchandiseIntroModel:(MerchandiseIntroModel *) intro;

-(void)creatSearchTableViewCellWithScoreProductIntroModel:(ScoreProductIntroModel *) intro;

@end
