//
//  recommend CollectionViewCell.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-7.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MerchandiseIntroModel.h"
#import "ScoreProductIntroModel.h"

@interface recommendCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *showImage;//展示图片

@property (nonatomic, strong) UILabel *priceLabel;//价格

@property (nonatomic, strong) UILabel *nameLabel;//销售名称

@property (nonatomic, strong) UILabel *ScoreLabel;//销售名称

//根据数据模型创建视图
-(void)creatrecommendCollectionViewCellWithMerchandiseIntroModel:(MerchandiseIntroModel *) intro;

-(void)creatrecommendCollectionViewCellWithScoreProductIntroModel:(ScoreProductIntroModel *) intro;

@end
