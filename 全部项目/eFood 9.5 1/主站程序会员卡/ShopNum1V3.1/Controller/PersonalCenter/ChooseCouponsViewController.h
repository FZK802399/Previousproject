//
//  ChooseCouponsViewController.h
//  ShopNum1V3.1
//
//  Created by 森泓投资 on 16/8/16.
//  Copyright © 2016年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>
//新增
@protocol ChooseCouponsVCDelegate <NSObject>

- (void)setChooseCouponsViewControllerDataInfo:(NSDictionary *)dataInfo andDiscount:(NSString *)disCount;

@end

@interface ChooseCouponsViewController : UIViewController
//新增
@property (weak, nonatomic) id <ChooseCouponsVCDelegate> couponsDelegate;
@property (nonatomic ,strong)NSMutableArray *postArray;
@property(nonatomic,strong)NSString *postShoopMoney;
@end
