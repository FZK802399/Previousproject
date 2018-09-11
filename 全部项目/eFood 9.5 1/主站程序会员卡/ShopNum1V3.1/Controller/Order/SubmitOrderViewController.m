//
//  SubmitOrderViewController.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-29.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "SubmitOrderViewController.h"
#import "OrderSubmitModel.h"
#import "OrderMerchandiseSubmitModel.h"
#import "PostageModel.h"
#import "ShopCartMerchandiseModel.h"
#import "ProductDetailView.h"
#import "OrderPayOnlineViewController.h"
#import "OrderListViewController.h"
#import "UseScoreViewController.h"
#import "AFAppAPIClient.h"
#import "OrderController.h"
#import "OrderListController.h"
#import "ConfirmPayController.h"

@interface popTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIImageView *checkImage;
@end

@implementation popTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat height = 44;
        CGFloat originX = 10;
        CGFloat originY = 6;
        if (_nameLabel == nil) {
            _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX + 35, originY, 260, height - 22)];
            _nameLabel.textAlignment = NSTextAlignmentLeft;
            _nameLabel.font = [UIFont systemFontOfSize:12];
            _nameLabel.backgroundColor = [UIColor clearColor];
//            _nameLabel.textColor = [UIColor textTitleColor];
            [self.contentView addSubview:_nameLabel];
        }
        if (_checkImage == nil) {
            _checkImage = [[UIImageView alloc] initWithFrame:CGRectMake(originX , originY, 22, 22)];
            [self.contentView addSubview:_checkImage];
        }
    }
    return self;
}
@end

//-------------------------------------------------------------------------------


@interface SubmitOrderViewController ()<UIActionSheetDelegate, UITextFieldDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (strong, nonatomic) UIButton *faPiaoButton;
@property (strong, nonatomic) UIView *totalView;
@property (strong, nonatomic) UILabel *yunfeiPriceLabel;
@property (strong, nonatomic) UILabel *allTotalPriceLabel;
@property (strong, nonatomic) UILabel *scoreLabel;
/// 发票信息
@property (strong, nonatomic) UITextField *InvoiceTypeTextField; // 发票类型
@property (strong, nonatomic) UITextField *InvoiceTitleTextField; // 发票抬头
@property (strong, nonatomic) UITextField *InvoiceContentTextField; // 发票内容
@end

@implementation SubmitOrderViewController {

    NSInteger theCanUseScore;
    BOOL isFaPiao;
    CGFloat userScroe;
    BOOL keyboardIsShown;
}
@synthesize useScore = _useScore;

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
    
    self.submitButton.layer.cornerRadius = 3.0f;
    self.allScrollView.delegate = self;
    self.useScore = 0;
    self.buyNum = 0;
//    self.choosePopView = [[ZSYPopoverListView alloc] initWithFrame:CGRectMake(0, 0, 280, 200)];
//    self.choosePopView.titleName.text = @"Choose";
//    self.choosePopView.datasource = self;
//    self.choosePopView.delegate = self;
    
    self.orderAddressView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH, 60)];
    self.orderAddressView.backgroundColor = [UIColor whiteColor];
    self.addressName = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 15)];
    self.addressName.font = [UIFont systemFontOfSize:13];
    [self.orderAddressView addSubview:self.addressName];
    
    self.telLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100 - 44, 5, 100, 15)];
    self.telLabel.textAlignment = NSTextAlignmentRight;
    self.telLabel.font = [UIFont systemFontOfSize:13];
    self.telLabel.text = @"请选择收货地址";
    [self.orderAddressView addSubview:self.telLabel];
    
    self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, SCREEN_WIDTH - 54, 40)];
    self.addressLabel.font = [UIFont systemFontOfSize:12];
    self.addressLabel.textColor = [UIColor lightGrayColor];
    self.addressLabel.numberOfLines = 0;
    [self.orderAddressView addSubview:self.addressLabel];
    
    UIButton * choose1 = [UIButton buttonWithType:UIButtonTypeCustom];
    choose1.frame = CGRectMake(SCREEN_WIDTH - 44, 8, 44, 44);
    [choose1 setImage:[UIImage imageNamed:@"btn_detail_normal.png"] forState:UIControlStateNormal];
    [choose1 addTarget:self action:@selector(changeAddressAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.orderAddressView addSubview:choose1];
    
    self.productDetailView = [[UIView alloc] initWithFrame:CGRectMake(0, 75, SCREEN_WIDTH, [self.productArray count] * 115 + 25)];
     self.productDetailView.backgroundColor = [UIColor whiteColor];
    
    CGFloat OriginY = self.productDetailView.frame.origin.y + self.productDetailView.frame.size.height + 10;
    
    self.payTypeView = [[UIView alloc] initWithFrame:CGRectMake(0, OriginY, SCREEN_WIDTH, 44)];
    self.payTypeView.backgroundColor = [UIColor whiteColor];
    UILabel * payTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 11, 68, 21)];
    payTitle.text = @"支付类型";
    payTitle.font = [UIFont systemFontOfSize:14];
    [self.payTypeView addSubview:payTitle];
    
    self.payTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-44-168, 11, 168, 21)];
    self.payTypeLabel.textAlignment = NSTextAlignmentRight;
    self.payTypeLabel.font = [UIFont systemFontOfSize:13];
    self.payTypeLabel.text = @"请选择支付方式";
    [self.payTypeView addSubview:self.payTypeLabel];
    
    UIButton * choose2 = [UIButton buttonWithType:UIButtonTypeCustom];
    choose2.frame = CGRectMake(SCREEN_WIDTH-44, 0, 44, 44);
//    choose2.backgroundColor = [UIColor yellowColor];
    [choose2 setImage:[UIImage imageNamed:@"btn_detail_normal.png"] forState:UIControlStateNormal];
    [choose2 addTarget:self action:@selector(changePayTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.payTypeView addSubview:choose2];
    
    OriginY = CGRectGetMaxY(self.payTypeView.frame)+10;
    // ---- 支付方式
    
    
    // ---- 配送方式
        self.transpotTypeView = [[UIView alloc] initWithFrame:CGRectMake(0, OriginY, SCREEN_WIDTH, 60)];
        self.transpotTypeView.backgroundColor = [UIColor whiteColor];
        UILabel * postTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, 68, 21)];
        postTitle.text = @"配送方式";
        postTitle.font = [UIFont systemFontOfSize:14];
        [self.transpotTypeView addSubview:postTitle];
    
        UILabel * postpriceTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 68, 21)];
        postpriceTitle.text = @"运费";
        postpriceTitle.font = [UIFont systemFontOfSize:12];
        postpriceTitle.textColor = [UIColor grayColor];
        [self.transpotTypeView addSubview:postpriceTitle];
    
//        UILabel * baopriceTitle = [[UILabel alloc] initWithFrame:CGRectMake(210, 6, 68, 21)];
//        baopriceTitle.text = @"保价费用";
//        baopriceTitle.font = [UIFont systemFontOfSize:13];
//        [self.transpotTypeView addSubview:baopriceTitle];
    
        self.TransportTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 91 -44, 6, 91, 21)];
        self.TransportTypeLabel.text = @"请选择快递方式";
        self.TransportTypeLabel.font = [UIFont systemFontOfSize:13];
        self.TransportTypeLabel.textAlignment = NSTextAlignmentRight;
        [self.transpotTypeView addSubview:self.TransportTypeLabel];
    
    ///运费
        self.TransportPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 91 -44, 30, 91, 21)];
        self.TransportPriceLabel.textColor = [UIColor grayColor];
        self.TransportPriceLabel.font = [UIFont systemFontOfSize:13];
        self.TransportPriceLabel.textAlignment = NSTextAlignmentRight;
        [self.transpotTypeView addSubview:self.TransportPriceLabel];
    
    ///保送费用
//        self.postBaoPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(210, 30, 75, 21)];
//        self.postBaoPriceLabel.font = [UIFont systemFontOfSize:13];
//        [self.transpotTypeView addSubview:self.postBaoPriceLabel];
    
        UIButton * choose3 = [UIButton buttonWithType:UIButtonTypeCustom];
        choose3.frame = CGRectMake(SCREEN_WIDTH - 44, 8, 44, 44);
        [choose3 setImage:[UIImage imageNamed:@"btn_detail_normal.png"] forState:UIControlStateNormal];
        [choose3 addTarget:self action:@selector(changeTransportAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.transpotTypeView addSubview:choose3];
    
    // 发票
    UIView *faPiaoView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.transpotTypeView.frame), SCREEN_WIDTH, 120)];
    faPiaoView.backgroundColor = [UIColor whiteColor];
    
    UILabel *faPiaoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 60, 30)];
    faPiaoLabel.text = @"发票";
    faPiaoLabel.font = [UIFont systemFontOfSize:14];
    [faPiaoView addSubview:faPiaoLabel];
    
    self.faPiaoButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(faPiaoLabel.frame), CGRectGetMinY(faPiaoLabel.frame), SCREEN_WIDTH - CGRectGetWidth(faPiaoLabel.frame) - 20, 30)];
    self.faPiaoButton.backgroundColor = [UIColor whiteColor];
    [self.faPiaoButton setImage:[UIImage imageNamed:@"checkbox_off"] forState:UIControlStateNormal];
    [self.faPiaoButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [self.faPiaoButton addTarget:self action:@selector(addFaPiao:) forControlEvents:UIControlEventTouchUpInside];
    [faPiaoView addSubview:self.faPiaoButton];
    
    //    @property (strong, nonatomic) UITextField *InvoiceTypeTextField; // 发票类型
    //    @property (strong, nonatomic) UITextField *InvoiceTitleTextField; // 发票抬头
    //    @property (strong, nonatomic) UITextField *InvoiceContentTextField; // 发票内容
    // 发票类型 纸质发票
    CGFloat invoiceHeight = 30;
    UIColor *invoiceColor = [UIColor lightGrayColor];
    UIFont *invoiceFont = [UIFont systemFontOfSize:11.0f];
    
    self.InvoiceTypeTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(faPiaoLabel.frame), CGRectGetMaxY(faPiaoLabel.frame), CGRectGetWidth(faPiaoView.frame), invoiceHeight)];
    self.InvoiceTypeTextField.text = @"纸质发票";
    self.InvoiceTypeTextField.font = invoiceFont;
    self.InvoiceTypeTextField.textColor = invoiceColor;
    self.InvoiceTypeTextField.enabled = NO;
//    self.InvoiceTypeTextField.layer.borderColor = invoiceColor.CGColor;
//    self.InvoiceTypeTextField.layer.borderWidth = 0.5;
    [faPiaoView addSubview:self.InvoiceTypeTextField];
    
    // 发票抬头
    self.InvoiceTitleTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(faPiaoLabel.frame), CGRectGetMaxY(self.InvoiceTypeTextField.frame), CGRectGetWidth(faPiaoView.frame), invoiceHeight)];
    self.InvoiceTitleTextField.placeholder = @"发票抬头";
    self.InvoiceTitleTextField.font = invoiceFont;
    self.InvoiceTitleTextField.textColor = invoiceColor;
    self.InvoiceTitleTextField.delegate = self;
//    self.InvoiceTitleTextField.layer.borderColor = invoiceColor.CGColor;
//    self.InvoiceTitleTextField.layer.borderWidth = 0.5;
    [faPiaoView addSubview:self.InvoiceTitleTextField];
    
    // 发票内容
    self.InvoiceContentTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(faPiaoLabel.frame), CGRectGetMaxY(self.InvoiceTitleTextField.frame), CGRectGetWidth(faPiaoView.frame), invoiceHeight)];
    self.InvoiceContentTextField.placeholder = @"发票内容";
    self.InvoiceContentTextField.font = invoiceFont;
    self.InvoiceContentTextField.textColor = invoiceColor;
    self.InvoiceContentTextField.delegate = self;
//    self.InvoiceContentTextField.layer.borderColor = invoiceColor.CGColor;
//    self.InvoiceContentTextField.layer.borderWidth = 0.5;
    [faPiaoView addSubview:self.InvoiceContentTextField];
    
    // 森泓取消发票
//    [self.allScrollView addSubview:faPiaoView];
    
    self.useScoreView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.transpotTypeView.frame)-1, SCREEN_WIDTH, 44)];
     self.useScoreView.backgroundColor = [UIColor whiteColor];
    UILabel * scoreTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 11, 68, 21)];
    scoreTitle.text = @"使用积分";
    scoreTitle.font = [UIFont systemFontOfSize:14];
    [self.useScoreView addSubview:scoreTitle];
    
    self.useScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(104, 11, 168, 21)];
    self.useScoreLabel.font = [UIFont systemFontOfSize:13];
    self.useScoreLabel.text = @"请输入使用的积分";
    [self.useScoreView addSubview:self.useScoreLabel];
    
    UIButton * choose4 = [UIButton buttonWithType:UIButtonTypeCustom];
    choose4.frame = CGRectMake(SCREEN_WIDTH - 44, 0, 44, 44);
    choose4.tag = 1001;
    [choose4 setImage:[UIImage imageNamed:@"btn_detail_normal.png"] forState:UIControlStateNormal];
    [choose4 addTarget:self action:@selector(useScoreAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.useScoreView addSubview:choose4];
    
    self.textMailView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.useScoreView.frame) - 1, SCREEN_WIDTH, 120)];
    self.textMailView.backgroundColor = [UIColor whiteColor];
    UILabel * usermailTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH, 15)];
    usermailTitle.text = @"订单留言:";
    usermailTitle.font = [UIFont systemFontOfSize:14];
    [self.textMailView addSubview:usermailTitle];
    self.usersMail = [[UITextView alloc] initWithFrame:CGRectMake(15, 25, SCREEN_WIDTH - 30, 80)];
    // 合计
    [self setupTotalView];
    
    
    [self.usersMail setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
    self.usersMail.layer.cornerRadius = 3.0;
    self.usersMail.layer.borderWidth = 1.0;
    self.usersMail.layer.borderColor = [UIColor colorWithRed:238/255.0 green:238/225.0 blue:239/255.0 alpha:1].CGColor;
    self.usersMail.delegate = self;
    self.usersMail.returnKeyType = UIReturnKeyDefault;
    [self.textMailView addSubview:self.usersMail];
    
    self.totalPriceLabel.text = [NSString stringWithFormat:@"AU$%.2f", self.totalPrice];
    self.allTotalPrice = self.totalPrice;

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
    
    self.bottomView.layer.borderWidth = 1;
    self.bottomView.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
    
    self.totalView.layer.borderWidth = 1;
    self.totalView.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;

    
    
    [self.allScrollView addSubview:self.orderAddressView];
    [self.allScrollView addSubview:self.payTypeView];
    [self.allScrollView addSubview:self.transpotTypeView];
    [self.allScrollView addSubview:self.productDetailView];
    [self.allScrollView addSubview:self.totalView];
    
    if (self.saleType != SaleTypeYiYuanGou) {
        [self.allScrollView addSubview:self.useScoreView];
        [self.allScrollView addSubview:self.textMailView];
    }
    
    [self.allScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.totalView.frame)+10)];
    self.allScrollView.scrollEnabled = YES;
    
    [self loadAddressData];
    
    
    [self loadProductInfoView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyboard)];
    [self.allScrollView addGestureRecognizer:tap];
    
//    [self registerForKeyboardNotifications];

//    [self loadPayTypeData];
//    [self loadPostTypeData];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)resignKeyboard {
    [self.usersMail resignFirstResponder];
    [self.InvoiceTitleTextField resignFirstResponder];
    [self.InvoiceContentTextField resignFirstResponder];
}

- (void)showChoosePickerWithArray:(NSArray *)typeArray {
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    if (self.popViewType == PopoverListForPay) {
        as.title = @"修改支付类型";
        as.tag = 101;
//        for (PaymentModel *pay in typeArray) {
//            [as addButtonWithTitle:[NSString stringWithFormat:@"%@(AU$ %.2f)",pay.name, pay.Charge]];
//        }
        for (NSString * str in typeArray) {
            [as addButtonWithTitle:str];
        }
    }else{
        as.title = @"修改运送方式";
        as.tag = 102;
        for (PostageModel *post in typeArray) {
//            NSLog(@"%@  %@",post.name2,post.name);
            [as addButtonWithTitle:post.name2];
        }
    }
    
    [as addButtonWithTitle:@"取消"];
    [as setCancelButtonIndex:[typeArray count]];
    
    [as showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (actionSheet.tag == 101) {
        if (buttonIndex != self.payType.count) {
//            _selectPayType = [self.payType objectAtIndex:buttonIndex];
//            self.payTypeLabel.text = self.selectPayType.name;
            _selectPayType = [self.payType objectAtIndex:buttonIndex];
            self.payTypeLabel.text = _selectPayType;
        }
        
    }else{
        if (buttonIndex != self.postType.count) {
            self.selectPostType = [self.postType objectAtIndex:buttonIndex];
            self.TransportTypeLabel.text = self.selectPostType.name2;
            self.yunfeiPriceLabel.text = [NSString stringWithFormat:@"AU$%.2f",self.selectPostType.peipr];
            self.TransportPriceLabel.text = [NSString stringWithFormat:@"AU$%.2f",self.selectPostType.peipr];
//            self.postBaoPriceLabel.text = [NSString stringWithFormat:@"AU$%.2f", self.selectPostType.baopr];
            ///总价 包括运费
            self.allTotalPrice = self.totalPrice + self.selectPostType.peipr - userScroe;
//            self.allTotalPrice = self.totalPrice + self.selectPostType.peipr;
            self.totalPriceLabel.text = [NSString stringWithFormat:@"AU$%.2f",self.allTotalPrice];
            self.allTotalPriceLabel.text = [NSString stringWithFormat:@"AU$%.2f",self.allTotalPrice];
            NSLog(@"totalPrice : %.2f",self.allTotalPrice);
            [self getPostPrice];
        }
    }
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet{

}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self creatOrderNum];
    
    //键盘弹起的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:self.view.window];
    //键盘隐藏的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

//页面消失前取消通知
-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

//生成订单号
-(void)creatOrderNum{
    NSDictionary *orderDic= [NSDictionary dictionaryWithObjectsAndKeys:kWebAppSign,@"AppSign", nil];
    [OrderSubmitModel generalOrderNumberWithparameters:orderDic andBolock:^(NSString *orderNumber, NSError *error) {
        if (error) {
            
        }else {
            if (orderNumber.length > 0) {
                self.orderNum = orderNumber;
            }
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
        
        float instance= self.allScrollView.frame.origin.y + self.allScrollView.frame.size.height + keyboardFrame.size.height - SCREEN_HEIGHT;
        
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
        
        float instance= self.allScrollView.frame.origin.y + self.allScrollView.frame.size.height + keyboardFrame.size.height - SCREEN_HEIGHT;
        
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

//商品详细数据
-(void)loadProductInfoView{

    UIImageView * iconInfo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"productinfo_title.png"]];
    iconInfo.frame = CGRectMake(10, 5, 15, 13);
    [self.productDetailView addSubview:iconInfo];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 4, 100, 16)];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.text = @"商品信息";
    nameLabel.font = [UIFont boldSystemFontOfSize:16];
    nameLabel.textColor = [UIColor darkGrayColor];
    [self.productDetailView addSubview:nameLabel];
    
    _totalProductPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(210, 4, 100, 16)];
    _totalProductPriceLabel.textAlignment = NSTextAlignmentRight;
    _totalProductPriceLabel.backgroundColor = [UIColor clearColor];
    _totalProductPriceLabel.text = [NSString stringWithFormat:@"AU$%.2f", self.totalPrice];
    _totalProductPriceLabel.font = [UIFont systemFontOfSize:13];
    _totalProductPriceLabel.textColor = [UIColor redColor];
//    [self.productDetailView addSubview:_totalProductPriceLabel];
    
    if (self.submitProductType == SubmitOrderForScore) {
//        _submitProductArray = [[NSMutableArray alloc] initWithCapacity:0];
//        
//        int i= 0;
//        for (OrderMerchandiseSubmitModel * submitModel in self.productArray) {
//            ProductDetailView * prodv = [[ProductDetailView alloc] initWithFrame:CGRectMake(0, i * 115 + 25, SCREEN_WIDTH, 115)];
//            [prodv creatProductDetailViewWithSubmitOrderViewController:submitModel];
//            [self.productDetailView addSubview:prodv];
//            i++;
//            
//            NSMutableDictionary *merchandiseParameters = [[NSMutableDictionary alloc] init];
////            [merchandiseParameters setObject:submitModel.Attributes forKey:@"Attributes"];
//            [merchandiseParameters setObject:[NSNumber numberWithInt:submitModel.BuyNumber] forKey:@"BuyNumber"];
//            [merchandiseParameters setObject:[NSNumber numberWithFloat:submitModel.Score] forKey:@"BuyScore"];
//            
//            [merchandiseParameters setObject:submitModel.Guid forKey:@"Guid"];
//            [merchandiseParameters setObject:[NSNumber numberWithFloat:submitModel.BuyPrice] forKey:@"prmo"];
//            [merchandiseParameters setObject:self.appConfig.loginName forKey:@"MemLoginID"];
//            [merchandiseParameters setObject:submitModel.Name forKey:@"Name"];
//            [merchandiseParameters setObject:submitModel.OriginalImge forKey:@"OriginalImge"];
//            [merchandiseParameters setObject:submitModel.ProductGuid forKey:@"ProductGuid"];
//            [merchandiseParameters setObject:submitModel.ShopID forKey:@"ShopID"];
//            [merchandiseParameters setObject:submitModel.ShopName forKey:@"ShopName"];
//
//            
//            [merchandiseParameters setObject:submitModel.CreateTimeStr forKey:@"CreateTime"];
//            [merchandiseParameters setObject:submitModel.ExtensionAttriutes forKey:@"ExtensionAttriutes"];
//            [merchandiseParameters setObject:@"0" forKey:@"IsShipment"];
//            [merchandiseParameters setObject:@"1" forKey:@"IsReal"];
//
//            
//            [_submitProductArray addObject:merchandiseParameters];
//        }

    }else {
        _submitProductArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        int i= 0;
        for (OrderMerchandiseSubmitModel * submitModel in self.productArray) {
            ProductDetailView * prodv = [[ProductDetailView alloc] initWithFrame:CGRectMake(0, i * 115 + 25, SCREEN_WIDTH, 115)];
            [prodv creatProductDetailViewWithSubmitOrderViewController:submitModel];
            [self.productDetailView addSubview:prodv];
            i++;
            
//            self.buyNum += submitModel.BuyNumber;
//            self.zongJia = self.buyNum * submitModel.MarketPrice;
            NSMutableDictionary *merchandiseParameters = [[NSMutableDictionary alloc] init];
            [merchandiseParameters setObject:submitModel.Attributes forKey:@"Attributes"];
            [merchandiseParameters setObject:[NSNumber numberWithInt:submitModel.BuyNumber] forKey:@"BuyNumber"];
            [merchandiseParameters setObject:[NSNumber numberWithFloat:submitModel.BuyPrice] forKey:@"BuyPrice"];
            
            [merchandiseParameters setObject:submitModel.Guid forKey:@"Guid"];
            [merchandiseParameters setObject:[NSNumber numberWithFloat:submitModel.MarketPrice] forKey:@"MarketPrice"];
            [merchandiseParameters setObject:self.appConfig.loginName forKey:@"MemLoginID"];
            [merchandiseParameters setObject:submitModel.Name forKey:@"Name"];
            [merchandiseParameters setObject:submitModel.OriginalImge forKey:@"OriginalImge"];
            [merchandiseParameters setObject:submitModel.ProductGuid forKey:@"ProductGuid"];
            [merchandiseParameters setObject:submitModel.ShopID forKey:@"ShopID"];
            [merchandiseParameters setObject:submitModel.ShopName forKey:@"ShopName"];
            [merchandiseParameters setObject:submitModel.SpecificationName forKey:@"DetailedSpecifications"];
            
            [merchandiseParameters setObject:submitModel.CreateTimeStr forKey:@"CreateTime"];
            [merchandiseParameters setObject:submitModel.ExtensionAttriutes forKey:@"ExtensionAttriutes"];
            [merchandiseParameters setObject:@"0" forKey:@"IsJoinActivity"];
            [merchandiseParameters setObject:@"0" forKey:@"IsPresent"];
            [merchandiseParameters setObject:submitModel.SpecificationValue forKey:@"SpecificationValue"];
            
            [_submitProductArray addObject:merchandiseParameters];
        }
    }
}


//地址数据
-(void)loadAddressData{
    NSDictionary * addressDic= [NSDictionary dictionaryWithObjectsAndKeys:
                                self.appConfig.loginName,@"MemLoginID",
                                kWebAppSign, @"AppSign", nil];
    [AddressModel getLoginUserAddressListByParameters:addressDic andblock:^(NSArray *list, NSError *error) {
        if (error) {
            
        }else {
            if (list) {
                NSArray * addressList = [NSArray arrayWithArray:list];
                if ([addressList count] > 0) {
                    self.selectAddress = [addressList objectAtIndex:0];
                    self.addressName.text = self.selectAddress.name;
                    self.telLabel.text = self.selectAddress.mobile;
                    self.addressLabel.text = self.selectAddress.address;
                }
            }
        }
    }];
}
//获取支付方式
-(void)loadPayTypeData{

    AppConfig * config = [AppConfig sharedAppConfig];
    [config loadConfig];
    NSString * str = [NSString stringWithFormat:@"http://senghongapp.efood7.com/api/paytype/?AppSign=%@",config.appSign];
    NSString * utfStr = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL * url = [NSURL URLWithString:utfStr];
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionTask * task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"error - %@",error);
            return ;
        }
        NSString * jsonStr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSData * jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray * arr = [NSMutableArray arrayWithObject:@"在线支付"];
        if ([[dict valueForKey:@"HuoDaoFuKuan"] integerValue] == 1) {
            [arr addObject:@"货到付款"];
        }
        if ([dict[@"XianXia"]integerValue] == 1) {
            [arr addObject:@"线下支付"];
        }
        _payType = [NSMutableArray arrayWithArray:arr];
        _popViewType = PopoverListForPay;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showChoosePickerWithArray:_payType];
        });
    }];
    [task resume];
//    NSDictionary *paydic = [NSDictionary dictionaryWithObjectsAndKeys:
//                            kWebAppSign, @"AppSign", nil];
//    [PaymentModel getPaymentwithParameters:paydic andbolock:^(NSArray *list, NSError *error) {
//        if (error) {
//            
//        }else{
//            _payType = [NSMutableArray arrayWithArray:list];
//            _popViewType = PopoverListForPay;
//            [self showChoosePickerWithArray:_payType];
    
//            _choosePopView.titleName.text = @"修改支付方式";
//            [_choosePopView.mainPopoverListView reloadData];
//            [_choosePopView.mainPopoverListView deselectRowAtIndexPath:self.selectedIndexPath animated:NO];
//            [_choosePopView show];
//        }
//    }];
}

//获取运送方式
-(void)loadPostTypeData {

    if (_selectAddress == nil) {
        [self showAlertWithMessage:@"请先选择收货地址"];
        return;
    }
    AppConfig * config = [AppConfig sharedAppConfig];
    [config loadConfig];

    NSDictionary *yunDict = @{@"dataSMemberID":config.loginName,
                              @"dataSHGUID":self.selectAddress.guid,
                              @"dataZFGUID":@(1),
                              @"Strpuallpr":@(_totalPrice),
                              @"Strpuallcou":@(self.buyNum),
                              @"StrpuallW":@(_totalWeight),
                              @"AppSign":kWebAppSign
                              };
    
//    NSDictionary *paydic = [NSDictionary dictionaryWithObjectsAndKeys:
//                            _selectAddress.addressCode, @"Code",
//                            @"0", @"IsPayArrived",
//                            kWebAppSign, @"AppSign",nil];
    
    [PostageModel getPostagePrice:yunDict andblock:^(NSArray *list, NSError *error) {
        if (error) {
            
        }else {
            if (self.saleType == SaleTypeYiYuanGou) {
                for (PostageModel *model in list) {
                    model.peipr = 0;
                }
            }
            _postType = [NSMutableArray arrayWithArray:list];
            _popViewType = PopoverListForPost;
            [self showChoosePickerWithArray:_postType];
            
//            _choosePopView.titleName.text = @"修改运送方式";
//            [_choosePopView.mainPopoverListView reloadData];
//            [_choosePopView.mainPopoverListView deselectRowAtIndexPath:self.selectedIndexPath animated:NO];
//            [_choosePopView show];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//#pragma mark - popoverList代理
//- (NSInteger)popoverListView:(ZSYPopoverListView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    if (_popViewType == PopoverListForPay) {
//        return [_payType count];
//    }else {
//    
//        return [_postType count];
//    }
//}
//
//- (UITableViewCell *)popoverListView:(ZSYPopoverListView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *identifier = @"identifier";
//    popTableViewCell *cell = [tableView dequeueReusablePopoverCellWithIdentifier:identifier];
//    if (nil == cell)
//    {
//        cell = [[popTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.backgroundColor = [UIColor clearColor];
//    }
//    
//    if ( self.selectedIndexPath && NSOrderedSame == [self.selectedIndexPath compare:indexPath])
//    {
//        cell.checkImage.image = [UIImage imageNamed:@"change_type_selected.png"];
//    }
//    else
//    {
//        cell.checkImage.image = [UIImage imageNamed:@"change_type_normal.png"];
//    }
//    if (_popViewType == PopoverListForPay) {
//        cell.nameLabel.text = [NSString stringWithFormat:@"%@(AU$ %.2f)", [[self.payType objectAtIndex:indexPath.row] name] ,[[self.payType objectAtIndex:indexPath.row] Charge]];
//    }else {
//        
//        cell.nameLabel.text = [[self.postType objectAtIndex:indexPath.row] name];
//    }
//    return cell;
//}
//
//- (void)popoverListView:(ZSYPopoverListView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    popTableViewCell *cell = (popTableViewCell*)[tableView popoverCellForRowAtIndexPath:indexPath];
//    cell.checkImage.image = [UIImage imageNamed:@"change_type_normal.png"];
//}
//
//- (void)popoverListView:(ZSYPopoverListView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    self.selectedIndexPath = nil;
//    popTableViewCell *cell = (popTableViewCell*)[tableView popoverCellForRowAtIndexPath:indexPath];
//    cell.checkImage.image = [UIImage imageNamed:@"change_type_selected.png"];
//    if (_popViewType == PopoverListForPay) {
//        self.selectPayType = [self.payType objectAtIndex:indexPath.row];
//        self.payTypeLabel.text = self.selectPayType.name;
//    }else{
//        
//        self.selectPostType = [self.postType objectAtIndex:indexPath.row];
//
//        self.TransportTypeLabel.text = self.selectPostType.name;
//        self.postBaoPriceLabel.text = [NSString stringWithFormat:@"AU$%.2f", self.selectPostType.baopr];
//        [self getPostPriceAndUseScore];
//    }
//    
//    [self.choosePopView dismiss];
//}



-(void)selectedAddress:(AddressModel *)address {
    self.selectAddress = address;
    self.addressName.text = self.selectAddress.name;
    self.telLabel.text = self.selectAddress.mobile;
    self.addressLabel.text = self.selectAddress.address;
}

-(void)setUseScore:(NSInteger)useScore{
    _useScore = useScore;
    self.scoreLabel.text = [NSString stringWithFormat:@"-AU$%.2f",useScore];
    NSDictionary * scoreDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithInteger:useScore],@"Score",
                               kWebAppSign,@"AppSign", nil];
    [OrderSubmitModel getScorePriceWithparameters:scoreDic andblock:^(CGFloat ScorePrice, NSError *error) {
        if (error) {
            
        }else {
            if (ScorePrice > 0) {
                userScroe = ScorePrice;
                self.allTotalPrice = self.totalPrice - ScorePrice + self.selectPostType.peipr;
                self.scoreLabel.text = [NSString stringWithFormat:@"-AU$%.2f", ScorePrice];
                self.totalPriceLabel.text = [NSString stringWithFormat:@"%.2f", self.allTotalPrice];
                self.allTotalPriceLabel.text = [NSString stringWithFormat:@"AU$%.2f",self.allTotalPrice];
            }
        }
    }];
}

//修改收货地址
- (IBAction)changeAddressAction:(id)sender {
    [self performSegueWithIdentifier:kSegueChooseAddress sender:self];
}

//修改支付方式
- (IBAction)changePayTypeAction:(id)sender {
    if (_selectAddress == nil) {
        [self showAlertWithMessage:@"请先选择收货地址"];
        return;
    }

    [self loadPayTypeData];
}

//使用积分
- (IBAction)useScoreAction:(id)sender {
    if (self.selectPostType == nil) {
        [self showAlertWithMessage:@"请先选择配送方式"];
        return;
    }
    [self performSegueWithIdentifier:kSegueSubmitOrderToUseScore sender:self];
}

////获取邮费
-(void)getPostPrice{
    
    if (self.submitProductType == SubmitOrderForScore) {
        
        _submitDataDic = [[NSMutableDictionary alloc] initWithCapacity:0];
        [_submitDataDic setObject:_selectAddress.address forKey:@"Address"];
        [_submitDataDic setObject:allTrim(self.usersMail.text) forKey:@"ClientToSellerMsg"];//留言
        [_submitDataDic setObject:@"0" forKey:@"DispatchPrice"];//运费
        [_submitDataDic setObject:[NSNumber numberWithFloat:_selectPostType.baopr] forKey:@"InsurePrice"];//保值运费
        [_submitDataDic setObject:_selectPostType.Guid forKey:@"DispatchModeGuid"];
        [_submitDataDic setObject:_selectPostType.name2 forKey:@"DispatchModeName"];
        [_submitDataDic setObject:_selectAddress.email forKey:@"Email"];
        [_submitDataDic setObject:self.appConfig.loginName forKey:@"MemLoginID"];
        [_submitDataDic setObject:_selectAddress.mobile forKey:@"Mobile"];
        [_submitDataDic setObject:_selectAddress.name forKey:@"Name"];
        [_submitDataDic setObject:_orderNum forKey:@"OrderNumber"];
        [_submitDataDic setObject:@"" forKey:@"OutOfStockOperate"];
//        [_submitDataDic setObject:_selectPayType.Guid forKey:@"PaymentGuid"];
        [_submitDataDic setObject:@"0" forKey:@"PostType"];
        
        [_submitDataDic setObject:@"200" forKey:@"CostTotalScore"];
        
        //    [_submitDataDic setObject:_selectPayType.paymentType forKey:@"PayType"];
        [_submitDataDic setObject:_selectAddress.postalcode forKey:@"Postalcode"];
        [_submitDataDic setObject:_submitProductArray forKey:@"ScoreOrderProductList"];
        [_submitDataDic setObject:[NSNumber numberWithDouble:_totalPrice] forKey:@"ProductPrice"];
        [_submitDataDic setObject:_selectAddress.addressCode forKey:@"RegionCode"];
        [_submitDataDic setObject:[NSNumber numberWithDouble:self.allTotalPrice] forKey:@"TotaltPrice"];
        [_submitDataDic setObject:@"0" forKey:@"Tel"];
        [_submitDataDic setObject:[NSNumber numberWithDouble:self.allTotalPrice] forKey:@"PaymentPrice"];
        [_submitDataDic setObject:[NSNumber numberWithDouble:self.allTotalPrice] forKey:@"prmo"];

        [_submitDataDic setObject:_orderNum forKey:@"TradeID"];
//        [_submitDataDic setObject:@"0" forKey:@"UseScore"];
        [_submitDataDic setObject:kWebAppSign forKey:@"AppSign"];
//        [_submitDataDic setObject:@"-1" forKey:@"JoinActiveType"];
//        [_submitDataDic setObject:@"0" forKey:@"ActvieContent"];
        
        
        [OrderSubmitModel getScoreOrderPostPriceWithparameters:_submitDataDic andblock:^(NSDictionary *backOrderModel, NSError *error) {
            if (error) {
                
            }else {
                if (backOrderModel) {
                    
                    theCanUseScore = [backOrderModel objectForKey:@"CostTotalScore"] == [NSNull null] ? 0 :[[backOrderModel objectForKey:@"CostTotalScore"] integerValue];
                    
//                    UIButton * tempBtn = (UIButton*)[self.view viewWithTag:1001];
//                    tempBtn.enabled = NO;
//                    self.useScoreLabel.text = [NSString stringWithFormat:@"需要使用%d积分",theCanUseScore];
//                    
//                    _selectPostType.peipr = [[backOrderModel objectForKey:@"DispatchPrice"] floatValue];
                    //                _selectPostType.baopr = [[backOrderModel objectForKey:@"InsurePrice"] floatValue];
//                    self.TransportPriceLabel.text = [NSString stringWithFormat:@"AU$%.2f", _selectPostType.peipr];
//                    self.postBaoPriceLabel.text = [NSString stringWithFormat:@"AU$%.2f", _selectPostType.baopr];
//                    self.totalPriceLabel.text = [NSString stringWithFormat:@"AU$%.2f", self.totalPrice + _selectPostType.peipr + _selectPayType.Charge + _selectPostType.baopr];
//                    self.allTotalPrice = self.totalPrice + _selectPostType.peipr + _selectPostType.baopr + _selectPayType.Charge;
                }
                
            }
        }];
        
    }else {
    
        _submitDataDic = [[NSMutableDictionary alloc] initWithCapacity:0];
        [_submitDataDic setObject:_selectAddress.address forKey:@"Address"];
        [_submitDataDic setObject:allTrim(self.usersMail.text) forKey:@"ClientToSellerMsg"];//留言
        [_submitDataDic setObject:@"0" forKey:@"DispatchPrice"];//运费
        [_submitDataDic setObject:[NSNumber numberWithFloat:_selectPostType.baopr] forKey:@"InsurePrice"];//保值运费
        [_submitDataDic setObject:_selectPostType.Guid forKey:@"DispatchModeGuid"];
        [_submitDataDic setObject:_selectPostType.name2 forKey:@"DispatchModeName"];
        [_submitDataDic setObject:_selectAddress.email forKey:@"Email"];
        [_submitDataDic setObject:self.appConfig.loginName forKey:@"MemLoginID"];
        [_submitDataDic setObject:_selectAddress.mobile forKey:@"Mobile"];
        [_submitDataDic setObject:_selectAddress.name forKey:@"Name"];
        [_submitDataDic setObject:_orderNum forKey:@"OrderNumber"];
        [_submitDataDic setObject:@"" forKey:@"OutOfStockOperate"];
//        [_submitDataDic setObject:_selectPayType.Guid forKey:@"PaymentGuid"];
        [_submitDataDic setObject:@"0" forKey:@"PostType"];
        //    [_submitDataDic setObject:_selectPayType.paymentType forKey:@"PayType"];
        [_submitDataDic setObject:_selectAddress.postalcode forKey:@"Postalcode"];
        [_submitDataDic setObject:_submitProductArray forKey:@"ProductList"];
        [_submitDataDic setObject:[NSNumber numberWithDouble:_totalPrice] forKey:@"ProductPrice"];
        [_submitDataDic setObject:_selectAddress.addressCode forKey:@"RegionCode"];
        [_submitDataDic setObject:[NSNumber numberWithDouble:self.allTotalPrice] forKey:@"ShouldPayPrice"];
        [_submitDataDic setObject:@"0" forKey:@"Tel"];
        [_submitDataDic setObject:[NSNumber numberWithDouble:self.allTotalPrice] forKey:@"orderPrice"];
        [_submitDataDic setObject:_orderNum forKey:@"TradeID"];
        [_submitDataDic setObject:@"0" forKey:@"UseScore"];
        [_submitDataDic setObject:kWebAppSign forKey:@"AppSign"];
        [_submitDataDic setObject:@"-1" forKey:@"JoinActiveType"];
        [_submitDataDic setObject:@"0" forKey:@"ActvieContent"];
        
        
        [OrderSubmitModel getPostPriceWithparameters:_submitDataDic andblock:^(NSDictionary *backOrderModel, NSError *error) {
            if (error) {
                
            }else {
                if (backOrderModel) {
                    
                    theCanUseScore = [backOrderModel objectForKey:@"CanByScores"] == [NSNull null] ? 0 :[[backOrderModel objectForKey:@"CanByScores"] integerValue];
                    
//                    if (theCanUseScore == 0) {
//                        UIButton * tempBtn = (UIButton*)[self.view viewWithTag:1001];
//                        tempBtn.enabled = NO;
//                        self.useScoreLabel.text = @"可用积分为0";
//                    }
//
//                    _selectPostType.peipr = [[backOrderModel objectForKey:@"DispatchPrice"] floatValue];
//                    //                _selectPostType.baopr = [[backOrderModel objectForKey:@"InsurePrice"] floatValue];
//                    self.TransportPriceLabel.text = [NSString stringWithFormat:@"AU$%.2f", _selectPostType.peipr];
//                    self.postBaoPriceLabel.text = [NSString stringWithFormat:@"AU$%.2f", _selectPostType.baopr];
//                    self.totalPriceLabel.text = [NSString stringWithFormat:@"AU$%.2f", self.totalPrice + _selectPostType.peipr + _selectPayType.Charge + _selectPostType.baopr];
//                    self.allTotalPrice = self.totalPrice + _selectPostType.peipr + _selectPostType.baopr + _selectPayType.Charge;
                }
                
            }
        }];

    }


    
}

//提交订单
- (IBAction)submitAction:(id)sender {
    if (_selectAddress == nil) {
        [self showAlertWithMessage:@"请先选择收货地址"];
        return;
    }
    
    if (_selectPayType == nil) {
        [self showAlertWithMessage:@"请先选择支付类型"];
        return;
    }
    
    if (_selectPostType == nil) {
        [self showAlertWithMessage:@"请先选择配送方式"];
        return;
    }
    if (isFaPiao) {
        if (allTrim(self.InvoiceTitleTextField.text).length == 0) {
            [self showAlertWithMessage:@"请填写发票抬头"];
            return;
        }
        if (allTrim(self.InvoiceContentTextField.text).length == 0) {
            [self showAlertWithMessage:@"请填写发票内容"];
            return;
        }
    }
    NSNumber * num ;
    if ([_payTypeLabel.text isEqualToString:@"货到付款"]) {
        num = [NSNumber numberWithInt:0];
    }
    else if ([_payTypeLabel.text isEqualToString:@"在线支付"])
    {
        num = [NSNumber numberWithInt:1];
    }
    else if ([_payTypeLabel.text isEqualToString:@"线下支付"])
    {
        num = [NSNumber numberWithInt:2];
    }
    if (self.submitProductType == SubmitOrderForScore) {
//        _submitDataDic = [[NSMutableDictionary alloc] initWithCapacity:0];
//        [_submitDataDic setObject:_selectAddress.address forKey:@"Address"];
//        [_submitDataDic setObject:allTrim(self.usersMail.text) forKey:@"ClientToSellerMsg"];//留言
//        [_submitDataDic setObject:[NSNumber numberWithFloat:_selectPostType.peipr] forKey:@"DispatchPrice"];//运费
////        [_submitDataDic setObject:[NSNumber numberWithFloat:_selectPostType.baopr] forKey:@"InsurePrice"];//保值运费
//        [_submitDataDic setObject:_selectPostType.Guid forKey:@"DispatchModeGuid"];
//        [_submitDataDic setObject:_selectPostType.name2 forKey:@"DispatchModeName"];
//        [_submitDataDic setObject:_selectAddress.email forKey:@"Email"];
//        [_submitDataDic setObject:self.appConfig.loginName forKey:@"MemLoginID"];
//        [_submitDataDic setObject:_selectAddress.mobile forKey:@"Mobile"];
//        [_submitDataDic setObject:_selectAddress.name forKey:@"Name"];
//        [_submitDataDic setObject:_orderNum forKey:@"OrderNumber"];
//        [_submitDataDic setObject:@"" forKey:@"OutOfStockOperate"];
//#pragma mark - 提交订单 支付方式
////        [_submitDataDic setObject:_selectPayType.Guid forKey:@"PaymentGuid"];
////        [_submitDataDic setObject:_selectPayType.name forKey:@"PaymentName"];
//        [_submitDataDic setObject:@"0" forKey:@"PostType"];
//        [_submitDataDic setObject:[NSNumber numberWithInteger:theCanUseScore] forKey:@"CostTotalScore"];
//        [_submitDataDic setObject:num forKey:@"PayType"];  //如果不添加选择支付方式 则默认传@1 在线支付
//        [_submitDataDic setObject:_selectAddress.postalcode forKey:@"Postalcode"];
//        [_submitDataDic setObject:_submitProductArray forKey:@"ScoreOrderProductList"];
//        [_submitDataDic setObject:[NSNumber numberWithDouble:_totalPrice] forKey:@"ProductPrice"];
//        [_submitDataDic setObject:_selectAddress.addressCode forKey:@"RegionCode"];
//        [_submitDataDic setObject:[NSNumber numberWithDouble:self.allTotalPrice] forKey:@"TotaltPrice"];
//        [_submitDataDic setObject:[NSNumber numberWithDouble:_allTotalPrice] forKey:@"ShouldPayPrice"];
//        [_submitDataDic setObject:@"" forKey:@"Tel"];
//        [_submitDataDic setObject:[NSNumber numberWithDouble:self.allTotalPrice] forKey:@"PaymentPrice"];
//        [_submitDataDic setObject:[NSNumber numberWithDouble:self.allTotalPrice] forKey:@"prmo"];
////        [_submitDataDic setObject:_orderNum forKey:@"TradeID"];
//        [_submitDataDic setObject:@"0" forKey:@"UseScore"];
//        [_submitDataDic setObject:kWebAppSign forKey:@"AppSign"];
//        [_submitDataDic setObject:@"0" forKey:@"CreateUser"];
//        [_submitDataDic setObject:@"0" forKey:@"ModifyUser"];
//        [_submitDataDic setObject:@"0" forKey:@"PayMemo"];
//        [_submitDataDic setObject:@"0" forKey:@"ShipmentNumber"];
//        [_submitDataDic setObject:@"0" forKey:@"ShipmentStatus"];
//        [_submitDataDic setObject:@"0" forKey:@"SellerToClientMsg"];
//        [_submitDataDic setObject:@"-1" forKey:@"JoinActiveType"];
//        
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"yyyy/MM/dd hh:mm:ss"];
//        NSString *timeNowStr = [dateFormatter stringFromDate:[NSDate date]];
//        
//        [_submitDataDic setObject:timeNowStr forKey:@"DispatchTime"];
//        [_submitDataDic setObject:timeNowStr forKey:@"ConfirmTime"];
//        [_submitDataDic setObject:timeNowStr forKey:@"CreateTime"];
//        [_submitDataDic setObject:timeNowStr forKey:@"ModifyTime"];
//        [_submitDataDic setObject:timeNowStr forKey:@"PayTime"];
//        // 发票信息
//        if (isFaPiao) {
//            [_submitDataDic setObject:self.InvoiceTypeTextField.text forKey:@"InvoiceType"]; // 发票类型
//            [_submitDataDic setObject:self.InvoiceTitleTextField.text forKey:@"InvoiceTitle"]; // 发票抬头
//            [_submitDataDic setObject:self.InvoiceContentTextField.text forKey:@"InvoiceContent"]; // 发票内容
//        }
//        
//        [OrderSubmitModel AddScoreOrderPostPriceWithparameters:_submitDataDic andblock:^(NSInteger result, NSError *error) {
//            if (result == 202) {
////                NSLog(@"提交订单成功！");
//                
//                NSDictionary *cutScoreDic = [NSDictionary dictionaryWithObjectsAndKeys:
//                                             self.appConfig.loginName,@"MemLoginID",
//                                             kWebAppSign,@"AppSign",
//                                             [NSNumber numberWithInteger:theCanUseScore],@"Score",nil];
//                [OrderSubmitModel PayScoreOrderWithparameters:cutScoreDic andblock:^(NSInteger result, NSError *error) {
//                    if (error) {
//                        
//                    }else {
//                        if (result == 202) {
////                            [self performSegueWithIdentifier:kSegueSubmitToOrderList sender:self];
//                            
//                            OrderListController * vc = [[OrderListController alloc]init];
//                            vc.OrderType = WAIT_PAYMONEY;
//                            vc.hidesBottomBarWhenPushed = YES;
//                            [self.navigationController pushViewController:vc animated:YES];
//                            
//                            
////                            OrderController *orderVC = [OrderController create];
////                            orderVC.OrderType = WAIT_PAYMONEY;
////                            [self.navigationController pushViewController:orderVC animated:YES];
//                        }else {
//                            [self showAlertWithMessage:@"支付积分失败！"];
//                        }
//                    }
//                }];
//                
//            }else {
//                [self showAlertWithMessage:@"提交订单失败！"];
//            }
//        }];
    }else {
        _submitDataDic = [[NSMutableDictionary alloc] initWithCapacity:0];
        [_submitDataDic setObject:_selectAddress.address forKey:@"Address"];
        [_submitDataDic setObject:allTrim(self.usersMail.text) forKey:@"ClientToSellerMsg"];//留言
        [_submitDataDic setObject:[NSNumber numberWithFloat:_selectPostType.peipr]  forKey:@"DispatchPrice"];//运费
        [_submitDataDic setObject:[NSNumber numberWithFloat:_selectPostType.baopr] forKey:@"InsurePrice"];//保值运费
        [_submitDataDic setObject:_selectPostType.Guid forKey:@"DispatchModeGuid"];
        [_submitDataDic setObject:_selectPostType.name2 forKey:@"DispatchModeName"];
        [_submitDataDic setObject:@"dzu@163.com" forKey:@"Email"];
        [_submitDataDic setObject:self.appConfig.loginName forKey:@"MemLoginID"];
        [_submitDataDic setObject:_selectAddress.mobile forKey:@"Mobile"];
        [_submitDataDic setObject:_selectAddress.name forKey:@"Name"];
        [_submitDataDic setObject:_orderNum forKey:@"OrderNumber"];
        [_submitDataDic setObject:_orderNum forKey:@"DealNumber"];
        [_submitDataDic setObject:@"" forKey:@"OutOfStockOperate"];
//        [_submitDataDic setObject:_selectPayType.Guid forKey:@"PaymentGuid"];
        [_submitDataDic setObject:@"0" forKey:@"PostType"];
        [_submitDataDic setObject:num forKey:@"PayType"];  //如果不添加选择支付方式 则默认传@1 在线支付
        [_submitDataDic setObject:_selectAddress.postalcode forKey:@"Postalcode"];
        [_submitDataDic setObject:_submitProductArray forKey:@"ProductList"];
        [_submitDataDic setObject:[NSNumber numberWithDouble:_totalPrice] forKey:@"ProductPrice"];
        [_submitDataDic setObject:_selectAddress.addressCode forKey:@"RegionCode"];
        [_submitDataDic setObject:[NSNumber numberWithDouble:_allTotalPrice] forKey:@"ShouldPayPrice"];
        [_submitDataDic setObject:@"0" forKey:@"Tel"];
        [_submitDataDic setObject:[NSNumber numberWithDouble:_allTotalPrice] forKey:@"orderPrice"];
        [_submitDataDic setObject:_orderNum forKey:@"TradeID"];
        [_submitDataDic setObject:[NSNumber numberWithInteger:self.useScore] forKey:@"UseScore"];
        [_submitDataDic setObject:kWebAppSign forKey:@"AppSign"];
        [_submitDataDic setObject:@"-1" forKey:@"JoinActiveType"];
        [_submitDataDic setObject:@"0" forKey:@"ActvieContent"];
        // 一元购订单
        if (self.saleType == SaleTypeYiYuanGou) {
            [_submitDataDic setObject:@5 forKey:@"BuyType"];
        } else {
            [_submitDataDic setObject:@10 forKey:@"BuyType"];
        }
        #pragma mark - 提交发票信息
        if (isFaPiao) {
            [_submitDataDic setObject:self.InvoiceTypeTextField.text forKey:@"InvoiceType"]; // 发票类型
            [_submitDataDic setObject:self.InvoiceTitleTextField.text forKey:@"InvoiceTitle"]; // 发票抬头
            [_submitDataDic setObject:self.InvoiceContentTextField.text forKey:@"InvoiceContent"]; // 发票内容
        }
        
        [OrderSubmitModel addOrderModelWithparameters:_submitDataDic andblock:^(NSInteger result, NSError *error) {
            if (result == 202) {
                if (num.intValue == 1) {
                    ConfirmPayController * vc = [[UIStoryboard storyboardWithName:@"StoryboardIOS7" bundle:nil]instantiateViewControllerWithIdentifier:@"ConfirmPayController"];
                    vc.orderNumber = self.orderNum;
                    vc.totalPrice = _totalPrice;
                    if (self.saleType == SaleTypeYiYuanGou) {
                        // 一元购
                        vc.saleType = self.saleType;
                    }
                    [self.navigationController pushViewController:vc animated:YES];
                } else if (num.intValue == 0) {
#warning bug 货到付款的待付款订单 在待付款列表里面不存在
                    OrderListController * vc = [[OrderListController alloc]init];
                    vc.OrderType = ALL_ORDER;
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                } else {
                    OrderListController * vc = [[OrderListController alloc]init];
                    vc.OrderType = WAIT_PAYMONEY;
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }else if (result == -1){
                [self showAlertWithMessage:@"网络错误"];
            }
            else {
                [self showAlertWithMessage:@"交易失败请重新购买"];
            }
        }];
    }
}

//修改运送方式
- (IBAction)changeTransportAction:(id)sender {
    
    if (_selectAddress == nil) {
        [self showAlertWithMessage:@"请先选择收货地址"];
        return;
    }
    
    if (_selectPayType == nil) {
        [self showAlertWithMessage:@"请先选择支付方式"];
        return;
    }

    [self loadPostTypeData];
}


//跳转传值
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    AddressViewController * advc = [segue destinationViewController];
    if ([segue.identifier isEqualToString:kSegueChooseAddress]) {
        advc.showType = AddressListForSelect;
        advc.delegate = self;
    }
    
    
    NSString * payStr = [NSString stringWithFormat:@"%@/alipay/default.aspx?out_trade_no=%@&subject=订单:%@&total_fee=%f", kWebAppBaseUrl, self.orderNum, self.orderNum, self.allTotalPrice];
    
    payStr = [payStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    OrderPayOnlineViewController * oplvc= [segue destinationViewController];
    if ([segue.identifier isEqualToString:kSegueSubmitOrderlToPay]) {
        if ([oplvc respondsToSelector:@selector(setPayWebUrl:)]) {
            oplvc.payWebUrl = [NSURL URLWithString:payStr];
        }
    }
    
    OrderListViewController * olvc = [segue destinationViewController];
    if ([segue.identifier isEqualToString:kSegueSubmitToOrderList]) {
        if ([olvc respondsToSelector:@selector(setOrderStatue:)]) {
            if (self.submitProductType == SubmitOrderForScore) {
                olvc.orderType = 1;
            }else {
                olvc.orderType = 0;
            }
            olvc.comFrome = 1;
            olvc.orderStatue = OrderAll;
        }
    }
    
    UseScoreViewController * usvc = [segue destinationViewController];
    if ([segue.identifier isEqualToString:kSegueSubmitOrderToUseScore]) {
        if ([usvc respondsToSelector:@selector(setCanUseScore:)]) {
            usvc.canUseScore = theCanUseScore;
            usvc.partentViewController = self;
        }
    }
}
     
- (void)addFaPiao:(id)sender{
    if (isFaPiao) {
        [self.faPiaoButton setImage:[UIImage imageNamed:@"checkbox_off"] forState:UIControlStateNormal];
        self.InvoiceTitleTextField.text = @"";
        self.InvoiceContentTextField.text = @"";
    } else {
        [self.faPiaoButton setImage:[UIImage imageNamed:@"checkbox_on"] forState:UIControlStateNormal];
        [self.InvoiceTitleTextField becomeFirstResponder];
    }
    isFaPiao = !isFaPiao;
}
// 运费 TransportPriceLabel  积分 useScoreLabel
- (void)setupTotalView {
    UIFont *fontSize14 = [UIFont systemFontOfSize:12.0f];
    UIColor *darkColor = [UIColor grayColor];
    // 商品合计
    CGFloat y;
    // 1元购不要积分和留言
    if (self.saleType == SaleTypeYiYuanGou) {
        y = CGRectGetMaxY(self.transpotTypeView.frame);
    } else {
        y = CGRectGetMaxY(self.textMailView.frame);
    }
    
    self.totalView = [[UIView alloc] initWithFrame:CGRectMake(0, y + 10, SCREEN_WIDTH, 110)];
    self.totalView.backgroundColor = [UIColor whiteColor];
    CGFloat padding = 10.0;
    CGFloat height = 25.0;
    CGFloat width = 80.0;
    CGFloat Y = 0;
    // 第一部分
    // 合计  运费  现金券
    UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, Y, width, height)];
    totalLabel.font = fontSize14;
    totalLabel.textColor = darkColor;
    totalLabel.text = @"商品合计";
    [self.totalView addSubview:totalLabel];
    // 件数
    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, Y, width, height)];
    countLabel.font = fontSize14;
    countLabel.textColor = darkColor;
    countLabel.textAlignment = NSTextAlignmentCenter;
    countLabel.center = CGPointMake(SCREEN_WIDTH / 2.0, height / 2.0);
    countLabel.text = [NSString stringWithFormat:@"%ld 件", self.productArray.count];
    [self.totalView addSubview:countLabel];
    // 总价 _totalPrice
    UILabel *totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 110, Y, 100, height)];
    totalPriceLabel.font = fontSize14;
    totalPriceLabel.textColor = darkColor;
    totalPriceLabel.textAlignment = NSTextAlignmentRight;
    totalPriceLabel.text = [NSString stringWithFormat:@"AU$%.2f",_totalPrice];
    [self.totalView addSubview:totalPriceLabel];
    
    // 运费
    Y += height;
    UILabel *yunfeiLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, Y, width, height)];
    yunfeiLabel.font = fontSize14;
    yunfeiLabel.textColor = darkColor;
    yunfeiLabel.text = @"运费";
    [self.totalView addSubview:yunfeiLabel];
    // 总价 _totalPrice
    self.yunfeiPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 110, Y, 100, height)];
    self.yunfeiPriceLabel.font = fontSize14;
    self.yunfeiPriceLabel.textColor = darkColor;
    self.yunfeiPriceLabel.textAlignment = NSTextAlignmentRight;
    self.yunfeiPriceLabel.text = [NSString stringWithFormat:@"AU$%.2f",0.0f];
    [self.totalView addSubview:self.yunfeiPriceLabel];
    
    // 运费
    Y += height;
    
    UILabel *xianjinquanLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, Y, width, height)];
    xianjinquanLabel.font = fontSize14;
    xianjinquanLabel.textColor = darkColor;
    xianjinquanLabel.text = @"使用积分抵扣";
    [self.totalView addSubview:xianjinquanLabel];
    // 总价 _totalPrice
    self.scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 110, Y, 100, height)];
    self.scoreLabel.font = fontSize14;
    self.scoreLabel.textColor = darkColor;
    self.scoreLabel.textAlignment = NSTextAlignmentRight;
    self.scoreLabel.text = [NSString stringWithFormat:@"-AU$%.2f", 0.0f];
    [self.totalView addSubview:self.scoreLabel];
    
    // 第二部分
    // 总计
    Y += height;
    // 分隔线
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, round(Y), SCREEN_WIDTH, 1.0)];
    view.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    [self.totalView addSubview:view];
    
    UILabel *allTotalLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, Y, width, 35)];
    allTotalLabel.font = [UIFont systemFontOfSize:16.0f];
    allTotalLabel.textColor = darkColor;
    allTotalLabel.text = @"总计";
    [self.totalView addSubview:allTotalLabel];
    // 总价 _totalPrice
    self.allTotalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 210, Y, 200, 35)];
    self.allTotalPriceLabel.font = [UIFont systemFontOfSize:16.0f];
    self.allTotalPriceLabel.textColor = [UIColor redColor];
    self.allTotalPriceLabel.textAlignment = NSTextAlignmentRight;
    self.allTotalPriceLabel.text = [NSString stringWithFormat:@"AU$%.2f",self.totalPrice];
    [self.totalView addSubview:self.allTotalPriceLabel];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

//键盘弹起后处理scrollView的高度使得textfield可见
-(void)keyboardDidShow:(NSNotification *)notification{
    if (keyboardIsShown) {
        return;
    }
    NSDictionary * info = [notification userInfo];
    NSValue *avalue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [self.view convertRect:[avalue CGRectValue] fromView:nil];
    CGRect viewFrame = [self.allScrollView frame];
    viewFrame.size.height -= keyboardRect.size.height;
    self.allScrollView.frame = viewFrame;
    CGRect textFieldRect = [self.textMailView frame];
    [self.allScrollView scrollRectToVisible:textFieldRect animated:YES];
    keyboardIsShown = YES;
}

//键盘隐藏后处理scrollview的高度，使其还原为本来的高度
-(void)keyboardDidHide:(NSNotification *)notification{
    NSDictionary *info = [notification userInfo];
    NSValue *avalue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [self.view convertRect:[avalue CGRectValue] fromView:nil];
    CGRect viewFrame = [self.allScrollView frame];
    viewFrame.size.height += keyboardRect.size.height;
    self.allScrollView.frame = viewFrame;
    keyboardIsShown = NO;
}

@end
