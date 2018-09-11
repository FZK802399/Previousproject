//
//  SeventhCollectionViewCell.h
//  Shop
//
//  Created by Mac on 15/10/23.
//  Copyright (c) 2015年 ocean. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScoreProductIntroModel;
@class MerchandiseIntroModel;

@interface SeventhCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) UILabel *repertoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *rmbLabel;

-(void)creatSearchTableViewCellWithScoreProductIntroModel:(ScoreProductIntroModel *)intro;
-(void)creatSearchTableViewCellWithMerchandiseIntroModel:(MerchandiseIntroModel *)intro;


@end
