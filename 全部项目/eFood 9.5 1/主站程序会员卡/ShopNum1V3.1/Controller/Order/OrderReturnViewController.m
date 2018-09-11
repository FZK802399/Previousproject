//
//  OrderReturnViewController.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-9-5.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "OrderReturnViewController.h"
#import "ReturnProductView.h"
#import "RefundOrderModel.h"

@interface OrderReturnViewController ()

@end

@implementation OrderReturnViewController

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
    _currenDetailProduct = _lastDetailModel.ReturnProductList;
    // Do any additional setup after loading the view.
    [self updateViewWithDetailModel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)updateViewWithDetailModel{
    
    self.productDetailView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 320, [self.currenDetailProduct count] * 115 + 25)];
    self.productDetailView.backgroundColor = [UIColor whiteColor];
    self.productDetailView.layer.borderWidth = 1;
    self.productDetailView.layer.borderColor = [UIColor colorWithRed:234 /255.0f green:234 /255.0f blue:234 /255.0f alpha:1].CGColor;
    
    CGFloat OriginY = self.productDetailView.frame.origin.y + self.productDetailView.frame.size.height + 10;
    self.productReturnTextView = [[UIView alloc] initWithFrame:CGRectMake(0, OriginY, 320, 150)];
    self.productReturnTextView.backgroundColor = [UIColor whiteColor];
    self.productReturnTextView.layer.borderWidth = 1;
    self.productReturnTextView.layer.borderColor = [UIColor colorWithRed:234 /255.0f green:234 /255.0f blue:234 /255.0f alpha:1].CGColor;
    UILabel * retextTitle= [[UILabel alloc] initWithFrame:CGRectMake(6, 5, 200, 20)];
    retextTitle.text= @"请输入退货理由";
    retextTitle.font = [UIFont systemFontOfSize:13];
    retextTitle.backgroundColor = [UIColor whiteColor];
    [self.productReturnTextView addSubview:retextTitle];
    
    CALayer *topLayer2 = [CALayer layer];
    topLayer2.frame = CGRectMake(0, 29, 320, 1);
    topLayer2.backgroundColor = [UIColor colorWithRed:236 /255.0f green:236 /255.0f blue:236 /255.0f alpha:1].CGColor;
    [self.productReturnTextView.layer addSublayer:topLayer2];
    
    self.ReturnTextField = [[UITextView alloc] initWithFrame:CGRectMake(10, 40, 300, 100)];
    self.ReturnTextField.delegate = self;
    self.ReturnTextField.layer.borderWidth = 1;
    self.ReturnTextField.layer.borderColor = [UIColor colorWithRed:234 /255.0f green:234 /255.0f blue:234 /255.0f alpha:1].CGColor;
    [self.productReturnTextView addSubview:self.ReturnTextField];
    
    OriginY = self.productReturnTextView.frame.origin.y + self.productReturnTextView.frame.size.height + 10;
//    CGFloat buttonViewOriginy = SCREEN_HEIGHT - 60  - 64;
//    if (kCurrentSystemVersion >= 7.0) {
//        buttonViewOriginy =  buttonViewOriginy - 64;
//    }
    self.ButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, OriginY, 320, 60)];
    self.ButtonView.backgroundColor = [UIColor whiteColor];
    self.ReturnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.ReturnBtn.frame = CGRectMake(10, 10, 300, 40);
    [self.ButtonView addSubview:self.ReturnBtn];
    [self.ReturnBtn setBackgroundImage:[UIImage imageNamed:@"bigButtonbg_normal.png"] forState:UIControlStateNormal];
    [self.ReturnBtn setTitle:@"提交申请" forState:UIControlStateNormal];
    [self.ReturnBtn addTarget:self action:@selector(ReturnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.ReturnBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    self.ButtonView.layer.borderWidth = 1;
    self.ButtonView.layer.borderColor = [UIColor colorWithRed:234 /255.0f green:234 /255.0f blue:234 /255.0f alpha:1].CGColor;
    
    
    
    [self.allScrollView addSubview:self.productDetailView];
    [self.allScrollView addSubview:self.productReturnTextView];
    [self.allScrollView addSubview:self.ButtonView];
    
    [self.allScrollView setContentSize:CGSizeMake(320, OriginY + self.ButtonView.frame.size.height + 10)];
    self.allScrollView.scrollEnabled = YES;
    [self loadProductInfoView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyboard)];
    [self.allScrollView addGestureRecognizer:tap];
    
    [self registerForKeyboardNotifications];
    
}

- (void)resignKeyboard {
    [self.ReturnTextField resignFirstResponder];
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
    bottomLayer.backgroundColor = [UIColor colorWithRed:246 /255.0f green:246 /255.0f blue:246 /255.0f alpha:1].CGColor;
    [self.productDetailView.layer addSublayer:bottomLayer];
    
    int i= 0;
    for (ReturnMerchandiseModel * submitModel in _currenDetailProduct) {
        ReturnProductView * prodv = [[ReturnProductView alloc] initWithFrame:CGRectMake(0, i * 115 + 25, 320, 115)];
        [prodv creatProductDetailViewWithReturnMerchandiseModel:submitModel];
        [self.productDetailView addSubview:prodv];
        i++;
    }
    
}


-(void)ReturnBtnClick:(id)sender{
    
    if (allTrim(self.ReturnTextField.text).length == 0) {
        [self showAlertWithMessage:@"请输入退货理由"];
        return;
    }
    
    _submitReturnProductArray = [[NSMutableArray alloc] initWithCapacity:0];
    BOOL isHaveProduct = false;
    
    for (ReturnMerchandiseModel * submitModel in _currenDetailProduct) {
        if (submitModel.isCheckForReturn) {
            isHaveProduct = true;
            NSMutableDictionary *merchandiseParameters = [[NSMutableDictionary alloc] init];
            [merchandiseParameters setObject:submitModel.Attributes forKey:@"Attributes"];
            [merchandiseParameters setObject:[NSNumber numberWithInt:submitModel.ReturnCount] forKey:@"ReturnCount"];
            [merchandiseParameters setObject:[NSNumber numberWithFloat:submitModel.BuyPrice] forKey:@"BuyPrice"];
            
            [merchandiseParameters setObject:submitModel.OrderGuid forKey:@"OrderGuid"];
            [merchandiseParameters setObject:submitModel.ProductImgStr forKey:@"ProductImage"];
            [merchandiseParameters setObject:submitModel.ProductGuid forKey:@"ProductGuid"];
            [merchandiseParameters setObject:[NSNumber numberWithInteger:1] forKey:@"OrderType"];
            
            [_submitReturnProductArray addObject:merchandiseParameters];
        }
        
    }
    
    if (!isHaveProduct) {
        [self showAlertWithMessage:@"请选择要退货的商品"];
        return;
    }
    
    
     NSMutableDictionary *returnParameters = [[NSMutableDictionary alloc] init];
    [returnParameters setObject:kWebAppSign forKey:@"AppSign"];
    [returnParameters setObject:_lastDetailModel.Guid forKey:@"OrderGuid"];
    [returnParameters setObject:self.appConfig.loginName forKey:@"ApplyUserID"];
    [returnParameters setObject:self.appConfig.loginName forKey:@"OperateUserID"];
    [returnParameters setObject:[NSNumber numberWithInteger:0] forKey:@"OrderStatus"];
    [returnParameters setObject:allTrim(self.ReturnTextField.text) forKey:@"ReturnGoodsCause"];

    [returnParameters setObject:_submitReturnProductArray forKey:@"GoodSList"];
    
    [OrderDetailModel AddReturnOrderWithParameters:returnParameters andblock:^(NSInteger result, NSError *error) {
        if (result == 202) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

//注册键盘监听
- (void)registerForKeyboardNotifications{
    // keyboard notification
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        
        float animationTime = [[note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
        NSValue *rectValue = [note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardFrame = [rectValue CGRectValue];
        
        float instance= self.allScrollView.frame.origin.y + self.allScrollView.frame.size.height + keyboardFrame.size.height - SCREEN_HEIGHT -  self.ButtonView.frame.size.height - 20;
        
        if (kCurrentSystemVersion < 7.0) {
            instance += 64;
        }
        if (instance > 0) {
            [UIView animateWithDuration:animationTime animations:^{
                CGFloat OriginY  = 0;
                OriginY = [self MatchIOS7:OriginY];
                self.allScrollView.frame = CGRectMake(0, OriginY-instance, self.allScrollView.frame.size.width, self.allScrollView.frame.size.height);
            }];
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillChangeFrameNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        
        float animationTime = [[note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
        NSValue *rectValue = [note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardFrame = [rectValue CGRectValue];
        
        float instance= self.allScrollView.frame.origin.y + self.allScrollView.frame.size.height + keyboardFrame.size.height - SCREEN_HEIGHT -  self.ButtonView.frame.size.height - 20;
        
        if (kCurrentSystemVersion < 7.0) {
            instance += 64;
        }
        if (instance > 0) {
            [UIView animateWithDuration:animationTime animations:^{
                CGFloat OriginY  = 0;
                OriginY = [self MatchIOS7:OriginY];
                self.allScrollView.frame = CGRectMake(0, OriginY-instance, self.allScrollView.frame.size.width, self.allScrollView.frame.size.height);
            }];
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        
        float animationTime = [[note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
        
        [UIView animateWithDuration:animationTime animations:^{
            CGFloat OriginY  = 0;
            OriginY = [self MatchIOS7:OriginY];
            self.allScrollView.frame = CGRectMake(0, OriginY, self.allScrollView.frame.size.width, self.allScrollView.frame.size.height);
        }];
    }];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
