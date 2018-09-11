//
//  OrderMerchandiseSubmitModel.h
//  Shop
//
//  Created by Ocean Zhang on 4/16/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderMerchandiseSubmitModel : NSObject

@property (nonatomic, strong) NSString *Attributes;
@property (nonatomic, assign) NSInteger BuyNumber;
@property (nonatomic, assign) NSInteger Score;
@property (nonatomic, assign) CGFloat BuyPrice;
@property (nonatomic, strong) NSDate *CreateTime;
@property (nonatomic, strong) NSString *CreateTimeStr;
@property (nonatomic, strong) NSString *Guid;
@property (nonatomic, assign) CGFloat MarketPrice;
@property (nonatomic, strong) NSString *MemLoginID;
@property (nonatomic, strong) NSString *Name;
@property (nonatomic, strong) NSString *OriginalImge;
@property (nonatomic, strong) NSString *ProductGuid;
@property (nonatomic, strong) NSString *ShopID;
@property (nonatomic, strong) NSString *ShopName;
@property (nonatomic, strong) NSString *SpecificationName;
@property (nonatomic, strong) NSString *SpecificationValue;

@property (nonatomic, strong) NSString *ExtensionAttriutes;

@property (nonatomic, assign) NSInteger IsJoinActivity;

@property (nonatomic, assign) NSInteger IsPresent;

@property (nonatomic, strong) NSString *RepertoryNumber;
///税费
@property (nonatomic, assign) CGFloat IncomeTax;
@property (nonatomic,strong) NSDictionary *CouponRule;
@property(nonatomic,assign)NSInteger MemberI;
//优惠卷费
@property(nonatomic,assign)CGFloat couponsMoney;
//会员减免费
@property(nonatomic,assign)CGFloat VipCountMoner;

@end
