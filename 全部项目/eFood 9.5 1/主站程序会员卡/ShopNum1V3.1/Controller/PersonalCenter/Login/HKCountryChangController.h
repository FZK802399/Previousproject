//
//  HKCountryChangController.h
//  ShopNum1V3.1
//
//  Created by Mac on 16/6/1.
//  Copyright © 2016年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HKCountry,HKCountryChangController;


@protocol CountryChangControllerDelegate <NSObject>

-(void)countryChangController:(HKCountryChangController *)countryChangVc didFinishedSelectCountry:(HKCountry *)country;

@end

@interface HKCountryChangController : UITableViewController
@property (weak, nonatomic) id<CountryChangControllerDelegate> delegate;
@end
