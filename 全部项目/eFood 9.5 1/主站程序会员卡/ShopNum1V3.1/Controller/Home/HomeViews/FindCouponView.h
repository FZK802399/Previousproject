//
//  FindCouponView.h
//  ShopNum1V3.1
//
//  Created by Mac on 16/1/4.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FindCouponView;

@protocol FindCouponViewDelegate <NSObject>

@required
- (void)didSelectBack;
- (void)didSelectGotoLook;
@end

@interface FindCouponView : UIView

@property (weak, nonatomic) id<FindCouponViewDelegate> delegate;

- (void)updateViewWithModel:(id)model;

@end
