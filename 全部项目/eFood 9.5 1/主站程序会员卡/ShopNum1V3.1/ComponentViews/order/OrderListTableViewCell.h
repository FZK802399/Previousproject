//
//  OrderListTableViewCell.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-9-3.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderIntroModel.h"
#import "ScoreOrderIntroModel.h"

@protocol OrderItemTableViewCellDelegate <NSObject>

@optional
- (void)viewWuliuWith:(id)intro;

- (void)viewPayWith:(id)intro;

- (void)confirmReceiver:(id)intro;

- (void)commentProduct:(id)model;

- (void)cancelOrder:(id)intro;

@end

@interface OrderListTableViewCell : UITableViewCell
@property (strong, nonatomic)  UILabel *statueLabel;
@property (strong, nonatomic)  UILabel *timeLabel;
@property (strong, nonatomic)  UILabel *priceLabel;
@property (strong, nonatomic)  UILabel *nameLabel;
@property (strong, nonatomic)  UILabel *moreLabel;

@property (strong, nonatomic)  UIImageView *ico_image;

@property (strong, nonatomic)  UIImageView *icon2;
@property (strong, nonatomic)  UIImageView *icon3;
@property (strong, nonatomic)  UIButton *apprialBtn;
@property (strong, nonatomic)  UIButton *payBtn;
@property (strong, nonatomic)  UIButton *ValidationBtn;
@property (strong, nonatomic)  UIButton *lookBtn;
@property (strong, nonatomic)  UIButton *cancelBtn;

@property (nonatomic, strong) id currentIntro;

@property (nonatomic, assign) id<OrderItemTableViewCellDelegate> delegate;


-(void)creatOrderListTableViewCellWithOrderIntroModel:(OrderIntroModel*)intro;

-(void)creatOrderListTableViewCellWithScoreOrderIntroModel:(ScoreOrderIntroModel*)intro;

@end
