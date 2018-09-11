//
//  CanMakeCouponsViewController.h
//  ShopNum1V3.1
//
//  Created by 森泓投资 on 16/8/15.
//  Copyright © 2016年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CanMakeCouponsViewControllerDelegate <NSObject>

-(void)getCouponsNum:(NSInteger)bunber;

@end

@interface CanMakeCouponsViewController : UIViewController



@property (nonatomic,weak)id<CanMakeCouponsViewControllerDelegate>aDelegate;
@end
