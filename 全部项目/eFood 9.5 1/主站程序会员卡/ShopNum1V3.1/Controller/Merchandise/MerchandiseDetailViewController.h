//
//  MerchandiseDetailViewController.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-7.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "WFSViewController.h"
#import "MerchandiseImageList.h"
#import "MerchandisePriceIntro.h"
#import "MerchandiseSpecificationItem.h"
#import "OrderMerchandiseSubmitModel.h"

#import "ScoreProductDetialModel.h"

typedef enum{
    //购买
    GoBUY = 0,
    //购物车
    AddShopCart = 1,
    
} NextStepType;

typedef enum{
    //普通
    CommonMerchandiseDetailType = 0,
    //积分商品
    ScoreMerchandiseDetailType = 1,
    
} MerchandiseDetailType;

@interface MerchandiseDetailViewController : WFSViewController<MerchandisePriceIntroDelegate, MerchandisePriceIntroDataSource, MerchandiseSpecficationItemDelegate, UIActionSheetDelegate>


@property (strong, nonatomic) OrderMerchandiseSubmitModel * subimitModel;
@property (assign, nonatomic) NextStepType stepType;
@property (strong, nonatomic) MerchandiseSpecificationItem *specificationItem;
@property (copy, nonatomic) NSString * GuID;

//抢购商品的结束时间
@property (strong, nonatomic) NSString * EndTime;
@property (strong, nonatomic) MerchandiseDetailModel * currentDetailModel;
@property (strong, nonatomic) IBOutlet UIScrollView *allDetilScroll;
@property (strong, nonatomic) IBOutlet MerchandiseImageList * ImageListView;
@property (strong, nonatomic) IBOutlet MerchandisePriceIntro *priceView;
@property (strong, nonatomic) NSString * MobileDetail;
@property (strong, nonatomic) IBOutlet UIButton *addShopCartBtn;
@property (strong, nonatomic) IBOutlet UIButton *goBuyBtn;
@property (strong, nonatomic) IBOutlet UIButton *goShopCartBtn;
@property (strong, nonatomic) IBOutlet UILabel *ShopCartNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *goButBtnTwo;

@property (assign, nonatomic) MerchandiseDetailType detailType;

@property (strong, nonatomic) ScoreProductDetialModel *ScoreDetailModel;

//购物车
- (IBAction)addShopCartBtnClick:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *goDetialView;
@property (strong, nonatomic) IBOutlet UIView *addressView;
@property (strong, nonatomic) IBOutlet UIView *apppraisalView;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel; // 地址
@property (strong, nonatomic) IBOutlet UILabel *HaveProductLabel; // 有无货

- (IBAction)goShopCartBtnClick:(id)sender;// 收藏按钮
- (IBAction)goAppraisalView:(id)sender;
- (IBAction)checkAreaAction:(id)sender;

+ (instancetype)createMerchandiseDetailVC;


@end
