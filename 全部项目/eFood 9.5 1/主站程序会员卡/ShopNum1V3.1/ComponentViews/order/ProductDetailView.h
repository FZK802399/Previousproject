//
//  ProductDetailView.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-29.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ShopCartMerchandiseModel.h"
#import "OrderMerchandiseSubmitModel.h"
#import "OrderMerchandiseIntroModel.h"

@interface ProductDetailView : UIView

@property (strong ,nonatomic) UIImageView * IcoImage;
@property (strong ,nonatomic) UILabel * productName;
@property (strong ,nonatomic) UILabel * productPrice;
@property (strong ,nonatomic) UILabel * productNum;
@property (strong ,nonatomic) UILabel * productColor;
@property (strong ,nonatomic) UILabel * productActivity;


//-(void)creatProductDetailViewWithShopCartMerchandiseModel:(ShopCartMerchandiseModel *)detail;
-(void)creatProductDetailViewWithSubmitOrderViewController:(OrderMerchandiseSubmitModel *)detail;

-(void)creatProductDetailViewWithMerchandiseIntroModel:(OrderMerchandiseIntroModel *)detail;

@end
