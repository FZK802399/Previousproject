//
//  SubmitOrderViewController.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-29.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "WFSViewController.h"
#import "PostageModel.h"
#import "AddressModel.h"
#import "PaymentModel.h"
#import "ZSYPopoverListView.h"
#import "AddressViewController.h"

typedef enum{

    PopoverListForPay = 0,

    PopoverListForPost = 1,
    
} PopoverListType;

typedef enum{
    
    SubmitOrderForScore = 0,
    
    SubmitOrderForCommon = 1,
    
} SubmitListType;

@interface SubmitOrderViewController : WFSViewController<ZSYPopoverListDatasource, ZSYPopoverListDelegate, AddressListViewControllerDelegate, UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *allScrollView;
///地址
@property (strong, nonatomic) IBOutlet UIView *orderAddressView;
///支付方式
@property (strong, nonatomic) IBOutlet UIView *payTypeView;
///配送方式
@property (strong, nonatomic) IBOutlet UIView *transpotTypeView;
///商品详情
@property (strong, nonatomic) IBOutlet UIView *productDetailView;
///使用积分
@property (strong, nonatomic) IBOutlet UIView *useScoreView;
///订单留言
@property (strong, nonatomic) IBOutlet UIView *textMailView;
@property (strong, nonatomic) IBOutlet UIView *ScoreInfoView;

@property (strong, nonatomic) IBOutlet UITextView *usersMail;


//商品参数数组
@property (strong, nonatomic) NSArray *productArray;
//提交商品参数数组
@property (strong, nonatomic) NSMutableArray *submitProductArray;

@property (nonatomic, retain) NSIndexPath *selectedIndexPath;

@property (strong, nonatomic) ZSYPopoverListView *choosePopView;

@property (assign ,nonatomic) PopoverListType popViewType;

@property (assign ,nonatomic) SubmitListType submitProductType;

@property (strong, nonatomic) IBOutlet UILabel *addressName;
@property (strong, nonatomic) IBOutlet UILabel *telLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *payTypeLabel;

@property (strong, nonatomic) IBOutlet UILabel *useScoreLabel;
//运送方式
@property (strong, nonatomic) IBOutlet UILabel *TransportTypeLabel;
//运费
@property (strong, nonatomic) IBOutlet UILabel *TransportPriceLabel;

@property (strong, nonatomic) IBOutlet UILabel *productAllPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *NeedScoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *postageLabel;
@property (strong, nonatomic) IBOutlet UILabel *ProductNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *inAllPriceLabel;

//商品总价
@property (strong, nonatomic) UILabel *totalProductPriceLabel;
//全部总价
@property (strong, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *postBaoPriceLabel;
@property (strong, nonatomic) IBOutlet UIView *bottomView;

//post 数据字典
@property (strong, nonatomic) NSMutableDictionary *submitDataDic;


@property (assign, nonatomic) CGFloat buyNum;
//@property (assign, nonatomic) CGFloat zongJia;

- (IBAction)changeAddressAction:(id)sender;
- (IBAction)changePayTypeAction:(id)sender;
- (IBAction)changeTransportAction:(id)sender;
- (IBAction)useScoreAction:(id)sender;
- (IBAction)submitAction:(id)sender;


@property (nonatomic, strong) NSMutableArray *postType;
@property (nonatomic, strong) NSMutableArray *payType;


@property (nonatomic, strong) NSString *orderNum;


@property (nonatomic, assign) CGFloat totalWeight;
///产品金额
@property (nonatomic, assign) CGFloat totalPrice;
//全部金额
@property (assign, nonatomic) CGFloat allTotalPrice;

@property (assign, nonatomic) NSInteger useScore;

///配送方式
@property (nonatomic, strong) PostageModel *selectPostType;
///支付方式
//@property (nonatomic, strong) PaymentModel *selectPayType;
@property (nonatomic, strong) NSString *selectPayType;
///配送地址
@property (nonatomic, strong) AddressModel *selectAddress;

// 购买类型
@property (nonatomic, assign) SaleType saleType;

@end
