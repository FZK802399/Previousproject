//
//  IAPManager.m
//  ForbiddenCityVirtual_EN
//
//  Created by Heramerom on 13-8-21.
//  Copyright (c) 2013年 Duke Douglas. All rights reserved.
//

#import "IAPManager.h"

@implementation IAPManager

+ (id)getInstance
{
    static IAPManager *iapManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        iapManager = [[IAPManager alloc] init];
    });
    return iapManager;
}

//交易是否可用
- (BOOL)canMakePayment
{
    return [SKPaymentQueue canMakePayments];
}

//开始购买某一件商品
- (void)paymentProUpgradeWithProduct:(SKProduct *)product
{    
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    NSLog(@"add payment to the queue");
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}
//根据产品的id号去加载商品
- (void)loadProductWithProductID:(NSString *)productID
{
    [NOTIFICATION_CENTER postNotificationName:kIAPBeginLoadProduct object:nil];
    NSSet *productIDs = [NSSet setWithObject:productID];
    _productsRequest = [[[SKProductsRequest alloc] initWithProductIdentifiers:productIDs] autorelease];
    [_productsRequest setDelegate:self];
    [_productsRequest start];
}

//恢复交易
- (void)restorePayment
{
    //把自己添加到支付队列当中
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    //恢复交易信息
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

//成功的完成交易
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"successful paymenttransaction");
    
    [self recordTransaction:transaction];
    [self provideContent:transaction.payment.productIdentifier];
    [self finishedTransaction:transaction wasSuccessful:YES];
}
//重新交易并成功
- (void)restoreTransaction:(SKPaymentTransaction *)transcation
{    
    NSLog(@"restore transaction");
    [self recordTransaction:transcation];
    [self provideContent:transcation.originalTransaction.payment.productIdentifier];
    [self finishedTransaction:transcation wasSuccessful:YES];
}

//完成交易失败
- (void)failedTransaction:(SKPaymentTransaction *)transcation
{
    if (transcation.error.code != SKErrorPaymentCancelled)
    {
        NSLog(@"the error is %@ ",transcation.error);
        [self finishedTransaction:transcation wasSuccessful:NO];
    }
    else
    {
        NSLog(@"sk error payment cancelled");
        [self finishedTransaction:transcation wasSuccessful:NO];
    }
}

//记录交易信息
- (void)recordTransaction:(SKPaymentTransaction *)transaction
{
    if ([transaction.payment.productIdentifier isEqualToString:@""])
    {
        [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:@"proUpgradeTransactionReceipt"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

//可用的特性
- (void)provideContent:(NSString *)productId
{
    if ([productId isEqualToString:kEnglishProductID])
    {
        [USER_DEFAULTS setBool:YES  forKey:kWasEnglishPaid];
        [USER_DEFAULTS synchronize];
    }
    if ([productId isEqualToString:kChineseProductID])
    {
        [USER_DEFAULTS setBool:YES forKey:kWasChinesePaid];
        [USER_DEFAULTS synchronize];
    }
}

//从交易队列中移除交易并发送交易结果的通知
- (void)finishedTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful
{
    //移除交易
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    //发送通知
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction,@"transaction", nil];
    if (wasSuccessful)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kIAPPaymentSuccessedNotification object:self userInfo:userInfo];
        NSLog(@"发送通知");
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kIAPPaymentFaildNotification object:self userInfo:userInfo];
    }
}



#pragma mark -
#pragma mark SKProductsRequestDelegate method

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *products = response.products;
    SKProduct *product = [products count] == 1 ? [products objectAtIndex:0] : nil;
    if (product)
    {
        if ([self canMakePayment])
        {
            [self paymentProUpgradeWithProduct:product];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kIAPFatchedNotification object:self userInfo:nil];
}

#pragma mark -
#pragma mark SKPaymentTransactionObserver method

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
            default:
                break;
        }
    }
//    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    NSLog(@"error to payment %@", error);
}

@end
