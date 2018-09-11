//
//  PaymentViewController.m
//  ForbiddenCityVirtual_EN
//
//  Created by Heramerom on 13-8-29.
//  Copyright (c) 2013年 Duke Douglas. All rights reserved.
//

#import "PaymentViewController.h"

@interface PaymentViewController ()

@end

@implementation PaymentViewController

@synthesize productKind = _productKind;


- (void)dealloc
{
    Release(_restoreButton);
    Release(_paymentButton);
    Release(_closeButton);
    Release(_activityIndicator);
    
    [NOTIFICATION_CENTER removeObserver:self name:kIAPBeginLoadProduct object:nil];
    [NOTIFICATION_CENTER removeObserver:self name:kIAPPaymentFaildNotification object:nil];
    [NOTIFICATION_CENTER removeObserver:self name:kIAPPaymentSuccessedNotification object:nil];
    
    [super dealloc];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _closeButton = [[UIButton alloc] initWithFrame:CGRectMake(kLCDH - 61, 0, 61, 56)];
    [_closeButton setImage:[UIImage imageNamed:@"phclose.png"] forState:UIControlStateNormal];
    [_closeButton setImage:[UIImage imageNamed:@"phclose_h.png"] forState:UIControlStateHighlighted];
    [_closeButton addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_closeButton];
    
    [NOTIFICATION_CENTER addObserver:self selector:@selector(dismissSelf) name:kIAPPaymentSuccessedNotification object:nil];
    [NOTIFICATION_CENTER addObserver:self selector:@selector(showActivityView) name:kIAPBeginLoadProduct object:nil];
    [NOTIFICATION_CENTER addObserver:self selector:@selector(hiddenActivityView) name:kIAPPaymentFaildNotification object:nil];
    if (_productKind == EnglishProduct)
    {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"engpayment.jpg"]];
        _paymentButton = [[UIButton alloc] initWithFrame:CGRectMake(440, 208, 186, 63)];
        [_paymentButton setImage:[UIImage imageNamed:@"paynow.png"] forState:UIControlStateNormal];
        [_paymentButton setImage:[UIImage imageNamed:@"paynow_h"] forState:UIControlStateHighlighted];
        [_paymentButton addTarget:self action:@selector(beginToPay) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_paymentButton];
        
        _restoreButton = [[UIButton alloc] initWithFrame:CGRectMake(634, 208, 136, 63)];
        [_restoreButton setImage:[UIImage imageNamed:@"restore.png"] forState:UIControlStateNormal];
        [_restoreButton setImage:[UIImage imageNamed:@"restore_h.png"] forState:UIControlStateHighlighted];
        [_restoreButton addTarget:self action:@selector(beginToRestore) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_restoreButton];
    }
    else
    {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"snowpayment.jpg"]];
        _paymentButton = [[UIButton alloc] initWithFrame:CGRectMake(330, 263, 186, 63)];
        [_paymentButton setImage:[UIImage imageNamed:@"paynow.png"] forState:UIControlStateNormal];
        [_paymentButton setImage:[UIImage imageNamed:@"paynow_h"] forState:UIControlStateHighlighted];
        [_paymentButton addTarget:self action:@selector(beginToPay) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_paymentButton];
        
        _restoreButton = [[UIButton alloc] initWithFrame:CGRectMake(542, 263, 136, 63)];
        [_restoreButton setImage:[UIImage imageNamed:@"restore.png"] forState:UIControlStateNormal];
        [_restoreButton setImage:[UIImage imageNamed:@"restore_h.png"] forState:UIControlStateHighlighted];
        [_restoreButton addTarget:self action:@selector(beginToRestore) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_restoreButton];
    }
}


- (void)beginToPay
{
    _iapManager = [IAPManager getInstance];
    if (_productKind == SnowProduct)
    {
        [_iapManager loadProductWithProductID:kSnowProductID];
    }
    else if (_productKind == EnglishProduct)
    {
        [_iapManager loadProductWithProductID:kEnglishProductID];
    }
    [MobClick event:@"toPayment"];
}

- (void)beginToRestore
{
    _iapManager = [IAPManager getInstance];
    [_iapManager restorePayment];
}

- (void)dismissSelf
{
    [self dismissViewControllerAnimated:YES completion:^{
        nil;
    }];
}

- (void)showActivityView
{
    if (!_activityIndicator)
    {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_activityIndicator setCenter:CGPointMake(1024 / 2, 768 / 2)];
        [self.view addSubview:_activityIndicator];
    }
    [_activityIndicator startAnimating];
    
}

- (void)hiddenActivityView
{
    [_activityIndicator stopAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
