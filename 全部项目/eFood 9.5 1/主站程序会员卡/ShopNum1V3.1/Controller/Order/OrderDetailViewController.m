//
//  OrderDetailViewController.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-9-2.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "ProductDetailView.h"
#import "OrderPayOnlineViewController.h"
#import "OrderReturnViewController.h"
#import "RefundOrderModel.h"
#import "UpdateReturnOrderViewController.h"


@interface OrderDetailViewController ()

@end

@implementation OrderDetailViewController{
    NSString *ReturnOrderGuid;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadLeftBackBtn];
    [self loadRightShortCutBtn];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.currenOrderType == 1) {
        [self loadScoreOrderDetailData];
    }else {
        [self loadOrderDetailData];
    }
    
}

-(void)updateViewWithDetailModel{
    
    if (self.currenOrderType == 1) {
        ScoreOrderDetailModel *currntModel = (ScoreOrderDetailModel *)_currenDetailModel;

        self.orderAddressView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, 320, 60)];
        self.orderAddressView.backgroundColor = [UIColor whiteColor];
        self.addressName = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 69, 21)];
        self.addressName.font = [UIFont systemFontOfSize:13];
        [self.orderAddressView addSubview:self.addressName];
        self.addressName.text = currntModel.Name;
        self.telLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 5, 161, 21)];
        self.telLabel.font = [UIFont systemFontOfSize:13];
        [self.orderAddressView addSubview:self.telLabel];
        self.telLabel.text = currntModel.Mobile;
        self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 270, 21)];
        self.addressLabel.font = [UIFont systemFontOfSize:13];
        [self.orderAddressView addSubview:self.addressLabel];
        self.addressLabel.text = currntModel.Address;
        
        self.productDetailView = [[UIView alloc] initWithFrame:CGRectMake(0, 75, 320, [self.currenDetailProduct count] * 115 + 25)];
        self.productDetailView.backgroundColor = [UIColor whiteColor];
        
        CGFloat OriginY = self.productDetailView.frame.origin.y + self.productDetailView.frame.size.height - 1;
        self.priceDetailView = [[UIView alloc] initWithFrame:CGRectMake(0, OriginY, 320, 80)];
        self.priceDetailView.backgroundColor = [UIColor whiteColor];
        
        UILabel *productPricetitle = [[UILabel alloc] initWithFrame:CGRectMake(180, 9, 60, 15)];
        productPricetitle.font = [UIFont systemFontOfSize:12];
        productPricetitle.text = @"商品总价：";
        productPricetitle.textColor = [UIColor textTitleColor];
        productPricetitle.textAlignment = NSTextAlignmentRight;
        [self.priceDetailView addSubview:productPricetitle];
        
        UILabel *productPrice = [[UILabel alloc] initWithFrame:CGRectMake(240, 9, 60, 15)];
        productPrice.font = [UIFont systemFontOfSize:12];
        productPrice.text = [NSString stringWithFormat:@"AU$ %.2f", currntModel.prmo];
        //    productPrice.textColor = [UIColor textTitleColor];
        productPrice.textAlignment = NSTextAlignmentLeft;
        [self.priceDetailView addSubview:productPrice];
        
        UILabel *postPriceTitle = [[UILabel alloc] initWithFrame:CGRectMake(180, 26, 60, 15)];
        postPriceTitle.text = [NSString stringWithFormat:@"积分："];
        postPriceTitle.textAlignment = NSTextAlignmentRight;
        postPriceTitle.font = [UIFont systemFontOfSize:12];
        postPriceTitle.textColor = [UIColor textTitleColor];
        [self.priceDetailView addSubview:postPriceTitle];
        
        
        UILabel *postPrice = [[UILabel alloc] initWithFrame:CGRectMake(240, 26, 70, 15)];
        postPrice.font = [UIFont systemFontOfSize:12];
        [self.priceDetailView addSubview:postPrice];
        postPrice.text = [NSString stringWithFormat:@"%d", currntModel.CostTotalScore];
        postPrice.textAlignment = NSTextAlignmentLeft;
        
        
        
        UILabel *paymentPriceTitle = [[UILabel alloc] initWithFrame:CGRectMake(180, 43, 60, 15)];
        paymentPriceTitle.text = [NSString stringWithFormat:@"运费："];
        paymentPriceTitle.textAlignment = NSTextAlignmentRight;
        paymentPriceTitle.font = [UIFont systemFontOfSize:12];
        paymentPriceTitle.textColor = [UIColor textTitleColor];
        [self.priceDetailView addSubview:paymentPriceTitle];
        
        UILabel *paymentPrice = [[UILabel alloc] initWithFrame:CGRectMake(240, 43, 60, 15)];
        paymentPrice.text = [NSString stringWithFormat:@"AU$ %.2f", currntModel.DispatchPrice];
        paymentPrice.textAlignment = NSTextAlignmentLeft;
        paymentPrice.font = [UIFont systemFontOfSize:12];
        [self.priceDetailView addSubview:paymentPrice];
        
        UILabel *shouldPayPricetitle = [[UILabel alloc] initWithFrame:CGRectMake(180, 60, 60, 15)];
        shouldPayPricetitle.text = [NSString stringWithFormat:@"实付款："];
        shouldPayPricetitle.textAlignment = NSTextAlignmentRight;
        shouldPayPricetitle.font = [UIFont systemFontOfSize:12];
        shouldPayPricetitle.textColor = [UIColor textTitleColor];
        [self.priceDetailView addSubview:shouldPayPricetitle];
        
        UILabel *shouldPayPrice = [[UILabel alloc] initWithFrame:CGRectMake(240, 60, 120, 15)];
        shouldPayPrice.text = [NSString stringWithFormat:@"AU$ %.2f", currntModel.TotaltPrice];
        shouldPayPrice.textAlignment = NSTextAlignmentLeft;
        shouldPayPrice.font = [UIFont systemFontOfSize:12];
        [self.priceDetailView addSubview:shouldPayPrice];
        
        OriginY += CGRectGetHeight(self.priceDetailView.frame) + 10;
        self.payTypeView = [[UIView alloc] initWithFrame:CGRectMake(0, OriginY, 320, 44)];
        self.payTypeView.backgroundColor = [UIColor whiteColor];
        UILabel * payTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 11, 68, 21)];
        payTitle.text = @"支付方式";
        payTitle.font = [UIFont systemFontOfSize:13];
        [self.payTypeView addSubview:payTitle];
        
        self.payTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(104, 11, 168, 21)];
        self.payTypeLabel.font = [UIFont systemFontOfSize:13];
        self.payTypeLabel.text = currntModel.PaymentName;
        
        self.payTypeLabel.textColor = [UIColor textTitleColor];
        [self.payTypeView addSubview:self.payTypeLabel];
        
        OriginY += CGRectGetHeight(self.payTypeView.frame) + 10;
        
        self.transpotTypeView = [[UIView alloc] initWithFrame:CGRectMake(0, OriginY, 320, 60)];
        self.transpotTypeView.backgroundColor = [UIColor whiteColor];
        UILabel * postTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, 68, 21)];
        postTitle.text = @"配送方式";
        postTitle.font = [UIFont systemFontOfSize:13];
        [self.transpotTypeView addSubview:postTitle];
        
        UILabel * postpriceTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 68, 21)];
        postpriceTitle.text = @"运费";
        postpriceTitle.font = [UIFont systemFontOfSize:13];
        [self.transpotTypeView addSubview:postpriceTitle];
        
        UILabel * baopriceTitle = [[UILabel alloc] initWithFrame:CGRectMake(210, 6, 68, 21)];
        baopriceTitle.text = @"保价费用";
        baopriceTitle.textColor = [UIColor textTitleColor];
        baopriceTitle.font = [UIFont systemFontOfSize:13];
        [self.transpotTypeView addSubview:baopriceTitle];
        
        self.TransportTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(104, 6, 91, 21)];
        self.TransportTypeLabel.font = [UIFont systemFontOfSize:13];
        self.TransportTypeLabel.textColor = [UIColor textTitleColor];
        self.TransportTypeLabel.text = currntModel.DispatchModeName;
        
        [self.transpotTypeView addSubview:self.TransportTypeLabel];
        
        self.TransportPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(104, 30, 75, 21)];
        self.TransportPriceLabel.text = [NSString stringWithFormat:@"AU$%.2f", currntModel.DispatchPrice];
        self.TransportPriceLabel.textColor = [UIColor redColor];
        self.TransportPriceLabel.font = [UIFont systemFontOfSize:13];
        [self.transpotTypeView addSubview:self.TransportPriceLabel];
        
        self.postBaoPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(210, 30, 75, 21)];
        self.postBaoPriceLabel.text = [NSString stringWithFormat:@"AU$%.2f", currntModel.InsurePrice];
        self.postBaoPriceLabel.textColor = [UIColor redColor];
        self.postBaoPriceLabel.font = [UIFont systemFontOfSize:13];
        [self.transpotTypeView addSubview:self.postBaoPriceLabel];
        
        
        
        OriginY += CGRectGetHeight(self.transpotTypeView.frame) + 10;
        self.textMailView = [[UIView alloc] initWithFrame:CGRectMake(0, OriginY, 320, 120)];
        self.textMailView.backgroundColor = [UIColor whiteColor];
        UILabel * usermailTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 320, 15)];
        usermailTitle.text = @"订单留言";
        usermailTitle.font = [UIFont systemFontOfSize:13];
        [self.textMailView addSubview:usermailTitle];
        self.usersMail = [[UITextView alloc] initWithFrame:CGRectMake(15, 25, 290, 80)];
        [self.usersMail setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
        self.usersMail.layer.cornerRadius = 3.0;
        self.usersMail.layer.borderWidth = 1.0;
        self.usersMail.layer.borderColor = [UIColor colorWithRed:238/255.0 green:238/225.0 blue:239/255.0 alpha:1].CGColor;
        [self.usersMail setEditable:NO];
        self.usersMail.text = currntModel.ClientToSellerMsg;
        self.usersMail.returnKeyType = UIReturnKeyDefault;
        [self.textMailView addSubview:self.usersMail];
        
        OriginY += CGRectGetHeight(self.textMailView.frame) + 10;
        self.useScoreView = [[UIView alloc] initWithFrame:CGRectMake(0, OriginY, 320, 44)];
        self.useScoreView.backgroundColor = [UIColor whiteColor];
        UILabel * scoreTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 11, 68, 21)];
        scoreTitle.text = @"下单时间：";
        scoreTitle.font = [UIFont systemFontOfSize:13];
        [self.useScoreView addSubview:scoreTitle];
        
        UILabel * timeTitle = [[UILabel alloc] initWithFrame:CGRectMake(70, 11, 200, 21)];
        timeTitle.text = currntModel.CreateTime;
        timeTitle.font = [UIFont systemFontOfSize:12];
        [self.useScoreView addSubview:timeTitle];
        
        OriginY += CGRectGetHeight(self.useScoreView.frame) - 1;
        self.orderNumberView = [[UIView alloc] initWithFrame:CGRectMake(0, OriginY, 320, 44)];
        self.orderNumberView.backgroundColor = [UIColor whiteColor];
        UILabel * orderTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 11, 68, 21)];
        orderTitle.text = @"订单编号：";
        orderTitle.font = [UIFont systemFontOfSize:13];
        [self.orderNumberView addSubview:orderTitle];
        UILabel * ordernumber = [[UILabel alloc] initWithFrame:CGRectMake(70, 11, 200, 21)];
        ordernumber.text = _currenOderNumber;
        ordernumber.font = [UIFont systemFontOfSize:12];
        [self.orderNumberView addSubview:ordernumber];
        
        self.orderAddressView.layer.borderWidth = 1;
        self.orderAddressView.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
        
        self.payTypeView.layer.borderWidth = 1;
        self.payTypeView.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
        
        self.transpotTypeView.layer.borderWidth = 1;
        self.transpotTypeView.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
        
        self.productDetailView.layer.borderWidth = 1;
        self.productDetailView.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
        
        self.useScoreView.layer.borderWidth = 1;
        self.useScoreView.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
        
        self.textMailView.layer.borderWidth = 1;
        self.textMailView.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
        
        self.priceDetailView.layer.borderWidth = 1;
        self.priceDetailView.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
        
        self.orderNumberView.layer.borderWidth = 1;
        self.orderNumberView.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
        
        self.ButtonActionView.layer.borderWidth = 1;
        self.ButtonActionView.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
        
        
        [self.allScrollView addSubview:self.orderAddressView];
        [self.allScrollView addSubview:self.productDetailView];
        [self.allScrollView addSubview:self.payTypeView];
        [self.allScrollView addSubview:self.transpotTypeView];
        [self.allScrollView addSubview:self.priceDetailView];
        [self.allScrollView addSubview:self.textMailView];
        [self.allScrollView addSubview:self.useScoreView];
        [self.allScrollView addSubview:self.orderNumberView];
        [self.allScrollView addSubview:self.ButtonActionView];
        [self.allScrollView setContentSize:CGSizeMake(320, self.orderNumberView.frame.origin.y + self.orderNumberView.frame.size.height + 10 + CGRectGetHeight(self.ButtonActionView.frame))];
        self.allScrollView.scrollEnabled = YES;
        
        [self loadProductInfoView];

        
    }else {
    
        OrderDetailModel *currntModel = (OrderDetailModel *)_currenDetailModel;
        
        self.orderAddressView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, 320, 60)];
        self.orderAddressView.backgroundColor = [UIColor whiteColor];
        self.addressName = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 69, 21)];
        self.addressName.font = [UIFont systemFontOfSize:13];
        [self.orderAddressView addSubview:self.addressName];
        self.addressName.text = currntModel.Name;
        self.telLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 5, 161, 21)];
        self.telLabel.font = [UIFont systemFontOfSize:13];
        [self.orderAddressView addSubview:self.telLabel];
        self.telLabel.text = currntModel.Mobile;
        self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 270, 21)];
        self.addressLabel.font = [UIFont systemFontOfSize:13];
        [self.orderAddressView addSubview:self.addressLabel];
        self.addressLabel.text = currntModel.Address;
        
        self.productDetailView = [[UIView alloc] initWithFrame:CGRectMake(0, 75, 320, [self.currenDetailProduct count] * 115 + 25)];
        self.productDetailView.backgroundColor = [UIColor whiteColor];
        
        CGFloat OriginY = self.productDetailView.frame.origin.y + self.productDetailView.frame.size.height - 1;
        self.priceDetailView = [[UIView alloc] initWithFrame:CGRectMake(0, OriginY, 320, 80)];
        self.priceDetailView.backgroundColor = [UIColor whiteColor];
        
        UILabel *productPricetitle = [[UILabel alloc] initWithFrame:CGRectMake(180, 9, 60, 15)];
        productPricetitle.font = [UIFont systemFontOfSize:12];
        productPricetitle.text = @"商品总价：";
        productPricetitle.textColor = [UIColor textTitleColor];
        productPricetitle.textAlignment = NSTextAlignmentRight;
        [self.priceDetailView addSubview:productPricetitle];
        
        UILabel *productPrice = [[UILabel alloc] initWithFrame:CGRectMake(240, 9, 60, 15)];
        productPrice.font = [UIFont systemFontOfSize:12];
        productPrice.text = [NSString stringWithFormat:@"AU$ %.2f", currntModel.ProductPrice];
        //    productPrice.textColor = [UIColor textTitleColor];
        productPrice.textAlignment = NSTextAlignmentLeft;
        [self.priceDetailView addSubview:productPrice];
        
        UILabel *postPriceTitle = [[UILabel alloc] initWithFrame:CGRectMake(180, 26, 60, 15)];
        postPriceTitle.text = [NSString stringWithFormat:@"运费："];
        postPriceTitle.textAlignment = NSTextAlignmentRight;
        postPriceTitle.font = [UIFont systemFontOfSize:12];
        postPriceTitle.textColor = [UIColor textTitleColor];
        [self.priceDetailView addSubview:postPriceTitle];
        
        
        UILabel *postPrice = [[UILabel alloc] initWithFrame:CGRectMake(240, 26, 70, 15)];
        postPrice.font = [UIFont systemFontOfSize:12];
        [self.priceDetailView addSubview:postPrice];
        
        if (currntModel.ScorePrice == 0) {
            postPrice.text = [NSString stringWithFormat:@"AU$ %.2f", currntModel.DispatchPrice];
            postPrice.textAlignment = NSTextAlignmentLeft;
        }else{
            [postPriceTitle setHidden:YES];
            postPrice.frame = CGRectMake(200, 26, 90, 15);
            postPrice.text = [NSString stringWithFormat:@"积分抵现%.0f元", currntModel.ScorePrice];
            postPrice.textColor = [UIColor colorWithRed:255/255.0 green:122/255.0 blue:120/255.0 alpha:1];
            postPrice.layer.cornerRadius = 2;
            postPrice.layer.borderWidth = 1;
            postPrice.layer.borderColor = [UIColor colorWithRed:255/255.0 green:122/255.0 blue:120/255.0 alpha:1].CGColor;
            postPrice.textAlignment = NSTextAlignmentCenter;
        }
        
        UILabel *paymentPriceTitle = [[UILabel alloc] initWithFrame:CGRectMake(180, 43, 60, 15)];
        paymentPriceTitle.text = [NSString stringWithFormat:@"手续费："];
        paymentPriceTitle.textAlignment = NSTextAlignmentRight;
        paymentPriceTitle.font = [UIFont systemFontOfSize:12];
        paymentPriceTitle.textColor = [UIColor textTitleColor];
        [self.priceDetailView addSubview:paymentPriceTitle];
        
        UILabel *paymentPrice = [[UILabel alloc] initWithFrame:CGRectMake(240, 43, 60, 15)];
        paymentPrice.text = [NSString stringWithFormat:@"AU$ %.2f", currntModel.paymentModel.Charge];
        paymentPrice.textAlignment = NSTextAlignmentLeft;
        paymentPrice.font = [UIFont systemFontOfSize:12];
        [self.priceDetailView addSubview:paymentPrice];
        
        UILabel *shouldPayPricetitle = [[UILabel alloc] initWithFrame:CGRectMake(180, 60, 60, 15)];
        shouldPayPricetitle.text = [NSString stringWithFormat:@"实付款："];
        shouldPayPricetitle.textAlignment = NSTextAlignmentRight;
        shouldPayPricetitle.font = [UIFont systemFontOfSize:12];
        shouldPayPricetitle.textColor = [UIColor textTitleColor];
        [self.priceDetailView addSubview:shouldPayPricetitle];
        
        UILabel *shouldPayPrice = [[UILabel alloc] initWithFrame:CGRectMake(240, 60, 120, 15)];
        shouldPayPrice.text = [NSString stringWithFormat:@"AU$ %.2f", currntModel.DispatchPrice + currntModel.InsurePrice + currntModel.ProductPrice - currntModel.ScorePrice];
        shouldPayPrice.textAlignment = NSTextAlignmentLeft;
        shouldPayPrice.font = [UIFont systemFontOfSize:12];
        [self.priceDetailView addSubview:shouldPayPrice];
        
        OriginY += CGRectGetHeight(self.priceDetailView.frame) + 10;
        self.payTypeView = [[UIView alloc] initWithFrame:CGRectMake(0, OriginY, 320, 44)];
        self.payTypeView.backgroundColor = [UIColor whiteColor];
        UILabel * payTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 11, 68, 21)];
        payTitle.text = @"支付方式";
        payTitle.font = [UIFont systemFontOfSize:13];
        [self.payTypeView addSubview:payTitle];
        
        self.payTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(104, 11, 168, 21)];
        self.payTypeLabel.font = [UIFont systemFontOfSize:13];
        if (currntModel.paymentModel) {
            self.payTypeLabel.text = currntModel.paymentModel.name;
        }else{
            self.payTypeLabel.text = currntModel.PayTypeName;
        }
        
        self.payTypeLabel.textColor = [UIColor textTitleColor];
        [self.payTypeView addSubview:self.payTypeLabel];
        
        OriginY += CGRectGetHeight(self.payTypeView.frame) + 10;
        
        self.transpotTypeView = [[UIView alloc] initWithFrame:CGRectMake(0, OriginY, 320, 60)];
        self.transpotTypeView.backgroundColor = [UIColor whiteColor];
        UILabel * postTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, 68, 21)];
        postTitle.text = @"配送方式";
        postTitle.font = [UIFont systemFontOfSize:13];
        [self.transpotTypeView addSubview:postTitle];
        
        UILabel * postpriceTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 68, 21)];
        postpriceTitle.text = @"运费";
        postpriceTitle.font = [UIFont systemFontOfSize:13];
        [self.transpotTypeView addSubview:postpriceTitle];
        
        UILabel * baopriceTitle = [[UILabel alloc] initWithFrame:CGRectMake(210, 6, 68, 21)];
        baopriceTitle.text = @"保价费用";
        baopriceTitle.textColor = [UIColor textTitleColor];
        baopriceTitle.font = [UIFont systemFontOfSize:13];
        [self.transpotTypeView addSubview:baopriceTitle];
        
        self.TransportTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(104, 6, 91, 21)];
        self.TransportTypeLabel.font = [UIFont systemFontOfSize:13];
        self.TransportTypeLabel.textColor = [UIColor textTitleColor];
        self.TransportTypeLabel.text = currntModel.PostModel.name2;
        
        [self.transpotTypeView addSubview:self.TransportTypeLabel];
        
        self.TransportPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(104, 30, 75, 21)];
        self.TransportPriceLabel.text = [NSString stringWithFormat:@"AU$%.2f", currntModel.DispatchPrice];
        self.TransportPriceLabel.textColor = [UIColor redColor];
        self.TransportPriceLabel.font = [UIFont systemFontOfSize:13];
        [self.transpotTypeView addSubview:self.TransportPriceLabel];
        
        self.postBaoPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(210, 30, 75, 21)];
        self.postBaoPriceLabel.text = [NSString stringWithFormat:@"AU$%.2f", currntModel.InsurePrice];
        self.postBaoPriceLabel.textColor = [UIColor redColor];
        self.postBaoPriceLabel.font = [UIFont systemFontOfSize:13];
        [self.transpotTypeView addSubview:self.postBaoPriceLabel];
        
        
        
        OriginY += CGRectGetHeight(self.transpotTypeView.frame) + 10;
        self.textMailView = [[UIView alloc] initWithFrame:CGRectMake(0, OriginY, 320, 120)];
        self.textMailView.backgroundColor = [UIColor whiteColor];
        UILabel * usermailTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 320, 15)];
        usermailTitle.text = @"订单留言";
        usermailTitle.font = [UIFont systemFontOfSize:13];
        [self.textMailView addSubview:usermailTitle];
        self.usersMail = [[UITextView alloc] initWithFrame:CGRectMake(15, 25, 290, 80)];
        [self.usersMail setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
        self.usersMail.layer.cornerRadius = 3.0;
        self.usersMail.layer.borderWidth = 1.0;
        self.usersMail.layer.borderColor = [UIColor colorWithRed:238/255.0 green:238/225.0 blue:239/255.0 alpha:1].CGColor;
        [self.usersMail setEditable:NO];
        self.usersMail.text = currntModel.ClientToSellerMsg;
        self.usersMail.returnKeyType = UIReturnKeyDefault;
        [self.textMailView addSubview:self.usersMail];
        
        OriginY += CGRectGetHeight(self.textMailView.frame) + 10;
        self.useScoreView = [[UIView alloc] initWithFrame:CGRectMake(0, OriginY, 320, 44)];
        self.useScoreView.backgroundColor = [UIColor whiteColor];
        UILabel * scoreTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 11, 68, 21)];
        scoreTitle.text = @"下单时间：";
        scoreTitle.font = [UIFont systemFontOfSize:13];
        [self.useScoreView addSubview:scoreTitle];
        
        UILabel * timeTitle = [[UILabel alloc] initWithFrame:CGRectMake(70, 11, 200, 21)];
        timeTitle.text = currntModel.CreateTime;
        timeTitle.font = [UIFont systemFontOfSize:12];
        [self.useScoreView addSubview:timeTitle];
        
        OriginY += CGRectGetHeight(self.useScoreView.frame) - 1;
        self.orderNumberView = [[UIView alloc] initWithFrame:CGRectMake(0, OriginY, 320, 44)];
        self.orderNumberView.backgroundColor = [UIColor whiteColor];
        UILabel * orderTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 11, 68, 21)];
        orderTitle.text = @"订单编号：";
        orderTitle.font = [UIFont systemFontOfSize:13];
        [self.orderNumberView addSubview:orderTitle];
        UILabel * ordernumber = [[UILabel alloc] initWithFrame:CGRectMake(70, 11, 200, 21)];
        ordernumber.text = _currenOderNumber;
        ordernumber.font = [UIFont systemFontOfSize:12];
        [self.orderNumberView addSubview:ordernumber];
        
        if ((currntModel.ShipmentStatus ==1 && currntModel.OrderStatus != 2 && currntModel.OrderStatus != 3) || (currntModel.ShipmentStatus ==4 && currntModel.OrderStatus != 2 && currntModel.OrderStatus != 3)) {
            OriginY += CGRectGetHeight(self.orderNumberView.frame) + 10;
            self.ButtonActionView = [[UIView alloc] initWithFrame:CGRectMake(0, OriginY, 320, 44)];
            UIButton * cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            cancleBtn.frame = CGRectMake(100, 9, 110, 25);
            [cancleBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
            [cancleBtn setBackgroundImage:[UIImage imageNamed:@"middle_yellow_btnbg_normal.png"] forState:UIControlStateNormal];
            
            NSDictionary *returnDic= [NSDictionary dictionaryWithObjectsAndKeys:
                                      kWebAppSign,@"AppSign",
                                      self.appConfig.loginName, @"MemLoginID",
                                      currntModel.Guid, @"OrderGuid", nil];
            [RefundOrderModel getReturnOrderDetailWithparameters:returnDic andblock:^(RefundOrderModel *model, NSError *error) {
                if (error) {
                    
                }else {
                    if (model) {
                        ReturnOrderGuid = model.Guid;
                        if (model.returnOrderStatue == 0) {
                            self.title = @"退货中";
                            [cancleBtn setBackgroundImage:[UIImage imageNamed:@"middle_yellow_btnbg_normal.png"] forState:UIControlStateNormal];
                            [cancleBtn setTitle:@"申请待审核" forState:UIControlStateNormal];
                            [self.ButtonActionView addSubview:cancleBtn];
                            //                    [self.ReturnBtn addTarget:self action:@selector(ReturnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        }else if (model.returnOrderStatue == 3){
                            self.title = @"退货中";
                            [cancleBtn setBackgroundImage:[UIImage imageNamed:@"middle_yellow_btnbg_normal.png"] forState:UIControlStateNormal];
                            [cancleBtn setTitle:@"退货中" forState:UIControlStateNormal];
                            [self.ButtonActionView addSubview:cancleBtn];
                            
                        }else if (model.returnOrderStatue == 4){
                            //                        self.title = @"已完成";
                            CGFloat RallPrice = 0;
                            for (ReturnGoodModel *goodModel in model.returnProductList) {
                                RallPrice += goodModel.BuyPrice * goodModel.ReturnCount;
                            }
                            
                            [cancleBtn setBackgroundImage:[UIImage imageNamed:@"middle_yellow_btnbg_normal.png"] forState:UIControlStateNormal];
                            [cancleBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
                            [cancleBtn setTitle:[NSString stringWithFormat:@"退款：%.2f", RallPrice] forState:UIControlStateNormal];
                            [self.ButtonActionView addSubview:cancleBtn];
                            
                        }else if (model.returnOrderStatue == 1){
                            //                        self.title = @"已完成";
                            [cancleBtn setBackgroundImage:[UIImage imageNamed:@"middle_yellow_btnbg_normal.png"] forState:UIControlStateNormal];
                            [cancleBtn setTitle:@"不同意退货" forState:UIControlStateNormal];
                            //                        [self.ButtonActionView addSubview:cancleBtn];
                            
                        }else {
                            self.title = @"退货中";
                            [cancleBtn setBackgroundImage:[UIImage imageNamed:@"middle_yellow_btnbg_normal.png"] forState:UIControlStateNormal];
                            [cancleBtn setTitle:@"填写物流信息" forState:UIControlStateNormal];
                            [self.ButtonActionView addSubview:cancleBtn];
                            [cancleBtn addTarget:self action:@selector(updateReturnOrderClick:) forControlEvents:UIControlEventTouchUpInside];
                        }
                    }else{
                        [cancleBtn setTitle:@"申请退货" forState:UIControlStateNormal];
                        [self.ButtonActionView addSubview:cancleBtn];
                        [cancleBtn addTarget:self action:@selector(cancelOrder) forControlEvents:UIControlEventTouchUpInside];
                    }
                    
                }
            }];
            
            
            
        }
        
        //
        //    //支付宝支付
        //    UIButton * payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //    payBtn.frame = CGRectMake(218, 5, 93, 25);
        //    [payBtn setBackgroundImage:[UIImage imageNamed:@"middle_green_btnbg_normal.png"] forState:UIControlStateNormal];
        //    [payBtn setTitle:@"付款" forState:UIControlStateNormal];
        //    [self.ButtonActionView addSubview:payBtn];
        //    [payBtn addTarget:self action:@selector(goPayAction:) forControlEvents:UIControlEventTouchUpInside];
        
        //    UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //    UIButton * refundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        self.orderAddressView.layer.borderWidth = 1;
        self.orderAddressView.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
        
        self.payTypeView.layer.borderWidth = 1;
        self.payTypeView.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
        
        self.transpotTypeView.layer.borderWidth = 1;
        self.transpotTypeView.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
        
        self.productDetailView.layer.borderWidth = 1;
        self.productDetailView.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
        
        self.useScoreView.layer.borderWidth = 1;
        self.useScoreView.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
        
        self.textMailView.layer.borderWidth = 1;
        self.textMailView.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
        
        self.priceDetailView.layer.borderWidth = 1;
        self.priceDetailView.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
        
        self.orderNumberView.layer.borderWidth = 1;
        self.orderNumberView.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
        
        self.ButtonActionView.layer.borderWidth = 1;
        self.ButtonActionView.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
        
        
        [self.allScrollView addSubview:self.orderAddressView];
        [self.allScrollView addSubview:self.productDetailView];
        [self.allScrollView addSubview:self.payTypeView];
        [self.allScrollView addSubview:self.transpotTypeView];
        [self.allScrollView addSubview:self.priceDetailView];
        [self.allScrollView addSubview:self.textMailView];
        [self.allScrollView addSubview:self.useScoreView];
        [self.allScrollView addSubview:self.orderNumberView];
        [self.allScrollView addSubview:self.ButtonActionView];
        [self.allScrollView setContentSize:CGSizeMake(320, self.orderNumberView.frame.origin.y + self.orderNumberView.frame.size.height + 10 + CGRectGetHeight(self.ButtonActionView.frame))];
        self.allScrollView.scrollEnabled = YES;
        
        [self loadProductInfoView];
    }
    

}


-(void)updateReturnOrderClick:(id)sender{
    [self performSegueWithIdentifier:kSegueReturnOrderToUpdate sender:self];
    
}

-(void)cancelOrder{
    [self performSegueWithIdentifier:kSegueOrderDetailToReturn sender:self];

}


//商品详细数据
-(void)loadProductInfoView{
    
    UIImageView * iconInfo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"productinfo_title.png"]];
    iconInfo.frame = CGRectMake(10, 7, 15, 13);
    [self.productDetailView addSubview:iconInfo];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 6, 100, 16)];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.text = @"商品信息";
    nameLabel.font = [UIFont boldSystemFontOfSize:16];
    nameLabel.textColor = [UIColor darkGrayColor];
    [self.productDetailView addSubview:nameLabel];
    
    CALayer *bottomLayer = [CALayer layer];
    bottomLayer.frame = CGRectMake(0, 25, 320, 1);
    bottomLayer.backgroundColor = [UIColor colorWithRed:234 /255.0f green:234 /255.0f blue:234 /255.0f alpha:1].CGColor;
    [self.productDetailView.layer addSublayer:bottomLayer];
    
    int i= 0;
    for (OrderMerchandiseIntroModel * Model in self.currenDetailProduct) {
        ProductDetailView * prodv = [[ProductDetailView alloc] initWithFrame:CGRectMake(0, i * 115 + 25, 320, 115)];
        [prodv creatProductDetailViewWithMerchandiseIntroModel:Model];
        [self.productDetailView addSubview:prodv];
        i++;
    }
    
}


-(void)loadOrderDetailData{
    NSDictionary * orderDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               _currenOderNumber,@"OrderNumber",
                               kWebAppSign,@"AppSign", nil];
    [OrderDetailModel getOrderDetailWithparameters:orderDic andblock:^(OrderDetailModel *model, NSError *error) {
        if (error) {
            
        }else {
            if (model) {
                _currenDetailModel = model;
                _currenDetailProduct = model.ProductList;
                [self updateViewWithDetailModel];
            }
        
        }
    }];

}

-(void)loadScoreOrderDetailData{
    NSDictionary * orderDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               _currenOderNumber,@"OrderNumber",
                               kWebAppSign,@"AppSign", nil];
    [ScoreOrderDetailModel getScoreOrderDetailWithparameters:orderDic andblock:^(ScoreOrderDetailModel *model, NSError *error) {
        if (error) {
            
        }else {
            if (model) {
                _currenDetailModel = model;
                _currenDetailProduct = model.ScoreProductList;
                [self updateViewWithDetailModel];
            }
            
        }
    }];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    OrderReturnViewController *orvc = [segue destinationViewController];
    if ([segue.identifier isEqualToString:kSegueOrderDetailToReturn]) {
        if ([orvc respondsToSelector:@selector(setLastDetailModel:)]) {
            orvc.lastDetailModel = _currenDetailModel;
        }
    }
    
    
    UpdateReturnOrderViewController *urovc = [segue destinationViewController];
    if ([segue.identifier isEqualToString:kSegueReturnOrderToUpdate]) {
        if ([urovc respondsToSelector:@selector(setReturnOrderGuid:)]) {
            urovc.returnOrderGuid = ReturnOrderGuid;
        }
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
