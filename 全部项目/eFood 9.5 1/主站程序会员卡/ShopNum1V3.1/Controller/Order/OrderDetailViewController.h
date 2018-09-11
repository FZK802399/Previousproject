//
//  OrderDetailViewController.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-9-2.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "WFSViewController.h"
#import "OrderDetailModel.h"
#import "ScoreOrderDetailModel.h"

@interface OrderDetailViewController : WFSViewController
@property (strong, nonatomic) IBOutlet UIScrollView *allScrollView;

@property (strong, nonatomic) UIView *orderAddressView;
@property (strong, nonatomic) UIView *payTypeView;
@property (strong, nonatomic) UIView *transpotTypeView;
@property (strong, nonatomic) UIView *productDetailView;
@property (strong, nonatomic) UIView *useScoreView;
@property (strong, nonatomic) UIView *textMailView;
@property (strong, nonatomic) UIView *priceDetailView;
@property (strong, nonatomic) UIView *orderNumberView;
@property (strong, nonatomic) UIView *ButtonActionView;


@property (strong, nonatomic) IBOutlet UITextView *usersMail;


@property (strong, nonatomic) IBOutlet UILabel *addressName;
@property (strong, nonatomic) IBOutlet UILabel *telLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *payTypeLabel;
//运送方式
@property (strong, nonatomic) IBOutlet UILabel *TransportTypeLabel;
//运费
@property (strong, nonatomic) IBOutlet UILabel *TransportPriceLabel;
//商品总价
@property (strong, nonatomic) UILabel *totalProductPriceLabel;
//全部总价
@property (strong, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *postBaoPriceLabel;

@property (strong, nonatomic) NSString *currenOderNumber;
@property (strong, nonatomic) id currenDetailModel;
//@property (strong, nonatomic) ScoreOrderDetailModel *currenScoreDetailModel;
@property (strong, nonatomic) NSArray *currenDetailProduct;
@property (assign, nonatomic) NSInteger currenOrderType;

@end
