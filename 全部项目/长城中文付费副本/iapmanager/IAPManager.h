//
//  IAPManager.h
//  ForbiddenCityVirtual_EN
//
//  Created by Heramerom on 13-8-21.
//  Copyright (c) 2013年 Duke Douglas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

#define kIAPBeginLoadProduct @"kiapBeginLoadProduct"

#define kIAPFatchedNotification @"kIAPFatchedNotification"
#define kIAPPaymentFaildNotification @"kIAPPaymentFaildNotification"
#define kIAPPaymentSuccessedNotification @"kIAPPaymentSuccessedNotification"

@interface IAPManager : NSObject<SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
    SKProduct *_product;
    SKProductsRequest *_productsRequest;
}

//单利方法
+ (id)getInstance;
//交易是否可用
- (BOOL)canMakePayment;
//根据productID去苹果商店加载商品
- (void)loadProductWithProductID:(NSString *)productID;
//恢复交易
- (void)restorePayment;

@end
