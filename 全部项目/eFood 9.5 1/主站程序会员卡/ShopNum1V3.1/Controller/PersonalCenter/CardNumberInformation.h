//
//  CardNumberInformation.h
//  ShopNum1V3.1
//
//  Created by 森泓投资 on 16/7/8.
//  Copyright © 2016年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardNumberItem.h"
@class CardNumberItem;

@interface CardNumberInformation : UITableViewCell


@property (nonatomic ,strong) CardNumberItem *cardItem;



+ (CardNumberInformation *)cardNumberInfo;

@end
