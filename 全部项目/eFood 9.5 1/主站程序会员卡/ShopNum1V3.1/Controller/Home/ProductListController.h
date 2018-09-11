//
//  ProductListController.h
//  ShopNum1V3.1
//
//  Created by Right on 15/11/24.
//  Copyright © 2015年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetProductInfoApi.h"
@interface ProductListController : UIViewController
+ (instancetype) createWithType:(CheckProductType)type title:(NSString*)title;
+ (instancetype) create;
///
@property (assign, nonatomic) CheckProductType type;

@end
