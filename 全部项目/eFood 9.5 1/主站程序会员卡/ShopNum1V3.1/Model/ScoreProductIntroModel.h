//
//  ScoreProductIntroModel.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-11-19.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScoreProductIntroModel : NSObject

@property (readonly, nonatomic) NSString *guid;

@property (readonly, nonatomic) NSString *name;

@property (readonly, nonatomic) NSString *originalImageStr;

@property (readonly, nonatomic) NSURL *originalImage;

@property (readonly, nonatomic) NSInteger ExchangeScore;

@property (assign, nonatomic) CGFloat prmo;

@property (readonly, nonatomic) NSInteger SaleNumber;


- (id)initWithAttributes:(NSDictionary *)attributes;

//积分展示商品
+ (void)getScoreMerchandiseIntroForHomeShowByParamer:(NSDictionary *)parameters andBlocks:(void(^)(NSArray *merchandiseList,NSError *error))block;

@end
