//
//  OrderReturnViewController.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-9-5.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "WFSViewController.h"
#import "OrderDetailModel.h"

@interface OrderReturnViewController : WFSViewController <UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *allScrollView;

@property (strong, nonatomic) UIView *productDetailView;
@property (strong, nonatomic) UIView *productReturnTextView;
@property (strong, nonatomic) UIView *ButtonView;

@property (strong, nonatomic) UITextView *ReturnTextField;

@property (strong, nonatomic) UIButton *ReturnBtn;

@property (strong, nonatomic) OrderDetailModel *lastDetailModel;
@property (strong, nonatomic) NSArray *currenDetailProduct;
@property (strong, nonatomic) NSMutableArray *submitReturnProductArray;

@end
