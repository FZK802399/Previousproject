//
//  IAPManager.h
//  BeiJing360
//
//  Created by Duke Douglas on 13-3-20.
//  Copyright (c) 2013年 __ChuangYiFengTong__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

extern NSString *const kIAPPaymentSuccessful;
extern NSString *const kIAPPaymentFaild;

@interface IAPManager : NSObject<SKProductsRequestDelegate,SKPaymentTransactionObserver>
{
    SKProduct *_product;
    SKProductsRequest *_productsRequest;
}

@property (nonatomic,assign) id delegate;

//单例
+ (IAPManager *)getInstance;
//加载商品
- (void)loadProduct;
//交易是否可用
- (BOOL)canMakePayment;
//交易完成
- (void)paymentProUpgradeWithProduct:(SKProduct *)product;

//产品是否已经购买
- (BOOL)wasAlreadyPayment;


@end
