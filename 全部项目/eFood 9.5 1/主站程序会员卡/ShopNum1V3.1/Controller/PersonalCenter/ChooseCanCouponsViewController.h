//
//  ChooseCanCouponsViewController.h
//  ShopNum1V3.1
//
//  Created by 森泓投资 on 16/8/16.
//  Copyright © 2016年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>
//新增
@protocol ChooseCanVCDelegate <NSObject>

- (void)setChooseCanViewControllerDataInfo:(NSDictionary *)dataInfo andDisCount:(NSString *)disCount;

@end
@interface ChooseCanCouponsViewController : UIViewController

@property (nonatomic,assign)NSInteger nnum;
@property (nonatomic,assign)NSInteger nnumb;

@property (nonatomic,strong)NSString *moneyCount;
@property (nonatomic,strong)NSString *cardCodeCount;
@property (nonatomic,strong)NSMutableArray *shopArray;
@property(nonatomic,strong)NSString *shoopMoney;
//新增
@property (weak, nonatomic) id <ChooseCanVCDelegate> aDelegate;

@end
