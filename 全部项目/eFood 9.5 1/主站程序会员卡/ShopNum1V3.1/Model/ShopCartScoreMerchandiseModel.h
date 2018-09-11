//
//  ShopCartScoreMerchandiseModel.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-11-27.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopCartScoreMerchandiseModel : NSObject

@property (nonatomic, strong) NSString *guid;

@property (nonatomic, strong) NSString *productGuid;

@property (nonatomic, strong) NSString *originalImageStr;

@property (nonatomic, strong) NSURL *originalImage;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *Attributes;

//购买数量
@property (nonatomic, assign) NSInteger buyNumber;

@property (nonatomic, assign) NSInteger IsJoinActivity;

//仓库储存量
@property (nonatomic, assign) NSInteger RepertoryCount;

@property (nonatomic, assign) NSInteger buyScore;

@property (nonatomic, assign) CGFloat prmo;

@property (nonatomic, strong) NSString *createTime;

@property (nonatomic,strong) NSDictionary *CouponRule;
@property(nonatomic,assign)NSInteger MemberI;

///购物车中结算是否选中
@property (nonatomic, assign) Boolean isCheckForShopCart;

- (id)initWithAttributes:(NSDictionary *)attributes;

+ (void)getScoreShopCartMerchandiseListByParamer:(NSDictionary *)parameters andblock:(void(^)(NSArray *shopCartList,NSError *error))block;

+ (void)deleteScoreShopCartMerchandiseByParamer:(NSDictionary *)parameters andblock:(void(^)(NSInteger result,NSError *error))block;


@end
