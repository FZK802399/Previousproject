//
//  PaymentViewController.h
//  ForbiddenCityVirtual_EN
//
//  Created by Heramerom on 13-8-29.
//  Copyright (c) 2013年 Duke Douglas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IAPManager.h"

enum PaymentProductsKind {
    SnowProduct,
    EnglishProduct
    };
typedef NSInteger PaymentProductsKind;

@interface PaymentViewController : UIViewController
{
    UIButton *_paymentButton;
    UIButton *_restoreButton;
    UIButton *_closeButton;
    
    IAPManager *_iapManager;
    
    UIActivityIndicatorView *_activityIndicator;
}

@property (nonatomic, assign) PaymentProductsKind productKind;


@end
