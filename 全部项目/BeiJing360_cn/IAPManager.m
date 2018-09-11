//
//  IAPManager.m
//  BeiJing360
//
//  Created by Duke Douglas on 13-3-20.
//  Copyright (c) 2013年 __ChuangYiFengTong__. All rights reserved.
//

#import "IAPManager.h"

#define kProductId @"com.chuangyifengtong.gugongxunimanyou"

NSString *const kIAPPaymentSuccessful = @"kIAPPaymentSuccessful";
NSString *const kIAPPaymentFaild = @"kIAPPaymentFaild";

@implementation IAPManager

@synthesize delegate = _delegate;

static IAPManager *iapMananger = nil;

#pragma mark - single instance
//单例
+ (IAPManager *)getInstance
{
    if (!iapMananger)
    {
        return [[IAPManager alloc] init];
    }
    return iapMananger;
}

#pragma mark - product info
//加载商品
- (void)loadProduct
{
    //添加交易观察者
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    //根据产品标识符获得产品信息
    _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:kProductId]];
    _productsRequest.delegate = self;
    [_productsRequest start];
    
}

#pragma mark - pruducts request delegate method 
//加载商品完成
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *products = response.products;
    _product = [products count] == 1 ? [products objectAtIndex:0] : nil;
    if (_product)
    {
        
        //输出商品信息
        NSLog(@"product title = %@", _product.localizedDescription);
        NSLog(@"product price = %@", _product.price);
        NSLog(@"product description = %@", _product.description);
        NSLog(@"product id = %@", _product.productIdentifier);
        
        //开始购买商品
        [self paymentProUpgradeWithProduct:_product];
    }
    
}

#pragma mark - make payment 
//交易是否可用
- (BOOL)canMakePayment
{
    return [SKPaymentQueue canMakePayments];
}
//开始交易
- (void)paymentProUpgradeWithProduct:(SKProduct *)product
{
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    //商品加入到支付队列，这自动进行交易
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

//交易完成
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self recordTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - purchase helper
//记录交易收据
- (void)recordTransaction:(SKPaymentTransaction *)transaction
{
    if ([transaction.payment.productIdentifier isEqualToString:kProductId])
    {
        [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:@"proUpgradeTransactionReceipt"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
//记录交易信息
- (void)provideContent:(NSString *)productId
{
    if ([productId isEqualToString:kProductId])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isProUpgradePurchased"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
//完成交易
- (void)finishedTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful
{
    //在支付队列中移除已完成的交易
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    //发送交易完成的通知
    NSDictionary *transactionInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction", nil];
    if (wasSuccessful)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kIAPPaymentSuccessful object:self userInfo:transactionInfo];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kIAPPaymentFaild object:self userInfo:transactionInfo];
    }
}

//成功完成交易
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    [self recordTransaction:transaction];
    [self provideContent:transaction.payment.productIdentifier];
    [self finishedTransaction:transaction wasSuccessful:YES];
    //代理回调方法，停止进度轮
    [self.delegate performSelector:@selector(loadProductSuccessful)];
    //调用代理方法
    [self.delegate performSelector:@selector(successPaymentTransaction)];
}

//重复交易
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    [self recordTransaction:transaction];
    [self provideContent:transaction.payment.productIdentifier];
    [self finishedTransaction:transaction wasSuccessful:YES];
    //代理回调方法，停止进度轮
    [self.delegate performSelector:@selector(loadProductSuccessful)];
    //调用代理方法
    [self.delegate performSelector:@selector(successPaymentTransaction)];
}
//交易失败
- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        NSLog(@"the error is %@ ",transaction.error);
        [self finishedTransaction:transaction wasSuccessful:NO];
        //代理回调方法，停止进度轮
        [self.delegate performSelector:@selector(loadProductSuccessful)];
        //调用代理方法
        [self.delegate performSelector:@selector(failedPaymentTransaction)];
    }
    else
    {
        NSLog(@"sk error payment cancelled");
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        [self.delegate performSelector:@selector(failedPaymentTransaction)];
        
    }
}

#pragma mark - already payment
//产品是否已经购买
- (BOOL)wasAlreadyPayment
{
    BOOL wasPayment = [[NSUserDefaults standardUserDefaults] valueForKey:@"isProUpgradePurchased"];
    return wasPayment;
}

#pragma mark - dealloc
- (void)dealloc
{
    //移除交易观察者
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    [_product release];
    [_productsRequest release];
    [super dealloc];
}




@end
