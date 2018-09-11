//
//  ScoreProductDetialModel.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-11-19.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScoreProductDetialModel : NSObject

@property (readonly, nonatomic) NSString *guid;

@property (readonly, nonatomic) NSString *name;

@property (readonly, nonatomic) NSString *originalImageStr;

@property (readonly, nonatomic) NSURL *originalImage;

@property (readonly, nonatomic) NSInteger ExchangeScore;

@property (assign, nonatomic) CGFloat prmo;

@property (readonly, nonatomic) NSInteger SaleNumber;

@property (readonly, nonatomic) NSInteger RepertoryAlertCount;

@property (readonly, nonatomic) NSInteger RepertoryCount;

@property (readonly, nonatomic) NSString *Detail;

@property (readonly, nonatomic) NSString *Memo;

@property (readonly, nonatomic) NSInteger ClickCount;

@property (readonly, nonatomic) NSInteger CommentCount;

@property (readonly, nonatomic) NSInteger IsReal;

@property (readonly, nonatomic) NSString *Title;

@property (readonly, nonatomic) NSString *Description;

@property (readonly, nonatomic) NSString *Keywords;


- (id)initWithAttributes:(NSDictionary *)attributes;

///积分展示商品详细
+ (void)getScoreMerchandiseDetailWithParamer:(NSDictionary *)parameters andBlocks:(void(^)(ScoreProductDetialModel *detail,NSError *error))block;

//添加购物车
+ (void)addScoreMerchandiseToShopCartByParamer:(NSDictionary *)parameters andblock:(void(^)(NSInteger result,NSError *error))block;

@end
