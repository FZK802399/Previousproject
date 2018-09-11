//
//  DZYSubmitOrderSectionFoot.h
//  ShopNum1V3.1
//
//  Created by yons on 16/1/20.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderMerchandiseSubmitModel.h"

@protocol DZYSubmitOrderSectionFootDelegate <NSObject>

- (void)setDZYSubmitOrderSectionFootBlak;

@end

@interface DZYSubmitOrderSectionFoot : UIView
@property (nonatomic,strong)NSArray * productArr;

@property (nonatomic, weak) id <DZYSubmitOrderSectionFootDelegate> aDelegate;


-(void)setShuiPriceWithshuiPrice:(CGFloat )shuiPrice;
-(void)setYouFeiWithPrice:(CGFloat )youFei;
-(void)setRMBWithPrice:(CGFloat )RMB;
-(void)setCouponsPrice:(CGFloat )couponsPrice;


@end
