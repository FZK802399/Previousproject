//
//  PaymentViewController.m
//  ForbiddenCityVirtual_EN
//
//  Created by Heramerom on 13-8-22.
//  Copyright (c) 2013年 Duke Douglas. All rights reserved.
//

#import "PaymentViewController.h"
#import "IAPManager.h"

@interface PaymentViewController ()
{
    UIActivityIndicatorView *_activityIndicator;
    UIImageView *_backgrandImage;
}

@end

@implementation PaymentViewController

@synthesize delegate = _delegate;


- (void)dealloc
{
    Release(_closeButton);
    Release(_paymentButton);
    Release(_restoreButton);
    Release(_activityIndicator);
    Release(_backgrandImage);
    
    [NOTIFICATION_CENTER removeObserver:self name:kIAPPaymentSuccessedNotification object:nil];
    [NOTIFICATION_CENTER removeObserver:self name:kIAPBeginLoadProduct object:nil];
    [NOTIFICATION_CENTER removeObserver:self name:kIAPPaymentFaildNotification object:nil];
    
    [super dealloc];
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
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithRed:40.0f/255.0f green:56.0f/255.0f blue:114.0f/255.0f alpha:1.0]];
    _backgrandImage = [[UIImageView alloc] init];
    
    if (kDEVICE_VERSION >= 7.0)
    {
        [_backgrandImage setFrame:CGRectMake(0, 20, kLCDH, kLCDW - 20)];
    }
    else
    {
        [_backgrandImage setFrame:CGRectMake(0, 0, kLCDH, kLCDW - 20)];
    }
    [self.view addSubview:_backgrandImage];
    
    
    _closeButton = [[UIButton alloc] initWithFrame:CGRectMake(kLCDH - 61, 0, 61, 56)];
    [_closeButton setImage:[UIImage imageNamed:@"phclose.png"] forState:UIControlStateNormal];
    [_closeButton setImage:[UIImage imageNamed:@"phclose_h.png"] forState:UIControlStateHighlighted];
    [_closeButton addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_closeButton];
    
    [NOTIFICATION_CENTER addObserver:self selector:@selector(dismissSelf) name:kIAPPaymentSuccessedNotification object:nil];
    [NOTIFICATION_CENTER addObserver:self selector:@selector(showActivityView) name:kIAPBeginLoadProduct object:nil];
    [NOTIFICATION_CENTER addObserver:self selector:@selector(hiddenActivityView) name:kIAPPaymentFaildNotification object:nil];
    
    if (CURRENTLANGUAGE == English)
    {
        [_backgrandImage setImage:[UIImage imageNamed:@"payment_en.jpg"]];
        
        _paymentButton = [[UIButton alloc] initWithFrame:CGRectMake(433, 310, 226, 53)];
        [_paymentButton setImage:[UIImage imageNamed:@"topay_en.png"] forState:UIControlStateNormal];
        [_paymentButton setImage:[UIImage imageNamed:@"topay_en_h.png"] forState:UIControlStateHighlighted];
        
        _restoreButton = [[UIButton alloc] initWithFrame:CGRectMake(625 + 60, 310, 106, 53)];
        [_restoreButton setImage:[UIImage imageNamed:@"restore_en.png"] forState:UIControlStateNormal];
        [_restoreButton setImage:[UIImage imageNamed:@"restore_en_h.png"] forState:UIControlStateHighlighted]
        ;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)
        {
            [_paymentButton setFrame:CGRectMake(433, 310 + 20, 226, 53)];
            [_restoreButton setFrame:CGRectMake(625 + 60, 310 + 20, 106, 53)];
            [self setNeedsStatusBarAppearanceUpdate];
        }

    }
    else
    {
        [_backgrandImage setImage:[UIImage imageNamed:@"payment_cn.jpg"]];

        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"payment_cn.jpg"]];
        _paymentButton = [[UIButton alloc] initWithFrame:CGRectMake(433, 310, 156, 53)];
        [_paymentButton setImage:[UIImage imageNamed:@"topay_cn.png"] forState:UIControlStateNormal];
        [_paymentButton setImage:[UIImage imageNamed:@"topay_cn_h.png"] forState:UIControlStateHighlighted];
        
        _restoreButton = [[UIButton alloc] initWithFrame:CGRectMake(620, 310, 106, 53)];
        [_restoreButton setImage:[UIImage imageNamed:@"restore_cn.png"] forState:UIControlStateNormal];
        [_restoreButton setImage:[UIImage imageNamed:@"restore_cn_h.png"] forState:UIControlStateHighlighted];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)
        {
            [_paymentButton setFrame:CGRectMake(433, 310 + 20, 156, 53)];
            [_restoreButton setFrame:CGRectMake(620, 310 + 20, 106, 53)];
            [self setNeedsStatusBarAppearanceUpdate];
        }

    }
    
    [_paymentButton addTarget:self action:@selector(beginToPayment) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_paymentButton];
    
    [_restoreButton addTarget:self action:@selector(restoreThePayment) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_restoreButton];
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [_activityIndicator setCenter:CGPointMake(600, 380)];
    [self.view addSubview:_activityIndicator];
    [_activityIndicator stopAnimating];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)
    {
        [_closeButton setFrame:CGRectMake(kLCDH - 61, 20, 61, 56)];
        [self setNeedsStatusBarAppearanceUpdate];
    }

}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)dismissSelf
{
    [self dismissViewControllerAnimated:YES completion:^
     {
         [_delegate performSelector:@selector(viewRelease)];
     }];
    
}

- (void)showActivityView
{
    [_activityIndicator startAnimating];
        
    [_restoreButton setUserInteractionEnabled:NO];
    [_paymentButton setUserInteractionEnabled:NO];
}

- (void)hiddenActivityView
{
    [_activityIndicator stopAnimating];
    [_restoreButton setUserInteractionEnabled:YES];
    [_paymentButton setUserInteractionEnabled:YES];
}


- (void)beginToPayment
{
    [_delegate performSelector:@selector(beginToPayment)];
}

- (void)restoreThePayment
{
    [_delegate performSelector:@selector(restorePayment)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
