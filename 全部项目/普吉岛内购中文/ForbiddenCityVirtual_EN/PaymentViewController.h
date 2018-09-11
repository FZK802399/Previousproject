//
//  PaymentViewController.h
//  ForbiddenCityVirtual_EN
//
//  Created by Heramerom on 13-8-22.
//  Copyright (c) 2013年 Duke Douglas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentViewController : UIViewController
{
    UIButton *_closeButton;
    
    UIButton *_paymentButton;
    UIButton *_restoreButton;
}

@property (nonatomic, assign) id delegate;

@end
