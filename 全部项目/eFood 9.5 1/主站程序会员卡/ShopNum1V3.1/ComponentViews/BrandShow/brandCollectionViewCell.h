//
//  brandCollectionViewCell.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-9.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrandModel.h"
#import "SortModel.h"

@interface brandCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *showImage;//展示图片

@property (nonatomic, strong) UILabel *nameLabel;//品牌名称

//根据数据模型创建视图
-(void)creatbrandCollectionViewCellWithMerchandiseIntroModel:(BrandModel *) intro;

-(void)creatSortCollectionViewCellWithMerchandiseIntroModel:(SortModel *) intro;


@end
