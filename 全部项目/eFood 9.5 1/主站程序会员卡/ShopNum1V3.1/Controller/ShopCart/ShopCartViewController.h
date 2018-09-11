//
//  ShopCartViewController.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-4.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ShopCartViewController : WFSViewController<UITableViewDelegate, UITableViewDataSource, QCheckBoxDelegate>
@property (strong, nonatomic) IBOutlet UITableView *shopcartTableView;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UIImageView *noProductImage;
@property (strong, nonatomic) IBOutlet UILabel *noProductLabel;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIButton *commonBtn;
@property (strong, nonatomic) IBOutlet UIButton *ScoreBtn;

@property (strong, nonatomic) NSMutableArray * shopCartData;

@property (strong, nonatomic) IBOutlet UIButton *gobuyBtn;
@property (strong, nonatomic) IBOutlet UILabel *totalPrice;
@property (assign, nonatomic) CGFloat allTotalPrice;
@property (strong, nonatomic) IBOutlet QCheckBox *allCheckBtn;

- (IBAction)goBuyAction:(id)sender;
- (IBAction)changeTabViewAction:(id)sender;

@end
