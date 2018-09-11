//
//  OrderMerchandiseIntroModel.h
//  Shop
//
//  Created by Ocean Zhang on 4/17/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderMerchandiseIntroModel : NSObject

@property (nonatomic, strong) NSString *Guid;
@property (nonatomic, strong) NSString *ProductGuid;
@property (nonatomic, strong) NSString *ProductName;
@property (nonatomic, strong) NSString *Name;
@property (nonatomic, assign) NSInteger BuyNumber;
@property (nonatomic, assign) NSInteger BuyScore;
@property (nonatomic, assign) CGFloat BuyPrice;

///规格
@property (nonatomic, strong) NSString *SpecificationName;
@property (nonatomic, strong) NSURL *ProductImg;
@property (nonatomic, strong) NSString *ProductImgStr;
@property (nonatomic, assign) CGFloat prmo;

@property (nonatomic, strong) NSString *orderNum;
@property (nonatomic, assign) BOOL isShowComment;
///用来判断是否选中
@property (nonatomic, assign) BOOL isSelect;
///用来退货的商品加减
@property (nonatomic, assign) NSInteger refundNum;
///
@property (nonatomic, assign) NSInteger Rank;

- (id)initWithAttributes:(NSDictionary *)attributes andOrderNum:(NSString *)orderNum;

@end
