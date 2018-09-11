//
//  HKCountry.h
//  ShopNum1V3.1
//
//  Created by Mac on 16/6/6.
//  Copyright © 2016年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HKCountry : NSObject
//"ID": 1,
//"Code": "+86",
//"country": "中国",
//"FristCode": "Z"
@property (nonatomic, strong) NSNumber *ID;
/**编码*/
@property (nonatomic , copy) NSString *Code;
/**名字*/
@property (nonatomic , copy) NSString *country;
/**首字母*/
@property (nonatomic , copy) NSString *FristCode;


+ (void)getCountryListWithBlock:(void(^)(NSArray<HKCountry *> * arr,NSError * error))block;
@end
